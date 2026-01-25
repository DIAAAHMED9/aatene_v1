import 'package:attene_mobile/general_index.dart';

/// BottomSheet لعرض منتجات المتجر داخل البروفايل.
///
/// - يعيد استخدام شريط البحث والفلاتر الموجود في VendorCard.
/// - يعرض بطاقات المنتجات الموجودة بالفعل (ProductCard) للتجربة.
///
/// ملاحظة: حالياً يعتمد على داتا وهمية (ProductCard نفسه فيه داتا ثابتة).
/// لاحقاً بنربطه بليست المنتجات الحقيقية القادمة من الـ Controller/API.
class VendorProductsBottomSheet extends StatelessWidget {
  const VendorProductsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.85,
      minChildSize: 0.45,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Text('المنتجات', style: getMedium(fontSize: 18)),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              // ✅ شريط البحث + الفلاتر (بنفس الموجود في VendorCard)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  spacing: 5,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        border: Border.all(color: AppColors.neutral800),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            // TODO: فتح فلاتر المنتجات لاحقاً
                          },
                          icon: SvgPicture.asset(
                            'assets/images/svg_images/filter_alt.svg',
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextFiledAatene(
                        isRTL: isRTL,
                        hintText: 'بحث',
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(5),
                          child: CircleAvatar(
                            backgroundColor: AppColors.primary400,
                            child: const Icon(Icons.search, color: Colors.white),
                          ),
                        ),
                        textInputAction: TextInputAction.search,
                      ),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.white,
                        border: Border.all(color: AppColors.neutral800),
                      ),
                      child: Center(
                        child: IconButton(
                          onPressed: () {
                            // TODO: فلتر إضافي/ترتيب لاحقاً
                          },
                          icon: SvgPicture.asset(
                            'assets/images/svg_images/filter_mine.svg',
                            width: 18,
                            height: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ✅ بطاقات المنتجات (موجودة بالفعل في البروفايل)
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(14, 0, 14, 16),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 17,
                    runSpacing: 20,
                    children: List.generate(12, (_) => const ProductCard()),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
