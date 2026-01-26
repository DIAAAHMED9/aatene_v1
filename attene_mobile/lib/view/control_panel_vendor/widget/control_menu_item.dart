import 'package:attene_mobile/general_index.dart';

class DashboardMenuItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;

  const DashboardMenuItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        spacing: 10,
        children: [
          icon,
          Column(
            spacing: 5,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: getBold()),
              Text(
                subtitle,
                style: getRegular(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),

          const Spacer(),
          const Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: AppColors.neutral50,
            weight: 10,
          ),
        ],
      ),
    );
  }
}
