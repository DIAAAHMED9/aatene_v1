import 'package:flutter/material.dart';
import 'package:attene_mobile/models/chat_models.dart';

import 'chat_massege.dart';
import 'chat_message_model.dart';

class ChatDetailPage extends StatelessWidget {
  final ChatConversation conversation;

  const ChatDetailPage({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    return ChatMassege(conversation: conversation);
  }
}
