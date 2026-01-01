import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:attene_mobile/controller/chat_controller.dart';
import 'chat_all.dart';

class ChatInterested extends StatelessWidget {
  const ChatInterested({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController c = Get.find<ChatController>();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => c.setTab(ChatTab.interested),
    );
    return const ChatAll();
  }
}
