
import '../../../../general_index.dart';

class StoreCard extends StatelessWidget {
  final String storeName;
  final String description;
  final double rating;
  final String imagePath;

  const StoreCard({
    super.key,
    required this.storeName,
    required this.description,
    required this.rating,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. The Banner Section (الجزء العلوي)
          _buildBannerSection(),

          // 2. The Info Section (الجزء السفلي)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderRow(),
                _buildDescription(),
                _buildStatsRow(),
                _buildFollowButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets for Clean Code ---

  Widget _buildBannerSection() {
    return Stack(
      children: [
        // الخلفية والصورة
        Container(
          height: 250,
          decoration: const BoxDecoration(
            color: Color(0xFFFBECE6), // لون الخلفية البيج
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Row(
            children: [
              // محاكاة النصوص الإنجليزية في التصميم (كصورة أو تصميم)
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // هذا الجزء محاكاة للنصوص الإنجليزية في الصورة
                      // في التطبيق الحقيقي يفضل أن تكون الصورة كاملة مصممة مسبقاً
                      // أو استخدام CustomPaint وتنسيقات معقدة
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "NEW ARRIVALS",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                            const Text(
                              "JUST\nFOR\nYOU",
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                                height: 0.9,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1.5,
                                ),
                              ),
                              child: const Column(
                                children: [
                                  Text(
                                    "FOR ONLINE",
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "30% OFF",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // الصورة
              Expanded(
                flex: 5,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                  ),
                  child: Image.network(
                    imagePath,
                    height: 250,
                    fit: BoxFit.cover,
                    alignment: Alignment.topCenter,
                  ),
                ),
              ),
            ],
          ),
        ),

        // شارة "إعلان ممول"
        Positioned(
          bottom: 10,
          right: 10,
          // لأننا RTL ستظهر في اليمين، عدلها ل left إذا أردتها يساراً
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              "إعلان ممول",
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              storeName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.workspace_premium, color: Colors.amber, size: 24),
            // التاج الذهبي
          ],
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      description,
      style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.5),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildStatsRow() {
    return Row(
      spacing: 5,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(Icons.stars_rounded, color: Colors.amber, size: 20),
        const Text(
          "5.0",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),

        _buildIconBadge(Icons.local_shipping_outlined, Colors.green),

        _buildIconBadge(Icons.verified_user_outlined, Colors.teal),
      ],
    );
  }

  Widget _buildIconBadge(IconData icon, Color color) {
    return Icon(icon, color: color, size: 20);
  }

  Widget _buildFollowButton() {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3E5F84),
          // اللون الأزرق الرمادي الغامق
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_add_alt_1, color: Colors.white),
            Text(
              "متابعة المتجر",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
