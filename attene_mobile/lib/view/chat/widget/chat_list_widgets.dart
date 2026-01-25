import 'package:cached_network_image/cached_network_image.dart';

import '../../../general_index.dart';

class TabsRow extends StatelessWidget {
  final ChatController controller;

  const TabsRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final tab = controller.currentTab.value;
      Widget chip(String label, ChatTab t) {
        final selected = tab == t;
        return ChoiceChip(
          label: Text(
            label,
            style: TextStyle(
              color: selected
                  ? AppColors.backgroundColor
                  : AppColors.primary400,
            ),
          ),
          selected: selected,
          onSelected: (_) => controller.setTab(t),
          selectedColor: AppColors.primary400,
          backgroundColor: AppColors.backgroundColor,
        );
      }

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            chip('الكل', ChatTab.all),
            const SizedBox(width: 8),
            chip('غير مقروء', ChatTab.unread),
            // const SizedBox(width: 8),
            // chip('نشط', ChatTab.active),
            // const SizedBox(width: 8),
            // chip('غير نشط', ChatTab.notActive),
            const SizedBox(width: 8),
            chip('مهتم', ChatTab.interested),
            const SizedBox(width: 8),

            chip('المجموعات', ChatTab.groub),
          ],
        ),
      );
    });
  }
}

class ConversationCard extends StatelessWidget {
  final ChatConversation conversation;
  final ChatController controller;

  const ConversationCard({
    required this.conversation,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final title = conversation.displayName(
      myOwnerType: controller.myOwnerType,
      myOwnerId: controller.myOwnerId,
    );

    final subtitle = _lastMessageText(conversation.lastMessage);
    final unread = conversation.totalUnread;
    final time = _bestTimeLabel(conversation);

    final isGroup = conversation.type == 'group';
    final participantsCount = conversation.participantsCount ?? 0;

    return Material(
      color: cs.surface,
      elevation: 0,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () async {
          await controller.openConversation(conversation);
          Get.to(() => ChatDetailPage(conversation: conversation));
        },
        onLongPress: () => _openActions(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary400.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              ConversationAvatar(
                conversation: conversation,
                controller: controller,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getBold(),
                          ),
                        ),
                        if (time.isNotEmpty)
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            subtitle.isEmpty
                                ? (isGroup ? 'مجموعة' : 'محادثة')
                                : subtitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: cs.onSurfaceVariant),
                          ),
                        ),
                        if (isGroup && participantsCount > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: cs.surfaceContainerHighest.withOpacity(
                                0.6,
                              ),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '$participantsCount',
                              style: TextStyle(
                                fontSize: 12,
                                color: cs.onSurfaceVariant,
                              ),
                            ),
                          ),
                        if (unread > 0) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: cs.primary,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              '$unread',
                              style: TextStyle(
                                color: cs.onPrimary,
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              leading: const Icon(Icons.delete_outline_rounded),
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

  String _lastMessageText(dynamic lastMessage) {
    if (lastMessage == null) return '';
    if (lastMessage is String) return lastMessage;
    if (lastMessage is Map) {
      if (lastMessage['body'] != null) return lastMessage['body'].toString();
      if (lastMessage['message'] != null)
        return lastMessage['message'].toString();
      if (lastMessage['text'] != null) return lastMessage['text'].toString();
    }
    return lastMessage.toString();
  }

  String _bestTimeLabel(ChatConversation c) {
    try {
      DateTime? dt;
      final lm = c.lastMessage;
      if (lm is Map && lm['created_at'] != null) {
        dt = DateTime.tryParse(lm['created_at'].toString());
      }
      dt ??= DateTime.tryParse(c.updatedAt ?? c.createdAt ?? '');
      if (dt == null) return '';

      final now = DateTime.now();
      final local = dt.toLocal();
      final sameDay =
          now.year == local.year &&
          now.month == local.month &&
          now.day == local.day;
      if (sameDay) {
        final hh = local.hour.toString().padLeft(2, '0');
        final mm = local.minute.toString().padLeft(2, '0');
        return '$hh:$mm';
      }
      final d = local.day.toString().padLeft(2, '0');
      final m = local.month.toString().padLeft(2, '0');
      return '$d/$m';
    } catch (_) {
      return '';
    }
  }
}

class ConversationAvatar extends StatelessWidget {
  final ChatConversation conversation;
  final ChatController controller;

  const ConversationAvatar({
    required this.conversation,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isGroup = conversation.type == 'group';

    final mainUrl = conversation.displayAvatar(
      myOwnerType: controller.myOwnerType,
      myOwnerId: controller.myOwnerId,
    );

    if (!isGroup) {
      return Avatar(url: mainUrl, isGroup: false, radius: 24);
    }

    final urls = <String>[];
    try {
      for (final p in conversation.participants) {
        final pd = p.participantData;
        final pid = pd?.id?.toString();
        final ptype = pd?.type?.toString();
        if (pid == null || ptype == null) continue;
        if (pid == controller.myOwnerId && ptype == controller.myOwnerType)
          continue;
        final a = pd?.avatar;
        if (a != null && a.toString().trim().isNotEmpty) urls.add(a.toString());
        if (urls.length >= 2) break;
      }
    } catch (_) {}

    if (urls.length < 2) {
      return Avatar(url: mainUrl, isGroup: true, radius: 24);
    }

    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 6,
            child: Avatar(url: urls[0], isGroup: false, radius: 18),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Avatar(url: urls[1], isGroup: false, radius: 18),
          ),
        ],
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final VoidCallback onNewChat;

