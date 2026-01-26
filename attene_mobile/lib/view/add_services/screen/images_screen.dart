
import '../../../general_index.dart';
import '../../../utils/responsive/index.dart';



class ImagesScreen extends StatelessWidget {
  const ImagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: const ImagesScreenBody(),
    );
  }
}

class ImagesScreenBody extends StatelessWidget {
  const ImagesScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceController controller = Get.find<ServiceController>();

    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveDimensions.responsiveWidth(16, 30, 40),
              vertical: ResponsiveDimensions.responsiveHeight(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'صور الخدمة',
                  style: getBold(
                    fontSize: ResponsiveDimensions.responsiveFontSize(20),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      'الصور',
                      style: getRegular(
                        fontSize: ResponsiveDimensions.responsiveFontSize(18),
                      ),
                    ),
                  ],
                ),
                Text(
                  'يمكنك إضافة حتى (10) صور و (1) فيديو',
                  style: getRegular(
                    fontSize: ResponsiveDimensions.responsiveFontSize(9),
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
                Container(
                  padding: EdgeInsets.all(
                    ResponsiveDimensions.responsiveWidth(12),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: AppColors.primary50),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.swap_horiz_sharp,
                        color: AppColors.primary400,
                        size: ResponsiveDimensions.responsiveFontSize(20),
                      ),
                      SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
                      Expanded(
                        child: Text(
                          'يمكنك سحب و افلات الصورة لاعادة ترتيب الصور',
                          style: getRegular(
                            fontSize: ResponsiveDimensions.responsiveFontSize(
                              13,
                            ),
                            color: AppColors.primary400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),

                Container(
                  padding: EdgeInsets.all(
                    ResponsiveDimensions.responsiveWidth(12),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: AppColors.primary300,
                        size: ResponsiveDimensions.responsiveFontSize(20),
                      ),
                      SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
                      Expanded(
                        child: Text(
                          '• الأبعاد: الصورة بعرض 800 بكسل وطول 460 بكسل (460x800). \n • الحجم:ألا يتعدى حجم الصورة أو الفيديو 50 ميغابايت.\n• الجودة: أن تكون الصورة عالية الجودة وواضحة. ',
                          style: getRegular(
                            fontSize: ResponsiveDimensions.responsiveFontSize(
                              13,
                            ),
                            color: AppColors.primary500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          DraggableImageGrid(
            controller: controller,
            buttonAddImage: _buildAddImagesButton(controller),
          ),

          SizedBox(height: ResponsiveDimensions.responsiveHeight(20)),
        ],
      ),
    );
  }

  Widget _buildAddImagesButton(ServiceController controller) {
    return GetBuilder<ServiceController>(
      builder: (controller) {
        final canAddMoreImages =
            controller.serviceImages.length < ServiceController.maxImages;

        return InkWell(
          onTap: canAddMoreImages
              ? () {
                  _openMediaLibrary(controller);
                }
              : null,
          child: Container(
            height: ResponsiveDimensions.responsiveHeight(120),
            padding: ResponsiveDimensions.responsivePadding(mobile: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F8F8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: ResponsiveDimensions.responsivePadding(mobile: 7),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(color: Colors.black),
                  ),
                  child: Icon(
                    Icons.add,
                    size: ResponsiveDimensions.responsiveFontSize(25),
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
                Text(
                  'اضف او اسحب صورة او فيديو',
                  style: getRegular(
                    fontSize: ResponsiveDimensions.responsiveFontSize(14),
                    color: Color(0xFF757575),
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.responsiveHeight(4)),
                Text(
                  'png , jpg , svg',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.responsiveFontSize(12),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _openMediaLibrary(ServiceController controller) async {
    try {
      final maxSelection =
          ServiceController.maxImages - controller.serviceImages.length;

      final result = await Get.to<List<dynamic>?>(
        () => MediaLibraryScreen(
          isSelectionMode: true,
          maxSelectionCount: maxSelection,
        ),
      );

      if (result != null && result.isNotEmpty) {
        final List<MediaItem> mediaItems = [];
        for (var item in result) {
          if (item is MediaItem) {
            mediaItems.add(item);
          }
        }

        if (mediaItems.isNotEmpty) {
          controller.addImagesFromMediaLibrary(mediaItems);

          Get.snackbar(
            'تمت الإضافة',
            'تم إضافة ${mediaItems.length} صورة بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      print('خطأ في فتح مكتبة الوسائط: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء اختيار الصور',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  Widget _buildFinalSaveButton(ServiceController controller) {
    return GetBuilder<ServiceController>(
      builder: (controller) {
        final hasImages = controller.serviceImages.isNotEmpty;

        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.to(const DescriptionScreen()),
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasImages
                      ? AppColors.primary400
                      : Colors.grey[300],
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveDimensions.responsiveHeight(16),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  elevation: 2,
                ),
                child: controller.isLoading.value
                    ? SizedBox(
                        height: ResponsiveDimensions.responsiveHeight(24),
                        width: ResponsiveDimensions.responsiveHeight(24),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: ResponsiveDimensions.responsiveFontSize(20),
                            color: hasImages ? Colors.white : Colors.grey[600],
                          ),
                          SizedBox(
                            width: ResponsiveDimensions.responsiveWidth(8),
                          ),
                          Text(
                            'التالي: الوصف والأسئلة الشائعة',
                            style: getMedium(
                              color: hasImages
                                  ? Colors.white
                                  : Color(0xFF757575),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(12)),
            if (!hasImages)
              Container(
                padding: EdgeInsets.all(
                  ResponsiveDimensions.responsiveWidth(12),
                ),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_outlined,
                      color: Colors.orange[700],
                      size: ResponsiveDimensions.responsiveFontSize(18),
                    ),
                    SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
                    Expanded(
                      child: Text(
                        'يجب إضافة صورة واحدة على الأقل',
                        style: getRegular(
                          fontSize: ResponsiveDimensions.responsiveFontSize(12),
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(12)),
            TextButton(
              onPressed: () => Get.back(),
              child: Text(
                'العودة للسعر والتطويرات',
                style: getRegular(
                  fontSize: ResponsiveDimensions.responsiveFontSize(14),
                  color: Color(0xFF757575),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}