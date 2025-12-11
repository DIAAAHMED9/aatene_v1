import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/models/chat_models.dart';

import '../../../controller/chat_controller.dart';
import '../../../utlis/connection_status.dart';

class ChatMassege extends StatefulWidget {
  final ChatConversation conversation;
  
  const ChatMassege({super.key, required this.conversation});

  @override
  State<ChatMassege> createState() => _ChatMassegeState();
}

class _ChatMassegeState extends State<ChatMassege> {
  final ChatController chatController = Get.find<ChatController>();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  Timer? _typingTimer;
  bool _isTyping = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.setCurrentConversation(widget.conversation);
      chatController.loadConversationMessages(widget.conversation.id);
      _scrollToBottom();
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _typingTimer?.cancel();
    chatController.clearCurrentConversation();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onTextChanged(String text) {
    if (!_isTyping && text.isNotEmpty) {
      _isTyping = true;
      chatController.sendTypingStatus(widget.conversation.id, true);
    }
    
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      if (_isTyping) {
        _isTyping = false;
        chatController.sendTypingStatus(widget.conversation.id, false);
      }
    });
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty || _isSending) return;

    try {
      setState(() => _isSending = true);
      await chatController.sendMessage(message, widget.conversation.id);
      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل إرسال الرسالة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      flexibleSpace: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 8),
              _buildUserAvatar(),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.conversation.name ?? 'بدون اسم',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: widget.conversation.isOnline
                                ? Colors.green
                                : Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          widget.conversation.isOnline
                              ? 'متصل الآن'
                              : 'غير متصل',
                          style: TextStyle(
                            color: widget.conversation.isOnline
                                ? Colors.green
                                : Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              GetBuilder<ChatController>(
                builder: (controller) {
                  if (controller.connectionStatus.value != ConnectionStatus.connected) {
                    return IconButton(
                      icon: Icon(
                        Icons.wifi_off,
                        color: Colors.red.shade400,
                      ),
                      onPressed: () {
                        controller.reconnectWebSocket();
                      },
                    );
                  }
                  return const SizedBox();
                },
              ),
              _buildMoreMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserAvatar() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: widget.conversation.avatar != null
              ? NetworkImage(widget.conversation.avatar!)
              : const AssetImage("assets/image/1.png") as ImageProvider,
        ),
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: widget.conversation.isOnline ? Colors.green : Colors.grey,
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

  Widget _buildMoreMenu() {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, color: Colors.black54),
      onSelected: (value) => _handleMenuAction(value),
      itemBuilder: (context) => [
        if (widget.conversation.unreadCount > 0)
          const PopupMenuItem(
            value: 'mark_read',
            child: Row(
              children: [
                Icon(Icons.mark_chat_read, size: 20),
                SizedBox(width: 8),
                Text('تحديد كمقروء'),
              ],
            ),
          ),
        PopupMenuItem(
          value: 'toggle_interest',
          child: Row(
            children: [
              Icon(
                widget.conversation.isInterested
                    ? Icons.star
                    : Icons.star_outline,
                size: 20,
                color: widget.conversation.isInterested
                    ? Colors.amber
                    : null,
              ),
              const SizedBox(width: 8),
              Text(
                widget.conversation.isInterested
                    ? 'إلغاء المتابعة'
                    : 'متابعة',
              ),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'block',
          child: Row(
            children: [
              Icon(Icons.block, size: 20, color: Colors.red),
              SizedBox(width: 8),
              Text('حظر المستخدم'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'clear_chat',
          child: Row(
            children: [
              Icon(Icons.delete_outline, size: 20),
              SizedBox(width: 8),
              Text('مسح المحادثة'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return GetBuilder<ChatController>(
      builder: (controller) {
        return Column(
          children: [
            // حالة الاتصال
            if (controller.connectionStatus.value != ConnectionStatus.connected)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.orange.shade100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      ConnectionStatusHelper.getIcon(controller.connectionStatus.value),
                      size: 16,
                      color: Colors.orange,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      ConnectionStatusHelper.getDisplayName(controller.connectionStatus.value),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                      ),
                    ),
                    if (controller.connectionStatus.value == ConnectionStatus.disconnected)
                      TextButton(
                        onPressed: () => controller.reconnectWebSocket(),
                        child: const Text(
                          'إعادة الاتصال',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            
            // قائمة الرسائل
            Expanded(
              child: controller.isLoadingMessages.value
                  ? const Center(child: CircularProgressIndicator())
                  : _buildMessagesList(controller),
            ),

            // شريط إرسال الرسائل
            _buildMessageInput(),
          ],
        );
      },
    );
  }

  Widget _buildMessagesList(ChatController controller) {
    if (controller.currentMessages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 80,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            const Text(
              'ابدأ المحادثة الآن',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'أرسل أول رسالة لك',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: controller.currentMessages.length + 1,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, index) {
        if (index == controller.currentMessages.length) {
          return const SizedBox(height: 20);
        }
        
        final message = controller.currentMessages[index];
        return _buildMessageBubble(message, context);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message, BuildContext context) {
    final isMe = message.messageType == "sender";
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!isMe)
              CircleAvatar(
                radius: 14,
                backgroundImage: widget.conversation.avatar != null
                    ? NetworkImage(widget.conversation.avatar!)
                    : null,
              ),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.75,
                ),
                margin: EdgeInsets.only(
                  left: isMe ? 40 : 8,
                  right: isMe ? 8 : 40,
                ),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isMe
                      ? const Color(0xff2176ff)
                      : Colors.grey.shade200,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      message.content,
                      style: TextStyle(
                        fontSize: 15,
                        color: isMe ? Colors.white : Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _formatMessageTime(message.timestamp),
                          style: TextStyle(
                            fontSize: 10,
                            color: isMe
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 4),
                        if (isMe)
                          Icon(
                            message.isRead
                                ? Icons.done_all
                                : Icons.done,
                            size: 12,
                            color: isMe
                                ? Colors.white.withOpacity(0.8)
                                : Colors.grey.shade600,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isMe)
              const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          // زر إضافة مرفق
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.grey.shade600,
            ),
            onPressed: () => _showAttachmentMenu(),
          ),
          
          // حقل النص
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _messageController,
                onChanged: _onTextChanged,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: "اكتب رسالة...",
                  hintStyle: const TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.emoji_emotions_outlined),
                    color: Colors.grey.shade600,
                    onPressed: () {
                      // إضافة إيموجي
                    },
                  ),
                ),
                maxLines: 5,
                minLines: 1,
              ),
            ),
          ),
          
          // زر الإرسال
          const SizedBox(width: 8),
          _isSending
              ? Container(
                  padding: const EdgeInsets.all(8),
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : IconButton(
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _messageController.text.trim().isEmpty
                          ? Colors.grey.shade300
                          : const Color(0xff2176ff),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  onPressed: _sendMessage,
                ),
        ],
      ),
    );
  }

  String _formatMessageTime(DateTime timestamp) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDay = DateTime(
      timestamp.year,
      timestamp.month,
      timestamp.day,
    );

    if (today == messageDay) {
      return '${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (today.difference(messageDay).inDays == 1) {
      return 'أمس ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}/${timestamp.month} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    }
  }

  void _showAttachmentMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'إرفاق ملف',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildAttachmentOption(
                    icon: Icons.photo,
                    label: 'صورة',
                    onTap: () {
                      Get.back();
                      // اختيار صورة
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.video_library,
                    label: 'فيديو',
                    onTap: () {
                      Get.back();
                      // اختيار فيديو
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.attach_file,
                    label: 'ملف',
                    onTap: () {
                      Get.back();
                      // اختيار ملف
                    },
                  ),
                  _buildAttachmentOption(
                    icon: Icons.location_on,
                    label: 'موقع',
                    onTap: () {
                      Get.back();
                      // اختيار موقع
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: Colors.blue),
          ),
          onPressed: onTap,
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }

  void _handleMenuAction(String value) {
    switch (value) {
      case 'mark_read':
        chatController.markMessagesAsRead(widget.conversation.id);
        break;
      case 'toggle_interest':
        chatController.toggleInterest(
          widget.conversation.id,
          !widget.conversation.isInterested,
        );
        break;
      case 'block':
        _showBlockDialog();
        break;
      case 'clear_chat':
        _showClearChatDialog();
        break;
    }
  }

  void _showBlockDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('حظر المستخدم'),
        content: const Text('هل أنت متأكد من حظر هذا المستخدم؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              chatController.blockUser(
                widget.conversation.participantType,
                widget.conversation.participantId,
              );
              Get.back(); // العودة للشاشة السابقة
            },
            child: const Text(
              'حظر',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearChatDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('مسح المحادثة'),
        content: const Text('هل أنت متأكد من مسح جميع الرسائل؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              // تنفيذ مسح المحادثة
            },
            child: const Text(
              'مسح',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}