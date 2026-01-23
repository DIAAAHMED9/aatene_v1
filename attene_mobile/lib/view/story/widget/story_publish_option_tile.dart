import '../../../general_index.dart';
import '../../../utlis/responsive/index.dart';

class StoryPublishOptionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const StoryPublishOptionTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ResponsiveDimensions.w(12)),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveDimensions.h(12),
          horizontal: ResponsiveDimensions.w(12),
        ),
        child: Row(
          children: [
            Container(
              width: ResponsiveDimensions.w(38),
              height: ResponsiveDimensions.w(38),
              decoration: BoxDecoration(
                color: AppColors.neutral1000,
                borderRadius: BorderRadius.circular(ResponsiveDimensions.w(10)),
                border: Border.all(color: AppColors.neutral900, width: 1),
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: ResponsiveDimensions.w(20),
                  color: AppColors.primary400,
                ),
              ),
            ),
            SizedBox(width: ResponsiveDimensions.w(12)),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(14),
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutral200,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: ResponsiveDimensions.w(16),
              color: AppColors.neutral600,
            ),
          ],
        ),
      ),
    );
  }
}
