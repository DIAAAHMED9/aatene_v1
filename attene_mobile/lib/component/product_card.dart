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
  FavoriteController? _favController;

  bool _favoriteBusy = false;

  @override
  void initState() {
    super.initState();

    _favController = Get.isRegistered<FavoriteController>()
        ? Get.find<FavoriteController>()
        : Get.put(FavoriteController(), permanent: true);

    final p = widget.product;
    if (p != null) {
      final apiFav = (p['is_favorite'] == true);
      final id = (p['id'] ?? '').toString();

      if (apiFav && id.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _favController?.cacheFavorite(
            type: FavoriteType.product,
            itemId: id,
            value: true,
            setOverride: false,
          );
        });
      }
    }
  }

  Future<void> toggleLike() async {
    final favCtrl = _favController;
    final p = widget.product;

    if (favCtrl == null || p == null) return;

    final productId = (p['id'] ?? '').toString();
    if (productId.isEmpty) return;

    if (_favoriteBusy) return;

    final apiFav = (p['is_favorite'] == true);

    final wasLiked = favCtrl.getEffectiveFavorite(
      FavoriteType.product,
      productId,
      apiFav: apiFav,
    );

    final newState = !wasLiked;

    setState(() => _favoriteBusy = true);

    favCtrl.setLocalFavorite(
      type: FavoriteType.product,
      itemId: productId,
      value: newState,
      setOverride: true,
    );

    widget.onFavoriteChanged?.call(newState);

    bool success = false;

    try {
      if (newState) {
        success = await favCtrl.addToFavorites(
          type: FavoriteType.product,
          itemId: productId,
        );
      } else {
        success = await favCtrl.removeFromFavorites(
          type: FavoriteType.product,
          itemId: productId,
        );
      }
    } catch (_) {
      success = false;
    }

    if (!success) {
      favCtrl.setLocalFavorite(
        type: FavoriteType.product,
        itemId: productId,
        value: wasLiked,
        setOverride: true,
      );

      widget.onFavoriteChanged?.call(wasLiked);
    }

    if (mounted) {
      setState(() => _favoriteBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    if (p == null || p.isEmpty) {
      return const SizedBox.shrink();
    }

    final String productId = p['id']?.toString() ?? '';

    final String coverImage = (p['cover']?.toString().isNotEmpty == true)
        ? p['cover'].toString()
        : 'https://images.unsplash.com/photo-1520975916090-3105956dac38';

    final String productName = p['name']?.toString() ?? 'منتج';

    int reviewRate = int.tryParse(p['review_rate']?.toString() ?? '0') ?? 0;
    int reviewCount = int.tryParse(p['review_count']?.toString() ?? '0') ?? 0;

    double price = double.tryParse(p['price']?.toString() ?? '0') ?? 0.0;
    double priceAfterDiscount =
        double.tryParse(p['price_after_discount']?.toString() ?? '') ?? price;

    final bool hasDiscount = priceAfterDiscount < price;

    final String displayPrice = hasDiscount
        ? '${priceAfterDiscount.toStringAsFixed(0)}₪'
        : '${price.toStringAsFixed(0)}₪';

    final String oldPrice = hasDiscount ? '${price.toStringAsFixed(0)}₪' : '';

    return GestureDetector(
      onTap: () {
      
        if (p['id'] != null || p['slug'] != null) {
          Get.toNamed(
            '/product-details',
            arguments: {
              'id': p['id'],
              'productId': p['id'],
              'slug': p['slug'],
            },
          );
        }
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardH = constraints.maxHeight;
          final imgH = (cardH.isFinite ? (cardH * 0.60) : 150.0)
              .clamp(120.0, 155.0);

          return Container(
            width: 170,
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
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(14)),
                      child: Image.network(
                        coverImage,
                        height: imgH,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: imgH,
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image, size: 50),
                        ),
                      ),
                    ),

                    if ((p['discount_present'] ?? 0) > 0 || (p['condition'] == 'new'))
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
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
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
                            child: Center(
                              child: Obx(() {
                                final favCtrl = _favController;
                                final apiFav = (p['is_favorite'] == true);

                                if (favCtrl == null || productId.isEmpty) {
                                  return Icon(
                                    Icons.favorite_border,
                                    size: 18,
                                    color: Colors.grey,
                                  );
                                }

                                final liked = favCtrl.getEffectiveFavorite(
                                  FavoriteType.product,
                                  productId,
                                  apiFav: apiFav,
                                );

                                if (_favoriteBusy) {
                                  return SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        liked ? AppColors.primary400 : Colors.grey,
                                      ),
                                    ),
                                  );
                                }

                                return Icon(
                                  liked ? Icons.favorite : Icons.favorite_border,
                                  size: 18,
                                  color: liked ? AppColors.primary400 : Colors.grey,
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 6),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (p['is_featured'] == true)
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
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            height: 1.1,
                          ),
                        ),

                        const SizedBox(height: 3),

                        SizedBox(
                          height: 16,
                          child: Row(
                            children: [
                              Row(
                                children: List.generate(
                                  5,
                                  (index) => Icon(
                                    index < reviewRate
                                        ? Icons.star
                                        : Icons.star_border,
                                    size: 13,
                                    color: Colors.amber,
                                  ),
                                ),
                              ),
                              if (reviewCount > 0) ...[
                                const SizedBox(width: 4),
                                Text(
                                  '($reviewCount)',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),

                        const Spacer(),

                        Row(
                          children: [
                            Text(
                              displayPrice,
                              style: TextStyle(
                                color: AppColors.error200,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (hasDiscount) ...[
                              const SizedBox(width: 6),
                              Text(
                                oldPrice,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 11,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                            ],
                          ],
                        ),

                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}