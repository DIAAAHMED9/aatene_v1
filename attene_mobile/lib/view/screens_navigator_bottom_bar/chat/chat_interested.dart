import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/models/chat_models.dart';
import 'package:attene_mobile/utlis/connection_status.dart';

import '../../../controller/chat_controller.dart';
import 'chat_massege.dart';

class ChatInterested extends StatelessWidget {
  const ChatInterested({super.key});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Row(
          children: [
            const Text(
              "المهتمين",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            GetBuilder<ChatController>(
              builder: (controller) {
                return Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ConnectionStatusHelper.getColor(
                      controller.connectionStatus.value,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          GetBuilder<ChatController>(
            builder: (controller) {
              if (controller.connectionStatus.value == ConnectionStatus.disconnected ||
                  controller.connectionStatus.value == ConnectionStatus.error) {
                return IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.blue),
                  onPressed: () {
                    controller.reconnectWebSocket();
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
      body: GetBuilder<ChatController>(
        builder: (controller) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                // شريط البحث
                _buildSearchBar(controller),
                const SizedBox(height: 10),
                
                // تبويبات
                _buildTabButtons(controller),
                const Divider(color: Colors.grey, height: 15),
                
                // قائمة المهتمين
                Expanded(
                  child: controller.interestedConversations.isEmpty
                      ? _buildEmptyState()
                      : _buildInterestedList(controller),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar(ChatController controller) {
    return Container(
      width: double.infinity,
      color: AppColors.light1000,
      height: 55,
      child: TextField(
        onChanged: (value) {
          controller.updateSearchQuery(value);
        },
        decoration: InputDecoration(
          hintText: 'ابحث في المهتمين...',
          prefixIcon: IconButton(
            icon: Container(
              width: 35,
              height: 35,
              decoration: BoxDecoration(
                color: AppColors.primary400,
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Icon(Icons.search, color: Colors.white),
            ),
            onPressed: () {},
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButtons(ChatController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildTabButton(
          label: "الكل",
          isActive: false,
          onTap: () {
            controller.setCurrentTab(ChatTab.all);
            Get.back();
          },
        ),
        const SizedBox(width: 10),
        _buildTabButton(
          label: "غير مقروء",
          isActive: false,
          onTap: () {
            controller.setCurrentTab(ChatTab.unread);
            Get.back();
          },
        ),
        const SizedBox(width: 10),
        _buildTabButton(
          label: "المهتمين",
          isActive: true,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 100,
      height: 35,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: isActive ? const Color(0xff2176ff) : Colors.white,
        border: isActive ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: MaterialButton(
        onPressed: onTap,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black,
            fontSize: 10,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.star_outline,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد محادثات مهتم بها',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'يمكنك متابعة المحادثات المهمة لك',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestedList(ChatController controller) {
    final conversations = controller.getFilteredConversations();

    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshConversations();
      },
      child: ListView.separated(
        itemCount: conversations.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return _buildInterestedItem(conversation, controller);
        },
      ),
    );
  }

  Widget _buildInterestedItem(ChatConversation conversation, ChatController controller) {
    return MaterialButton(
      onPressed: () {
        controller.setCurrentConversation(conversation);
        Get.to(
          () => ChatMassege(conversation: conversation),
          transition: Transition.rightToLeft,
        );
      },
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          // صورة المستخدم
          _buildUserAvatar(conversation),
          const SizedBox(width: 12),
          
          // معلومات المحادثة
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        conversation.name ?? 'بدون اسم',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      _formatTime(conversation.lastMessageTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  conversation.lastMessage ?? 'لا توجد رسائل',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          
          // زر المتابعة
          IconButton(
            icon: Icon(
              Icons.star,
              color: Colors.amber.shade700,
            ),
            onPressed: () {
              controller.toggleInterest(conversation.id, false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserAvatar(ChatConversation conversation) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 25,
          backgroundImage: conversation.avatar != null
              ? NetworkImage(conversation.avatar!)
              : const AssetImage("assets/image/1.png") as ImageProvider,
        ),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: conversation.isOnline ? Colors.green : Colors.grey,
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(DateTime? time) {
    if (time == null) return '';
    
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inSeconds < 60) {
      return 'الآن';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}د';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}س';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else {
      return '${difference.inDays}أيام';
    }
  }
}
