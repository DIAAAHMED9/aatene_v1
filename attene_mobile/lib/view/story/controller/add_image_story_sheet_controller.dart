import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

import '../../../general_index.dart';
import '../index.dart';

class AddImageStorySheetController extends GetxController
    with SingleGetTickerProviderMixin {
  late TabController tabController;

  final RxInt currentTabIndex = 0.obs; // 0 studio, 1 camera, 2 video
  final RxBool isLoading = false.obs;

  final RxList<AssetEntity> studioAssets = <AssetEntity>[].obs;
  final RxList<AssetEntity> videoAssets = <AssetEntity>[].obs;

  final Rx<File?> selectedFile = Rx<File?>(null);

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(() {
      if (!tabController.indexIsChanging) {
        currentTabIndex.value = tabController.index;
        _onTabChanged(tabController.index);
      }
    });

    _loadStudio();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> _onTabChanged(int index) async {
    if (index == 0) {
      await _loadStudio();
    } else if (index == 1) {
      await openCamera();
      tabController.animateTo(0);
    } else {
      await _loadVideos();
    }
  }

  Future<bool> _ensurePermission() async {
    final PermissionState ps = await PhotoManager.requestPermissionExtend();
    final bool ok = ps.isAuth;
    return ok;
  }

  Future<void> _loadStudio() async {
    isLoading.value = true;
    try {
      final ok = await _ensurePermission();
      if (!ok) {
        studioAssets.clear();
        return;
      }

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        hasAll: true,
        onlyAll: true,
      );

      if (albums.isEmpty) {
        studioAssets.clear();
        return;
      }

      final AssetPathEntity recent = albums.first;
      final List<AssetEntity> assets = await recent.getAssetListPaged(
        page: 0,
        size: 120,
      );

      studioAssets.assignAll(assets);

      if (selectedFile.value == null && assets.isNotEmpty) {
        await selectAsset(assets.first);
      }
    } catch (e) {
      print('❌ [STORY IMAGE] load studio error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadVideos() async {
    isLoading.value = true;
    try {
      final ok = await _ensurePermission();
      if (!ok) {
        videoAssets.clear();
        return;
      }

      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.video,
        hasAll: true,
        onlyAll: true,
      );

      if (albums.isEmpty) {
        videoAssets.clear();
        return;
      }

      final AssetPathEntity recent = albums.first;
      final List<AssetEntity> assets = await recent.getAssetListPaged(
        page: 0,
        size: 120,
      );

      videoAssets.assignAll(assets);

      if (selectedFile.value == null && assets.isNotEmpty) {
        await selectAsset(assets.first);
      }
    } catch (e) {
      print('❌ [STORY VIDEO] load videos error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectAsset(AssetEntity asset) async {
    try {
      final File? f = await asset.file;
      if (f != null) {
        selectedFile.value = f;
      }
    } catch (e) {
      print('❌ [STORY MEDIA] select asset error: $e');
    }
  }

  Future<void> openCamera() async {
    try {
      final XFile? x = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
      );
      if (x != null) {
        selectedFile.value = File(x.path);
      }
    } catch (e) {
      print('❌ [STORY CAMERA] error: $e');
    }
  }

  void onPublish() {
    final file = selectedFile.value;
    if (file == null) return;

    final tab = currentTabIndex.value == 0
        ? StoryMediaSourceTab.studio
        : currentTabIndex.value == 1
        ? StoryMediaSourceTab.camera
        : StoryMediaSourceTab.video;

    Get.back(
      result: StoryMediaPickResult(tab: tab, file: file),
    );
  }
}