// lib/controllers/media_library_controller.dart
import 'dart:io';
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/view/media_library/media_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MediaLibraryController extends GetxController 
    with SingleGetTickerProviderMixin {
  
  late TabController tabController;
  final TextEditingController searchTextController = TextEditingController();
  
  final RxInt currentTabIndex = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxDouble uploadProgress = 0.0.obs;

  // ✅ تصحيح: استخدام RxList بشكل صحيح
  final RxList<MediaItem> uploadedMediaItems = <MediaItem>[].obs; // الملفات المرفوعة سابقاً
  final RxList<MediaItem> temporaryMediaItems = <MediaItem>[].obs; // الملفات المختارة حديثاً
  final RxList<String> selectedMediaIds = <String>[].obs;

  final List<TabData> tabs = [
    TabData(label: 'تحميل', viewName: 'تحميل'),
    TabData(label: 'الملفات السابقة', viewName: 'الملفات السابقة'),
  ];

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    
    tabController = TabController(
      length: tabs.length, 
      vsync: this,
      initialIndex: currentTabIndex.value
    );
    
    tabController.addListener(_handleTabChange);
    searchTextController.addListener(_handleSearchChange);
    
    // تحميل البيانات من API عند التهيئة
    loadUploadedMediaFromAPI();
  }
  
  void _handleTabChange() {
    if (!tabController.indexIsChanging) {
      currentTabIndex.value = tabController.index;
    }
  }
  
  void _handleSearchChange() {
    searchQuery.value = searchTextController.text;
  }
  
  void changeTab(int index) {
    if (index >= 0 && index < tabs.length) {
      tabController.animateTo(index);
      currentTabIndex.value = index;
    }
  }
  
  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
  }

  // ✅ دوال الوسائط
  bool get canSelectMore {
    return selectedMediaIds.length < 10;
  }

  void toggleMediaSelection(String mediaId) {
    if (selectedMediaIds.contains(mediaId)) {
      selectedMediaIds.remove(mediaId);
    } else {
      if (canSelectMore) {
        selectedMediaIds.add(mediaId);
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

  // ✅ دالة محاكاة جلب البيانات من API
  Future<void> loadUploadedMediaFromAPI() async {
    isLoading.value = true;
    
    try {
      // هنا نضيف محاكاة لجلب البيانات من API
      await Future.delayed(Duration(seconds: 1));
      
      final apiData = <MediaItem>[];
      for (int i = 1; i <= 8; i++) {
        apiData.add(MediaItem(
          id: 'api_$i',
          path: 'https://example.com/image_$i.jpg', // رابط من API
          type: i % 3 == 0 ? MediaType.video : MediaType.image,
          name: 'ملف مرفوع $i.${i % 3 == 0 ? 'mp4' : 'png'}',
          dateAdded: DateTime.now().subtract(Duration(days: i * 2)),
          size: (i * 1024 * 1024).toInt(), // حجم مختلف لكل ملف
        ));
      }
      
      uploadedMediaItems.assignAll(apiData);
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تحميل الملفات السابقة');
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ دوال اختيار الملفات
  Future<void> pickImages() async {
    try {
      final List<XFile>? images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (images != null) {
        await _processSelectedFiles(images, MediaType.image);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في اختيار الصور');
    }
  }

  Future<void> pickVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.gallery,
        maxDuration: const Duration(minutes: 10),
      );

      if (video != null) {
        await _processSelectedFiles([video], MediaType.video);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في اختيار الفيديو');
    }
  }

  Future<void> takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (photo != null) {
        await _processSelectedFiles([photo], MediaType.image);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في التقاط الصورة');
    }
  }

  Future<void> takeVideo() async {
    try {
      final XFile? video = await _picker.pickVideo(
        source: ImageSource.camera,
        maxDuration: const Duration(minutes: 10),
      );

      if (video != null) {
        await _processSelectedFiles([video], MediaType.video);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في تسجيل الفيديو');
    }
  }

  // ✅ معالجة الملفات المختارة
  Future<void> _processSelectedFiles(List<XFile> files, MediaType type) async {
    isLoading.value = true;
    uploadProgress.value = 0.0;

    final newMediaItems = <MediaItem>[];

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      final fileSize = await _getFileSize(file.path);
      
      final mediaItem = MediaItem(
        id: 'temp_${DateTime.now().millisecondsSinceEpoch}_$i',
        path: file.path,
        type: type,
        name: file.name,
        dateAdded: DateTime.now(),
        size: fileSize,
        isLocal: true, // ✅ إضافة علامة أن الملف محلي
      );

      await _simulateUpload();
      newMediaItems.add(mediaItem);
      
      uploadProgress.value = (i + 1) / files.length;
    }

    temporaryMediaItems.addAll(newMediaItems);
    
    // ✅ اختيار الملفات المرفوعة تلقائياً
    for (final item in newMediaItems) {
      if (canSelectMore) {
        selectedMediaIds.add(item.id);
      }
    }

    isLoading.value = false;
    uploadProgress.value = 0.0;
    
    if (files.isNotEmpty) {
      Get.snackbar('نجاح', 'تم إضافة ${files.length} ملف بنجاح');
      
      // ✅ الانتقال تلقائياً إلى تبويب الملفات السابقة بعد الرفع
      if (temporaryMediaItems.isNotEmpty) {
        changeTab(1); // الانتقال إلى تبويب الملفات السابقة
      }
    }
  }

  Future<int> _getFileSize(String path) async {
    final file = File(path);
    final stat = await file.stat();
    return stat.size;
  }

  Future<void> _simulateUpload() async {
    await Future.delayed(Duration(milliseconds: 500));
  }

  void clearSelection() {
    selectedMediaIds.clear();
  }

  // ✅ الحصول على الوسائط المعروضة حسب التبويب النشط
  List<MediaItem> get displayedMedia {
    if (currentTabIndex.value == 0) {
      // تبويب التحميل - نعرض الملفات المؤقتة
      return temporaryMediaItems;
    } else {
      // تبويب الملفات السابقة - نعرض الملفات من API
      return uploadedMediaItems;
    }
  }

  // ✅ الحصول على الوسائط المصفاة حسب البحث
  List<MediaItem> get filteredMedia {
    var filtered = displayedMedia;
    
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((item) => 
        item.name.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  // ✅ دالة التأكيد على الإدراج
  void confirmSelection() {
    if (selectedMediaIds.isNotEmpty) {
      final selectedMedia = _getSelectedMediaItems();
      
      // ✅ هنا يمكنك إضافة كود لرفع الملفات إلى API
      _uploadSelectedMediaToAPI(selectedMedia);
      
      Get.back(result: selectedMedia);
      Get.snackbar(
        'تم الإدراج', 
        'تم إدراج ${selectedMediaIds.length} عنصر',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  // ✅ الحصول على الوسائط المختارة
  List<MediaItem> _getSelectedMediaItems() {
    final allMedia = [...temporaryMediaItems, ...uploadedMediaItems];
    return allMedia.where((item) => selectedMediaIds.contains(item.id)).toList();
  }

  // ✅ محاكاة رفع الملفات إلى API
  Future<void> _uploadSelectedMediaToAPI(List<MediaItem> mediaItems) async {
    isLoading.value = true;
    
    try {
      // محاكاة رفع الملفات إلى API
      for (final media in mediaItems) {
        if (media.isLocal??false) {
          // رفع الملفات المحلية إلى API
          await _uploadFileToAPI(media);
        }
      }
      
      // بعد الرفع الناجح، ننقل الملفات المؤقتة إلى الملفات المرفوعة
      final uploadedItems = temporaryMediaItems.where((item) => selectedMediaIds.contains(item.id)).toList();
      uploadedMediaItems.addAll(uploadedItems);
      
      // إزالة الملفات المرفوعة من القائمة المؤقتة
      temporaryMediaItems.removeWhere((item) => selectedMediaIds.contains(item.id));
      
    } catch (e) {
      Get.snackbar('خطأ', 'فشل في رفع الملفات إلى السيرفر');
    } finally {
      isLoading.value = false;
      selectedMediaIds.clear();
    }
  }

  Future<void> _uploadFileToAPI(MediaItem media) async {
    // محاكاة رفع ملف إلى API
    await Future.delayed(Duration(seconds: 1));
    
    // هنا يمكنك إضافة كود الرفع الفعلي إلى API
    print('رفع الملف: ${media.name} إلى API');
  }

  @override
  void onClose() {
    tabController.removeListener(_handleTabChange);
    searchTextController.removeListener(_handleSearchChange);
    tabController.dispose();
    searchTextController.dispose();
    super.onClose();
  }
}