import '../../../general_index.dart';

class FollowersTabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const FollowersTabItem({
    super.key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary500 : AppColors.primary50,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            title,
            style: getMedium(
              color: isSelected ? Colors.white : AppColors.primary500,
            ),
          ),
        ),
      ),
    );
  }
}
