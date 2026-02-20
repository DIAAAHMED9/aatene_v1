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
  late FavoriteController _favController;
  bool _favoriteBusy = false;

  @override
  void initState() {
    super.initState();

    _favController = Get.isRegistered<FavoriteController>()
        ? Get.find<FavoriteController>()
        : Get.put(FavoriteController(), permanent: true);

    final apiFav = (widget.service?['is_favorite'] == true);
    final id = (widget.service?['id'] ?? '').toString();
    if (apiFav && id.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _favController.cacheFavorite(
          type: FavoriteType.service,
          itemId: id,
          value: true,
          setOverride: false,
        );
      });
    }
  }

  Future<void> toggleLike() async {
    if (widget.service == null) return;

    final serviceId = (widget.service!['id'] ?? '').toString();
    final apiFav = (widget.service!['is_favorite'] == true);
    if (serviceId.isEmpty || _favoriteBusy) return;

    final wasLiked = _favController.getEffectiveFavorite(
      FavoriteType.service,
      serviceId,
      apiFav: apiFav,
    );
    final newState = !wasLiked;

    setState(() => _favoriteBusy = true);

    _favController.setLocalFavorite(
      type: FavoriteType.service,
      itemId: serviceId,
      value: newState,
      setOverride: true,
    );

    bool success = false;
    if (newState) {
      success = await _favController.addToFavorites(
        type: FavoriteType.service,
        itemId: serviceId,
      );
    } else {
      success = await _favController.removeFromFavorites(
        type: FavoriteType.service,
        itemId: serviceId,
      );
    }

    if (!success) {
      _favController.setLocalFavorite(
        type: FavoriteType.service,
        itemId: serviceId,
        value: wasLiked,
        setOverride: true,
      );
    } else {
      widget.onFavoriteChanged?.call(newState);
    }

    if (mounted) setState(() => _favoriteBusy = false);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.service == null) {
      return const SizedBox.shrink();
    }

    final s = widget.service!;
    final String serviceId = s['id']?.toString() ?? '';

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
      // ✅ مثل المنتجات: تفاصيل الخدمة بالـ slug إن وجد (مع id كـ fallback)
      final slug = (s['slug'] ?? s['service_slug'] ?? '').toString();
      Get.toNamed(
        '/service-details',
        arguments: {
          'serviceId': s['id'],
          'id': s['id'],
          'slug': slug,
          'serviceSlug': slug,
        },
      );
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
                        child: Obx(() {
                          final apiFav = (s['is_favorite'] == true);
                          final liked = serviceId.isNotEmpty
                              ? _favController.getEffectiveFavorite(
                                  FavoriteType.service,
                                  serviceId,
                                  apiFav: apiFav,
                                )
                              : apiFav;
                          return Icon(
                            liked ? Icons.favorite : Icons.favorite_border,
                            color: liked ? AppColors.primary400 : Colors.grey,
                            size: 18,
                          );
                        }),
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