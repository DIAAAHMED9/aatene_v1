import '../../../general_index.dart';

class ComplaintsCard extends StatelessWidget {
  const ComplaintsCard({
    super.key,
    required this.number,
    required this.title,
    required this.backgroundColor,
    required this.textColor,
  });

  final String number;
  final String title;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.colorComplaintsCard),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(title, style: getBold(fontSize: 10)),
              Text(number, style: getBold(fontSize: 18, color: textColor)),
            ],
          ),
        ),
      ),
    );
  }
}
