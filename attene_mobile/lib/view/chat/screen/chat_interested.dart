

import '../../../general_index.dart';


class ChatInterested extends StatelessWidget {
  const ChatInterested({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController c = Get.find<ChatController>();
    WidgetsBinding.instance.addPostFrameCallback((_) => c.setTab(ChatTab.interested));
    return const ChatAll();
  }
}