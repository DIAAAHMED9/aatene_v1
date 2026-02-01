import 'package:attene_mobile/view/control_users/screen/you_follow.dart';

import '../../../general_index.dart';
import 'followers_list.dart';

class FollowersPage extends StatelessWidget {
  FollowersPage({super.key});

  final controller = Get.put(FollowersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "قائمة المتابعين",
          style: getBold(color: AppColors.neutral100, fontSize: 20),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[100],
            ),
            child: Icon(Icons.arrow_back, color: AppColors.neutral100),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          spacing: 15,
          children: [
            Obx(
              () => Row(
                spacing: 15,
                children: [
                  FollowersTabItem(
                    title: 'أشخاص تتابعهم',
                    isSelected: controller.selectedTab.value == 0,
                    onTap: () => controller.changeTab(0),
                  ),
                  FollowersTabItem(
                    title: 'المتابعين',
                    isSelected: controller.selectedTab.value == 1,
                    onTap: () => controller.changeTab(1),
                  ),
                ],
              ),
            ),
            const FollowersSearchField(),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                onPageChanged: controller.changeTab,
                children: [YouFollowPage(), FollowersListPage()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
