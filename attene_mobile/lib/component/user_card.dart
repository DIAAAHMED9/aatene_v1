import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/favorite/controller/favorite_controller.dart';
import 'package:attene_mobile/view/profile/vendor_profile/screen/store_profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserCard extends StatefulWidget {
  final Map<String, dynamic>? user;
  final bool showFavoriteButton;
  final bool initialFollowed;
  final Function(bool)? onFollowChanged;

  const UserCard({
    super.key,
    required this.user,
    this.showFavoriteButton = true,
    this.initialFollowed = false,
    this.onFollowChanged,
  });

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  late bool isFollowed;
  late FavoriteController _favController;

  @override
  void initState() {
    super.initState();
    isFollowed = widget.initialFollowed;
    _favController = Get.find<FavoriteController>();
  }

  Future<void> toggleFollow() async {
    if (widget.user  == null) return;

    final newState = !isFollowed;
    setState(() => isFollowed = newState);

    final success = newState
        ? await _favController.addToFavorites(
            type: FavoriteType.user,
            itemId: widget.user!['id'].toString(),
          )
        : await _favController.removeFromFavorites(
            type: FavoriteType.user,
            itemId: widget.user!['id'].toString(),
          );

    if (!success) {
      setState(() => isFollowed = !newState);
    } else {
      widget.onFollowChanged?.call(newState);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.user == null) return const SizedBox.shrink();

    final s = widget.user!;
    final String userName = s['name']?.toString() ?? 'مستخدم';
    final String coverImage = s['cover']?.toString() ??
        s['logo']?.toString() ??
        'https://images.unsplash.com/photo-1472851294608-062f824d29cc?w=400';
    final double rating = double.tryParse(s['rating']?.toString() ?? '0') ?? 0.0;
    final int reviewCount = int.tryParse(s['review_count']?.toString() ?? '0') ?? 0;
    final bool isVerified = s['is_verified'] == true || s['verified'] == true;
    final bool isFeatured = s['is_featured'] == true || s['shown'] == true;

    return GestureDetector(
      onTap: () {
        if (s['id'] != null) {
          Get.to(() => StoreProfilePage(storeId: s['id']));
        }
      },
      child: Container(
        width: 162,
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.neutral900, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.network(
                    coverImage,
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 100,
                      color: Colors.grey[200],
                      child: const Icon(Icons.store, size: 40),
                    ),
                  ),
                ),
                if (isFeatured)
                  Positioned(
                    bottom: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'إعلان ممول',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                if (widget.showFavoriteButton)
                  Positioned(
                    bottom: 0,
                    left: 5,
                    child: GestureDetector(
                      onTap: toggleFollow,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: isFollowed
                              ? AppColors.primary100
                              : AppColors.primary400,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          isFollowed
                              ? Icons.arrow_forward
                              : Icons.person_add_alt,
                          color: isFollowed
                              ? AppColors.primary400
                              : Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 26),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  userName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                if (isVerified) ...[
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.verified,
                    size: 14,
                    color: Colors.blue,
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Row(
              spacing: 7,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.stars_rounded,
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      rating.toStringAsFixed(1),
                      style: getMedium(
                        fontSize: 12,
                        color: AppColors.neutral400,
                      ),
                    ),
                  ],
                ),
                if (reviewCount > 0)
                  Text(
                    '($reviewCount)',
                    style: getMedium(
                      fontSize: 10,
                      color: AppColors.neutral500,
                    ),
                  ),
                SvgPicture.asset(
                  "assets/images/svg_images/bus.svg",
                  width: 16,
                  height: 16,
                  fit: BoxFit.cover,
                ),
                SvgPicture.asset(
                  "assets/images/svg_images/privicy_vendor.svg.svg",
                  width: 16,
                  height: 16,
                  fit: BoxFit.cover,
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}