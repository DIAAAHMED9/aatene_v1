

import 'package:reorderables/reorderables.dart';

import '../../../general_index.dart';
import '../../../utils/responsive/responsive_dimensions.dart';
import '../../../utils/platform/local_image.dart';

class DraggableImageGrid extends StatefulWidget {
  final ServiceController controller;
  final Widget buttonAddImage;

  const DraggableImageGrid({
    super.key,
    required this.controller,
    required this.buttonAddImage,
  });

  @override
  State<DraggableImageGrid> createState() => _DraggableImageGridState();
}

class _DraggableImageGridState extends State<DraggableImageGrid> {
  late ServiceController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ServiceController>(
      id: 'images_list',
      builder: (controller) {
        return Column(
          children: [
            _buildHeader(controller),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),

            _buildReorderableWrap(controller),
          ],
        );
      },
    );
  }

  Future<void> _openMediaLibrary() async {
    try {
      final maxSelection =
          ServiceController.maxImages - _controller.serviceImages.length;

      if (maxSelection <= 0) {
        Get.snackbar(
          'الحد الأقصى',
          'لقد وصلت إلى الحد الأقصى للصور المسموح بها',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        return;
      }

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
          _controller.addImagesFromMediaLibrary(mediaItems);

          Get.snackbar(
            'تمت الإضافة',
            'تم إضافة ${mediaItems.length} صورة بنجاح',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
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

  Widget _buildAddButton() {
    final canAddMoreImages =
        _controller.serviceImages.length < ServiceController.maxImages;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canAddMoreImages ? _openMediaLibrary : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: canAddMoreImages ? Colors.white : Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: canAddMoreImages
                  ? AppColors.primary300
                  : Colors.grey[300]!,
              width: 2,
              style: BorderStyle.solid,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(5),
                width: ResponsiveDimensions.responsiveWidth(40),
                height: ResponsiveDimensions.responsiveWidth(40),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: canAddMoreImages
                        ? AppColors.primary300
                        : Colors.grey[200]!,
                    width: 2,
                  ),
                ),
                child: Icon(
                  Icons.add,
                  size: ResponsiveDimensions.responsiveFontSize(24),
                  color: canAddMoreImages
                      ? AppColors.primary400
                      : Colors.grey[400],
                ),
              ),
              SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
              Text(
                textAlign: TextAlign.center,
                'اضف او اسحب صورة او فيديو ',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.responsiveFontSize(12),
                  color: canAddMoreImages
                      ? AppColors.primary400
                      : Colors.grey[400],
                  fontWeight: FontWeight.w600,
                  fontFamily: "PingAR",
                ),
              ),
              SizedBox(height: ResponsiveDimensions.responsiveHeight(4)),
              Text(
                'png , jpg , svg',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.responsiveFontSize(10),
                  color: canAddMoreImages
                      ? AppColors.primary400
                      : Colors.grey[400],
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: ResponsiveDimensions.responsiveHeight(4)),

              Text(
                '${_controller.serviceImages.length}/${ServiceController.maxImages}',
                style: getRegular(
                  fontSize: ResponsiveDimensions.responsiveFontSize(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReorderableWrap(ServiceController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _calculateCrossAxisCount(constraints.maxWidth);
        final spacing = ResponsiveDimensions.responsiveWidth(12);
        final itemWidth =
            (constraints.maxWidth -
                ResponsiveDimensions.responsiveWidth(32) -
                spacing * (crossAxisCount - 1)) /
            crossAxisCount;
        final itemHeight = itemWidth * 0.85;

        final totalItems = controller.serviceImages.length + 1;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.responsiveWidth(16),
          ),
          child: ReorderableWrap(
            spacing: spacing,
            runSpacing: ResponsiveDimensions.responsiveHeight(12),
            children: List.generate(totalItems, (index) {
              if (index == controller.serviceImages.length) {
                return SizedBox(
                  key: const Key('add_button'),
                  width: itemWidth,
                  height: itemHeight,
                  child: _buildAddButton(),
                );
              }

              final image = controller.serviceImages[index];
              return SizedBox(
                key: Key('image_${image.id}'),
                width: itemWidth,
                height: itemHeight,
                child: _buildImageItem(
                  image: image,
                  index: index,
                  controller: controller,
                ),
              );
            }),
            onReorder: (oldIndex, newIndex) {
              _handleReorder(oldIndex, newIndex);
            },
            onNoReorder: (int index) {},
            buildDraggableFeedback:
                (
                  BuildContext context,
                  BoxConstraints constraints,
                  Widget child,
                ) {
                  if (child.key == const Key('add_button')) {
                    return child;
                  }

                  return Transform.scale(
                    scale: 1.05,
                    child: Material(
                      elevation: 8,
                      color: Colors.transparent,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 3,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: child,
                      ),
                    ),
                  );
                },
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      height: ResponsiveDimensions.responsiveHeight(250),
      margin: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.responsiveWidth(16),
      ),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!, width: 1),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.photo_library_outlined,
              size: ResponsiveDimensions.responsiveFontSize(48),
              color: Colors.grey[400],
            ),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),
            Text(
              'لا توجد صور مضافة',
              style: getRegular(
                fontSize: ResponsiveDimensions.responsiveFontSize(16),
                color: Colors.grey,
              ),
            ),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveDimensions.responsiveWidth(24),
              ),
              child: Text(
                'انقر على زر "اختيار من مكتبة الوسائط" لإضافة صور لخدمتك',
                style: getRegular(
                  fontSize: ResponsiveDimensions.responsiveFontSize(12),
                  color: Color(0xFFBDBDBD),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ServiceController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.responsiveWidth(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الصور المضافة (${controller.serviceImages.length}/${ServiceController.maxImages})',
                style: getBold(),
              ),
              if (controller.serviceImages.length > 1)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveDimensions.responsiveWidth(12),
                    vertical: ResponsiveDimensions.responsiveHeight(6),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.primary100),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.swap_vert,
                        size: ResponsiveDimensions.responsiveFontSize(14),
                        color: AppColors.primary400,
                      ),
                      SizedBox(width: ResponsiveDimensions.responsiveWidth(6)),
                      Text(
                        'اسحب لإعادة الترتيب',
                        style: getMedium(
                          fontSize: ResponsiveDimensions.responsiveFontSize(12),
                          color: AppColors.primary400,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          if (controller.serviceImages.isNotEmpty)
            SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
          if (controller.serviceImages.isNotEmpty)
            Text(
              'الصورة الرئيسية مميزة باللون البرتقالي ★',
              style: getRegular(
                fontSize: ResponsiveDimensions.responsiveFontSize(12),
                color: Color(0xFF757575),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildImageItem({
    required ServiceImage image,
    required int index,
    required ServiceController controller,
  }) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: image.isMain ? AppColors.primary400 : Colors.grey[300]!,
            width: image.isMain ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: _buildImageContent(image, index)),

            Padding(
              padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(6)),
              child: Row(
                children: [
                  Expanded(child: _buildMainButton(image, controller)),
                  SizedBox(width: ResponsiveDimensions.responsiveWidth(6)),

                  _buildDeleteButton(image, controller),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageContent(ServiceImage image, int index) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
          child: _buildImageWidget(image),
        ),

        if (image.isMain)
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveDimensions.responsiveWidth(6),
                vertical: ResponsiveDimensions.responsiveHeight(2),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary400,
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star,
                    size: ResponsiveDimensions.responsiveFontSize(10),
                    color: Colors.white,
                  ),
                  SizedBox(width: ResponsiveDimensions.responsiveWidth(2)),
                  Text(
                    'رئيسية',
                    style: getBold(
                      fontSize: ResponsiveDimensions.responsiveFontSize(9),
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

        Positioned(
          top: 6,
          right: 6,
          child: Container(
            width: ResponsiveDimensions.responsiveWidth(22),
            height: ResponsiveDimensions.responsiveWidth(22),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: getBold(
                  fontSize: ResponsiveDimensions.responsiveFontSize(11),
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),

        if (widget.controller.serviceImages.length > 1)
          Positioned(
            bottom: 6,
            right: 6,
            child: Container(
              padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(4)),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.drag_handle,
                size: ResponsiveDimensions.responsiveFontSize(14),
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageWidget(ServiceImage image) {
    if (image.isLocalFile && image.file != null) {
      return buildLocalImage(
        image.file!.path,
        fit: BoxFit.cover,
      );
    } else if (image.url.startsWith('http')) {
      return Image.network(
        image.url,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
              strokeWidth: 2,
              color: AppColors.primary400,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildErrorWidget(),
      );
    } else {
      try {
    return buildLocalImage(image.url, fit: BoxFit.cover);
      } catch (e) {
        return _buildErrorWidget();
      }
    }
  }

  Widget _buildErrorWidget() {
    return Container(
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image,
              color: Colors.grey[400],
              size: ResponsiveDimensions.responsiveFontSize(24),
            ),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(4)),
            Text(
              'خطأ في الصورة',
              style: getRegular(
                fontSize: ResponsiveDimensions.responsiveFontSize(9),
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainButton(ServiceImage image, ServiceController controller) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: !image.isMain
            ? () {
                controller.setMainImage(image.id);
                Get.snackbar(
                  'تم التحديث',
                  'تم تعيين الصورة كرئيسية',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 1),
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            : null,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.responsiveWidth(6),
            vertical: ResponsiveDimensions.responsiveHeight(4),
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: image.isMain ? AppColors.primary400 : Colors.grey[400]!,
              width: 1,
            ),
            color: image.isMain ? AppColors.primary50 : Colors.transparent,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                image.isMain ? Icons.star : Icons.star_outline,
                size: ResponsiveDimensions.responsiveFontSize(12),
                color: image.isMain ? AppColors.primary400 : Colors.grey[600],
              ),
              SizedBox(width: ResponsiveDimensions.responsiveWidth(4)),
              Text(
                image.isMain ? 'رئيسية' : 'تعيين',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.responsiveFontSize(11),
                  color: image.isMain ? AppColors.primary400 : Colors.grey[600],
                  fontWeight: image.isMain
                      ? FontWeight.bold
                      : FontWeight.normal,
                  fontFamily: "PingAR",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteButton(ServiceImage image, ServiceController controller) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          _showDeleteDialog(image, controller);
        },
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: ResponsiveDimensions.responsiveWidth(32),
          height: ResponsiveDimensions.responsiveWidth(32),
          decoration: BoxDecoration(
            color: Colors.red[50],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.red[200]!, width: 1),
          ),
          child: Center(
            child: Icon(
              Icons.delete_outline,
              size: ResponsiveDimensions.responsiveFontSize(16),
              color: Colors.red[400],
            ),
          ),
        ),
      ),
    );
  }

  int _calculateCrossAxisCount(double screenWidth) {
    if (screenWidth >= 1200) return 4;
    if (screenWidth >= 900) return 3;
    if (screenWidth >= 600) return 2;
    return 2;
  }

  void _handleReorder(int oldIndex, newIndex) {
    if (oldIndex >= _controller.serviceImages.length ||
        newIndex >= _controller.serviceImages.length) {
      return;
    }

    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    _controller.reorderImages(oldIndex, newIndex);

    Get.snackbar(
      'تم إعادة الترتيب',
      'تم نقل الصورة إلى الموضع ${newIndex + 1}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void _showDeleteDialog(ServiceImage image, ServiceController controller) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(
              Icons.warning,
              color: Colors.orange,
              size: ResponsiveDimensions.responsiveFontSize(20),
            ),
            SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
            Text('حذف الصورة', style: getBold()),
          ],
        ),
        content: Text(
          'هل أنت متأكد من حذف هذه الصورة؟',
          style: getRegular(
            fontSize: ResponsiveDimensions.responsiveFontSize(14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'إلغاء',
              style: getRegular(
                color: Color(0xFFBDBDBD),
                fontSize: ResponsiveDimensions.responsiveFontSize(14),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.removeImage(image.id);

              Get.snackbar(
                'تم الحذف',
                'تم حذف الصورة بنجاح',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 1),
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            child: Text(
              'حذف',
              style: getRegular(
                fontSize: ResponsiveDimensions.responsiveFontSize(14),
              ),
            ),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}