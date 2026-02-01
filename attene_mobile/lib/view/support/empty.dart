import 'package:attene_mobile/general_index.dart';

void main() {
  runApp(MyApp());
}

/// ===============================
/// App Root
/// ===============================
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen());
  }
}

/// ===============================
/// Home Screen (Example Usage)
/// ===============================
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: RatingSummaryWidget(
          rating: 4.2,
          totalReviews: 1280,
          ratingCount: const [40, 25, 15, 8, 2],
        ),
      ),
    );
  }
}

/// ===============================
/// Reusable Rating Summary Widget
/// ===============================
class RatingSummaryWidget extends StatefulWidget {
  final double rating;
  final int totalReviews;
  final List<int> ratingCount;
  final Color starColor;
  final Color barColor;

  const RatingSummaryWidget({
    super.key,
    required this.rating,
    required this.totalReviews,
    required this.ratingCount,
    this.starColor = Colors.amber,
    this.barColor = AppColors.primary400,
  }) : assert(ratingCount.length == 5);

  @override
  State<RatingSummaryWidget> createState() => _RatingSummaryWidgetState();
}

class _RatingSummaryWidgetState extends State<RatingSummaryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int maxCount = widget.ratingCount.reduce((a, b) => a > b ? a : b);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ===== Distribution =====
          Expanded(
            child: Column(
              children: List.generate(5, (index) {
                final starValue = 5 - index;
                final count = widget.ratingCount[index];
                final double progress = maxCount == 0 ? 0 : count / maxCount;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      /// Count
                      Text(
                        count.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(width: 10),

                      /// Animated Progress Bar
                      Expanded(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(begin: 0, end: progress),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          builder: (context, value, _) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: value,
                                minHeight: 8,
                                backgroundColor: AppColors.light1000,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  widget.barColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// Stars
                      Row(
                        children: List.generate(
                          starValue,
                          (_) => Icon(
                            Icons.star,
                            size: 16,
                            color: widget.starColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),

          /// ===== Rating Value =====
          Column(
            spacing: 5,
            children: [
              Text(
                widget.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'مراجعة ${widget.totalReviews}',
                style: getMedium(color: AppColors.neutral500),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
