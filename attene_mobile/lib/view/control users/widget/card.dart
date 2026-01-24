import '../../../general_index.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;

  final String subtitle;

  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 220,
      decoration: BoxDecoration(
        color: AppColors.light1000,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.neutral900),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: BorderRadius.circular(2),
              ),
              width: 30,
              height: 30,
              child: icon,
            ),
            Text(
              title,
              style: getBold(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              subtitle,
              style: getRegular(fontSize: 12, color: AppColors.neutral400),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
