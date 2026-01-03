

import '../../../general_index.dart';
import '../index.dart';

class ChatDetailPage extends StatelessWidget {
  final ChatConversation conversation;

  const ChatDetailPage({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return ChatMassege(conversation: conversation);
  }
}