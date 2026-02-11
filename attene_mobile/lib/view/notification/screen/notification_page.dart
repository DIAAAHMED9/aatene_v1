import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/notification/controller/notification_controller.dart';
import 'package:attene_mobile/view/notification/screen/notification_view.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NotificationController());

    return NotificationView(controller: controller);
  }
}
