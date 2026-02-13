import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/favorite/controller/favorite_controller.dart';
import 'package:flutter/material.dart';

class ServicesCard extends StatefulWidget {
  final Map<String, dynamic>? service;
  final bool showFavoriteButton;
  final bool isFavorite;
  final Function(bool)? onFavoriteChanged;

  const ServicesCard({
    super.key,
    this.service,
    this.showFavoriteButton = true,
    this.isFavorite = false,
    this.onFavoriteChanged,
  });

  @override
  State<ServicesCard> createState() => _ServicesCardState();
}

class _ServicesCardState extends State<ServicesCard> {
  late bool isLiked;
  late FavoriteController _favController;

  @override
  void initState() {
    super.initState();
    isLiked = widget.isFavorite;
    _favController = Get.find<FavoriteController>();
  }

  Future<void> toggleLike() async {
    if (widget.service == null) return;

    final newState = !isLiked;
    setState(() => isLiked = newState);

    final success = newState
        ? await _favController.addToFavorites(
            type: FavoriteType.service,
            itemId: widget.service!['id'].toString(),
          )
        : await _favController.removeFromFavorites(
            type: FavoriteType.service,
            itemId: widget.service!['id'].toString(),
          );

    if (!success) {
      setState(() => isLiked = !newState);
    } else {
      widget.onFavoriteChanged?.call(newState);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.service == null) {
      return const SizedBox.shrink();
    }

    final s = widget.service!;

    final String coverImage = s['cover']?.toString() ??
        s['image']?.toString() ??
        'https://images.unsplash.com/photo-1621905251189-08b45d6a269e?w=400';

    final String title = s['title']?.toString() ??
        s['name']?.toString() ??
        'خدمة';

    final double price = double.tryParse(s['price']?.toString() ?? '0') ?? 0.0;

    final int reviewCount = int.tryParse(s['review_count']?.toString() ?? '0') ?? 0;

    final String providerName = s['store']?['name'] ??
        s['user']?['name'] ??
        s['provider_name'] ??
        'مقدم خدمة';

    final String providerAvatar = s['store']?['logo'] ??
        s['user']?['avatar'] ??
        'https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100';

    final String location = s['city']?['name'] ??
        s['location']?.toString() ??
        '';

    return GestureDetector(
      onTap: () {
        if (s['id'] != null) {
          Get.toNamed('/service-details', arguments: {'serviceId': s['id']});
        }
      },
      child: Container(
        width: 160,
        height: 250,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
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
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    coverImage,
                    height: 120,
                    width: 160,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 120,
                      width: 160,
                      color: Colors.grey[200],
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                ),
                if (widget.showFavoriteButton)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: GestureDetector(
                      onTap: toggleLike,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? AppColors.primary400 : Colors.grey,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${price.toStringAsFixed(2)} ₪',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary400,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 14,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              ' (${reviewCount == 0 ? '0' : reviewCount} مراجعة )',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundImage: NetworkImage(providerAvatar),
                          onBackgroundImageError: (_, __) {},
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                providerName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              if (location.isNotEmpty)
                                Text(
                                  location,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.grey[600],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}