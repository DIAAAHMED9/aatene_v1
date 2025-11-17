// lib/view/media_library/media_library_screen.dart
import 'package:attene_mobile/component/appBar/custom_appbar.dart';
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/view/media_library/media_library_controller.dart';
import 'package:attene_mobile/view/media_library/media_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      if (controller.currentTabIndex.value == 0) {
        return _buildUploadTab();
      } else {
        return _buildMediaGrid();
      }
    });
  }

  // ✅ واجهة تبويب التحميل
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
          Icon(
            Icons.cloud_upload_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد ملفات محملة',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'انقر على زر "+" لرفع الملفات',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
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
          // معلومات الملفات المؤقتة
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary100),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary400),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'الملفات المرفوعة حديثاً. اضغط على "ادراج" لرفعها إلى السيرفر.',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          
          // شبكة الملفات المؤقتة
          Expanded(
            child: _buildMediaGrid(),
          ),
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
          itemBuilder: (context, index) {
            final media = filteredMedia[index];
            return _buildMediaGridItem(media);
          },
        ),
      );
    });
  }

  Widget _buildMediaGridItem(MediaItem media) {
    return Obx(() {
      final isSelected = controller.selectedMediaIds.contains(media.id);
      final isMaxSelected = controller.selectedMediaIds.length >= 10 && !isSelected;
      
      return GestureDetector(
        onTap: () {
          if (isMaxSelected) {
            Get.snackbar(
              'تنبيه',
              'يمكن اختيار 10 ملفات كحد أقصى',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            return;
          }
          
          if (isSelectionMode) {
            controller.toggleMediaSelection(media.id);
          } else {
            _showMediaPreview(media);
          }
        },
        onLongPress: () {
          if (isMaxSelected) return;
          controller.toggleMediaSelection(media.id);
        },
        child: Container(
          width: 168.5,
          height: 224.67,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary400 : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            color: isSelected ? AppColors.primary400.withOpacity(0.1) : Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              // منطقة الصورة/الفيديو
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
                          ? Image.asset(
                              'assets/images/placeholder.png',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.image, size: 40, color: Colors.grey[400]);
                              },
                            )
                          : _buildVideoThumbnail(media),
                    ),
                  ),
                  
                  // علامة الاختيار
                  if (isSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: AppColors.primary400,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  
                  // علامة الفيديو
                  if (media.type == MediaType.video)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),

                  // علامة الملف المحلي (الجديد)
                  if (media.isLocal == true)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'جديد',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              
              // معلومات الملف
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        media.name,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.primary400 : Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4),
                      Text(
                        _formatFileSize(media.size),
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? AppColors.primary400 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildFloatingActionButton() {
    return Obx(() {
      if (controller.currentTabIndex.value == 0) {
        // زر الرفع يظهر فقط في تبويب التحميل
        return FloatingActionButton(
          onPressed: _showUploadOptions,
          backgroundColor: AppColors.primary400,
          child: Icon(Icons.add, color: Colors.white),
        );
      }
      return SizedBox.shrink();
    });
  }

  void _showUploadOptions() {
    showModalBottomSheet(
      context: Get.context!,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
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
              Text(
                'اختر طريقة الرفع',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildUploadOption(
                      icon: Icons.photo_library,
                      title: 'معرض الصور',
                      onTap: () {
                        Get.back();
                        controller.pickImages();
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildUploadOption(
                      icon: Icons.video_library,
                      title: 'معرض الفيديو',
                      onTap: () {
                        Get.back();
                        controller.pickVideo();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildUploadOption(
                      icon: Icons.camera_alt,
                      title: 'التقاط صورة',
                      onTap: () {
                        Get.back();
                        controller.takePhoto();
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: _buildUploadOption(
                      icon: Icons.videocam,
                      title: 'تسجيل فيديو',
                      onTap: () {
                        Get.back();
                        controller.takeVideo();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideoThumbnail(MediaItem media) {
    return Stack(
      children: [
        Container(
          color: Colors.black12,
          child: Center(
            child: Icon(
              Icons.videocam,
              size: 40,
              color: Colors.grey[400],
            ),
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
                  ? Image.asset(
                      'assets/images/placeholder.png',
                      fit: BoxFit.contain,
                    )
                  : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_circle_filled, size: 60, color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                            'عرض الفيديو',
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 80,
            color: Colors.grey[300],
          ),
          SizedBox(height: 16),
          Text(
            'لا توجد ملفات',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'انقر على زر "تحميل" لإضافة الملفات الأولى',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }

  // void _showUploadOptions() {
  //   showModalBottomSheet(
  //     context: Get.context!,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
  //     ),
  //     builder: (context) {
  //       return Container(
  //         padding: EdgeInsets.all(16),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             SizedBox(height: 8),
  //             Container(
  //               width: 40,
  //               height: 4,
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[300],
  //                 borderRadius: BorderRadius.circular(2),
  //               ),
  //             ),
  //             SizedBox(height: 20),
  //             Text(
  //               'اختر نوع الملف',
  //               style: TextStyle(
  //                 fontSize: 18,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             SizedBox(height: 20),
  //             Row(
  //               children: [
  //                 Expanded(
  //                   child: _buildUploadOption(
  //                     icon: Icons.photo,
  //                     title: 'صور',
  //                     onTap: () {
  //                       Get.back();
  //                       controller.pickImages();
  //                     },
  //                   ),
  //                 ),
  //                 SizedBox(width: 12),
  //                 Expanded(
  //                   child: _buildUploadOption(
  //                     icon: Icons.videocam,
  //                     title: 'فيديو',
  //                     onTap: () {
  //                       Get.back();
  //                       controller.pickVideo();
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             SizedBox(height: 20),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  Widget _buildUploadOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
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
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / 1048576).toStringAsFixed(1)} MB';
  }

}