import 'package:flutter/material.dart';
import '../../../general_index.dart';
import '../dummy/story_vendor_dummy.dart';
import '../theme/story_vendor_theme.dart';

class ProductStoryScreen extends StatefulWidget {
  const ProductStoryScreen({super.key});

  @override
  State<ProductStoryScreen> createState() => _ProductStoryScreenState();
}

class _ProductStoryScreenState extends State<ProductStoryScreen> {
  /// ✅ اختيار واحد فقط (null = لا يوجد اختيار)
  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final bool hasSelection = selectedIndex != null;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 8),
              Container(
                width: 48,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'عرض المنتج',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),

              CustomAppBarWithTabs(
                isRTL: true,
                config: AppBarConfig(
                  title: '',
                  actionText: '',
                  onFilterPressed: () => Get.toNamed('/media-library'),
                  onSortPressed: () {},
                  showSearch: true,
                ),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.78,
                  ),
                  itemCount: demoProducts.length,
                  itemBuilder: (_, i) {
                    final p = demoProducts[i];
                    final bool isSelected = selectedIndex == i;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          // ✅ ضغط نفس العنصر => إلغاء اختيار
                          if (isSelected) {
                            selectedIndex = null;
                          } else {
                            selectedIndex = i; // ✅ اختيار واحد فقط
                          }
                        });
                      },
                      child: Stack(
                        children: [
                          // كرت المنتج نفسه (أنت عندك ProductCard جاهز)
                          // إذا ProductCard يحتاج بيانات مرّرها هنا
                          ProductCard(),

                          // ✅ Overlay يوضح التحديد
                          if (isSelected)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.black, width: 2),
                                  color: Colors.black.withOpacity(0.08),
                                ),
                              ),
                            ),

                          // ✅ علامة check
                          Positioned(
                            top: 10,
                            left: 10,
                            child: AnimatedScale(
                              duration: const Duration(milliseconds: 140),
                              scale: isSelected ? 1 : 0.0,
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(Icons.check, size: 18, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
                child: SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: StoryVendorTheme.blueBg,
                      disabledBackgroundColor: Colors.black12,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
                    ),
                    onPressed: hasSelection
                        ? () {
                            final p = demoProducts[selectedIndex!];

                            // ✅ نرجع “منتج مختار” كـ result
                            // (لو p عنده id/title/imageUrl رجّعهم)
                            Navigator.pop(context, p);
                          }
                        : null,
                    child: const Text(
                      'نشر',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
