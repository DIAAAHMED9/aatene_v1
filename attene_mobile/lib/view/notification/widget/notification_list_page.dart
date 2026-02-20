import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/notification/controller/notification_controller.dart';
import 'package:attene_mobile/view/notification/widget/animated_notification_item.dart';
import 'package:attene_mobile/view/notification/widget/notification_empty_state.dart';

class NotificationListPage extends StatelessWidget {
  final bool isRead;

  const NotificationListPage({super.key, required this.isRead});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Obx(() {
      final list =
      isRead ? controller.readList : controller.unreadList;

      if (list.isEmpty) {
        return NotificationEmptyState(isReadTab: isRead);
      }

      return ListView.builder(
        padding:
        const EdgeInsets.symmetric(horizontal: 16),
        physics:
        const BouncingScrollPhysics(),
        itemCount: list.length,
        itemBuilder: (context, index) {
          final item = list[index];

          return AnimatedNotificationItem(
            model: item,
            onDelete: () =>
                controller.removeWithUndo(item),
            onMarkRead: () =>
                controller.markAsRead(item),
          );
        },
      );
    });
  }
}