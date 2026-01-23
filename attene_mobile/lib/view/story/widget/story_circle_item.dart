import '../../../general_index.dart';
import '../../../utlis/responsive/index.dart';

class StoryCircleItem extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final bool isAddButton;
  final bool hasUnseen;
  final VoidCallback onTap;

  const StoryCircleItem({
    super.key,
    required this.title,
    required this.onTap,
    this.imageUrl,
    this.isAddButton = false,
    this.hasUnseen = false,
  });

  @override
  Widget build(BuildContext context) {
    final double circleSize = ResponsiveDimensions.w(64);
    final double innerPadding = ResponsiveDimensions.w(2.5);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: SizedBox(
        width: ResponsiveDimensions.w(82),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCircle(circleSize, innerPadding),
            SizedBox(height: ResponsiveDimensions.h(6)),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(12),
                fontWeight: FontWeight.w500,
                color: AppColors.neutral300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircle(double circleSize, double innerPadding) {
    if (isAddButton) {
      return Container(
        width: circleSize,
        height: circleSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.neutral1000,
          border: Border.all(color: AppColors.neutral900, width: 1),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            size: ResponsiveDimensions.w(26),
            color: AppColors.primary400,
          ),
        ),
      );
    }

    final BoxDecoration ringDecoration = hasUnseen
        ? const BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                AppColors.primary300,
                Colors.purpleAccent,
                Colors.blue,
              ],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
          )
        : BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.neutral800, width: 2),
          );

    return Container(
      width: circleSize,
      height: circleSize,
      padding: EdgeInsets.all(innerPadding),
      decoration: ringDecoration,
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
        ),
        padding: EdgeInsets.all(ResponsiveDimensions.w(2)),
        child: CircleAvatar(
          backgroundColor: AppColors.neutral900,
          backgroundImage: (imageUrl != null && (imageUrl ?? '').isNotEmpty)
              ? NetworkImage(imageUrl!)
              : null,
          child: (imageUrl == null || (imageUrl ?? '').isEmpty)
              ? Icon(
                  Icons.storefront,
                  color: AppColors.neutral600,
                  size: ResponsiveDimensions.w(22),
                )
              : null,
        ),
      ),
    );
  }
}
