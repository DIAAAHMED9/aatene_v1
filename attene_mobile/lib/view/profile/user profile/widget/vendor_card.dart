import 'package:flutter/material.dart';

class FavProfile extends StatelessWidget {
  final String storeName;
  final String logoUrl;
  final String location;
  final double rating;
  final int reviewCount;
  final List<String> productImages;
  final int additionalImagesCount;

  const FavProfile({
    super.key,
    this.storeName = 'Linda Store',
    this.logoUrl = 'https://via.placeholder.com/150', // استبدلها برابط شعارك
    this.location = 'خليج بايرون، أستراليا',
    this.rating = 4.5,
    this.reviewCount = 2372,
    required this.productImages,
    this.additionalImagesCount = 56,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.blue.shade100, width: 2),
      ),
      child: Column(
        children: [
          // الجزء العلوي: معلومات المتجر
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // زر المتابعة
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.person_add_alt_1, size: 18),
                  label: const Text(
                    'متابعة',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF456385),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const Spacer(),
                // تفاصيل المتجر
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      storeName,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '($reviewCount) $rating',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const Icon(Icons.star, color: Colors.orange, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          location,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        const Icon(
                          Icons.location_on,
                          color: Colors.green,
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(width: 12),
                // شعار المتجر
                CircleAvatar(
                  radius: 30,
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
              height: 200,
              child: Row(
                children: [
                  // الصورة الأولى مع عداد الصور الإضافية
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
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 2),
                  // الصورة الثانية
                  Expanded(
                    child: Image.network(productImages[1], fit: BoxFit.cover),
                  ),
                  const SizedBox(width: 2),
                  // الصورة الثالثة
                  Expanded(
                    child: Image.network(productImages[2], fit: BoxFit.cover),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
