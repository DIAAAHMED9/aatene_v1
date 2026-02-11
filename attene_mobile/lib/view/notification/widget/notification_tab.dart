import 'package:attene_mobile/general_index.dart';

class NotificationTabButton extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap;

  const NotificationTabButton({
    super.key,
    required this.title,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.primary400 : AppColors.primary50,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            title,
            style: getMedium(
              color: active ? AppColors.light1000 : AppColors.primary400,
            ),
          ),
        ),
      ),
    );
  }
}
