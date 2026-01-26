
import 'package:cached_network_image/cached_network_image.dart';

import '../../../general_index.dart';
import '../../../utils/platform/local_image.dart';

class MediaLibraryScreen extends StatefulWidget {
  final bool isSelectionMode;
  final int? maxSelectionCount;
  final List<MediaItem>? initialSelectedItems;
  final Function(List<MediaItem>)? onMediaSelected;

  const MediaLibraryScreen({
    super.key,
    this.isSelectionMode = false,
    this.maxSelectionCount,
    this.initialSelectedItems,
    this.onMediaSelected,
  });

  @override
  State<MediaLibraryScreen> createState() => _MediaLibraryScreenState();
}

class _MediaLibraryScreenState extends State<MediaLibraryScreen> {
  final MediaLibraryController controller = Get.find<MediaLibraryController>();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.isSelectionMode) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (widget.maxSelectionCount != null) {
          controller.setMaxSelection(widget.maxSelectionCount!);
        }

        if (widget.initialSelectedItems != null &&
            widget.initialSelectedItems!.isNotEmpty) {
          final selectedIds = widget.initialSelectedItems!
              .map((item) => item.id)
              .toList();
          controller.selectedMediaIds.assignAll(selectedIds);
        }
      });
    }

    searchController.addListener(() {
      controller.searchQuery.value = searchController.text;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithTabs(
        isRTL: isRTL,
        config: AppBarConfig(
          title: 'مكتبة الوسائط',
          actionText: widget.isSelectionMode ? 'ادراج' : '',
          onActionPressed: widget.isSelectionMode ? _confirmSelection : null,
          tabs: controller.tabs,
          searchController: searchController,
          onSearchChanged: (value) => controller.searchQuery.value = value,
          tabController: controller.tabController,
          onTabChanged: controller.changeTab,
          showSearch: true,
          showTabs: true,
        ),
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading.value && controller.displayedMedia.isEmpty) {
        return _buildLoadingState();
      }

      return controller.currentTabIndex.value == 0
          ? _buildUploadTab()
          : _buildMediaGrid();
    });
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: AppColors.primary400),
          SizedBox(height: 16),
          Text('جاري تحميل الصور...', style: getRegular(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildUploadTab() {
    return Obx(() {
      if (controller.temporaryMediaItems.isEmpty) {
        return _buildEmptyUploadState();
      } else {
        return _buildTemporaryMediaGrid();
      }
    });
  }

  Widget _buildEmptyUploadState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_upload_outlined, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'لا توجد ملفات محملة',
            style: getRegular(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'انقر على زر "+" لرفع الملفات',
            style: getRegular(
              fontSize: 14,
              color: AppColors.colorMediaLibraryScreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemporaryMediaGrid() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary100),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary400),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'الملفات المرفوعة حديثاً. سيتم رفعها تلقائياً إلى السيرفر.',
                    style: getRegular(
                      fontSize: 12,
                      color: AppColors.primary500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Obx(() {
            if (controller.uploadProgress.value > 0 &&
                controller.uploadProgress.value < 1) {
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: controller.uploadProgress.value,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary400,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'جاري الرفع... ${(controller.uploadProgress.value * 100).toStringAsFixed(0)}%',
                    style: TextStyle(
                      fontFamily: "PingAR",
                      fontSize: 12,
                      color: AppColors.primary400,
                    ),
                  ),
                ],
              );
            }
            return SizedBox();
          }),
          SizedBox(height: 16),
          Expanded(child: _buildMediaGrid()),
        ],
      ),
    );
  }

  Widget _buildMediaGrid() {
    return Obx(() {
      final filteredMedia = controller.filteredMedia;

      if (filteredMedia.isEmpty) {
        return _buildEmptyState();
      }

      return Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 168.5 / 280,
          ),
          itemCount: filteredMedia.length,
          itemBuilder: (context, index) =>
              _buildMediaGridItem(filteredMedia[index]),
        ),
      );
    });
  }

  Widget _buildMediaGridItem(MediaItem media) {
    return Obx(() {
      final isSelected = controller.selectedMediaIds.contains(media.id);
      final canSelectMore = controller.canSelectMore;
      final isMaxSelected =
          widget.isSelectionMode && !isSelected && !canSelectMore;
      final isUploading =
          media.isLocal == true &&
          controller.temporaryMediaItems.contains(media);

      return GestureDetector(
        onTap: () =>
            _handleMediaTap(media, isUploading, isMaxSelected, isSelected),
        onLongPress: () => _handleMediaLongPress(media, isUploading),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUploading
                  ? Colors.blue
                  : isSelected
                  ? AppColors.primary400
                  : Colors.grey[300]!,
              width: isUploading ? 2 : (isSelected ? 2 : 1),
            ),
            color: isUploading
                ? Colors.blue.withOpacity(0.1)
                : isSelected
                ? AppColors.primary400.withOpacity(0.1)
                : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              _buildMediaContent(media),
              if (isSelected && widget.isSelectionMode)
                _buildSelectionIndicator(),
              if (isUploading) _buildUploadingIndicator(),
            ],
          ),
        ),
      );
    });
  }

  void _handleMediaTap(
    MediaItem media,
    bool isUploading,
    bool isMaxSelected,
    bool isSelected,
  ) {
    if (isUploading) {
      Get.snackbar(
        'جاري الرفع',
        'الملف قيد الرفع إلى السيرفر',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
      return;
    }

    if (isMaxSelected) {
      Get.snackbar(
        'تنبيه',
        'يمكن اختيار ${controller.maxSelection.value} ملفات كحد أقصى',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (widget.isSelectionMode) {
      controller.toggleMediaSelection(media.id);
    } else {
      _showMediaPreview(media);
    }
  }

  void _handleMediaLongPress(MediaItem media, bool isUploading) {
    if (!widget.isSelectionMode && !isUploading) {
      _showMediaOptions(media);
    }
  }

  Widget _buildMediaContent(MediaItem media) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: double.infinity,
              height: 168.5,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(11),
                  topRight: Radius.circular(11),
                ),
                child: media.type == MediaType.image
                    ? _buildImageWidget(media)
                    : _buildVideoThumbnail(media),
              ),
            ),
            if (media.type == MediaType.video) _buildVideoIndicator(),
            if (media.isLocal == true) _buildUploadingLabel(),
          ],
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  media.name,
                  style: getMedium(fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),
                Text(
                  _formatFileSize(media.size),
                  style: getRegular(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionIndicator() {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: AppColors.primary400,
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.check, size: 16, color: Colors.white),
      ),
    );
  }

  Widget _buildUploadingIndicator() {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              SizedBox(height: 8),
              Text(
                'جاري الرفع...',
                style: getRegular(color: Colors.white, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoIndicator() {
    return Positioned(
      top: 8,
      left: 8,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(Icons.play_arrow, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildUploadingLabel() {
    return Positioned(
      bottom: 8,
      left: 8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          'جاري الرفع',
          style: getBold(color: Colors.white, fontSize: 10),
        ),
      ),
    );
  }

  Widget _buildImageWidget(MediaItem media) {
    if (media.isLocal == true) {
      return buildLocalImage(
        media.path,
        fit: BoxFit.cover,
      );
    } else {
      final imageUrl = controller.getMediaDisplayUrl(media);
      if (imageUrl.isEmpty)
        return Icon(Icons.image, size: 40, color: Colors.grey[400]);

      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary400,
          ),
        ),
        errorWidget: (context, url, error) =>
            Icon(Icons.image, size: 40, color: Colors.grey[400]),
      );
    }
  }

  Widget _buildVideoThumbnail(MediaItem media) {
    return Stack(
      children: [
        Container(
          color: Colors.black12,
          child: Center(
            child: Icon(Icons.videocam, size: 40, color: Colors.grey[400]),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Icon(
              Icons.play_circle_filled,
              color: Colors.white54,
              size: 48,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return Obx(() {
      return controller.currentTabIndex.value == 0
          ? FloatingActionButton(
              onPressed: _showUploadOptions,
              backgroundColor: AppColors.primary400,
              child: Icon(Icons.add, color: Colors.white),
            )
          : SizedBox.shrink();
    });
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text('اختر طريقة الرفع', style: getBold(fontSize: 18)),
            SizedBox(height: 20),
            Row(
              children: [
                _buildUploadOption(
                  Icons.photo_library,
                  'معرض الصور',
                  () => _selectAndClose(controller.pickImages),
                ),
                SizedBox(width: 12),
                _buildUploadOption(
                  Icons.video_library,
                  'معرض الفيديو',
                  () => _selectAndClose(controller.pickVideo),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                _buildUploadOption(
                  Icons.camera_alt,
                  'التقاط صورة',
                  () => _selectAndClose(controller.takePhoto),
                ),
                SizedBox(width: 12),
                _buildUploadOption(
                  Icons.videocam,
                  'تسجيل فيديو',
                  () => _selectAndClose(controller.takeVideo),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _selectAndClose(Function function) {
    Get.back();
    function();
  }

  Widget _buildUploadOption(IconData icon, String title, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Icon(icon, size: 40, color: AppColors.primary400),
              SizedBox(height: 8),
              Text(title, style: getRegular(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.photo_library_outlined, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(
            'لا توجد ملفات',
            style: getRegular(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            controller.currentTabIndex.value == 0
                ? 'انقر على زر "+" لإضافة الملفات الأولى'
                : 'انقر على زر "تحميل" لإضافة الملفات الأولى',
            style: getRegular(
              fontSize: 14,
              color: AppColors.colorMediaLibraryScreen,
            ),
          ),
        ],
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }

  void _showMediaPreview(MediaItem media) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Stack(
          children: [
            Container(
              width: Get.width * 0.9,
              height: Get.width * 0.9,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.black,
              ),
              child: media.type == MediaType.image
                  ? _buildImageWidget(media)
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.play_circle_filled,
                            size: 60,
                            color: Colors.white,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'عرض الفيديو',
                            style: getRegular(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Positioned(
              top: 20,
              right: 20,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.white, size: 30),
                onPressed: () => Get.back(),
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.white, size: 30),
                onPressed: () => _deleteMedia(media),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteMedia(MediaItem media) {
    Get.back();
    _showDeleteDialog(media);
  }

  void _showDeleteDialog(MediaItem media) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('حذف الملف'),
          ],
        ),
        content: Text('هل أنت متأكد من حذف هذا الملف؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('إلغاء', style: getRegular(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteMediaItem(media);
            },
            child: Text('حذف', style: getRegular(color: Colors.red)),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showMediaOptions(MediaItem media) {
    showModalBottomSheet(
      context: Get.context!,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('حذف الملف'),
              onTap: () {
                Get.back();
                _showDeleteDialog(media);
              },
            ),
            ListTile(
              leading: Icon(Icons.share, color: AppColors.primary400),
              title: Text('مشاركة'),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void _confirmSelection() {
    final selectedMedia = controller.getSelectedMediaItems();

    if (selectedMedia.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'لم تقم باختيار أي ملفات',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (widget.onMediaSelected != null) {
      widget.onMediaSelected!(selectedMedia);
    }

    Get.back(result: selectedMedia);
  }
}