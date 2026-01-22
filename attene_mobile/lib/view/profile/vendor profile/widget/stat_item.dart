import 'package:attene_mobile/general_index.dart';

class ProfileStatItem extends StatelessWidget {
  final String title;
  final String value;
  final Widget icon;
  final Widget? subtitle;

  const ProfileStatItem({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 3,
      children: [
        Row(
          spacing: 5,
          children: [
            icon,
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600] ,fontSize: 12,),
            ),
          ],
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary400),
        ),
        if (subtitle != null) ...[subtitle!],
      ],
    );
  }
}
