import 'package:attene_mobile/general_index.dart';

class VendorCard extends StatelessWidget {
  final String storeName;
  final String logoUrl;
  final String location;
  final double rating;
  final int reviewCount;
  final List<String> productImages;
  final int additionalImagesCount;

  const VendorCard({
    super.key,
    this.storeName = 'Linda Store',
    this.logoUrl = 'https://via.placeholder.com/150',
    this.location = 'خليج بايرون، أستراليا',
    this.rating = 4.5,
    this.reviewCount = 2372,
    required this.productImages,
    this.additionalImagesCount = 20,
  });

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    return Column(
      spacing: 5,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
                  onPressed: () {},
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
                hintText: "بحث",

                suffixIcon: Padding(
                  padding: const EdgeInsets.all(5),
                  child: CircleAvatar(
                    backgroundColor: AppColors.primary400,
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ),

                textInputAction: TextInputAction.done, textInputType: TextInputType.name,
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
                  onPressed: () {},
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
        Text(
          'المنتجات المفضلة ',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        Wrap(
          alignment: WrapAlignment.center,
          spacing: 17,
          runSpacing: 20,
          children: [
            ProductCard(),

            ProductCard(),

            ProductCard(),

            ProductCard(),
          ],
        ),

        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.blue.shade100, width: 2),
          ),
          child: Column(
            children: [
              // الجزء العلوي: معلومات المتجر
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  spacing: 5,
                  children: [
                    // شعار المتجر
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          logoUrl,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.store, color: Colors.white),
                        ),
                      ),
                    ),

                    // تفاصيل المتجر
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          storeName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          spacing: 4,
                          children: [
                            const Icon(
                              Icons.stars,
                              color: Colors.orange,
                              size: 12,
                            ),
                            Text(
                              ' $rating',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              '($reviewCount)',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Text(
                              location,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                            const Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    // زر المتابعة
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add_alt_1, size: 15),
                      label: const Text(
                        'متابعة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF456385),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // الجزء السفلي: معرض الصور
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                child: SizedBox(
                  height: 120,
                  child: Row(
                    children: [
                      // الصورة الأولى
                      Expanded(
                        child: Image.network(
                          productImages[1],
                          fit: BoxFit.cover,
                        ),
                      ),

                      // الصورة الثانية
                      Expanded(
                        child: Image.network(
                          productImages[2],
                          fit: BoxFit.cover,
                        ),
                      ),
                      // الصورة الثالثة
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(productImages[0], fit: BoxFit.cover),
                            Container(color: Colors.black.withOpacity(0.3)),
                            Center(
                              child: Text(
                                '+$additionalImagesCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.blue.shade100, width: 2),
          ),
          child: Column(
            children: [
              // الجزء العلوي: معلومات المتجر
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  spacing: 5,
                  children: [
                    // شعار المتجر
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.network(
                          logoUrl,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.store, color: Colors.white),
                        ),
                      ),
                    ),

                    // تفاصيل المتجر
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          storeName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Row(
                          spacing: 4,
                          children: [
                            const Icon(
                              Icons.stars,
                              color: Colors.orange,
                              size: 12,
                            ),
                            Text(
                              ' $rating',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 10,
                              ),
                            ),
                            Text(
                              '($reviewCount)',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Text(
                              location,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                            const Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: 12,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    // زر المتابعة
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.person_add_alt_1, size: 15),
                      label: const Text(
                        'متابعة',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF456385),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // الجزء السفلي: معرض الصور
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
                child: SizedBox(
                  height: 120,
                  child: Row(
                    children: [
                      // الصورة الأولى
                      Expanded(
                        child: Image.network(
                          productImages[1],
                          fit: BoxFit.cover,
                        ),
                      ),

                      // الصورة الثانية
                      Expanded(
                        child: Image.network(
                          productImages[2],
                          fit: BoxFit.cover,
                        ),
                      ),
                      // الصورة الثالثة
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.network(productImages[0], fit: BoxFit.cover),
                            Container(color: Colors.black.withOpacity(0.3)),
                            Center(
                              child: Text(
                                '+$additionalImagesCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
