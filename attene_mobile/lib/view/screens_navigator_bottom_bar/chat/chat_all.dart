import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/models/chat_models.dart';
import 'package:attene_mobile/utlis/connection_status.dart';

import '../../../controller/chat_controller.dart';
import 'Chat_Interested.dart';
import 'Chat_Unread.dart';
import 'chat_massege.dart';

class ChatAll extends StatelessWidget {
  ChatAll({super.key});

  final ChatController chatController = Get.find<ChatController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Row(
        children: [
          const Text(
            "الدردشة",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 8),
          GetBuilder<ChatController>(
            builder: (controller) {
              return Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    margin: const EdgeInsets.only(left: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: ConnectionStatusHelper.getColor(
                        controller.connectionStatus.value,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    ConnectionStatusHelper.getDisplayName(
                      controller.connectionStatus.value,
                    ),
                    style: TextStyle(
                      fontSize: 12,
                      color: ConnectionStatusHelper.getColor(
                        controller.connectionStatus.value,
                      ),
                    ),
                  ),
                ],
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
    );
  }

  Widget _buildBody() {
    return GetBuilder<ChatController>(
      builder: (controller) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // شريط البحث
              _buildSearchBar(controller),
              const SizedBox(height: 10),
              
              // تبويبات التصنيف
              _buildTabButtons(controller),
              const Divider(color: Colors.grey, height: 15),
              
              // حالة التحميل
              if (controller.isLoading.value)
                const Expanded(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                // قائمة المحادثات
                Expanded(
                  child: _buildConversationsList(controller),
                ),
            ],
          ),
        );
      },
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
          hintText: 'ابحث عن دردشة ...',
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
        // تبويب الكل
        _buildTabButton(
          label: "الكل",
          isActive: controller.currentTab.value == ChatTab.all,
          badgeCount: null,
          onTap: () {
            controller.setCurrentTab(ChatTab.all);
          },
        ),
        const SizedBox(width: 10),
        
        // تبويب غير مقروء
        _buildTabButton(
          label: "غير مقروء",
          isActive: controller.currentTab.value == ChatTab.unread,
          badgeCount: controller.totalUnreadCount.value,
          onTap: () {
            controller.setCurrentTab(ChatTab.unread);
          },
        ),
        const SizedBox(width: 10),
        
        // تبويب المهتمين
        _buildTabButton(
          label: "المهتمين",
          isActive: controller.currentTab.value == ChatTab.interested,
          badgeCount: null,
          onTap: () {
            controller.setCurrentTab(ChatTab.interested);
          },
        ),
      ],
    );
  }

  Widget _buildTabButton({
    required String label,
    required bool isActive,
    required int? badgeCount,
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
      child: Stack(
        children: [
          MaterialButton(
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
          if (badgeCount != null && badgeCount > 0)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  badgeCount > 99 ? '99+' : badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildConversationsList(ChatController controller) {
    final conversations = controller.getFilteredConversations();
    
    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_outlined,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              controller.searchQuery.value.isNotEmpty
                  ? 'لا توجد نتائج بحث'
                  : 'لا توجد محادثات',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            if (controller.searchQuery.value.isEmpty)
              TextButton(
                onPressed: () {
                  controller.refreshConversations();
                },
                child: const Text('تحديث القائمة'),
              ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshConversations();
      },
      child: ListView.separated(
        itemCount: conversations.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return _buildConversationItem(conversation, controller);
        },
      ),
    );
  }

  Widget _buildConversationItem(ChatConversation conversation, ChatController controller) {
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: conversation.unreadCount > 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: conversation.unreadCount > 0
                              ? Colors.black
                              : Colors.grey[700],
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        conversation.lastMessage ?? 'لا توجد رسائل',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          color: conversation.unreadCount > 0
                              ? Colors.black
                              : Colors.grey,
                        ),
                      ),
                    ),
                    if (conversation.unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff2176ff),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          conversation.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          
          // زر المتابعة
          IconButton(
            icon: Icon(
              conversation.isInterested
                  ? Icons.star
                  : Icons.star_outline,
              color: conversation.isInterested
                  ? Colors.amber
                  : Colors.grey.shade400,
            ),
            onPressed: () {
              controller.toggleInterest(
                conversation.id,
                !conversation.isInterested,
              );
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
        // مؤشر حالة الاتصال
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
    } else if (difference.inDays < 7) {
      return '${difference.inDays}أيام';
    } else {
      return '${time.day}/${time.month}';
    }
  }
}