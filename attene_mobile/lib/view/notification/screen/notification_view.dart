import 'package:attene_mobile/view/notification/controller/notification_controller.dart';
import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/notification/widget/notification_list_page.dart';
import 'package:attene_mobile/view/notification/widget/notification_tab.dart';

class NotificationView extends StatelessWidget {
  final NotificationController controller;

  const NotificationView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          const SizedBox(height: 10),
          _buildTabBar(),
          const SizedBox(height: 10),
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.changePage,
              physics: const BouncingScrollPhysics(),
              children: [
                NotificationListPage(isRead: false),
                NotificationListPage(isRead: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Text(
        "الإشعارات",
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
    );
  }

  Widget _buildTabBar() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            NotificationTabButton(
              title: 'غير مقروءة',
              active: controller.currentIndex.value == 0,
              onTap: () => controller.changePage(0),
            ),
            const SizedBox(width: 12),
            NotificationTabButton(
              title: 'مقروءة',
              active: controller.currentIndex.value == 1,
              onTap: () => controller.changePage(1),
            ),
          ],
        ),
      );
    });
  }
}