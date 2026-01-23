import '../../../general_index.dart';
import '../../../utlis/responsive/index.dart';

class StoryProductGridItem extends StatelessWidget {
  final dynamic product;
  final bool selected;
  final VoidCallback onTap;

  const StoryProductGridItem({
    super.key,
    required this.product,
    required this.selected,
    required this.onTap,
  });

  String _title(dynamic p) {
    try {
      return (p.title ?? '').toString();
    } catch (_) {}
    try {
      return (p.name ?? '').toString();
    } catch (_) {}
    try {
      return (p['title'] ?? p['name'] ?? 'منتج').toString();
    } catch (_) {}
    return 'منتج';
  }

  String? _img(dynamic p) {
    try {
      return p.imageUrl?.toString();
    } catch (_) {}
    try {
      return p.image?.toString();
    } catch (_) {}
    try {
      return (p['image_url'] ?? p['image'])?.toString();
    } catch (_) {}
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final img = _img(product);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveDimensions.w(12)),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.neutral1000,
          borderRadius: BorderRadius.circular(ResponsiveDimensions.w(12)),
          border: Border.all(
            color: selected ? AppColors.primary400 : AppColors.neutral900,
            width: selected ? 2 : 1,
          ),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(ResponsiveDimensions.w(12)),
                    ),
                    child: img == null || img.isEmpty
                        ? Container(
                            color: AppColors.neutral900,
                            child: Center(
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: AppColors.neutral600,
                                size: ResponsiveDimensions.w(26),
                              ),
                            ),
                          )
                        : Image.network(
                            img,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.neutral900,
                              child: Center(
                                child: Icon(
                                  Icons.broken_image_outlined,
                                  color: AppColors.neutral600,
                                  size: ResponsiveDimensions.w(24),
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(ResponsiveDimensions.w(8)),
                  child: Text(
                    _title(product),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.f(12),
                      fontWeight: FontWeight.w700,
                      color: AppColors.neutral200,
                    ),
                  ),
                ),
              ],
            ),
            if (selected)
              Positioned(
                top: ResponsiveDimensions.w(8),
                right: ResponsiveDimensions.w(8),
                child: Container(
                  padding: EdgeInsets.all(ResponsiveDimensions.w(6)),
                  decoration: BoxDecoration(
                    color: AppColors.primary400,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Icon(
                    Icons.check,
                    size: ResponsiveDimensions.w(16),
                    color: AppColors.neutral1000,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
