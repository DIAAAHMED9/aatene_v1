
import '../../../../general_index.dart';
import '../../../../utils/responsive/responsive_dimensions.dart';
import '../index.dart';

/// خطوة (1) المعلومات الأساسية.
///
/// ملاحظة مهمة:
/// - في الإضافة يتم تمرير القسم عبر Get.arguments.
/// - في التعديل يتم جلب القسم من ProductCentralController بعد تحميل بيانات المنتج.
/// لذلك يجب أن تكون الواجهة Reactive وتنتظر إلى أن يتم تعبئة selectedSection.
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
    // 1) إذا تم تمرير القسم عبر arguments (سيناريو الإضافة)
    final Section? argSection = Get.arguments?['selectedSection'] as Section?;
    if (argSection != null) {
      return _buildLoaded(context, argSection);
    }

    // 2) في التعديل: نأخذ القسم من الـ central controller (بعد تحميل الـ API)
    if (!Get.isRegistered<ProductCentralController>()) {
      // هذا لا يفترض أن يحدث داخل stepper، لكنه يحمي من كراش.
      return Scaffold(
        appBar: AppBar(title: Text('خطأ', style: getRegular())),
        body: Center(child: Text('لم يتم تهيئة بيانات المنتج', style: getRegular())),
      );
    }

    final central = Get.find<ProductCentralController>();

    return Obx(() {
      final selectedSection = central.selectedSection.value;

      if (selectedSection == null) {
        // ننتظر تحميل بيانات المنتج.
        return Scaffold(
          appBar: AppBar(title: Text('تحميل', style: getRegular())),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 12),
                Text('جاري تحميل بيانات المنتج...', style: getRegular()),
              ],
            ),
          ),
        );
      }

      return _buildLoaded(context, selectedSection);
    });
  }
}
