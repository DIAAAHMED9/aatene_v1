// import 'package:attene_mobile/utlis/responsive/responsive_helper.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:attene_mobile/utlis/colors/app_color.dart';
// import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
// import 'package:attene_mobile/view/product_variations/product_variation_controller.dart';
// import 'package:attene_mobile/view/product_variations/product_variation_model.dart';

// class UnifiedBottomSheet extends StatelessWidget {
//   final ProductVariationController controller = Get.find<ProductVariationController>();

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: VariationResponsive.unifiedBottomSheetHeight,
//       padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
//       child: Column(
//         children: [
//           _buildHeader(),
//           SizedBox(height: ResponsiveDimensions.h(16)),
//           Expanded(
//             child: GetBuilder<ProductVariationController>(
//               id: ProductVariationController.bottomSheetUpdateId,
//               builder: (controller) {
//                 return IndexedStack(
//                   index: controller.currentTabIndex.value,
//                   children: [
//                     _buildAttributesTab(),
//                     _buildValuesTab(),
//                   ],
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return GetBuilder<ProductVariationController>(
//       id: ProductVariationController.bottomSheetUpdateId,
//       builder: (controller) {
//         return Column(
//           children: [
//             Container(
//               width: ResponsiveDimensions.w(40),
//               height: ResponsiveDimensions.h(4),
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             SizedBox(height: ResponsiveDimensions.h(16)),
//             Text(
//               'إدارة السمات والصفات',
//               style: TextStyle(
//                 fontSize: ResponsiveDimensions.f(18),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: ResponsiveDimensions.h(16)),
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.grey[100],
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: _buildTabButton(
//                       text: 'السمات',
//                       isActive: controller.currentTabIndex.value == 0,
//                       onTap: () => controller.changeTab(0),
//                     ),
//                   ),
//                   Expanded(
//                     child: _buildTabButton(
//                       text: 'الصفات',
//                       isActive: controller.currentTabIndex.value == 1,
//                       onTap: () => controller.changeTab(1),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildTabButton({
//     required String text,
//     required bool isActive,
//     required VoidCallback onTap,
//   }) {
//     return InkWell(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.symmetric(vertical: ResponsiveDimensions.h(12)),
//         decoration: BoxDecoration(
//           color: isActive ? AppColors.primary400 : Colors.transparent,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               color: isActive ? Colors.white : Colors.grey[700],
//               fontWeight: FontWeight.w600,
//               fontSize: ResponsiveDimensions.f(16),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAttributesTab() {
//     return Column(
//       children: [
//         SizedBox(height: ResponsiveDimensions.h(16)),
//         _buildSearchBar(),
//         SizedBox(height: ResponsiveDimensions.h(16)),
//         _buildAddAttributeSection(),
//         SizedBox(height: ResponsiveDimensions.h(16)),
//         Expanded(
//           child: _buildAttributesList(),
//         ),
//         _buildAttributesTabButton(),
//       ],
//     );
//   }

//   Widget _buildSearchBar() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.w(16)),
//       child: TextField(
//         controller: controller.searchController,
//         focusNode: controller.searchFocusNode,
//         decoration: InputDecoration(
//           hintText: 'بحث في السمات...',
//           prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25),
//             borderSide: BorderSide(color: Colors.grey[300]!),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(25),
//             borderSide: BorderSide(color: AppColors.primary400),
//           ),
//           filled: true,
//           fillColor: Colors.grey[50],
//           contentPadding: EdgeInsets.symmetric(
//             horizontal: ResponsiveDimensions.w(16),
//             vertical: ResponsiveDimensions.h(14),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildAttributesList() {
//     return GetBuilder<ProductVariationController>(
//       id: ProductVariationController.bottomSheetUpdateId,
//       builder: (controller) {
//         final filteredAttributes = controller.filteredAttributes;
//         final searchQuery = controller.searchQuery.value;
        
//         if (filteredAttributes.isEmpty && searchQuery.isNotEmpty) {
//           return _buildNoSearchResults();
//         }
        
//         return ListView.builder(
//           itemCount: filteredAttributes.length,
//           itemBuilder: (context, index) {
//             final attribute = filteredAttributes[index];
//             return _buildAttributeListItem(attribute);
//           },
//         );
//       },
//     );
//   }

//   Widget _buildAddAttributeSection() {
//     return GetBuilder<ProductVariationController>(
//       id: ProductVariationController.bottomSheetUpdateId,
//       builder: (controller) {
//         return Card(
//           margin: EdgeInsets.zero,
//           child: Padding(
//             padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'إضافة سمة جديدة',
//                   style: TextStyle(
//                     fontSize: ResponsiveDimensions.f(16),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: ResponsiveDimensions.h(12)),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey[300]!),
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: controller.newAttributeController,
//                           focusNode: controller.newAttributeFocusNode,
//                           decoration: InputDecoration(
//                             hintText: 'أدخل اسم السمة الجديدة...',
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: ResponsiveDimensions.w(16),
//                               vertical: ResponsiveDimensions.h(14),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(right: ResponsiveDimensions.w(8)),
//                         child: InkWell(
//                           onTap: controller.newAttributeName.value.trim().isNotEmpty 
//                               ? () {
//                                   controller.addNewAttribute();
//                                 }
//                               : null,
//                           borderRadius: BorderRadius.circular(20),
//                           child: Container(
//                             width: ResponsiveDimensions.w(40),
//                             height: ResponsiveDimensions.h(40),
//                             decoration: BoxDecoration(
//                               color: controller.newAttributeName.value.trim().isNotEmpty 
//                                   ? AppColors.primary400 
//                                   : Colors.grey[400],
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.add,
//                               color: Colors.white,
//                               size: ResponsiveDimensions.w(20),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAttributeListItem(ProductAttribute attribute) {
//     return GetBuilder<ProductVariationController>(
//       id: ProductVariationController.bottomSheetUpdateId,
//       builder: (controller) {
//         final isSelected = controller.isAttributeSelected(attribute);
        
//         return Card(
//           margin: EdgeInsets.symmetric(vertical: ResponsiveDimensions.h(4)),
//           child: ListTile(
//             leading: Checkbox(
//               value: isSelected,
//               onChanged: (value) => controller.toggleAttributeSelection(attribute),
//               activeColor: AppColors.primary400,
//             ),
//             title: Text(
//               attribute.name,
//               style: TextStyle(
//                 fontWeight: FontWeight.w500,
//                 color: isSelected ? AppColors.primary400 : Colors.black87,
//               ),
//             ),
//             subtitle: Text('${attribute.values.length} صفة'),
//             trailing: Icon(Icons.category),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAttributesTabButton() {
//     return GetBuilder<ProductVariationController>(
//       id: ProductVariationController.bottomSheetUpdateId,
//       builder: (controller) {
//         final hasSelectedAttributes = controller.selectedAttributes.isNotEmpty;
        
//         if (hasSelectedAttributes) {
//           return Padding(
//             padding: EdgeInsets.only(top: ResponsiveDimensions.h(16)),
//             child: ElevatedButton(
//               onPressed: () => controller.changeTab(1),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary400,
//                 minimumSize: Size(double.infinity, ResponsiveDimensions.h(50)),
//               ),
//               child: Text(
//                 'الانتقال إلى إضافة الصفات',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: ResponsiveDimensions.f(16),
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           );
//         }
//         return SizedBox();
//       },
//     );
//   }

//   Widget _buildValuesTab() {
//     return Column(
//       children: [
//         SizedBox(height: ResponsiveDimensions.h(16)),
//         _buildAttributeSelector(),
//         SizedBox(height: ResponsiveDimensions.h(16)),
//         _buildAddValueSection(),
//         SizedBox(height: ResponsiveDimensions.h(16)),
//         Expanded(
//           child: _buildAttributeValuesContent(),
//         ),
//       ],
//     );
//   }

//   Widget _buildAttributeSelector() {
//     return GetBuilder<ProductVariationController>(
//       id: ProductVariationController.bottomSheetUpdateId,
//       builder: (controller) {
//         final selectedAttributes = controller.selectedAttributes;
//         final currentEditingAttribute = controller.currentEditingAttribute.value;
        
//         if (selectedAttributes.isEmpty) {
//           return Card(
//             child: Padding(
//               padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
//               child: Text('لم يتم اختيار أي سمات بعد'),
//             ),
//           );
//         }
        
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'اختر سمة لإضافة الصفات:',
//               style: TextStyle(fontWeight: FontWeight.w600),
//             ),
//             SizedBox(height: ResponsiveDimensions.h(8)),
//             Wrap(
//               spacing: ResponsiveDimensions.w(8),
//               children: selectedAttributes.map((attribute) {
//                 final isActive = currentEditingAttribute?.id == attribute.id;
//                 return ChoiceChip(
//                   label: Text(attribute.name),
//                   selected: isActive,
//                   onSelected: (selected) => controller.setCurrentEditingAttribute(attribute),
//                   selectedColor: AppColors.primary400,
//                   labelStyle: TextStyle(
//                     color: isActive ? Colors.white : Colors.black87,
//                   ),
//                 );
//               }).toList(),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildAddValueSection() {
//     return GetBuilder<ProductVariationController>(
//       id: ProductVariationController.bottomSheetUpdateId,
//       builder: (controller) {
//         final currentAttribute = controller.currentEditingAttribute.value;
//         if (currentAttribute == null) {
//           return _buildNoAttributeSelected();
//         }
        
//         return Card(
//           margin: EdgeInsets.zero,
//           child: Padding(
//             padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'إضافة صفة لـ ${currentAttribute.name}',
//                   style: TextStyle(
//                     fontSize: ResponsiveDimensions.f(16),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(height: ResponsiveDimensions.h(12)),
//                 Container(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey[300]!),
//                     borderRadius: BorderRadius.circular(25),
//                   ),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: TextField(
//                           controller: controller.newAttributeValueController,
//                           focusNode: controller.newAttributeValueFocusNode,
//                           decoration: InputDecoration(
//                             hintText: 'أدخل ${currentAttribute.name} جديد...',
//                             border: InputBorder.none,
//                             contentPadding: EdgeInsets.symmetric(
//                               horizontal: ResponsiveDimensions.w(16),
//                               vertical: ResponsiveDimensions.h(14),
//                             ),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(right: ResponsiveDimensions.w(8)),
//                         child: InkWell(
//                           onTap: controller.newAttributeValue.value.trim().isNotEmpty 
//                               ? () {
//                                   controller.addNewAttributeValue();
//                                 }
//                               : null,
//                           borderRadius: BorderRadius.circular(20),
//                           child: Container(
//                             width: ResponsiveDimensions.w(40),
//                             height: ResponsiveDimensions.h(40),
//                             decoration: BoxDecoration(
//                               color: controller.newAttributeValue.value.trim().isNotEmpty 
//                                   ? AppColors.primary400 
//                                   : Colors.grey[400],
//                               shape: BoxShape.circle,
//                             ),
//                             child: Icon(
//                               Icons.add,
//                               color: Colors.white,
//                               size: ResponsiveDimensions.w(20),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAttributeValuesContent() {
//     return GetBuilder<ProductVariationController>(
//       id: ProductVariationController.bottomSheetUpdateId,
//       builder: (controller) {
//         final currentAttribute = controller.currentEditingAttribute.value;
//         if (currentAttribute == null) {
//           return _buildNoAttributeSelected();
//         }
        
//         return Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Text(
//                   'صفات ${currentAttribute.name}',
//                   style: TextStyle(
//                     fontSize: ResponsiveDimensions.f(16),
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 SizedBox(width: ResponsiveDimensions.w(8)),
//                 Obx(() {
//                   final selectedCount = currentAttribute.values.where((v) => v.isSelected.value).length;
//                   return Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: ResponsiveDimensions.w(8),
//                       vertical: ResponsiveDimensions.h(2),
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColors.primary100,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       '$selectedCount/${currentAttribute.values.length}',
//                       style: TextStyle(
//                         color: AppColors.primary400,
//                         fontSize: ResponsiveDimensions.f(12),
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   );
//                 }),
//               ],
//             ),
//             SizedBox(height: ResponsiveDimensions.h(12)),
//             Expanded(
//               child: _buildAttributeValuesList(currentAttribute),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildAttributeValuesList(ProductAttribute attribute) {
//     return Obx(() {
//       if (attribute.values.isEmpty) {
//         return _buildNoValuesYet(attribute);
//       }
      
