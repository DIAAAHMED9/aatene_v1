
import '../../../../general_index.dart';

class ProductCardUI extends StatelessWidget {
  const ProductCardUI({super.key});

  @override
  Widget build(BuildContext context) {
    /// صور ثابتة
    final images = [
      'assets/images/png/closed-store.png',
      'assets/images/png/closed-store.png',
      'assets/images/png/closed-store.png',
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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
          /// Image Slider
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                const BorderRadius.vertical(top: Radius.circular(22)),
                child: SizedBox(
                  height: 260,
                  child: PageView.builder(
                    itemCount: images.length,
                    itemBuilder: (_, index) {
                      return Image.asset(
                        images[index],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      );
                    },
                  ),
                ),
              ),

              /// ❤️ Button
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.blue,
                  ),
                ),
              ),

              /// Indicators (Static UI)
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    images.length,
                        (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == 0
                            ? Colors.black
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// =========================
          /// Sponsored
          /// =========================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: const [
                Text(
                  'اعلان ممول',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.verified,
                  size: 14,
                  color: Colors.blue,
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),

          /// =========================
          /// Title
          /// =========================
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'T-Shirt Sailing T-Shirt Sailing',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 6),

          /// =========================
          /// Rating (Static)
          /// =========================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: List.generate(
                5,
                    (_) => const Icon(
                  Icons.star_border,
                  size: 16,
                  color: Colors.grey,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          /// =========================
          /// Price
          /// =========================
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '10\$',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 14),
        ],
      ),
    );
  }
}
