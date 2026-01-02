

import '../../../general_index.dart';

class FollowerItem extends StatelessWidget {
  final FollowerModel model;

  const FollowerItem({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FollowersController>();

    return Row(
      children: [
        CircleAvatar(radius: 28, backgroundImage: NetworkImage(model.avatar)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.name, style: getBold(fontSize: 14)),
              Text(
                '${model.followersCount ~/ 1000}K متابع',
                style: getMedium(fontSize: 13),
              ),
            ],
          ),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: model.isFollowing
                ? AppColors.primary50
                : AppColors.primary400,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          icon: Icon(
            model.isFollowing ? Icons.person_remove : Icons.person_add,
            size: 18,
            color: model.isFollowing
                ? AppColors.primary400
                : AppColors.primary50,
          ),
          label: Text(
            model.isFollowing ? 'إلغاء المتابعة' : 'رد المتابعة',
            style: getMedium(
              color: model.isFollowing
                  ? AppColors.primary400
                  : AppColors.primary50,
            ),
          ),
          onPressed: () {
            if (model.isFollowing) {
              Get.dialog(UnfollowDialog(model: model));
            } else {
            }
          },
        ),
      ],
    );
  }
}
