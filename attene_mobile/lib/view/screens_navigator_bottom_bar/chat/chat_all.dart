
// lib/view/screens_navigator_bottom_bar/chat/chat_all.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:attene_mobile/controller/chat_controller.dart';
import 'package:attene_mobile/models/chat_models.dart';

import 'chat_detail_page.dart';
import 'chat_message_model.dart';

class ChatAll extends StatefulWidget {
  const ChatAll({super.key});

  @override
  State<ChatAll> createState() => _ChatAllState();
}

class _ChatAllState extends State<ChatAll> {
  final ChatController c = Get.find<ChatController>();
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    c.refreshConversations();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = c.filteredConversations;

      return Scaffold(
        appBar: AppBar(
          title: const Text('المحادثات'),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => c.refreshConversations(),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(98),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                  child: TextField(
                    controller: _search,
                    onChanged: c.setSearch,
                    decoration: InputDecoration(
                      hintText: 'بحث...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
                _TabsRow(controller: c),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        body: Stack(
          children: [
            if (c.isLoading.value && list.isEmpty)
              const Center(child: CircularProgressIndicator())
            else if (list.isEmpty)
              const Center(child: Text('لا توجد محادثات'))
            else
              RefreshIndicator(
                onRefresh: () async => c.refreshConversations(),
                child: ListView.separated(
                  padding: const EdgeInsets.only(bottom: 96),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) => _ConversationTile(
                    conversation: list[index],
                    controller: c,
                  ),
                ),
              ),

            // Floating button (works even with custom bottom bars)
            Positioned(
              bottom: 18,
              right: 18,
              child: SafeArea(
                child: Material(
                  elevation: 6,
                  shape: const CircleBorder(),
                  color: Theme.of(context).colorScheme.primary,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _openNewChatSheet,
                    child: const SizedBox(
                      width: 56,
                      height: 56,
                      child: Icon(Icons.chat, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> _openNewChatSheet() async {
    await c.loadPreviousParticipants();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _NewChatSheet(controller: c),
    );
  }
}

class _TabsRow extends StatelessWidget {
  final ChatController controller;
  const _TabsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tab = controller.currentTab.value;
      Widget chip(String label, ChatTab t) {
        final selected = tab == t;
        return ChoiceChip(
          label: Text(label),
          selected: selected,
          onSelected: (_) => controller.setTab(t),
        );
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            chip('الكل', ChatTab.all),
            const SizedBox(width: 8),
            chip('غير مقروء', ChatTab.unread),
            const SizedBox(width: 8),
            chip('نشط', ChatTab.active),
            const SizedBox(width: 8),
            chip('غير نشط', ChatTab.notActive),
            const SizedBox(width: 8),
            chip('مهتم', ChatTab.interested),
          ],
        ),
      );
    });
  }
}

class _ConversationTile extends StatelessWidget {
  final ChatConversation conversation;
  final ChatController controller;

  const _ConversationTile({
    required this.conversation,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final title = conversation.displayName(
      myOwnerType: controller.myOwnerType,
      myOwnerId: controller.myOwnerId,
    );

    final avatarUrl = conversation.displayAvatar(
      myOwnerType: controller.myOwnerType,
      myOwnerId: controller.myOwnerId,
    );

    final unread = conversation.totalUnread;

    final subtitle = _lastMessageText(conversation.lastMessage);

    return InkWell(
      onTap: () async {
        await controller.openConversation(conversation);
        // ignore: use_build_context_synchronously
        Get.to(() => ChatDetailPage(conversation: conversation));
      },
      onLongPress: () => _openActions(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            _Avatar(url: avatarUrl, isGroup: conversation.type == 'group'),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (unread > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text('$unread', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _lastMessageText(dynamic lastMessage) {
    if (lastMessage == null) return '';
    if (lastMessage is String) return lastMessage;
    if (lastMessage is Map) {
      if (lastMessage['body'] != null) return lastMessage['body'].toString();
      if (lastMessage['message'] != null) return lastMessage['message'].toString();
    }
    return lastMessage.toString();
  }

  void _openActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('حذف المحادثة'),
              onTap: () async {
                Navigator.pop(context);
                await controller.deleteConversation(conversation.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? url;
  final bool isGroup;
  const _Avatar({this.url, required this.isGroup});

  @override
  Widget build(BuildContext context) {
    final placeholder = CircleAvatar(
      radius: 22,
      child: Icon(isGroup ? Icons.groups : Icons.person),
    );

    if (url == null || url!.trim().isEmpty) return placeholder;

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url!,
        width: 44,
        height: 44,
        fit: BoxFit.cover,
        placeholder: (_, __) => placeholder,
        errorWidget: (_, __, ___) => placeholder,
      ),
    );
  }
}

class _NewChatSheet extends StatefulWidget {
  final ChatController controller;
  const _NewChatSheet({required this.controller});

  @override
  State<_NewChatSheet> createState() => _NewChatSheetState();
}

class _NewChatSheetState extends State<_NewChatSheet> {
  final TextEditingController _q = TextEditingController();

  @override
  void dispose() {
    _q.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final raw = widget.controller.previousParticipants.toList();

      final query = _q.text.trim().toLowerCase();
      final filtered = query.isEmpty
          ? raw
          : raw.where((e) {
              final pd = (e['participant_data'] is Map) ? Map<String, dynamic>.from(e['participant_data']) : <String, dynamic>{};
              final name = (pd['name'] ?? '').toString().toLowerCase();
              return name.contains(query);
            }).toList();

      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 12,
          right: 12,
          top: 8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _q,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'ابحث عن مستخدم...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
            const SizedBox(height: 10),
            if (filtered.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 18),
                child: Text('لا يوجد مستخدمون'),
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final item = filtered[i];
                    final pd = (item['participant_data'] is Map)
                        ? Map<String, dynamic>.from(item['participant_data'])
                        : <String, dynamic>{};

                    final name = (pd['name'] ?? 'مستخدم').toString();
                    final avatar = pd['avatar']?.toString();
                    final type = pd['type']?.toString();
                    final id = pd['id']?.toString();

                    return ListTile(
                      leading: _Avatar(url: avatar, isGroup: false),
                      title: Text(name),
                      subtitle: Text(type ?? ''),
                      onTap: () async {
                        if (id == null || type == null) return;

                        // create direct conversation
                        final conv = await widget.controller.createConversation(
                          type: 'direct',
                          participants: [
                            {'type': type, 'id': id},
                          ],
                        );

                        if (!mounted) return;
                        if (conv != null) {
                          Navigator.pop(context);
                          await widget.controller.openConversation(conv);
                          Get.to(() => ChatDetailPage(conversation: conv));
                        }
                      },
                    );
                  },
                ),
              ),
            const SizedBox(height: 10),
          ],
        ),
      );
    });
  }
}
