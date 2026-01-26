import '../../../../general_index.dart';
import '../../../../utils/responsive/index.dart';

class ProductVariationsScreen extends StatelessWidget {
  const ProductVariationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProductVariationController>(
      init: ProductVariationController(),
      initState: (_) {
        Get.find<ProductVariationController>().loadAttributesOnOpen();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(ResponsiveDimensions.f(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // _buildHeader(),
                        SizedBox(height: ResponsiveDimensions.h(24)),

                        VariationToggleWidget(),
                        SizedBox(height: ResponsiveDimensions.h(15)),

                        GetBuilder<ProductVariationController>(
                          id: 'variations',
                          builder: (_) {
                            return controller.hasVariations
                                ? _buildVariationsContent()
                                : _buildNoVariationsContent();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.f(16),
        vertical: ResponsiveDimensions.f(12),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[300]!, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.primary400,
              size: ResponsiveDimensions.f(24),
            ),
            onPressed: () => Get.back(),
          ),
          SizedBox(width: ResponsiveDimensions.w(12)),
          Expanded(
            child: Text(
              'الاختلافات والكميات',
              style: getBold(
                fontSize: ResponsiveDimensions.f(18),
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildHeader() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'الاختلافات والكميات',
  //         style: getBold(
  //           fontSize: ResponsiveDimensions.f(20),
  //           color: Colors.black87,
  //         ),
  //       ),
  //       SizedBox(height: ResponsiveDimensions.h(8)),
  //       Text(
  //         'إدارة اختلافات المنتج والكميات المتاحة لكل اختلاف',
  //         style: getRegular(
  //           fontSize: ResponsiveDimensions.f(14),
  //           color: Colors.grey,
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget _buildNoVariationsContent() {
    return Column(
      spacing: 15,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/images/svg_images/background_change.svg',
          semanticsLabel: 'My SVG Image',
          height: 160,
          width: 160,
        ),
        Text(
          'لم يتم اضافة اي اختلافات بعد!',
          style: getRegular(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildVariationsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // AttributesManagementWidget(),
        SizedBox(height: ResponsiveDimensions.h(20)),

        SelectedAttributesWidget(),

        SizedBox(height: ResponsiveDimensions.h(32)),
        VariationsListWidget(),
      ],
    );
  }

  Widget _buildBottomActions(ProductVariationController controller) {
    final productController = Get.find<ProductCentralController>();

    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.f(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => Get.back(),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  vertical: ResponsiveDimensions.h(14),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide(color: Colors.grey[400]!),
              ),
              child: Text(
                'رجوع',
                style: getRegular(
                  color: Colors.grey,
                  fontSize: ResponsiveDimensions.f(16),
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveDimensions.w(12)),
          Expanded(
            child: GetBuilder<ProductVariationController>(
              builder: (_) {
                return ElevatedButton(
                  onPressed: () =>
                      _saveVariationsAndContinue(controller, productController),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary400,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveDimensions.h(14),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('التالي', style: getMedium(color: Colors.white)),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _saveVariationsAndContinue(
    ProductVariationController controller,
    ProductCentralController productController,
  ) {
    if (productController.selectedSection.value == null) {
      Get.snackbar(
        'قسم مطلوب',
        'يرجى اختيار قسم للمنتج قبل المتابعة',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    final validationResult = controller.validateVariations();
    if (!validationResult.isValid) {
      Get.snackbar(
        'تنبيه',
        validationResult.errorMessage,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    final variationsData = controller.getVariationsData();
    final variationsList =
        (variationsData['variations'] as List<Map<String, dynamic>>?) ?? [];

    productController.addVariations(variationsList);

    controller.saveCurrentState();

    print('✅ [VARIATIONS SAVED]: ${variationsList.length} اختلاف محفوظ');
    print(
      '✅ [SELECTED SECTION]: ${productController.selectedSection.value?.name}',
    );

    Get.snackbar(
      'نجاح',
      'تم حفظ الاختلافات بنجاح',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    Get.toNamed('/related-products');
  }
}
