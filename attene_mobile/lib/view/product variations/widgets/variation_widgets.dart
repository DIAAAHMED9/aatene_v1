import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import '../product_variation_controller.dart';
import '../variation_card.dart';

class VariationToggleWidget extends StatelessWidget {
  const VariationToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductVariationController>();

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
        SizedBox(height: ResponsiveDimensions.h(16)),
        GetBuilder<ProductVariationController>(
          id: 'variations',
          builder: (_) {
            final hasVariations = controller.hasVariations;
            return Row(
              children: [
                _buildRadioOption(
                  label: 'نعم',
                  isSelected: hasVariations,
                  onTap: () => controller.toggleHasVariations(true),
                ),
                SizedBox(width: ResponsiveDimensions.w(32)),
                _buildRadioOption(
                  label: 'لا',
                  isSelected: !hasVariations,
                  onTap: () => controller.toggleHasVariations(false),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildRadioOption({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: ResponsiveDimensions.h(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ResponsiveDimensions.w(24),
              height: ResponsiveDimensions.w(24),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary400 : Colors.grey[400]!,
                  width: isSelected ? 8 : 2,
                ),
                color: Colors.transparent,
              ),
            ),
            SizedBox(width: ResponsiveDimensions.w(12)),
            Text(
              label,
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(16),
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primary400 : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AttributesManagementWidget extends StatelessWidget {
  const AttributesManagementWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductVariationController>();

    return AateneButton(
      buttonText: '+  إدارة السمات والصفات',
      color: AppColors.primary100,
      textColor: AppColors.primary500,
      borderColor: AppColors.primary300,
      onTap: controller.openAttributesManagement,
    );
  }
}

class SelectedAttributesWidget extends StatelessWidget {
  const SelectedAttributesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductVariationController>();

    return GetBuilder<ProductVariationController>(
      id: 'attributes',
      builder: (_) {
        if (controller.selectedAttributes.isEmpty) {
          return _buildNoAttributesSelected();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'سمات المنتج',
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
                final selectedValues = attribute.values
                    .where((value) => value.isSelected.value)
                    .map((value) => value.value)
                    .toList();

                return Chip(
                  label: Text(attribute.name),
                  backgroundColor: AppColors.primary100,
                  deleteIconColor: AppColors.primary400,
                  onDeleted: () =>
                      controller.removeSelectedAttribute(attribute),
                  labelStyle: TextStyle(
                    color: AppColors.primary500,
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                    side: BorderSide(color: AppColors.primary300, width: 1.0),
                  ),
                );
              }).toList(),
            ),
          ],
        );
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
}

class VariationsListWidget extends StatelessWidget {
  const VariationsListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductVariationController>();

    return GetBuilder<ProductVariationController>(
      id: 'variations',
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVariationsHeader(controller),

            SizedBox(height: ResponsiveDimensions.h(16)),
            _buildVariationsContent(controller),
          ],
        );
      },
    );
  }

  Widget _buildVariationsHeader(ProductVariationController controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 500;

        return isWide
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'قيم الاختلافات',
                            style: TextStyle(
                              fontSize: ResponsiveDimensions.f(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            '*',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: ResponsiveDimensions.f(18),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          AateneButton(
                            buttonText: ' قيمة جديدة',
                            color: AppColors.primary400,
                            textColor: Colors.white,
                            borderColor: Colors.transparent,
                            onTap: () => controller.generateSingleVariation(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'قيم الاختلافات',
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.f(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 6),
                  Text(
                    '*',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: ResponsiveDimensions.f(18),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary100,
                      elevation: 0,
                    ),
                    onPressed: () {},

                    child: Text(
                      '+ قيمة جديدة',
                      style: TextStyle(color: AppColors.primary400),
                    ),
                  ),
                ],
              );
      },
    );
  }

  Widget _buildVariationsContent(ProductVariationController controller) {
    if (controller.variations.isEmpty) {
      return _buildNoVariations();
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.variations.length,
      itemBuilder: (context, index) {
        final variation = controller.variations[index];
        return VariationCard(
          key: ValueKey(variation.id),
          variation: variation,
          controller: controller,
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
}
