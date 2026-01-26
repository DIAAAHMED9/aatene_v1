import '../../../../general_index.dart';
import '../../../../utils/responsive/responsive_dimensions.dart';

class VariationToggleWidget extends StatelessWidget {
  const VariationToggleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductVariationController>();

    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('هل يوجد اختلافات للمنتج؟', style: getMedium(fontSize: 14)),
            SizedBox(width: ResponsiveDimensions.w(8)),
           GestureDetector(
             onTap: () {
               showDialog(
                 context: context,
                 builder: (context) => AlertDialog(
                   title: Text(
                     'ما هي الاختلافات',
                     textAlign: TextAlign.center,
                     style: getBold(fontSize: ResponsiveDimensions.f(18)),
                   ),
                   actions: [
                     AateneButton(
                       onTap: () => Get.back(),
                       buttonText: 'الغاء',
                       color: AppColors.primary400,
                       textColor: AppColors.light1000,
                       borderColor: AppColors.primary400,
                     ),

                   ],
                   content: Text(
                     textAlign: TextAlign.center,

                     'الاختلافات هي النسخ المختلفة للمنتج (مثل الألوان، المقاسات، الخ)',
                     style: getMedium(),
                   ),
                 ),
               );
             },

             child: Row(
               spacing: 5,
               children: [
                 Icon(
                      Icons.help_outline,
                      color: AppColors.primary300,
                      size: ResponsiveDimensions.w(20),
                    ),
                 Text("ما هي اختلافات المنتج",style: getMedium(fontSize: 12,color: AppColors.primary300),),
               ],
             ),
           ),

          ],
        ),
        // Text(
        //   'الاختلافات هي النسخ المختلفة للمنتج (مثل الألوان، المقاسات، الخ)',
        //   style: getRegular(
        //     fontSize: ResponsiveDimensions.f(14),
        //     color: Colors.grey,
        //   ),
        // ),
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
        AttributesManagementWidget(),
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
              height: ResponsiveDimensions.h(24),
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
              style: getRegular(
                color: isSelected ? AppColors.primary400 : Colors.grey,
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
      color: AppColors.primary50,
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
        // if (controller.selectedAttributes.isEmpty) {
        //   return _buildNoAttributesSelected();
        // }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('سمات المنتج', style: getMedium()),
                SizedBox(width: ResponsiveDimensions.w(8)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveDimensions.w(8),
                    vertical: ResponsiveDimensions.h(4),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${controller.selectedAttributes.length}',
                    style: getBold(
                      color: AppColors.primary400,
                      fontSize: ResponsiveDimensions.f(12),
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
                  backgroundColor: AppColors.primary50,
                  deleteIconColor: AppColors.primary400,
                  onDeleted: () =>
                      controller.removeSelectedAttribute(attribute),
                  labelStyle: getRegular(color: AppColors.primary500),
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

  // Widget _buildNoAttributesSelected() {
  //   return Container(
  //     padding: EdgeInsets.all(ResponsiveDimensions.w(20)),
  //     margin: EdgeInsets.only(top: ResponsiveDimensions.h(16)),
  //     decoration: BoxDecoration(
  //       color: Colors.orange[50],
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.orange[200]!),
  //     ),
  //     child: Row(
  //       children: [
  //         Icon(
  //           Icons.info_outline,
  //           color: Colors.orange[600],
  //           size: ResponsiveDimensions.w(24),
  //         ),
  //         SizedBox(width: ResponsiveDimensions.w(12)),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'لم يتم اختيار أي سمات بعد',
  //                 style: getMedium(
  //                   fontSize: ResponsiveDimensions.f(14),
  //                   color: Colors.orange,
  //                 ),
  //               ),
  //               SizedBox(height: ResponsiveDimensions.h(4)),
  //               Text(
  //                 'انقر على "إدارة السمات والصفات" لبدء إضافة السمات',
  //                 style: getRegular(
  //                   fontSize: ResponsiveDimensions.f(12),
  //                   color: Colors.orange,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
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
                    children: [TextWithStar(text: "قيم الاختلافات")],
                  ),
                ],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextWithStar(text: "قيم الاختلافات"),
                  Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary50,
                      elevation: 0,
                    ),
                    onPressed: controller.openAttributesManagement,
                    child: Text(
                      '+ قيمة جديدة',
                      style: getRegular(color: AppColors.primary400),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: 15,
      children: [
        Image.asset("assets/images/png/backgound_full.png",height: 160,width: 160,fit: BoxFit.cover,),
        Text(
          'لم يتم اضافة اي قيم بعد!',
          style: getRegular(),
        ),
      
      ],
    );
  }
}
