import '../../../../general_index.dart';
import '../../../../utils/responsive/responsive_dimensions.dart';
import '../index.dart';

class AddProductContent extends StatelessWidget {
  const AddProductContent({super.key});

  Widget _buildLoaded(BuildContext context, Section selectedSection) {
    final isRTL = LanguageUtils.isRTL;

    if (!Get.isRegistered<AddProductController>()) {
      Get.put(AddProductController());
    }

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

  @override
  Widget build(BuildContext context) {
    final Section? argSection = Get.arguments?['selectedSection'] as Section?;
    if (argSection != null) {
      return _buildLoaded(context, argSection);
    }

    if (!Get.isRegistered<ProductCentralController>()) {
      return Scaffold(
        appBar: AppBar(title: Text('خطأ', style: getMedium())),
        body: Center(
          child: Text('لم يتم تهيئة بيانات المنتج', style: getMedium()),
        ),
      );
    }

    final central = Get.find<ProductCentralController>();

    return Obx(() {
      final selectedSection = central.selectedSection.value;

      if (selectedSection == null) {
        return Scaffold(
          appBar: AppBar(title: Text('تحميل', style: getMedium())),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 12),
                Text('جاري تحميل بيانات المنتج...', style: getMedium()),
              ],
            ),
          ),
        );
      }

      return _buildLoaded(context, selectedSection);
    });
  }
}