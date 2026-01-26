// -----------------------------------------------------------
// Main Widget: Promotional Card
// -----------------------------------------------------------

import '../../../../general_index.dart';

class BigServicesCard extends StatelessWidget {
  const BigServicesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // لجعل البطاقة تأخذ حجم محتواها فقط
        children: const [
          // 1. Top Section: Video/Ad Header
          VideoAdHeader(),

          SizedBox(height: 12),

          // 2. Bottom Section: Product Details
          ProductInfoSection(),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------
// Widget 1: Video Header (The Top Part)
// -----------------------------------------------------------
class VideoAdHeader extends StatelessWidget {
  const VideoAdHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background Image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Image.network(
            'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?ixlib=rb-4.0.3&auto=format&fit=crop&w=800&q=80',
            // صورة توضيحية للمنتج (Eucerin)
            height: 220,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),

        // Play Button (Centered)
        Positioned.fill(
          child: Center(
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
        ),

        // Mute Button (Bottom Right)
        Positioned(
          bottom: 12,
          right: 12,
          child: Column(
            spacing: 5,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.volume_off,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------
// Widget 2: Product Info (The Bottom Part)
// -----------------------------------------------------------
class ProductInfoSection extends StatelessWidget {
  const ProductInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Right Side: Product Image with Favorite Icon
          Expanded(
            flex: 4,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=80',
                    // صورة التيشيرت
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.blue,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Left Side: Text Details
          Expanded(
            flex: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // محاذاة لليمين للنص العربي
              children: [
                // "New" Badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF222222),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "جديد",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                // "Sponsored" Label
                Row(
                  spacing: 5,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Icon(Icons.stars, size: 14, color: AppColors.primary400),
                    Text(
                      "اعلان ممول",
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // Product Title
                const Text(
                  "T-Shirt SailingT-Shirt\nSailing",
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 6),
                // Price
                // السعر والتقييم
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "40.00 ₪",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary400,
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        Text(
                          "( 20 مراجعة )",
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
                // معلومات الفني
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 12,
                      backgroundImage: NetworkImage(
                        "https://images.unsplash.com/photo-1599566150163-29194dcaad36?w=100",
                      ),
                    ),
                    const SizedBox(width: 6),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "سامي يوسف",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "فلسطين، رام الله",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 8,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
