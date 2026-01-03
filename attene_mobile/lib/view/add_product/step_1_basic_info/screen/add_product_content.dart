

import '../../../../general_index.dart';
import '../../../../utlis/responsive/responsive_dimensions.dart';
import '../index.dart';

class AddProductContent extends StatelessWidget {
  const AddProductContent({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    final selectedSection = Get.arguments?['selectedSection'] as Section?;

    if (selectedSection == null) {
      return Scaffold(
        appBar: AppBar(title: Text('خطأ', style: getRegular())),
        body: Center(child: Text('لم يتم تحديد قسم', style: getRegular())),
      );
    }

    Get.put(AddProductController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitleWidget(
              title: 'المعلومات الأساسية',
              onTap: () => Get.find<AddProductController>()
                  .navigateToKeywordManagement(),
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

          ],
        ),
      ),
    );
  }
}