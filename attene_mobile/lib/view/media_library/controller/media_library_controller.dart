

import 'dart:async';
import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../general_index.dart';

class MediaLibraryController extends GetxController
    with SingleGetTickerProviderMixin, WidgetsBindingObserver {
  late TabController tabController;
  final TextEditingController searchTextController = TextEditingController();

  final RxInt currentTabIndex = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;

  final RxList<MediaItem> uploadedMediaItems = <MediaItem>[].obs;
  final RxList<MediaItem> temporaryMediaItems = <MediaItem>[].obs;
  final RxList<String> selectedMediaIds = <String>[].obs;

  final List<TabData> tabs = [
    TabData(label: 'تحميل', viewName: 'تحميل'),
    TabData(label: 'الملفات السابقة', viewName: 'الملفات السابقة'),
  ];

  final ImagePicker _picker = ImagePicker();
  Timer? _autoRefreshTimer;
  DateTime? _lastLoadTime;
  final RxBool _isInitialized = false.obs;
  final RxBool _isAuthChecked = false.obs;
  final RxInt maxSelection = 10.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);

    _initializeBasicControllers();
    _setupAuthListener();

    print('🎯 [CONTROLLER] MediaLibraryController created');
  }

  void _initializeBasicControllers() {
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: currentTabIndex.value,
    );

    tabController.addListener(_handleTabChange);
    searchTextController.addListener(_handleSearchChange);
  }

  List<MediaItem> getSelectedMediaItems() {
    final allMedia = [...temporaryMediaItems, ...uploadedMediaItems];
    return allMedia
        .where((item) => selectedMediaIds.contains(item.id))
        .toList();
  }

  void _setupAuthListener() {
    final MyAppController myAppController = Get.find<MyAppController>();

    ever(myAppController.isAppInitialized, (bool initialized) {
      if (initialized) {
        _checkAndInitialize();
      }
    });

    ever(myAppController.isLoggedIn, (bool isLoggedIn) {
      _isAuthChecked.value = true;
      if (isLoggedIn) {
        _initializeMediaController();
      } else {
        _resetMediaController();
      }
    });

    if (myAppController.isAppInitialized.value) {
      _checkAndInitialize();
    }
  }

  void _checkAndInitialize() {
    final MyAppController myAppController = Get.find<MyAppController>();
    if (myAppController.isLoggedIn.value) {
      _initializeMediaController();
    } else {
      print('⏸️ [AUTH] User not logged in, media controller paused');
      _isAuthChecked.value = true;
    }
  }

  void _initializeMediaController() {
    if (_isInitialized.value) return;

    print(
      '🚀 [CONTROLLER] Initializing MediaLibraryController for user: $currentUserId',
    );

    _startAutoRefresh();
    _loadInitialData();
    _isInitialized.value = true;
  }

  void _resetMediaController() {
    if (!_isInitialized.value) return;

    print('🔁 [CONTROLLER] Resetting MediaLibraryController due to logout');

    _isInitialized.value = false;
    uploadedMediaItems.clear();
    temporaryMediaItems.clear();
    selectedMediaIds.clear();
    _autoRefreshTimer?.cancel();
    _lastLoadTime = null;
  }

  @override
  void onClose() {
    tabController.removeListener(_handleTabChange);
    searchTextController.removeListener(_handleSearchChange);
    tabController.dispose();
    searchTextController.dispose();
    _autoRefreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();

    print('🔚 [CONTROLLER] MediaLibraryController closed');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _isInitialized.value) {
      print('📱 [LIFECYCLE] App resumed, checking for updates...');
      _loadMediaWhenAppResumed();
    }
  }

  void setMaxSelection(int max) {
    maxSelection.value = max;
  }

  bool get canSelectMore {
    return selectedMediaIds.length < maxSelection.value;
  }

  void _startAutoRefresh() {
    _autoRefreshTimer = Timer.periodic(Duration(minutes: 2), (timer) {
      if (currentTabIndex.value == 1 &&
          !isLoading.value &&
          _isInitialized.value) {
        print('🔄 [AUTO REFRESH] Periodic auto-refresh triggered');
        loadUploadedMediaFromAPI();
      }
    });
  }

  Future<void> _loadMediaWhenAppResumed() async {
    if (currentTabIndex.value == 1 && _isInitialized.value) {
      print('📱 [APP RESUMED] Auto-refresh on app resume');
      await _loadMediaWhenTabOpened();
    }
  }

  void changeTab(int index) {
    if (index >= 0 && index < tabs.length) {
      tabController.animateTo(index);
      currentTabIndex.value = index;

      if (index == 1 && _isInitialized.value) {
        _loadMediaWhenTabOpened();
      }
    }
  }

  Future<void> _loadMediaWhenTabOpened() async {
    if (!_isInitialized.value) {
      print('⏸️ [TAB OPEN] Controller not initialized, skipping load');
      return;
    }

    if (_lastLoadTime != null &&
        DateTime.now().difference(_lastLoadTime!).inSeconds < 30) {
      print('⏱️ [TAB OPEN] Skipping auto-load, last load was recent');
      return;
    }

    print('🔄 [TAB OPEN] Auto-load triggered when opening previous files tab');
    await loadUploadedMediaFromAPI();
    _lastLoadTime = DateTime.now();
  }

  Future<void> _saveMediaToLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mediaJsonList = uploadedMediaItems
          .map((item) => _mediaItemToJson(item))
          .toList();
      await prefs.setString(
        'user_media_$currentUserId',
        jsonEncode(mediaJsonList),
      );
      print(
        '💾 [LOCAL STORAGE] Saved ${uploadedMediaItems.length} items locally for user: $currentUserId',
      );
    } catch (e) {
      print('❌ [LOCAL STORAGE] Error saving locally: $e');
    }
  }

  Future<void> _loadMediaFromLocalStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final mediaJson = prefs.getString('user_media_$currentUserId');

      if (mediaJson != null) {
        final List<dynamic> mediaList = jsonDecode(mediaJson);
        final List<MediaItem> loadedMedia = mediaList
            .map((json) => _mediaItemFromJson(json))
            .toList();

        uploadedMediaItems.assignAll(loadedMedia);
        print(
          '📂 [LOCAL STORAGE] Loaded ${loadedMedia.length} items from local storage',
        );

        for (var item in loadedMedia) {
          print('   📄 [LOCAL] ${item.name} (ID: ${item.id})');
        }
      } else {
        print(
          'ℹ️ [LOCAL STORAGE] No local data found for user: $currentUserId',
        );
      }
    } catch (e) {
      print('❌ [LOCAL STORAGE] Error loading from local storage: $e');
    }
  }

  Future<void> _loadInitialData() async {
    if (!_isInitialized.value) return;

    print('🚀 [INIT] Starting initial data load...');
    await _loadMediaFromLocalStorage();

    if (uploadedMediaItems.isEmpty) {
      print('🔄 [INIT] No local data, fetching from API...');
      await loadUploadedMediaFromAPI();
    } else {
      print('✅ [INIT] Using local data, will sync with API in background');
      loadUploadedMediaFromAPI();
    }
  }

  void toggleMediaSelection(String mediaId) {
    if (selectedMediaIds.contains(mediaId)) {
      selectedMediaIds.remove(mediaId);
      print('🔘 [SELECTION] Deselected: $mediaId');
    } else {
      if (canSelectMore) {
        selectedMediaIds.add(mediaId);
        print(
          '✅ [SELECTION] Selected: $mediaId (Total: ${selectedMediaIds.length})',
        );
      } else {
        Get.snackbar(
          'تنبيه',
          'يمكن اختيار 10 صور كحد أقصى',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    }
  }

  String get currentUserId {
    final MyAppController myAppController = Get.find<MyAppController>();
    return myAppController.userData['id']?.toString() ?? 'unknown';
  }

  Future<void> loadUploadedMediaFromAPI() async {
    final MyAppController myAppController = Get.find<MyAppController>();
    if (!myAppController.isLoggedIn.value) {
      print('⏸️ [API LOAD] User not authenticated, skipping API call');
      return;
    }

    if (isLoading.value) {
      print('⏳ [API LOAD] Already loading, skipping duplicate request');
      return;
    }

    isLoading.value = true;
    print('🔄 [API LOAD] Starting API media load for user: $currentUserId');

    try {
      final List<String> mediaTypes = [
        'gallery',
        'image',
        'media',
        'avatar',
        'thumbnail',
      ];
      final List<MediaItem> allMediaItems = [];
      int totalFilesFound = 0;

      for (String mediaType in mediaTypes) {
        try {
          print('🔍 [API LOAD] Trying type: $mediaType');

          final response = await ApiHelper.getMediaList(type: mediaType);

          if (response != null &&
              response['status'] == true &&
              response['data'] != null) {
            final dynamic data = response['data'];
            final int fileCount = data is List ? data.length : 0;
            totalFilesFound += fileCount;

            print('📊 [API LOAD] Found $fileCount files of type: $mediaType');

            if (data is List) {
              for (var item in data) {
                final mediaItem = MediaItem.fromApiMap(item);

                if (mediaItem.userId == currentUserId) {
                  allMediaItems.add(mediaItem);
                  print(
                    '   ✅ [API] Added: ${mediaItem.name} (Type: $mediaType)',
                  );
                } else {
                  print(
                    '   ❌ [API] Skipped (wrong user): ${mediaItem.name} (User: ${mediaItem.userId})',
                  );
                }
              }
            }
          } else {
            print(
              'ℹ️ [API LOAD] No files or invalid response for type: $mediaType',
            );
          }
        } catch (e) {
          print('⚠️ [API LOAD] Error loading type $mediaType: $e');
        }
      }

      print(
        '🎯 [API LOAD] Total files found: $totalFilesFound, User files: ${allMediaItems.length}',
      );

      final uniqueMediaItems = <String, MediaItem>{};
      for (var item in allMediaItems) {
        uniqueMediaItems[item.id] = item;
      }

      final int previousCount = uploadedMediaItems.length;
      uploadedMediaItems.assignAll(uniqueMediaItems.values.toList());
      final int newCount = uploadedMediaItems.length;

      print('📈 [API LOAD] List updated: $previousCount → $newCount items');

      await _saveMediaToLocalStorage();

      if (newCount > previousCount) {
        print('🎉 [API LOAD] Added ${newCount - previousCount} new items');
      } else if (newCount < previousCount) {
        print('🗑️ [API LOAD] Removed ${previousCount - newCount} items');
      } else {
        print('✅ [API LOAD] No changes in item count');
      }
    } catch (e) {
      print('❌ [API LOAD] General error loading media: $e');
      Get.snackbar(
        'خطأ',
        'فشل في تحميل الملفات السابقة',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
      print('🏁 [API LOAD] Media load completed');
    }
  }

  Future<void> _uploadFilesToAPI(
    List<XFile> files,
    List<MediaItem> mediaItems,
  ) async {
    final MyAppController myAppController = Get.find<MyAppController>();
    if (!myAppController.isLoggedIn.value) {
      print('⏸️ [UPLOAD] User not authenticated, skipping upload');
      return;
    }

    print('🚀 [UPLOAD] Starting upload of ${files.length} files');

    try {
      final successfulUploads = <MediaItem>[];
      int successCount = 0;
      int failCount = 0;

      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final mediaItem = mediaItems[i];

        uploadProgress.value = i / files.length;

        String uploadType = 'image';
        if (mediaItem.type == MediaType.video) {
          uploadType = 'media';
        }

        print(
          '🔼 [UPLOAD] Uploading: ${mediaItem.name} (Type: $uploadType, Size: ${await file.length()} bytes)',
        );

        final response = await ApiHelper.uploadMedia(
          file: file,
          type: uploadType,
          withLoading: false,
          onSendProgress: (sent, total) {
            if (total != -1) {
              final progress = (i + (sent / total)) / files.length;
              uploadProgress.value = progress;
              print(
                '   📊 [UPLOAD] Progress: ${(progress * 100).toStringAsFixed(1)}%',
              );
            }
          },
        );

        if (response != null && response['status'] == true) {
          print('✅ [UPLOAD] SUCCESS: ${mediaItem.name}');
          print('   📦 Response: ${response['data'] ?? 'No data'}');

          final responseData = response['data'] ?? response;
          final updatedMediaItem = MediaItem.fromApiMap(responseData);

          if (updatedMediaItem.userId == currentUserId) {
            successfulUploads.add(updatedMediaItem);
            temporaryMediaItems.remove(mediaItem);

            if (selectedMediaIds.contains(mediaItem.id)) {
              selectedMediaIds.remove(mediaItem.id);
              selectedMediaIds.add(updatedMediaItem.id);
            }

            successCount++;
            print(
              '   📁 Processed: ${updatedMediaItem.name} → ID: ${updatedMediaItem.id}',
            );
          } else {
            print(
              '⚠️ [UPLOAD] File belongs to different user: ${updatedMediaItem.userId}',
            );
          }
        } else {
          print('❌ [UPLOAD] FAILED: ${mediaItem.name}');
          print('   💬 Error: ${response?['message'] ?? 'Unknown error'}');
          failCount++;

          final alternativeSuccess = await _tryAlternativeUpload(
            file,
            mediaItem,
            successfulUploads,
          );
          if (alternativeSuccess) {
            successCount++;
            failCount--;
          }
        }
      }

      uploadProgress.value = 1.0;

      if (successfulUploads.isNotEmpty) {
        final existingIds = uploadedMediaItems.map((item) => item.id).toSet();
        final newItems = successfulUploads
            .where((item) => !existingIds.contains(item.id))
            .toList();

        if (newItems.isNotEmpty) {
          uploadedMediaItems.addAll(newItems);

          await _saveMediaToLocalStorage();

          print(
            '🎉 [UPLOAD] COMPLETED: $successCount successful, $failCount failed',
          );
          print('   📈 Added ${newItems.length} new items to list');

          if (currentTabIndex.value == 1) {
            print('🔄 [UPLOAD] Auto-refreshing list after successful upload');
            await loadUploadedMediaFromAPI();
          }

          Get.snackbar(
            'نجاح',
            'تم رفع $successCount ملف بنجاح${failCount > 0 ? ' وفشل $failCount ملف' : ''}',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
        }
      } else {
        print('😞 [UPLOAD] No files were successfully uploaded');
        Get.snackbar(
          'خطأ',
          'فشل في رفع جميع الملفات',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('❌ [UPLOAD] Upload process error: $e');
      Get.snackbar(
        'خطأ',
        'فشل في رفع بعض الملفات',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<bool> _tryAlternativeUpload(
    XFile file,
    MediaItem mediaItem,
    List<MediaItem> successfulUploads,
  ) async {
    try {
      print(
        '🔄 [ALTERNATIVE UPLOAD] Trying alternative upload for: ${mediaItem.name}',
      );

      final List<String> alternativeTypes = [
        'gallery',
        'avatar',
        'thumbnail',
        'media',
      ];

      for (String altType in alternativeTypes) {
        print('   🔁 Trying type: $altType');

        final response = await ApiHelper.uploadMedia(
          file: file,
          type: altType,
          withLoading: false,
        );

        if (response != null && response['status'] == true) {
          print('   ✅ [ALTERNATIVE] SUCCESS with type: $altType');

          final responseData = response['data'] ?? response;
          final updatedMediaItem = MediaItem.fromApiMap(responseData);

          if (updatedMediaItem.userId == currentUserId) {
            successfulUploads.add(updatedMediaItem);
            temporaryMediaItems.remove(mediaItem);
            print('   🎯 Added via alternative: ${updatedMediaItem.name}');
            return true;
          }
        }
      }
    } catch (e) {
      print('❌ [ALTERNATIVE UPLOAD] Alternative upload failed: $e');
    }
    return false;
  }

  Future<void> pickImages() async {
    try {
      print('🖼️ [PICKER] Opening image picker...');
      final List<XFile>? images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images != null && images.isNotEmpty) {
        print('✅ [PICKER] Selected ${images.length} images');
        await _processSelectedFiles(images, MediaType.image);
      } else {
        print('ℹ️ [PICKER] No images selected');
      }
    } catch (e) {
      print('❌ [PICKER] Error picking images: $e');
      Get.snackbar('خطأ', 'فشل في اختيار الصور');
    }
  }

  Future<void> pickVideo() async {
    try {
      print('🎥 [PICKER] Opening video picker...');
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10),
      );

      if (video != null) {
        print('✅ [PICKER] Selected video: ${video.name}');
        await _processSelectedFiles([video], MediaType.video);
      } else {
        print('ℹ️ [PICKER] No video selected');
      }
    } catch (e) {
      print('❌ [PICKER] Error picking video: $e');
      Get.snackbar('خطأ', 'فشل في اختيار الفيديو');
    }
  }

  Future<void> takePhoto() async {
    try {
      print('📸 [CAMERA] Opening camera for photo...');
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        print('✅ [CAMERA] Captured photo: ${photo.name}');
        await _processSelectedFiles([photo], MediaType.image);
      } else {
        print('ℹ️ [CAMERA] No photo captured');
      }
    } catch (e) {
      print('❌ [CAMERA] Error taking photo: $e');
      Get.snackbar('خطأ', 'فشل في التقاط الصورة');
    }
  }

  Future<void> takeVideo() async {
    try {
      print('🎬 [CAMERA] Opening camera for video...');
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 10),
      );

      if (video != null) {
        print('✅ [CAMERA] Recorded video: ${video.name}');
        await _processSelectedFiles([video], MediaType.video);
      } else {
        print('ℹ️ [CAMERA] No video recorded');
      }
    } catch (e) {
      print('❌ [CAMERA] Error taking video: $e');
      Get.snackbar('خطأ', 'فشل في تسجيل الفيديو');
    }
  }

  Future<void> _processSelectedFiles(List<XFile> files, MediaType type) async {
    final MyAppController myAppController = Get.find<MyAppController>();
    if (!myAppController.isLoggedIn.value) {
      print('⏸️ [PROCESS] User not authenticated, skipping file processing');
      Get.snackbar('تنبيه', 'يرجى تسجيل الدخول أولاً');
      return;
    }

    isLoading.value = true;
    uploadProgress.value = 0.0;

    print(
      '⚙️ [PROCESS] Processing ${files.length} ${type == MediaType.image ? 'images' : 'videos'}',
    );

    final newMediaItems = <MediaItem>[];
    final filesToUpload = <XFile>[];

    try {
      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final fileSize = await file.length();

        final mediaItem = MediaItem(
          id: 'temp_${DateTime.now().millisecondsSinceEpoch}_$i',
          path: file.path,
          type: type,
          name: file.name,
          dateAdded: DateTime.now(),
          size: fileSize,
          isLocal: true,
        );

        newMediaItems.add(mediaItem);
        filesToUpload.add(file);
        print(
          '   📄 Added to queue: ${file.name} (${_formatFileSize(fileSize)})',
        );
      }

      temporaryMediaItems.addAll(newMediaItems);
      print(
        '📦 [PROCESS] Added ${newMediaItems.length} items to temporary list',
      );

      await _uploadFilesToAPI(filesToUpload, newMediaItems);
    } catch (e) {
      print('❌ [PROCESS] Error processing files: $e');
      Get.snackbar('خطأ', 'فشل في معالجة الملفات');
    } finally {
      isLoading.value = false;
      uploadProgress.value = 0.0;
      print('🏁 [PROCESS] File processing completed');
    }
  }

  Map<String, dynamic> _mediaItemToJson(MediaItem item) {
    return {
      'id': item.id,
      'path': item.path,
      'type': item.type.index,
      'name': item.name,
      'dateAdded': item.dateAdded.toIso8601String(),
      'size': item.size,
      'isLocal': item.isLocal,
      'fileName': item.fileName,
      'fileUrl': item.fileUrl,
      'userId': item.userId,
    };
  }

  MediaItem _mediaItemFromJson(Map<String, dynamic> json) {
    return MediaItem(
      id: json['id'],
      path: json['path'],
      type: MediaType.values[json['type']],
      name: json['name'],
      dateAdded: DateTime.parse(json['dateAdded']),
      size: json['size'],
      isLocal: json['isLocal'] ?? false,
      fileName: json['fileName'],
      fileUrl: json['fileUrl'],
      userId: json['userId'],
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }

  void clearSelection() {
    print('🗑️ [SELECTION] Cleared ${selectedMediaIds.length} selections');
    selectedMediaIds.clear();
  }

  List<MediaItem> get displayedMedia {
    return currentTabIndex.value == 0
        ? temporaryMediaItems
        : uploadedMediaItems;
  }

  List<MediaItem> get filteredMedia {
    var filtered = displayedMedia;

    if (searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (item) => item.name.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ),
          )
          .toList();
      print(
        '🔍 [SEARCH] Filtered ${displayedMedia.length} → ${filtered.length} items',
      );
    }

    return filtered;
  }

  void confirmSelection() {
    if (selectedMediaIds.isNotEmpty) {
      final selectedMedia = _getSelectedMediaItems();

      print('✅ [CONFIRM] Confirmed selection of ${selectedMedia.length} items');

      Get.back(result: selectedMedia);
      Get.snackbar(
        'تم الإدراج',
        'تم إدراج ${selectedMediaIds.length} عنصر',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      print('⚠️ [CONFIRM] No items selected');
      Get.snackbar(
        'تنبيه',
        'لم تقم باختيار أي ملفات',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteMediaItem(MediaItem media) async {
    try {
      isLoading.value = true;

      if (media.isLocal == true) {
        temporaryMediaItems.remove(media);
        selectedMediaIds.remove(media.id);
        print('🗑️ حذف الملف المحلي: ${media.name}');
        return;
      }

      final response = await ApiHelper.deleteMedia(fileName: media.name);

      if (response != null && response['status'] == true) {
        uploadedMediaItems.removeWhere((item) => item.id == media.id);
        selectedMediaIds.remove(media.id);

        await _saveMediaToLocalStorage();

        print('🗑️ حذف الملف من الخادم: ${media.name}');

        Get.snackbar(
          'نجاح',
          'تم حذف الملف بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception(response?['message'] ?? 'فشل في حذف الملف');
      }
    } catch (e) {
      print('❌ خطأ في حذف الملف: $e');
      Get.snackbar(
        'خطأ',
        'فشل في حذف الملف',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  List<MediaItem> _getSelectedMediaItems() {
    final allMedia = [...temporaryMediaItems, ...uploadedMediaItems];
    return allMedia
        .where((item) => selectedMediaIds.contains(item.id))
        .toList();
  }

  String getMediaDisplayUrl(MediaItem media) {
    if (media.fileUrl != null && media.fileUrl!.isNotEmpty) {
      return media.fileUrl!;
    } else if (media.path.isNotEmpty) {
      if (media.path.startsWith('http')) {
        return media.path;
      } else if (media.isLocal == true) {
        return media.path;
      } else {
        return '${ApiHelper.getBaseUrl()}/storage/${media.path}';
      }
    }
    return '';
  }

  /// Return an URL suitable for display from a stored value.
  /// Stored values may be:
  /// - full URL (http...) -> returned as is
  /// - relative path (images/.., gallery/.., etc) -> baseUrl/storage/<path>
  String getDisplayUrlFromStoredValue(String value) {
    final v = value.trim();
    if (v.isEmpty) return '';
    if (v.startsWith('http')) return v;
    return '${ApiHelper.getBaseUrl()}/storage/$v';
  }

  /// Return the value that should be sent to backend when picking a media item.
  /// If we got a full URL, we try to strip `/storage/` and send the relative path.
  String getMediaApiValue(MediaItem media) {
    // Prefer relative server path when available
    final raw = (media.path.isNotEmpty) ? media.path : (media.fileUrl ?? '');
    final v = raw.trim();
    if (v.isEmpty) return '';
    if (v.startsWith('http')) {
      final idx = v.indexOf('/storage/');
      if (idx != -1) return v.substring(idx + '/storage/'.length);
      final uri = Uri.tryParse(v);
      if (uri != null && uri.pathSegments.isNotEmpty) return uri.pathSegments.join('/');
    }
    return v;
  }


  void _handleTabChange() {
    if (!tabController.indexIsChanging) {
      currentTabIndex.value = tabController.index;
    }
  }

  void _handleSearchChange() {
    searchQuery.value = searchTextController.text;
  }

  bool get isControllerInitialized => _isInitialized.value;

  bool get isAuthChecked => _isAuthChecked.value;
}