import '../../../general_index.dart';

class FollowerListItem extends StatelessWidget {
  final FollowerModel model;
  final String actionText;
  final Image actionIcon;
  final VoidCallback onAction;

  const FollowerListItem({
    super.key,
    required this.model,
    required this.actionText,
    required this.actionIcon,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        spacing: 10,
        children: [
          CircleAvatar(radius: 28, backgroundImage: NetworkImage(model.avatar)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(model.name, style: getBold(fontSize: 15)),
                Text(
                  '${model.followersCount} متابع',
                  style: getMedium(fontSize: 13, color: AppColors.neutral500),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: onAction,
            icon: actionIcon,
            label: Text(actionText),
          ),
        ],
      ),
    );
  }
}