  const EmptyState({required this.onNewChat});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          spacing: 10,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              "assets/images/svg_images/no_massege.svg",
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
            const Text(
              'لا توجد رسائل',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
            Text(
              'ابدأ محادثة فردية أو أنشئ مجموعة جديدة.',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
            // SizedBox(
            //   width: 170,
            //   child: AateneButton(
            //     onTap: onNewChat,
            //     buttonText: "إنشاء محادثة",
            //     color: AppColors.primary400,
            //     borderColor: AppColors.primary400,
            //     textColor: AppColors.light1000,
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

class Avatar extends StatelessWidget {
  final String? url;
  final bool isGroup;
  final double radius;

  const Avatar({this.url, required this.isGroup, this.radius = 22});

  @override
  Widget build(BuildContext context) {
    final placeholder = CircleAvatar(
      radius: radius,
      child: Icon(isGroup ? Icons.groups : Icons.person),
    );

    if (url == null || url!.trim().isEmpty) return placeholder;

    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url!,
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        placeholder: (_, __) => placeholder,
        errorWidget: (_, __, ___) => placeholder,
      ),
    );
  }
}

class NewChatSheet extends StatefulWidget {
  final ChatController controller;

  const NewChatSheet({required this.controller});

  @override
  State<NewChatSheet> createState() => NewChatSheetState();
}

class NewChatSheetState extends State<NewChatSheet> {
  final TextEditingController _q = TextEditingController();
  final TextEditingController _groupName = TextEditingController();

  int _mode = 0;
  final Set<String> _selected = <String>{};

  @override
  void dispose() {
    _q.dispose();
    _groupName.dispose();
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
              final pd = (e['participant_data'] is Map)
                  ? Map<String, dynamic>.from(e['participant_data'])
                  : <String, dynamic>{};
              final name = (pd['name'] ?? '').toString().toLowerCase();
              final type = (pd['type'] ?? '').toString().toLowerCase();
              return name.contains(query) || type.contains(query);
            }).toList();

      final cs = Theme.of(context).colorScheme;
      final canCreateGroup =
          _groupName.text.trim().isNotEmpty && _selected.isNotEmpty;

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
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: cs.surfaceContainerHighest.withOpacity(0.55),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ModeButton(
                      selected: _mode == 0,
                      label: 'فردية',
                      icon: Icons.person_rounded,
                      onTap: () => setState(() => _mode = 0),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: ModeButton(
                      selected: _mode == 1,
                      label: 'مجموعة',
                      icon: Icons.groups_rounded,
                      onTap: () => setState(() => _mode = 1),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            if (_mode == 1) ...[
              TextField(
                controller: _groupName,
                onChanged: (_) => setState(() {}),
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'اسم المجموعة (مطلوب)',
                  prefixIcon: const Icon(
                    Icons.drive_file_rename_outline_rounded,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],

            TextField(
              controller: _q,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: _mode == 0
                    ? 'ابحث عن مستخدم...'
                    : 'ابحث واختر أعضاء...',
                prefixIcon: const Icon(Icons.search_rounded),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
              ),
            ),

            if (_mode == 1) ...[
              const SizedBox(height: 8),
              Row(
                spacing: 20,
                children: [
                  Expanded(
                    child: Text(
                      'تم اختيار ${_selected.length} عضو',
                      style: TextStyle(color: cs.onSurfaceVariant),
                    ),
                  ),

                  Expanded(
                    child: AateneButton(
                      onTap: canCreateGroup
                          ? () async {
                              final parts = _selected.map((k) {
                                final sp = k.split(':');
                                return {'type': sp[0], 'id': sp[1]};
                              }).toList();

                              final conv = await widget.controller
                                  .createConversation(
                                    type: 'group',
                                    name: _groupName.text.trim(),
                                    participants: parts,
                                  );

                              if (!mounted) return;
                              if (conv != null) {
                                Navigator.pop(context);
                                await widget.controller.openConversation(conv);
                                Get.to(
                                  () => ChatDetailPage(conversation: conv),
                                );
                              }
                            }
                          : null,
                      buttonText: "إنشاء",
                      color: AppColors.primary400,
                      borderColor: AppColors.primary400,
                      textColor: AppColors.light1000,
                    ),
                  ),
                ],
              ),
            ],

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

                    if (id == null || type == null) {
                      return ListTile(
                        leading: Avatar(url: avatar, isGroup: false),
                        title: Text(name),
                        subtitle: Text(type ?? ''),
                      );
                    }

                    final key = '$type:$id';

                    if (_mode == 0) {
                      return ListTile(
                        leading: Avatar(url: avatar, isGroup: false),
                        title: Text(name),
                        subtitle: Text(type),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () async {
                          final conv = await widget.controller
                              .createConversation(
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
                    }

                    final selected = _selected.contains(key);
                    return CheckboxListTile(
                      value: selected,
                      onChanged: (v) {
                        setState(() {
                          if (v == true) {
                            _selected.add(key);
                          } else {
                            _selected.remove(key);
                          }
                        });
                      },
                      secondary: Avatar(url: avatar, isGroup: false),
                      title: Text(name),
                      subtitle: Text(type),
                      controlAffinity: ListTileControlAffinity.trailing,
                    );
                  },
                ),
              ),

            const SizedBox(height: 12),
          ],
        ),
      );
    });
  }
}

class ModeButton extends StatelessWidget {
  final bool selected;
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const ModeButton({
    required this.selected,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: selected ? AppColors.primary400 :AppColors.primary50,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected ?AppColors.primary400 : cs.onSurfaceVariant,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: selected ? cs.onPrimary : cs.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
