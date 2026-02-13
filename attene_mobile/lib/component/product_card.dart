import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/favorite/controller/favorite_controller.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatefulWidget {
  final Map<String, dynamic>? product;
  final bool showFavoriteButton;
  final bool isFavorite;
  final Function(bool)? onFavoriteChanged;

  const ProductCard({
    super.key,
    this.product,
    this.showFavoriteButton = true,
    this.isFavorite = false,
    this.onFavoriteChanged,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool isLiked;
  late FavoriteController _favController;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isFavorite;
    _favController = Get.find<FavoriteController>();
  }

  Future<void> toggleLike() async {
    if (widget.product == null) return;

    final newState = !isLiked;
    setState(() => isLiked = newState);

    final success = newState
        ? await _favController.addToFavorites(
            type: FavoriteType.product,
            itemId: widget.product!['id'].toString(),
          )
        : await _favController.removeFromFavorites(
            type: FavoriteType.product,
            itemId: widget.product!['id'].toString(),
          );

    if (!success) {
      setState(() => isLiked = !newState);
    } else {
      widget.onFavoriteChanged?.call(newState);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.product == null || widget.product!.isEmpty) {
      return const SizedBox.shrink();
    }

    final p = widget.product!;

    final String coverImage =
        p['cover'] ??
        'https://images.unsplash.com/photo-1520975916090-3105956dac38';

    final String productName = p['name']?.toString() ?? 'منتج';

    int reviewRate = 0;
    if (p['review_rate'] != null) {
      reviewRate = int.tryParse(p['review_rate'].toString()) ?? 0;
    }

    int reviewCount = 0;
    if (p['review_count'] != null) {
      reviewCount = int.tryParse(p['review_count'].toString()) ?? 0;
    }

    double price = 0.0;
    if (p['price'] != null) {
      price = double.tryParse(p['price'].toString()) ?? 0.0;
    }

    double priceAfterDiscount = price;
    if (p['price_after_discount'] != null) {
      priceAfterDiscount =
          double.tryParse(p['price_after_discount'].toString()) ?? price;
    }

    final bool hasDiscount = priceAfterDiscount < price;
    final String displayPrice = hasDiscount
        ? '${priceAfterDiscount.toStringAsFixed(0)}₪'
        : '${price.toStringAsFixed(0)}₪';
    final String oldPrice = hasDiscount ? '${price.toStringAsFixed(0)}₪' : '';

    return GestureDetector(
      onTap: () {
        if (p['id'] != null) {
          Get.toNamed('/product-details', arguments: {'productId': p['id']});
        }
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
                    coverImage,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 170,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 50),
                    ),
                  ),
                ),
                if ((p['discount_present'] ?? 0) > 0 ||
                    (p['condition'] == 'new'))
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
                      child: Text(
                        (p['condition'] == 'new') ? 'جديد' : 'خصم',
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                if (widget.showFavoriteButton)
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
                  if (p['is_featured'] == true || p['shown'] == true)
                    Row(
                      children: [
                        Icon(
                          Icons.stars_rounded,
                          size: 12,
                          color: AppColors.primary400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'اعلان ممول',
                          style: getMedium(
                            fontSize: 10,
                            color: AppColors.neutral500,
                          ),
                        ),
                      ],
                    ),
                  Text(
                    productName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < reviewRate ? Icons.star : Icons.star_border,
                            size: 14,
                            color: Colors.amber,
                          ),
                        ),
                      ),
                      if (reviewCount > 0)
                        Text(
                          '($reviewCount)',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      Text(
                        displayPrice,
                        style: TextStyle(
                          color: AppColors.error200,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (hasDiscount)
                        Text(
                          oldPrice,
                          style: const TextStyle(
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
