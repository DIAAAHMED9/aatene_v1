import 'dart:math';

import '../../../../general_index.dart';
import '../../../support/empty.dart';

/// نفس التصميم السابق تماماً، لكن مع إمكانية ربط التقييمات بالـ API عند تمرير [productSlug].
///
/// - إذا لم يتم تمرير slug: يعرض بيانات تجريبية (كما كان سابقاً) بدون كسر أي شاشة أخرى.
/// - إذا تم تمرير slug: يجلب تقييمات المنتج من: /reviews/product/:slug
class RatingProfile extends StatefulWidget {
  final String? productSlug;

  const RatingProfile({super.key, this.productSlug});

  @override
  State<RatingProfile> createState() => _RatingProfileState();
}

class _RatingProfileState extends State<RatingProfile> {
  late Future<_RatingData> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<_RatingData> _load() async {
    final slug = widget.productSlug?.trim();

    // الوضع القديم (Placeholder)
    if (slug == null || slug.isEmpty) {
      return _RatingData.placeholder();
    }

    try {
      final res = await ApiHelper.get(
        path: '/reviews/product/$slug',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (res is Map && res['status'] == true) {
        final raw = res['data'] ?? res['reviews'] ?? res['records'] ?? res['items'];
        final list = (raw is List) ? raw : <dynamic>[];
        return _RatingData.fromList(list);
      }

      return _RatingData.placeholder();
    } catch (_) {
      return _RatingData.placeholder();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_RatingData>(
      future: _future,
      builder: (context, snap) {
        final data = snap.data ?? _RatingData.placeholder();

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              spacing: 15,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                RatingSummaryWidget(
                  rating: data.average,
                  totalReviews: data.total,
                  ratingCount: data.counts,
                ),

                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("التعليقات", style: getBold(fontSize: 24)),
                        Text(
                          data.total == 0
                              ? "لا توجد تعليقات بعد"
                              : "سيتم عرض جميع التعليقات هنا",
                          style: getMedium(
                            fontSize: 14,
                            color: AppColors.neutral500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Row(
                        children: [
                          Text("كل التعليقات", style: getMedium()),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ],
                ),

                if (data.reviews.isEmpty)
                  const SizedBox.shrink()
                else
                  ...data.reviews.take(3).map((r) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary50),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          spacing: 10,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              spacing: 12,
                              children: [
                                const CircleAvatar(),
                                Column(
                                  spacing: 5,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(r.userName, style: getBold()),
                                    Text(
                                      r.createdAtLabel,
                                      style: getMedium(fontSize: 12),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.flag_outlined,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              r.comment,
                              style: getMedium(color: AppColors.neutral400),
                            ),
                            Row(
                              spacing: 5,
                              children: [
                                Text("التقييم", style: getBold(fontSize: 13)),
                                const Icon(Icons.star, color: Colors.orange),
                                Text(r.rating.toStringAsFixed(1)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RatingData {
  final double average;
  final int total;
  final List<int> counts; // [5..1] length 5
  final List<_ReviewItem> reviews;

  _RatingData({
    required this.average,
    required this.total,
    required this.counts,
    required this.reviews,
  });

  factory _RatingData.placeholder() {
    return _RatingData(
      average: 4.2,
      total: 1280,
      counts: const [20, 15, 5, 4, 2],
      reviews: const [],
    );
  }

  factory _RatingData.fromList(List<dynamic> list) {
    final reviews = <_ReviewItem>[];
    final counts = List<int>.filled(5, 0);

    double sum = 0;
    int n = 0;

    for (final e in list) {
      if (e is! Map) continue;
      final m = Map<String, dynamic>.from(e);

      final ratingRaw = m['rating'] ?? m['rate'] ?? m['stars'] ?? m['value'];
      final rating = _toDouble(ratingRaw);

      final comment = (m['comment'] ?? m['body'] ?? m['review'] ?? '').toString();
      final createdAt = (m['created_at'] ?? m['createdAt'] ?? m['date'] ?? '').toString();

      final user = m['user'] is Map ? Map<String, dynamic>.from(m['user']) : null;
      final userName = (user?['name'] ?? m['user_name'] ?? m['username'] ?? 'مستخدم').toString();

      final r = _ReviewItem(
        userName: userName,
        comment: comment.isEmpty ? '—' : comment,
        createdAt: createdAt,
        rating: rating,
      );

      reviews.add(r);

      if (rating > 0) {
        n += 1;
        sum += rating;
        final idx = (5 - rating.round()).clamp(0, 4);
        counts[idx] = counts[idx] + 1;
      }
    }

    final avg = n == 0 ? 0.0 : (sum / n);
    return _RatingData(
      average: double.parse(avg.toStringAsFixed(1)),
      total: reviews.length,
      counts: counts,
      reviews: reviews,
    );
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v.toDouble();
    final s = v.toString();
    return double.tryParse(s) ?? 0;
  }
}

class _ReviewItem {
  final String userName;
  final String comment;
  final String createdAt;
  final double rating;

  const _ReviewItem({
    required this.userName,
    required this.comment,
    required this.createdAt,
    required this.rating,
  });

  String get createdAtLabel {
    if (createdAt.isEmpty) return '';
    return createdAt;
  }
}
