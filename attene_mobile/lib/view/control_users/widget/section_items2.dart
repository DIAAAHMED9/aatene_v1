import '../../../general_index.dart';

class SectionItems2 extends StatelessWidget {
  const SectionItems2({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;

  final String subtitle;

  final Image icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.colorAboutUsScreen,
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
                Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: AppColors.primary400,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(child: icon),
                ),
                Text(title, style: getBold(fontSize: 14)),
              ],
            ),
            Text(
              subtitle,
              textAlign: TextAlign.start,
              style: getRegular(fontSize: 12, color: AppColors.neutral600),
            ),
          ],
        ),
      ),
    );
  }
}
