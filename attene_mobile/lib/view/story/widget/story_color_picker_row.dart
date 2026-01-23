import '../../../general_index.dart';
import '../../../utlis/responsive/index.dart';

class StoryColorPickerRow extends StatelessWidget {
  final List<Color> colors;
  final Color selected;
  final ValueChanged<Color> onSelect;
  final VoidCallback onDone;

  const StoryColorPickerRow({
    super.key,
    required this.colors,
    required this.selected,
    required this.onSelect,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: ResponsiveDimensions.h(10),
        horizontal: ResponsiveDimensions.w(12),
      ),
      decoration: BoxDecoration(
        color: AppColors.neutral1000.withOpacity(0.90),
        borderRadius: BorderRadius.circular(ResponsiveDimensions.w(14)),
        border: Border.all(color: AppColors.neutral900, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: ResponsiveDimensions.w(42),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: colors.length,
                separatorBuilder: (_, __) => SizedBox(width: ResponsiveDimensions.w(10)),
                itemBuilder: (context, index) {
                  final c = colors[index];
                  final bool isSelected = c.value == selected.value;

                  return InkWell(
                    onTap: () => onSelect(c),
                    borderRadius: BorderRadius.circular(999),
                    child: Container(
                      width: ResponsiveDimensions.w(40),
                      height: ResponsiveDimensions.w(40),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c,
                        border: Border.all(
                          color: isSelected ? AppColors.primary400 : AppColors.neutral800,
                          width: isSelected ? 3 : 1,
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              color: AppColors.neutral1000,
                              size: ResponsiveDimensions.w(18),
                            )
                          : null,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: ResponsiveDimensions.w(10)),
          InkWell(
            onTap: onDone,
            borderRadius: BorderRadius.circular(ResponsiveDimensions.w(12)),
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveDimensions.h(10),
                horizontal: ResponsiveDimensions.w(14),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary400,
                borderRadius: BorderRadius.circular(ResponsiveDimensions.w(12)),
              ),
              child: Text(
                'تم',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(13),
                  fontWeight: FontWeight.bold,
                  color: AppColors.neutral1000,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
