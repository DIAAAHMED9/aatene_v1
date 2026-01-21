import '../../../../general_index.dart';

class ProfileCardSmall extends StatefulWidget {
  const ProfileCardSmall({super.key});

  @override
  State<ProfileCardSmall> createState() => _ProfileCardSmallState();
}

class _ProfileCardSmallState extends State<ProfileCardSmall> {
  // حالة المتابعة (تتغير عند الضغط على الزر)
  bool _isFollowed = false;

  @override
  Widget build(BuildContext context) {
    // إعدادات القياسات لتناسب العرض 170
    const double cardWidth = 170.0;
    const double bannerHeight = 100.0;
    const double avatarRadius = 35.0;

    return Container(
      width: cardWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 1. الجزء العلوي (البانر + الأزرار + الصورة الشخصية المتداخلة)
          _buildHeaderStack(bannerHeight, avatarRadius),

          // 2. الجزء السفلي (المعلومات النصية)
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 16),
            child: Column(
              children: [
                _buildNameAndBadge(),
                const SizedBox(height: 4),
                _buildJobTitle(),
                const SizedBox(height: 8),
                _buildRatingAndLocation(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //  الصور والأزرار
  Widget _buildHeaderStack(double bannerHeight, double avatarRadius) {
    return SizedBox(
      height: bannerHeight + (avatarRadius * 0.5),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // البانر الخلفي
          Container(
            height: bannerHeight,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: NetworkImage(
                  "https://images.unsplash.com/photo-1503387762-592deb58ef4e?w=400",
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // زر الإضافة المتفاعل)
          Positioned(top: 8, left: 8, child: _buildAnimatedFollowButton()),

          // شارة إعلان ممول
          Positioned(top: 8, right: 8, child: _buildSponsoredBadge()),

          // الصورة الشخصية
          Positioned(
            top: bannerHeight - avatarRadius,
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: avatarRadius - 10,
                backgroundImage: const NetworkImage(
                  "https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // زر المتابعة مع الأنيميشن
  Widget _buildAnimatedFollowButton() {
    return GestureDetector(
      onTap: () => setState(() => _isFollowed = !_isFollowed),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: _isFollowed ? AppColors.primary50 : const Color(0xFF1976D2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          _isFollowed ? Icons.arrow_forward : Icons.person_add_alt_1,
          color: _isFollowed ? AppColors.primary400 : Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildSponsoredBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: Colors.black38,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        "ممول",
        style: TextStyle(color: Colors.white, fontSize: 8),
      ),
    );
  }

  Widget _buildNameAndBadge() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.emoji_events, color: Colors.amber, size: 16),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            "محمد علي",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildJobTitle() {
    return Text(
      "مهندس معماري وديكور",
      style: TextStyle(fontSize: 10, color: Colors.grey[600]),
      textAlign: TextAlign.center,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildRatingAndLocation() {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, size: 12, color: Colors.green[400]),
            const Text("الخليل", style: TextStyle(fontSize: 10)),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 14),
            const Text(
              " 5.0",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }
}
