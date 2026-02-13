import '../../../general_index.dart';

class YouFollowPage extends StatelessWidget {
  const YouFollowPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FollowersController>();

    return Obx(
          () {
        if (controller.isLoadingFollowings.value && controller.followingList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.filteredFollowing.length,
          itemBuilder: (_, index) {
            final model = controller.filteredFollowing[index];
            return FollowerListItem(
              model: model,
              actionText: 'إلغاء المتابعة',
              actionIcon: Image.asset(
                "assets/images/png/user-remove.png",
                width: 16,
                height: 16,
              ),
              onAction: () => controller.unfollow(model),
            );
          },
        );
      },
    );
  }
}