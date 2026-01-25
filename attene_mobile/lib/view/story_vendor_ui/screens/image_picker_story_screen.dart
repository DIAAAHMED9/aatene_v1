import 'package:flutter/material.dart';

import '../api/merchant_stories_api.dart';
import '../theme/story_vendor_theme.dart';

class ImagePickerStoryScreen extends StatefulWidget {
  const ImagePickerStoryScreen({super.key});

  @override
  State<ImagePickerStoryScreen> createState() => _ImagePickerStoryScreenState();
}

class _ImagePickerStoryScreenState extends State<ImagePickerStoryScreen> {
  /// ✅ اختيار واحد فقط: نخزن index واحد (أو null إذا ما في اختيار)
  int? selectedIndex;

  final colors = List<Color>.generate(
    24,
    (i) => Color.lerp(const Color(0xFF1B4965), const Color(0xFFBEE9E8), i / 23)!,
  );

  @override
  Widget build(BuildContext context) {
    final hasSelection = selectedIndex != null;

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
                'صور',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10),

              /// ✅ معاينة كبيرة بالأعلى تظهر فقط عند الاختيار
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  alignment: Alignment.topCenter,
                  child: !hasSelection
                      ? const SizedBox.shrink()
                      : Container(
                          height: 220,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: colors[selectedIndex!],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Container(color: colors[selectedIndex!]),
                          ),
                        ),
                ),
              ),

              if (hasSelection) const SizedBox(height: 10),

              /// ✅ الجريد: لا تختفي عند الاختيار
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: colors.length,
                  itemBuilder: (_, i) {
                    final isSelected = selectedIndex == i;

                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        setState(() {
                          /// ✅ ضغط على نفس الصورة => إلغاء التحديد
                          if (isSelected) {
                            selectedIndex = null;
                          } else {
                            /// ✅ اختيار صورة واحدة فقط
                            selectedIndex = i;
                          }
                        });
                      },
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Container(color: colors[i]),
                          ),

                          /// ✅ إطار واضح للصورة المختارة
                          if (isSelected)
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.black, width: 2),
                                ),
                              ),
                            ),

                          /// ✅ علامة التحديد
                          Positioned(
                            top: 10,
                            left: 10,
                            child: Container(
                              width: 22,
                              height: 22,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected ? Colors.white : Colors.white.withOpacity(0.3),
                              ),
                              child: isSelected
                                  ? const Icon(Icons.check, size: 16, color: Colors.black)
                                  : const SizedBox.shrink(),
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),

                    /// ✅ تعطيل النشر إذا لم يتم اختيار صورة
                    onPressed: hasSelection
                        ? () async {
                            // TODO: replace with real selected image path from your media library.
                            const demoImagePath = 'images/QzuU8cxzP0pgRFit46Dh5LifmCrxSCm8eg49f10v.png';

                            try {
                              await MerchantStoriesApi.create(
                                image: demoImagePath,
                                text: null,
                                // optional: you can set color as int string or int. We'll keep null.
                                color: null,
                              );
                              if (context.mounted) {
                                Navigator.pop(context, true);
                              }
                            } catch (_) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('فشل نشر القصة، حاول مرة أخرى')),
                              );
                            }
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
