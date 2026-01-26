import 'package:attene_mobile/general_index.dart';

class OffersTabPage extends StatelessWidget {
  const OffersTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // كرت عرض يحتوي على صور متعددة قابلة للتمرير
        _buildOfferCardWithScroll(
          title: "عرض الشتاء المميز",
          description: "مجموعة من 5 قطع شتوية مختارة بعناية",
          price: "1200.0",
          oldPrice: "1500.0",
          images: [
            'assets/images/png/placeholder_bag_image_png.png',
            'assets/images/png/placeholder_bag_image_png.png',
            'assets/images/png/placeholder_bag_image_png.png',
            'assets/images/png/placeholder_bag_image_png.png',
          ],
        ),

        const SizedBox(height: 16),
        _buildSpecialOfferTimer(), // شريط العداد التنازلي
        const SizedBox(height: 16),

        // كرت عرض آخر
        _buildOfferCardWithScroll(
          title: "باكيج الأناقة",
          description: "3 قمصان قطنية عالية الجودة",
          price: "850.0",
          images: [
            'assets/images/png/placeholder_bag_image_png.png',
            'assets/images/png/placeholder_bag_image_png.png',
          ],
          showOldPrice: false,
        ),
      ],
    );
  }

  Widget _buildOfferCardWithScroll({
    required String title,
    required String description,
    required String price,
    String? oldPrice,
    required List<String> images,
    bool showOldPrice = true,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.neutral100.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          // 1. الجزء الخاص بالصور (التمرير الأفقي)
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: images.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 300, // عرض الصورة الواحدة داخل التمرير
                  margin: const EdgeInsets.all(8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(images[index], fit: BoxFit.cover),
                        // Show number
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary50,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              "${index + 1}/${images.length}",
                              style: getMedium(
                                fontSize: 10,
                                color: AppColors.primary500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 2. تفاصيل العرض أسفل الصور
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(
                  description,
                  textAlign: TextAlign.right,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // السعر
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$price ₪",
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        if (showOldPrice && oldPrice != null)
                          Text(
                            "$oldPrice ₪",
                            style: const TextStyle(
                              color: Colors.red,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                    // زر إضافة للسلة أو تفاصيل
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A6982),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text(
                        "اطلب الآن",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // العداد التنازلي
  Widget _buildSpecialOfferTimer() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary200, AppColors.primary400],
        ),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "عرض خاص ينتهي خلال:",
            style: getBold(color: AppColors.light1000),
          ),
          Row(
            children: [
              _timerBlock("55", "ثانية"),
              _timerBlock("33", "دقيقة"),
              _timerBlock("12", "ساعة"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timerBlock(String val, String unit) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.light1000,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(val, style: getBold()),
          Text(unit, style: getMedium(fontSize: 10)),
        ],
      ),
    );
  }
}
