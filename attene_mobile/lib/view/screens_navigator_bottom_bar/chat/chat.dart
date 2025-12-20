import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controller/chat_controller.dart' show ChatController;
import '../../../utlis/connection_status.dart';
import 'chat_all.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();

    return Scaffold(
      appBar: AppBar(title: const Text('الدردشة')),
      body: GetBuilder<ChatController>(
        builder: (controller) {
          if (controller.connectionStatus.value ==
                  ConnectionStatus.disconnected ||
              controller.connectionStatus.value == ConnectionStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    ConnectionStatusHelper.getIcon(
                      controller.connectionStatus.value,
                    ),
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    ConnectionStatusHelper.getDisplayName(
                      controller.connectionStatus.value,
                    ),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'يرجى الاتصال بالإنترنت لاستخدام الدردشة',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      controller.reconnectWebSocket();
                    },
                    child: const Text('إعادة الاتصال'),
                  ),
                ],
              ),
            );
          }

          return GetBuilder<ChatController>(
            builder: (controller) {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              WidgetsBinding.instance.addPostFrameCallback((_) {
                Get.offAll(() => ChatAll());
              });

              return const Center(child: CircularProgressIndicator());
            },
          );
        },
      ),
    );
  }
}
