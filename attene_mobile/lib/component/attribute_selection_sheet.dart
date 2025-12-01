// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:attene_mobile/utlis/colors/app_color.dart';
// import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
// import 'package:attene_mobile/view/product_variations/product_variation_controller.dart';
// import 'package:attene_mobile/view/product_variations/product_variation_model.dart';

// class AttributeSelectionSheet extends StatelessWidget {
//   final ProductVariation variation;
//   final ProductAttribute attribute;
//   final ProductVariationController controller = Get.find<ProductVariationController>();

//   AttributeSelectionSheet({
//     super.key,
//     required this.variation,
//     required this.attribute,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: Get.height * 0.6,
//       padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       child: Column(
//         children: [
//           Container(
//             width: ResponsiveDimensions.w(40),
//             height: ResponsiveDimensions.h(4),
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(2),
//             ),
//           ),
//           SizedBox(height: ResponsiveDimensions.h(16)),
//           Text(
//             'اختر ${attribute.name}',
//             style: TextStyle(
//               fontSize: ResponsiveDimensions.f(18),
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: ResponsiveDimensions.h(16)),
//           Expanded(
//             child: GetBuilder<ProductVariationController>(
//               id: ProductVariationController.bottomSheetUpdateId,
//               builder: (controller) {
//                 final updatedAttribute = controller.allAttributes.firstWhere(
//                   (attr) => attr.id == attribute.id,
//                   orElse: () => attribute,
//                 );
                
//                 final selectedValues = updatedAttribute.values.where((v) => v.isSelected.value).toList();
                
//                 if (selectedValues.isEmpty) {
//                   return Center(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.list_alt_outlined, 
//                           size: ResponsiveDimensions.w(60), 
//                           color: Colors.grey[400]
//                         ),
//                         SizedBox(height: ResponsiveDimensions.h(16)),
//                         Text('لا توجد صفات متاحة لـ ${attribute.name}'),
//                         SizedBox(height: ResponsiveDimensions.h(8)),
//                         Text('يرجى إضافة صفات أولاً'),
//                       ],
//                     ),
//                   );
//                 }
                
//                 return ListView.builder(
//                   itemCount: selectedValues.length,
//                   itemBuilder: (context, index) {
//                     final value = selectedValues[index];
//                     return ListTile(
//                       leading: _buildRadioButton(attribute.name, value.value),
//                       title: Text(
//                         value.value,
//                         style: TextStyle(
//                           fontWeight: variation.attributes[attribute.name] == value.value 
//                               ? FontWeight.bold 
//                               : FontWeight.normal,
//                         ),
//                       ),
//                       onTap: () {
//                         controller.updateVariationAttribute(variation, attribute.name, value.value);
//                         Get.back();
//                       },
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildRadioButton(String attributeName, String value) {
//     final currentValue = variation.attributes[attributeName];
//     final isSelected = currentValue == value;
    
//     return Container(
//       width: ResponsiveDimensions.w(24),
//       height: ResponsiveDimensions.h(24),
//       decoration: BoxDecoration(
//         shape: BoxShape.circle,
//         border: Border.all(
//           color: isSelected ? AppColors.primary400 : Colors.grey[400]!,
//           width: 2,
//         ),
//       ),
//       child: Center(
//         child: Container(
//           width: ResponsiveDimensions.w(12),
//           height: ResponsiveDimensions.h(12),
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             color: isSelected ? AppColors.primary400 : Colors.transparent,
//           ),
//         ),
//       ),
//     );
//   }
// }