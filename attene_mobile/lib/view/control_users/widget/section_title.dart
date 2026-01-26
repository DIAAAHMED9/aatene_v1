import '../../../general_index.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const SectionTitle({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 5,
          children: [
            Row(
              spacing: 8,
              children: [
                CircleAvatar(backgroundColor: AppColors.primary300, radius: 12),
                Text(title, style: getBold(fontSize: 14)),
              ],
            ),
            Text(
              subtitle,
              style: getRegular(fontSize: 12, color: AppColors.neutral600),
            ),
          ],
        ),
      ),
    );
  }
}
