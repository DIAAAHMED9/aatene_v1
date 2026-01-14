import '../../../general_index.dart';

class ShowAllTitle extends StatelessWidget {
  const ShowAllTitle({super.key, required this.title, this.screen});

  final String title;
  final Widget? screen;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: getBold(fontSize: 21)),
        Spacer(),
        TextButton(
          onPressed: () {},
          child: Text(
            "عرض الكل",
            style: getMedium(fontSize: 14, color: AppColors.neutral500),
          ),
        ),
      ],
    );
  }
}
