import '../../../general_index.dart';
import '../../../utlis/responsive/responsive_dimensions.dart';

class StoryMediaTabBar extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChange;

  const StoryMediaTabBar({
    super.key,
    required this.index,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    Widget item(String title, int i) {
      final bool selected = i == index;
      return InkWell(
        onTap: () => onChange(i),
        borderRadius: BorderRadius.circular(999),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.w(14),
            vertical: ResponsiveDimensions.h(8),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(13),
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              color: selected ? AppColors.neutral200 : AppColors.neutral600,
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        item('الاستديو', 0),
        item('كاميرا', 1),
        item('فيديو', 2),
      ],
    );
  }
}
