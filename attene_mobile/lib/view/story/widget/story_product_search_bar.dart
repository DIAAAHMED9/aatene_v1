import '../../../general_index.dart';
import '../../../utlis/responsive/index.dart';

class StoryProductSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;

  const StoryProductSearchBar({
    super.key,
    required this.controller,
    required this.onFilterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: ResponsiveDimensions.h(44),
            padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.w(12)),
            decoration: BoxDecoration(
              color: AppColors.neutral1000,
              borderRadius: BorderRadius.circular(ResponsiveDimensions.w(12)),
              border: Border.all(color: AppColors.neutral900, width: 1),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: AppColors.neutral600,
                  size: ResponsiveDimensions.w(18),
                ),
                SizedBox(width: ResponsiveDimensions.w(8)),
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'ابحث عن منتج...',
                      isCollapsed: true,
                    ),
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.f(13),
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutral200,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: ResponsiveDimensions.w(10)),
        InkWell(
          onTap: onFilterTap,
          borderRadius: BorderRadius.circular(ResponsiveDimensions.w(12)),
          child: Container(
            height: ResponsiveDimensions.h(44),
            width: ResponsiveDimensions.h(44),
            decoration: BoxDecoration(
              color: AppColors.neutral1000,
              borderRadius: BorderRadius.circular(ResponsiveDimensions.w(12)),
              border: Border.all(color: AppColors.neutral900, width: 1),
            ),
            child: Icon(
              Icons.tune_rounded,
              color: AppColors.neutral300,
              size: ResponsiveDimensions.w(20),
            ),
          ),
        ),
      ],
    );
  }
}
