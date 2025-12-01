import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/variation_card.dart';
import 'package:attene_mobile/controller/product_controller.dart';
import 'package:attene_mobile/utlis/responsive/responsive_helper.dart';
import 'package:attene_mobile/utlis/sheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/appBar/custom_appbar.dart';
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:attene_mobile/view/product_variations/product_variation_controller.dart';

class ProductVariationsScreen extends StatefulWidget {
  const ProductVariationsScreen({super.key});

  @override
  State<ProductVariationsScreen> createState() => _ProductVariationsScreenState();
}

class _ProductVariationsScreenState extends State<ProductVariationsScreen> {
  final ProductVariationController controller = Get.find<ProductVariationController>();
  final BottomSheetController bottomSheetController = Get.find<BottomSheetController>();

  @override
  void initState() {
    super.initState();
    // ✅ تحميل السمات عند فتح الشاشة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadAttributesOnOpen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth > 600;
          
          return Column(
            children: [
              _buildAppBar(isWideScreen: isWideScreen),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(VariationResponsive.cardPadding),
                  child: _buildContent(isWideScreen: isWideScreen),
                ),
              ),
              _buildBottomActions(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar({required bool isWideScreen}) {
    return CustomAppBarWithTabs(
      isRTL: LanguageUtils.isRTL,
      config: AppBarConfig(
        title: 'الاختلافات والكميات',
        actionText: '',
        showSearch: false,
        showTabs: false,
      ),
    );
  }

  Widget _buildContent({required bool isWideScreen}) {
    return Column(
      crossAxisAlignment: isWideScreen ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        _buildHeader(isWideScreen: isWideScreen),
        SizedBox(height: ResponsiveDimensions.h(24)),
        _buildVariationQuestion(),
        SizedBox(height: ResponsiveDimensions.h(16)),
        _buildVariationToggle(isWideScreen: isWideScreen),
        SizedBox(height: ResponsiveDimensions.h(32)),
        _buildMainContent(),
      ],
    );
  }

  Widget _buildHeader({required bool isWideScreen}) {
    return Column(
      crossAxisAlignment: isWideScreen ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          'الاختلافات والكميات',
          style: TextStyle(
            fontSize: isWideScreen ? ResponsiveDimensions.f(20) : ResponsiveDimensions.f(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveDimensions.h(8)),
        Text(
          'إدارة اختلافات المنتج والكميات المتاحة لكل اختلاف',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(14),
            color: Colors.grey[600],
          ),
          textAlign: isWideScreen ? TextAlign.center : TextAlign.start,
        ),
      ],
    );
  }

