import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/models/section_model.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/widgets/add_product_widgets.dart';

import 'add_product_controller.dart';

class AddProductContent extends StatelessWidget {
  const AddProductContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    
    final selectedSection = Get.arguments?['selectedSection'] as Section?;
    
    if (selectedSection == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('خطأ'),
        ),
        body: const Center(
          child: Text('لم يتم تحديد قسم'),
        ),
      );
    }
    
    Get.put(AddProductController());

    return Scaffold(
backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ResponsiveDimensions.f(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitleWidget(
              title: 'المعلومات الأساسية',
              onTap: () => Get.find<AddProductController>().navigateToKeywordManagement(),
            ),
            
            SizedBox(height: ResponsiveDimensions.f(20)),
            
            CategorySectionWidget(selectedSection: selectedSection),
            
            SizedBox(height: ResponsiveDimensions.f(20)),
            
            ImageUploadSectionWidget(),
            
            SizedBox(height: ResponsiveDimensions.f(20)),
            
            ProductNameSectionWidget(isRTL: isRTL),
            
            SizedBox(height: ResponsiveDimensions.f(20)),
            
            PriceSectionWidget(isRTL: isRTL),
            
            SizedBox(height: ResponsiveDimensions.f(20)),
            
            ProductConditionSectionWidget(),
            
            SizedBox(height: ResponsiveDimensions.f(20)),
            
            CategoriesSectionWidget(),
            
            SizedBox(height: ResponsiveDimensions.f(20)),
            
            ProductDescriptionSectionWidget(),
            
            SizedBox(height: ResponsiveDimensions.f(20)),
            
            NextButtonWidget(selectedSection: selectedSection),
            
            SizedBox(height: ResponsiveDimensions.f(20)),
          ],
        ),
      ),
    );
  }
}