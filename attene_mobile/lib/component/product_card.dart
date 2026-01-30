import '../general_index.dart';
import '../view/home/model/home_api_models.dart';

class ProductCard extends StatefulWidget {
  final HomeProductItem? item;

  const ProductCard({super.key, this.item});

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
    final item = widget.item;

    final title = (item?.name.isNotEmpty ?? false) ? item!.name : 'منتج';
    final imageUrl =
        item?.imageUrl ??
        'https://images.unsplash.com/photo-1520975916090-3105956dac38';
    final priceText = item?.price != null
        ? '${item!.price!.toStringAsFixed(0)}₪'
        : '—';

    return GestureDetector(
      onTap: () {
        Get.to(ProductDetails());
      },
      child: Container(
        width: 150,
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
                    imageUrl,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 170,
                      color: Colors.black12,
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image_outlined),
                    ),
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
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? AppColors.primary400 : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: getMedium(fontSize: 13),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                priceText,
                style: getBlack(fontSize: 14, color: AppColors.primary400),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