  Widget _buildVariationQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'هل يوجد اختلافات للمنتج؟',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(16),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: ResponsiveDimensions.w(8)),
            Icon(
              Icons.help_outline,
              color: AppColors.primary400,
              size: ResponsiveDimensions.w(20),
            ),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.h(4)),
        Text(
          'الاختلافات هي النسخ المختلفة للمنتج (مثل الألوان، المقاسات، الخ)',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(14),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildVariationToggle({required bool isWideScreen}) {
    return GetBuilder<ProductVariationController>(
      id: ProductVariationController.attributesUpdateId,
      builder: (controller) {
        return Row(
          children: [
            Expanded(
              child: _buildToggleButton(
                text: 'نعم',
                isSelected: controller.hasVariations.value,
                onTap: () => controller.toggleHasVariations(true),
              ),
            ),
            SizedBox(width: ResponsiveDimensions.w(12)),
            Expanded(
              child: _buildToggleButton(
                text: 'لا',
                isSelected: !controller.hasVariations.value,
                onTap: () => controller.toggleHasVariations(false),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildToggleButton({
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveDimensions.h(14),
          horizontal: ResponsiveDimensions.w(16),
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary400 : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary400 : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.w500,
              fontSize: ResponsiveDimensions.f(16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return GetBuilder<ProductVariationController>(
      id: ProductVariationController.attributesUpdateId,
      builder: (controller) {
        return controller.hasVariations.value ? _buildVariationsContent() : _buildNoVariationsContent();
      },
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
        _buildManagementSection(),
        SizedBox(height: ResponsiveDimensions.h(20)),
        _buildAttributesContent(),
        _buildVariationsContentSection(),
      ],
    );
  }

  Widget _buildManagementSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AateneButton(
          buttonText: 'إدارة السمات والصفات',
          color: AppColors.primary400,
          textColor: Colors.white,
          onTap: () {
            // ✅ استخدام الـ BottomSheetController مباشرة
            bottomSheetController.openManageAttributes(controller.allAttributes);
          },
        ),
        SizedBox(height: ResponsiveDimensions.h(12)),
        Text(
          'قم بإضافة السمات مثل (اللون، المقاس، المادة) وقيمها لتتمكن من إنشاء الاختلافات',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(12),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildAttributesContent() {
    return GetBuilder<ProductVariationController>(
      id: ProductVariationController.attributesUpdateId,
      builder: (controller) {
        return controller.selectedAttributes.isNotEmpty 
            ? _buildSelectedAttributes() 
            : _buildNoAttributesSelected();
      },
    );
  }

  Widget _buildVariationsContentSection() {
    return GetBuilder<ProductVariationController>(
      id: ProductVariationController.attributesUpdateId,
      builder: (controller) {
        return controller.selectedAttributes.isNotEmpty 
            ? _buildVariationsSection() 
            : const SizedBox();
      },
    );
  }

  Widget _buildNoAttributesSelected() {
    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.w(20)),
      margin: EdgeInsets.only(top: ResponsiveDimensions.h(16)),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Colors.orange[600],
            size: ResponsiveDimensions.w(24),
          ),
          SizedBox(width: ResponsiveDimensions.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'لم يتم اختيار أي سمات بعد',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(14),
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(4)),
                Text(
                  'انقر على "إدارة السمات والصفات" لبدء إضافة السمات',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(12),
                    color: Colors.orange[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedAttributes() {
    return GetBuilder<ProductVariationController>(
      id: ProductVariationController.attributesUpdateId,
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: ResponsiveDimensions.h(24)),
            Row(
              children: [
                Text(
                  'السمات المختارة',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: ResponsiveDimensions.w(8)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveDimensions.w(8),
                    vertical: ResponsiveDimensions.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.selectedAttributes.length}',
                    style: TextStyle(
                      color: AppColors.primary400,
                      fontSize: ResponsiveDimensions.f(12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDimensions.h(12)),
            Wrap(
              spacing: ResponsiveDimensions.w(8),
              runSpacing: ResponsiveDimensions.h(8),
              children: controller.selectedAttributes.map((attribute) {
                return Chip(
                  label: Text(attribute.name),
                  backgroundColor: AppColors.primary100,
                  deleteIconColor: AppColors.primary400,
                  onDeleted: () => controller.removeSelectedAttribute(attribute),
                  labelStyle: TextStyle(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide(
                      color: AppColors.primary300,
                      width: 1.0,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }

  Widget _buildVariationsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ResponsiveDimensions.h(32)),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 500;
            
            return isWide 
                ? _buildWideVariationsHeader()
                : _buildNarrowVariationsHeader();
          },
        ),
        SizedBox(height: ResponsiveDimensions.h(8)),
        Text(
          'انقر على "إنشاء قيمة جديدة" لإضافة بطاقة اختلاف واحدة في كل مرة',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(14),
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: ResponsiveDimensions.h(16)),
        _buildVariationsListContent(),
      ],
    );
  }

  Widget _buildWideVariationsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'قيم الاختلافات',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(18),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveDimensions.h(4)),
            GetBuilder<ProductVariationController>(
              id: ProductVariationController.variationsUpdateId,
              builder: (controller) {
                return Text(
                  '${controller.variations.length} اختلاف',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(14),
                    color: Colors.grey[600],
                  ),
                );
              },
            ),
          ],
        ),
        AateneButton(
          buttonText: 'إنشاء قيمة جديدة',
          color: AppColors.primary400,
          textColor: Colors.white,
          onTap: () => controller.generateSingleVariation(),
        ),
      ],
    );
  }

  Widget _buildNarrowVariationsHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'قيم الاختلافات',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveDimensions.h(4)),
        GetBuilder<ProductVariationController>(
          id: ProductVariationController.variationsUpdateId,
          builder: (controller) {
            return Text(
              '${controller.variations.length} اختلاف',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(14),
                color: Colors.grey[600],
              ),
            );
          },
        ),
        SizedBox(height: ResponsiveDimensions.h(12)),
        AateneButton(
          buttonText: 'إنشاء قيمة جديدة',
          color: AppColors.primary400,
          textColor: Colors.white,
          onTap: () => controller.generateSingleVariation(),
        ),
      ],
    );
  }

  Widget _buildVariationsListContent() {
    return GetBuilder<ProductVariationController>(
      id: ProductVariationController.variationsUpdateId,
      builder: (controller) {
        return controller.variations.isNotEmpty 
            ? _buildVariationsList() 
            : _buildNoVariations();
      },
    );
  }

  Widget _buildVariationsList() {
    return GetBuilder<ProductVariationController>(
      id: ProductVariationController.variationsUpdateId,
      builder: (controller) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.variations.length,
          itemBuilder: (context, index) {
            final variation = controller.variations[index];
            return VariationCard(
              key: ValueKey(variation.id),
              variation: variation,
            );
          },
        );
      },
    );
  }

  Widget _buildNoVariations() {
    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.w(24)),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.grid_view_outlined,
            size: ResponsiveDimensions.w(60),
            color: Colors.blue[400],
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          Text(
            'لم يتم إنشاء قيم الاختلافات بعد',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(16),
              color: Colors.blue[800],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(8)),
          Text(
            'انقر على "إنشاء قيمة جديدة" لبدء إضافة الاختلافات',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(14),
              color: Colors.blue[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: EdgeInsets.all(VariationResponsive.cardPadding),
      decoration: BoxDecoration(
        color: Colors.white,
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
                padding: EdgeInsets.symmetric(vertical: ResponsiveDimensions.h(14)),
                side: BorderSide(color: Colors.grey[300]!),
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
            child: AateneButton(
              buttonText: 'التالي',
              color: AppColors.primary400,
              textColor: Colors.white,
              onTap: _saveVariationsAndContinue,
            ),
          ),
        ],
      ),
    );
  }

// في lib/view/product_variations/product_variations_screen.dart - تحديث هذه الدالة فقط
void _saveVariationsAndContinue() {
  // ✅ التحقق من وجود قسم مختار
  final productCentralController = Get.find<ProductCentralController>();
  if (productCentralController.selectedSection.value == null) {
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
  
  // ✅ حفظ البيانات في ProductCentralController
  final variationsData = controller.getVariationsData();
  final variationsList = variationsData['variations']?.map((v) => v as Map<String, dynamic>).toList() ?? [];
  productCentralController.addVariations(variationsList);
  
  print('✅ [VARIATIONS SAVED]: ${variationsList.length} اختلاف محفوظ');
  print('✅ [SELECTED SECTION]: ${productCentralController.selectedSection.value?.name}');
  
  Get.snackbar(
    'نجاح',
    'تم حفظ الاختلافات بنجاح',
    backgroundColor: Colors.green,
    colorText: Colors.white,
  );
  
  Get.toNamed('/related-products');
}
}