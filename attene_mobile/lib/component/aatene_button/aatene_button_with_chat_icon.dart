
import '../../general_index.dart';

class AateneButtonWithChatIcon extends StatelessWidget {
  const AateneButtonWithChatIcon({super.key, required this.buttonText});

  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {},
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: AppColors.primary400,
        ),
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.mark_unread_chat_alt_sharp,
              color: AppColors.light1000,
              size: 15,
            ),
            Text(buttonText, style: getMedium(color: AppColors.light1000)),
          ],
        ),
      ),
    );
  }
}