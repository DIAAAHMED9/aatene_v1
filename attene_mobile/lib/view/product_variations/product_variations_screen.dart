import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:attene_mobile/controller/product_controller.dart';
import 'package:attene_mobile/view/product_variations/product_variation_controller.dart';
import 'package:attene_mobile/view/product_variations/widgets/variation_widgets.dart';

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
                        _buildHeader(),
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
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(18),
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الاختلافات والكميات',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(20),
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: ResponsiveDimensions.h(8)),
        Text(
          'إدارة اختلافات المنتج والكميات المتاحة لكل اختلاف',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(14),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildNoVariationsContent() {
    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.w(24)),
      margin: EdgeInsets.only(top: ResponsiveDimensions.h(40)),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: ResponsiveDimensions.w(60),
            color: Colors.grey[400],
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          Text(
            'المنتج بدون اختلافات',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(16),
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: ResponsiveDimensions.h(8)),
          Text(
            'سيتم إضافة المنتج كصنف واحد بدون اختلافات',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(14),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVariationsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AttributesManagementWidget(),
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
                style: TextStyle(
                  color: Colors.grey[700],
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
                  child: Text(
                    'التالي',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: ResponsiveDimensions.f(16),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
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
