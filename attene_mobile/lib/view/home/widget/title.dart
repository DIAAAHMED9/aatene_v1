import '../../../general_index.dart';

class TitleHome extends StatelessWidget {
  const TitleHome({super.key, required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: getBold(fontSize: 21)),
        Text(
          subtitle,
          style: getMedium(fontSize: 14, color: AppColors.neutral500),
        ),
      ],
    );
  }
}
