import '../../general_index.dart';

class AateneButtonWithIcon extends StatelessWidget {
  const AateneButtonWithIcon({
    super.key,
    required this.buttonText,
    this.icon,
    this.onTap,
  });

  final String buttonText;
  final Icon? icon;
  final Function()? onTap;

  final double borderRadius = 100;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          color: AppColors.primary400,
        ),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back_ios, color: AppColors.light1000, size: 15),
            Text(buttonText, style: getMedium(color: AppColors.light1000)),
          ],
        ),
      ),
    );
  }
}
