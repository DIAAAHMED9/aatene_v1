import '../general_index.dart';
import 'package:flutter/material.dart';


class ProductCard extends StatefulWidget {
  const ProductCard({super.key});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isLiked = false;

  void toggleLike() {
    setState(() => isLiked = !isLiked);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(ProductDetails());
      },
      child: Container(
        width: 170,
        height: 280,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.primary50),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(14),
                  ),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1520975916090-3105956dac38',
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
      
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'جديد',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
      
                Positioned(
                  bottom: 0,
                  left: 5,
                  child: GestureDetector(
                    onTap: toggleLike,
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Icon(
                        size: 18,
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? AppColors.primary400 : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 7),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      /// adds
                      Icon(
                        Icons.stars_rounded,
                        size: 12,
                        color: AppColors.primary400,
                      ),
                      Text(
                        'اعلان ممول',
                        style: getMedium(
                          fontSize: 10,
                          color: AppColors.neutral500,
                        ),
                      ),
                    ],
                  ),
      
                  /// product title
                  Text(
                    'T-Shirt Sailing',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
      
                  ///star rating
                  Row(
                    spacing: 5,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => const Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      Text(
                        "(5)",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
      
                  /// product price
                  Row(
                    spacing: 5,
                    children: [
                      Text('14\$', style: TextStyle(color: AppColors.error200)),
                      Text(
                        '21\$',
                        style: TextStyle(
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
