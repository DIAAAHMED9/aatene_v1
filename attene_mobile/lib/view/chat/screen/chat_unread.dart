
import '../../../general_index.dart';
import '../index.dart' hide ChatController;

class ChatUnread extends StatelessWidget {
  const ChatUnread({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController c = Get.find<ChatController>();
    WidgetsBinding.instance.addPostFrameCallback((_) => c.setTab(ChatTab.unread));
    return const ChatAll();
  }
}