//       return ListView.builder(
//         itemCount: attribute.values.length,
//         itemBuilder: (context, index) {
//           final value = attribute.values[index];
//           return _buildValueListItem(value);
//         },
//       );
//     });
//   }

//   Widget _buildValueListItem(AttributeValue value) {
//     return Card(
//       margin: EdgeInsets.symmetric(vertical: ResponsiveDimensions.h(4)),
//       child: Obx(() => ListTile(
//         leading: Checkbox(
//           value: value.isSelected.value,
//           onChanged: (val) => controller.toggleAttributeValueSelection(value),
//           activeColor: AppColors.primary400,
//         ),
//         title: Text(
//           value.value,
//           style: TextStyle(
//             fontWeight: value.isSelected.value ? FontWeight.bold : FontWeight.normal,
//           ),
//         ),
//         trailing: Icon(
//           value.isSelected.value ? Icons.check_circle : Icons.radio_button_unchecked,
//           color: value.isSelected.value ? AppColors.primary400 : Colors.grey,
//         ),
//       )),
//     );
//   }

//   Widget _buildNoSearchResults() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.search_off, 
//             size: ResponsiveDimensions.w(60), 
//             color: Colors.grey
//           ),
//           SizedBox(height: ResponsiveDimensions.h(16)),
//           Text('لا توجد نتائج للبحث'),
//         ],
//       ),
//     );
//   }

//   Widget _buildNoAttributeSelected() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.category_outlined, 
//             size: ResponsiveDimensions.w(60), 
//             color: Colors.grey
//           ),
//           SizedBox(height: ResponsiveDimensions.h(16)),
//           Text('اختر سمة لإضافة الصفات'),
//         ],
//       ),
//     );
//   }

//   Widget _buildNoValuesYet(ProductAttribute attribute) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(Icons.list_alt_outlined, 
//             size: ResponsiveDimensions.w(60), 
//             color: Colors.grey
//           ),
//           SizedBox(height: ResponsiveDimensions.h(16)),
//           Text('لا توجد صفات لـ ${attribute.name} بعد'),
//           SizedBox(height: ResponsiveDimensions.h(8)),
//           Text('استخدم الحقل أعلاه لإضافة الصفات الأولى'),
//         ],
//       ),
//     );
//   }
// }