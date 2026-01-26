import '../../../general_index.dart';

class FollowersListPage extends StatelessWidget {
  const FollowersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FollowersController>();

    return Obx(
      () => ListView.builder(
        itemCount: controller.filteredFollowers.length,
        itemBuilder: (_, index) {
          final model = controller.filteredFollowers[index];
          return FollowerListItem(
            model: model,
            actionText: 'رد متابعة',
            actionIcon: Image.asset(
              "assets/images/png/user-add.png",
              width: 16,
              height: 16,
            ),
            onAction: () => controller.followBack(model),
          );
        },
      ),
    );
  }
}
