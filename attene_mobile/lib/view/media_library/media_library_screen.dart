// lib/view/media_library/media_library_screen.dart
import 'dart:io';
import 'package:attene_mobile/component/appBar/custom_appbar.dart';
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/view/media_library/media_library_controller.dart';
import 'package:attene_mobile/view/media_library/media_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MediaLibraryScreen extends StatelessWidget {
  final MediaLibraryController controller = Get.find<MediaLibraryController>();
  final bool isSelectionMode;
  final Function(List<MediaItem>)? onMediaSelected;

  MediaLibraryScreen({
    this.isSelectionMode = false,
    this.onMediaSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithTabs(
        isRTL: isRTL,
        config: AppBarConfig(
          title: 'مكتبة الوسائط',
          actionText: isSelectionMode ? 'ادراج' : '',
          onActionPressed: isSelectionMode ? controller.confirmSelection : null,
          tabs: controller.tabs, 
          searchController: controller.searchTextController,
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
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('جاري تحميل الملفات...'),
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
          Text('لا توجد ملفات محملة', style: TextStyle(fontSize: 18, color: Colors.grey[500])),
          SizedBox(height: 8),
          Text('انقر على زر "+" لرفع الملفات', style: TextStyle(fontSize: 14, color: Colors.grey[400])),
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
              color: AppColors.primary100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary400),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'الملفات المرفوعة حديثاً. سيتم رفعها تلقائياً إلى السيرفر.',
                    style: TextStyle(fontSize: 12, color: AppColors.primary500),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Obx(() {
            if (controller.uploadProgress.value > 0 && controller.uploadProgress.value < 1) {
              return Column(
                children: [
                  LinearProgressIndicator(
                    value: controller.uploadProgress.value,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary400),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'جاري الرفع... ${(controller.uploadProgress.value * 100).toStringAsFixed(0)}%',
                    style: TextStyle(fontSize: 12, color: AppColors.primary400),
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
          itemBuilder: (context, index) => _buildMediaGridItem(filteredMedia[index]),
        ),
      );
    });
  }

  Widget _buildMediaGridItem(MediaItem media) {
    return Obx(() {
      final isSelected = controller.selectedMediaIds.contains(media.id);
      final isMaxSelected = controller.selectedMediaIds.length >= 10 && !isSelected;
      final isUploading = media.isLocal == true && controller.temporaryMediaItems.contains(media);
      
      return GestureDetector(
        onTap: () => _handleMediaTap(media, isUploading, isMaxSelected, isSelected),
        onLongPress: () => _handleMediaLongPress(media, isUploading),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isUploading ? Colors.blue : 
                    isSelected ? AppColors.primary400 : Colors.grey[300]!,
              width: isUploading ? 2 : (isSelected ? 2 : 1),
            ),
            color: isUploading ? Colors.blue.withOpacity(0.1) : 
                  isSelected ? AppColors.primary400.withOpacity(0.1) : Colors.white,
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
          ),
          child: Stack(
            children: [
              _buildMediaContent(media),
              if (isSelected) _buildSelectionIndicator(),
              if (isUploading) _buildUploadingIndicator(),
            ],
          ),
        ),
      );
    });
  }

  void _handleMediaTap(MediaItem media, bool isUploading, bool isMaxSelected, bool isSelected) {
    if (isUploading) {
      Get.snackbar('جاري الرفع', 'الملف قيد الرفع إلى السيرفر', 
          backgroundColor: Colors.blue, colorText: Colors.white);
      return;
    }
    
    if (isMaxSelected) {
      Get.snackbar('تنبيه', 'يمكن اختيار 10 ملفات كحد أقصى', 
          backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }
    
    if (isSelectionMode) {
      controller.toggleMediaSelection(media.id);
    } else {
      _showMediaPreview(media);
    }
  }

  void _handleMediaLongPress(MediaItem media, bool isUploading) {
    if (!isSelectionMode && !isUploading) {
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
                borderRadius: BorderRadius.only(topLeft: Radius.circular(11), topRight: Radius.circular(11)),
                color: Colors.grey[100],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(11), topRight: Radius.circular(11)),
                child: media.type == MediaType.image ? _buildImageWidget(media) : _buildVideoThumbnail(media),
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
                Text(media.name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: 4),
                Text(_formatFileSize(media.size), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectionIndicator() {
    return Positioned(
      top: 8, right: 8,
      child: Container(
        width: 24, height: 24,
        decoration: BoxDecoration(color: AppColors.primary400, shape: BoxShape.circle),
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
              CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
              SizedBox(height: 8),
              Text('جاري الرفع...', style: TextStyle(color: Colors.white, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoIndicator() {
    return Positioned(
      top: 8, left: 8,
      child: Container(
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
        child: Icon(Icons.play_arrow, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildUploadingLabel() {
    return Positioned(
      bottom: 8, left: 8,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(4)),
        child: Text('جاري الرفع', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildImageWidget(MediaItem media) {
    if (media.isLocal == true) {
      return Image.file(File(media.path), fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.image, size: 40, color: Colors.grey[400]));
    } else {
      final imageUrl = controller.getMediaDisplayUrl(media);
      if (imageUrl.isEmpty) return Icon(Icons.image, size: 40, color: Colors.grey[400]);
      
      return CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        errorWidget: (context, url, error) => Icon(Icons.image, size: 40, color: Colors.grey[400]),
      );
    }
  }

  Widget _buildVideoThumbnail(MediaItem media) {
    return Stack(
      children: [
        Container(color: Colors.black12, child: Center(child: Icon(Icons.videocam, size: 40, color: Colors.grey[400]))),
        Positioned.fill(child: Center(child: Icon(Icons.play_circle_filled, color: Colors.white54, size: 48))),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 8),
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
            SizedBox(height: 20),
            Text('اختر طريقة الرفع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            Row(children: [
              _buildUploadOption(Icons.photo_library, 'معرض الصور', () => _selectAndClose(controller.pickImages)),
              SizedBox(width: 12),
              _buildUploadOption(Icons.video_library, 'معرض الفيديو', () => _selectAndClose(controller.pickVideo)),
            ]),
            SizedBox(height: 12),
            Row(children: [
              _buildUploadOption(Icons.camera_alt, 'التقاط صورة', () => _selectAndClose(controller.takePhoto)),
              SizedBox(width: 12),
              _buildUploadOption(Icons.videocam, 'تسجيل فيديو', () => _selectAndClose(controller.takeVideo)),
            ]),
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
          child: Column(children: [
            Icon(icon, size: 40, color: AppColors.primary400),
            SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
          ]),
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
          Text('لا توجد ملفات', style: TextStyle(fontSize: 18, color: Colors.grey[500], fontWeight: FontWeight.w500)),
          SizedBox(height: 8),
          Text(
            controller.currentTabIndex.value == 0 
                ? 'انقر على زر "+" لإضافة الملفات الأولى'
                : 'انقر على زر "تحميل" لإضافة الملفات الأولى',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(16), color: Colors.black),
              child: media.type == MediaType.image
                  ? _buildImageWidget(media)
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_circle_filled, size: 60, color: Colors.white),
                          SizedBox(height: 16),
                          Text('عرض الفيديو', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                    ),
            ),
            Positioned(top: 20, right: 20, child: IconButton(icon: Icon(Icons.close, color: Colors.white, size: 30), onPressed: () => Get.back())),
            Positioned(top: 20, left: 20, child: IconButton(icon: Icon(Icons.delete, color: Colors.white, size: 30), onPressed: () => _deleteMedia(media))),
          ],
        ),
      ),
    );
  }

  void _deleteMedia(MediaItem media) {
    Get.back();
    _showDeleteDialog(media);
  }

 // في ملف media_library_screen.dart - تأكد من أن دالة الحذف موجودة
void _showDeleteDialog(MediaItem media) {
  Get.dialog(
    AlertDialog(
      title: Text('حذف الملف'),
      content: Text('هل أنت متأكد من حذف هذا الملف؟'),
      actions: [
        TextButton(
          onPressed: () => Get.back(), 
          child: Text('إلغاء')
        ),
        TextButton(
          onPressed: () {
            Get.back();
            // controller.deleteMediaItem(media); // ✅ تأكد من استدعاء الدالة الصحيحة
          },
          child: Text('حذف', style: TextStyle(color: Colors.red)),
        ),
      ],
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
            ListTile(leading: Icon(Icons.delete), title: Text('حذف الملف'), onTap: () => _selectAndDelete(media)),
            ListTile(leading: Icon(Icons.share), title: Text('مشاركة'), onTap: () => Get.back()),
          ],
        ),
      ),
    );
  }

  void _selectAndDelete(MediaItem media) {
    Get.back();
    _showDeleteDialog(media);
  }
}