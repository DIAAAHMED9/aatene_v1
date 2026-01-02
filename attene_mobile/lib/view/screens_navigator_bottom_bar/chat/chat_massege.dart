
// lib/view/screens_navigator_bottom_bar/chat/chat_massege.dart
import 'dart:async';
import 'dart:io';

import 'package:attene_mobile/controller/chat_controller.dart';
import 'package:attene_mobile/models/chat_models.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';

import '../../../component/text/aatene_custom_text.dart';
import 'chat_message_model.dart';

class ChatMassege extends StatefulWidget {
  final ChatConversation conversation;

  const ChatMassege({super.key, required this.conversation});

  @override
  State<ChatMassege> createState() => _ChatMassegeState();
}

class _ChatMassegeState extends State<ChatMassege> {
  final ChatController c = Get.find<ChatController>();

  final TextEditingController _text = TextEditingController();
  final ScrollController _scroll = ScrollController();

  // Attachments (local) before sending
  final List<File> _pendingFiles = [];

  // Audio recording
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  Duration _recordDuration = Duration.zero;
  Timer? _recordTimer;
  String? _recordPath;

  @override
  void initState() {
    super.initState();
    c.openConversation(widget.conversation);
    ever<List<ChatMessage>>(c.currentMessages, (_) => _scrollToBottomSoon());
  }

  @override
  void dispose() {
    _text.dispose();
    _scroll.dispose();
    _recordTimer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  void _scrollToBottomSoon() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scroll.hasClients) return;
      _scroll.animateTo(
        0, // because reverse: true
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  bool _isMe(ChatMessage m) {
    // best effort: senderData.type/id matches myOwnerType/myOwnerId OR senderId matches my participant record id
    final conv = widget.conversation;
    final myOwnerType = c.myOwnerType;
    final myOwnerId = c.myOwnerId;

    if (m.senderData != null &&
        myOwnerType != null &&
        myOwnerId != null &&
        m.senderData!.type == myOwnerType &&
        m.senderData!.id == myOwnerId) {
      return true;
    }

    // if senderId equals participant record id of "me"
    ChatParticipant? myParticipant;
    for (final p in conv.participants) {
      final d = p.participantData;
      if (d == null || myOwnerType == null || myOwnerId == null) continue;
      if (d.type == myOwnerType && d.id == myOwnerId) {
        myParticipant = p;
        break;
      }
    }
    if (myParticipant != null && m.senderId != null) {
      return m.senderId == myParticipant.id.toString();
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final conv = (c.currentConversation.value?.id == widget.conversation.id)
          ? c.currentConversation.value!
          : widget.conversation;
      final title = conv.displayName(
        myOwnerType: c.myOwnerType,
        myOwnerId: c.myOwnerId,
      );

      return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _openConversationActions,
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (c.isLoadingMessages.value && c.currentMessages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                final msgs = c.currentMessages;

                return ListView.builder(
                  controller: _scroll,
                  reverse: true,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    final m = msgs[msgs.length - 1 - index];
                    final isMe = _isMe(m);
                    return _MessageBubble(
                      message: m,
                      isMe: isMe,
                      isGroup: widget.conversation.type == 'group',
                    );
                  },
                );
              }),
            ),

            if (_pendingFiles.isNotEmpty)
              _PendingAttachmentsBar(
                files: _pendingFiles,
                onRemove: (i) => setState(() => _pendingFiles.removeAt(i)),
              ),

          _Composer(
            textController: _text,
            isRecording: _isRecording,
            recordDuration: _recordDuration,
            onPickImages: _pickImages,
            onPickFiles: _pickFiles,
            onSend: _send,
            onStartRecord: _startRecording,
            onStopRecord: _stopRecordingAndSend,
            onCancelRecord: _cancelRecording,
            isBlocked: true,
          ),
        ],
      ),
    );
    });
  }

  Future<void> _openConversationActions() async {
    final conv = c.currentConversation.value ?? widget.conversation;
    final other = c.otherSideOfDirect(conv);
    final isDirect = (conv.type ?? '').toLowerCase() == 'direct';
    final blocked = isDirect && other != null && c.isBlockedEntity(type: other['type']!, id: other['id']!);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDirect && other != null)
              ListTile(
                leading: Icon(blocked ? Icons.lock_open : Icons.block),
                title: Text(blocked ? 'إلغاء الحظر' : 'حظر المستخدم'),
                onTap: () async {
                  Navigator.pop(context);
                  if (!blocked) {
                    final reason = await _askReason(title: 'سبب الحظر (اختياري)');
                    await c.blockEntity(blockedType: other['type']!, blockedId: other['id']!, reason: reason);
                  } else {
                    await c.unBlockEntity(blockedType: other['type']!, blockedId: other['id']!);
                  }
                  if (mounted) setState(() {});
                },
              ),
            if (isDirect && other != null)
              ListTile(
                leading: const Icon(Icons.report_gmailerrorred_outlined),
                title: const Text('إبلاغ'),
                onTap: () async {
                  Navigator.pop(context);
                  final reason = await _askReason(title: 'اكتب سبب البلاغ');
                  if (reason == null || reason.trim().isEmpty) return;
                  // ⚠️ لم يتم تزويدنا بـ API منفصل للبلاغ، لذلك نعرض إشعار فقط.
                  if (mounted) {
                    Get.snackbar('تم', 'تم استلام البلاغ');
                  }
                },
              ),
            ListTile(
              leading: const Icon(Icons.person_add_alt),
              title: const Text('إضافة مستخدم للمحادثة'),
              onTap: () {
                Navigator.pop(context);
                _openAddParticipantSheet();
              },
            ),
            if ((widget.conversation.type ?? '').toLowerCase() == 'group')
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('تعديل اسم المجموعة'),
                onTap: () {
                  Navigator.pop(context);
                  _renameGroup();
                },
              ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('حذف المحادثة'),
              onTap: () async {
                Navigator.pop(context);
                final ok = await c.deleteConversation(widget.conversation.id);
                if (ok && mounted) Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openAddParticipantSheet() async {
    await c.loadPreviousParticipants();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => _AddParticipantSheet(
        conversation: widget.conversation,
        controller: c,
      ),
    );
  }

  Future<void> _renameGroup() async {
    final tc = TextEditingController(
      text:
          (c.currentConversation.value?.name ?? widget.conversation.name) ?? '',
    );
    final newName = await showDialog<String?>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تعديل اسم المجموعة'),
        content: TextField(
          controller: tc,
          decoration: const InputDecoration(hintText: 'اسم المجموعة'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, tc.text.trim()),
            child: const Text('حفظ'),
          ),
        ],
      ),
    );

    if (newName == null || newName.isEmpty) return;

    final ok = await c.updateGroupName(
      conversationId: widget.conversation.id,
      name: newName,
    );
    if (ok) {
      // ✅ reflect immediately in AppBar + screen
      if (mounted) setState(() {});
    }
  }

  Future<String?> _askReason({required String title}) async {
    final tc = TextEditingController();
    final res = await showDialog<String?>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: tc,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'اكتب هنا...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () => Navigator.pop(context, tc.text.trim()), child: const Text('تم')),
        ],
      ),
    );
    return res;
  }


  Future<void> _pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (result == null) return;
    final paths = result.paths.whereType<String>().toList();
    if (paths.isEmpty) return;

    final toAdd = paths
        .take(10 - _pendingFiles.length)
        .map((p) => File(p))
        .toList();
    setState(() => _pendingFiles.addAll(toAdd));
  }

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.any,
    );
    if (result == null) return;
    final paths = result.paths.whereType<String>().toList();
    if (paths.isEmpty) return;

    final toAdd = paths
        .take(10 - _pendingFiles.length)
        .map((p) => File(p))
        .toList();
    setState(() => _pendingFiles.addAll(toAdd));
  }

  Future<void> _send() async {
    final text = _text.text.trim();
    final hasFiles = _pendingFiles.isNotEmpty;

    if (text.isEmpty && !hasFiles) return;

    final convId = widget.conversation.id;

    // Send files first (if any) with optional text
    if (hasFiles) {
      final files = List<File>.from(_pendingFiles);
      setState(() => _pendingFiles.clear());
      await c.sendFilesMessage(
        conversationId: convId,
        files: files,
        text: text.isEmpty ? null : text,
      );
      _text.clear();
      return;
    }

    await c.sendTextMessage(conversationId: convId, text: text);
    _text.clear();
  }

  Future<void> _startRecording() async {
    try {
      final hasPerm = await _recorder.hasPermission();
      if (!hasPerm) {
        if (mounted) Get.snackbar('الصوت', 'يرجى السماح بالمايكروفون');
        return;
      }

      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/voice_${DateTime.now().millisecondsSinceEpoch}.mp3';
      _recordPath = path;

      await _recorder.start(
        RecordConfig(
          encoder: AudioEncoder.wav,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: path,
      );

      _recordDuration = Duration.zero;
      _recordTimer?.cancel();
      _recordTimer = Timer.periodic(const Duration(milliseconds: 250), (_) {
        setState(() => _recordDuration += const Duration(milliseconds: 250));
      });

      setState(() => _isRecording = true);
    } catch (e) {
      // ignore: avoid_print
      print('❌ startRecording: $e');
    }
  }

  Future<void> _cancelRecording() async {
    try {
      _recordTimer?.cancel();
      _recordTimer = null;

      if (_isRecording) {
        await _recorder.stop();
      }

      // delete file if exists
      final p = _recordPath;
      if (p != null) {
        final f = File(p);
        if (await f.exists()) {
          await f.delete();
        }
      }
    } catch (_) {}
    setState(() {
      _isRecording = false;
      _recordDuration = Duration.zero;
      _recordPath = null;
    });
  }

  Future<void> _stopRecordingAndSend() async {
    try {
      _recordTimer?.cancel();
      _recordTimer = null;

      if (!_isRecording) return;

      final path = await _recorder.stop();
      setState(() => _isRecording = false);

      if (path == null) return;

      final f = File(path);
      if (!await f.exists()) return;

      await c.sendFilesMessage(
        conversationId: widget.conversation.id,
        files: [f],
        text: null,
      );
    } catch (e) {
      // ignore: avoid_print
      print('❌ stopRecordingAndSend: $e');
    } finally {
      setState(() {
        _recordDuration = Duration.zero;
        _recordPath = null;
      });
    }
  }
}

class _PendingAttachmentsBar extends StatelessWidget {
  final List<File> files;
  final void Function(int index) onRemove;

  const _PendingAttachmentsBar({required this.files, required this.onRemove});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: SizedBox(
        height: 76,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: files.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            final f = files[i];
            final isImage = _isImagePath(f.path);
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 76,
                    height: 76,
                    color: Colors.white,
                    child: isImage
                        ? Image.file(f, fit: BoxFit.cover)
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                _fileName(f.path),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: getRegular(fontSize: 11),
                              ),
                            ),
                          ),
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Material(
                    color: Colors.black54,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: () => onRemove(i),
                      child: const SizedBox(
                        width: 22,
                        height: 22,
                        child: Icon(Icons.close, size: 14, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _Composer extends StatelessWidget {
  final TextEditingController textController;
  final VoidCallback onPickImages;
  final VoidCallback onPickFiles;
  final Future<void> Function() onSend;

  final bool isBlocked;

  final bool isRecording;
  final Duration recordDuration;
  final Future<void> Function() onStartRecord;
  final Future<void> Function() onStopRecord;
  final Future<void> Function() onCancelRecord;

  const _Composer({
    required this.textController,
    required this.onPickImages,
    required this.onPickFiles,
    required this.onSend,
    required this.isBlocked,
    required this.isRecording,
    required this.recordDuration,
    required this.onStartRecord,
    required this.onStopRecord,
    required this.onCancelRecord,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade300)),
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.image_outlined),
              onPressed: isBlocked ? null : onPickImages,
            ),
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: isBlocked ? null : onPickFiles,
            ),
            Expanded(
              child: isRecording
                  ? _RecordingBar(
                      duration: recordDuration,
                      onCancel: onCancelRecord,
                    )
                  : TextField(
                      controller: textController,
                      enabled: !isBlocked,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالة...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 6),
            if (!isRecording)
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: isBlocked ? null : () => onSend(),
              ),
            GestureDetector(
              onLongPressStart: isBlocked ? null : (_) => onStartRecord(),
              onLongPressEnd: isBlocked ? null : (_) => onStopRecord(),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  Icons.mic,
                  color: isRecording
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecordingBar extends StatefulWidget {
  final Duration duration;
  final Future<void> Function() onCancel;

  const _RecordingBar({required this.duration, required this.onCancel});

  @override
  State<_RecordingBar> createState() => _RecordingBarState();
}

class _RecordingBarState extends State<_RecordingBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _a = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _a.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = _fmt(widget.duration);
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.fiber_manual_record, color: Colors.red, size: 16),
          const SizedBox(width: 8),
          Text(t, style: getMedium()),
          const SizedBox(width: 10),
          Expanded(child: _FakeWaves(animation: _a)),
          IconButton(
            onPressed: () => widget.onCancel(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  String _fmt(Duration d) {
    final s = d.inSeconds;
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}

class _FakeWaves extends AnimatedWidget {
  const _FakeWaves({required Animation<double> animation})
    : super(listenable: animation);

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final v = animation.value;
    // 12 bars
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(12, (i) {
        final h = (8 + ((i % 4) * 6)) * (0.6 + v * 0.4);
        return Container(
          width: 3,
          height: h,
          decoration: BoxDecoration(
            color: Colors.grey.shade700,
            borderRadius: BorderRadius.circular(99),
          ),
        );
      }),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final bool isGroup;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.isGroup,
  });

  @override
  Widget build(BuildContext context) {
    final urls = message.attachmentUrls;
    final hasAttachments = urls.isNotEmpty;
    final text = (message.body ?? '').trim();

    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final bubbleColor = isMe
        ? Theme.of(context).colorScheme.primary.withOpacity(0.14)
        : Colors.grey.shade200;

    final created = DateTime.tryParse(message.createdAt ?? '');
    final timeText = created == null ? '' : _formatArabicTime(created);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        children: [
          if (!isMe && isGroup) ...[
            _SenderAvatar(url: message.senderData?.avatar),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: align,
              children: [
                if (!isMe &&
                    isGroup &&
                    (message.senderData?.name?.trim().isNotEmpty ?? false))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      message.senderData!.name!,
                      style: getMedium(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.78,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: bubbleColor,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(isMe ? 16 : 4),
                        bottomRight: Radius.circular(isMe ? 4 : 16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (hasAttachments) _AttachmentsGrid(urls: urls),
                        if (hasAttachments && text.isNotEmpty)
                          const SizedBox(height: 8),
                        if (text.isNotEmpty) Text(text),
                        if (!hasAttachments && _looksLikeAudio(text, urls))
                          ...[],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                if (timeText.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      timeText,
                      style: getRegular(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SenderAvatar extends StatelessWidget {
  final String? url;

  const _SenderAvatar({this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.trim().isEmpty) {
      return const CircleAvatar(
        radius: 14,
        child: Icon(Icons.person, size: 16),
      );
    }
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url!,
        width: 28,
        height: 28,
        fit: BoxFit.cover,
        placeholder: (_, __) => const CircleAvatar(radius: 14),
        errorWidget: (_, __, ___) =>
            const CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)),
      ),
    );
  }
}

class _AttachmentsGrid extends StatelessWidget {
  final List<String> urls;

  const _AttachmentsGrid({required this.urls});

  @override
  Widget build(BuildContext context) {
    // WhatsApp-like: 1 big, 2 side-by-side, 3/4 grid, >4 grid with "+N"
    final count = urls.length;

    if (count == 1) return _AttachmentTile(url: urls[0], big: true);

    final show = urls.take(10).toList(); // hard cap
    final gridCount = show.length.clamp(2, 4);

    return SizedBox(
      height: gridCount <= 2 ? 140 : 200,
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: show.length > 4 ? 4 : show.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: gridCount <= 2 ? 2 : 2,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        itemBuilder: (context, i) {
          final url = show[i];
          final isLast = (i == 3) && (show.length > 4);
          return Stack(
            children: [
              Positioned.fill(child: _AttachmentTile(url: url)),
              if (isLast)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '+${show.length - 3}',
                        style: getBold(color: Colors.white, fontSize: 22),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  final String url;
  final bool big;

  const _AttachmentTile({required this.url, this.big = false});

  @override
  Widget build(BuildContext context) {
    final isImage = _isImageUrl(url);
    final isAudio = _isAudioUrl(url);

    if (isAudio) {
      return _AudioTile(url: url);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: big ? 220 : null,
        color: Colors.grey.shade200,
        child: isImage
            ? CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                placeholder: (_, __) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image_outlined)),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.insert_drive_file_outlined),
                      const SizedBox(height: 6),
                      Text(
                        url.split('/').last,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class _AudioTile extends StatefulWidget {
  final String url;

  const _AudioTile({required this.url});

  @override
  State<_AudioTile> createState() => _AudioTileState();
}

class _AudioTileState extends State<_AudioTile> {
  final AudioPlayer _player = AudioPlayer();
  StreamSubscription<Duration>? _posSub;
  Duration _pos = Duration.zero;
  Duration _dur = Duration.zero;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      await _player.setUrl(widget.url);
      _dur = _player.duration ?? Duration.zero;

      _posSub = _player.positionStream.listen((p) {
        if (!mounted) return;
        setState(() => _pos = p);
      });

      setState(() => _ready = true);
    } catch (_) {}
  }

  @override
  void dispose() {
    _posSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playing = _player.playing;
    final max = _dur.inMilliseconds == 0 ? 1.0 : _dur.inMilliseconds.toDouble();
    final value = _pos.inMilliseconds.clamp(0, _dur.inMilliseconds).toDouble();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          children: [
            IconButton(
              onPressed: !_ready
                  ? null
                  : () async {
                      if (playing) {
                        await _player.pause();
                      } else {
                        await _player.play();
                      }
                      setState(() {});
                    },
              icon: Icon(
                playing ? Icons.pause_circle_filled : Icons.play_circle_fill,
              ),
            ),
            Expanded(
              child: Slider(
                value: value,
                max: max,
                onChanged: !_ready
                    ? null
                    : (v) => _player.seek(Duration(milliseconds: v.toInt())),
              ),
            ),
            Text(_fmt(_pos), style: getRegular(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  String _fmt(Duration d) {
    final s = d.inSeconds;
    final mm = (s ~/ 60).toString().padLeft(2, '0');
    final ss = (s % 60).toString().padLeft(2, '0');
    return '$mm:$ss';
  }
}

class _AddParticipantSheet extends StatelessWidget {
  final ChatConversation conversation;
  final ChatController controller;

  const _AddParticipantSheet({
    required this.conversation,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final tc = TextEditingController();

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
            controller: tc,
            decoration: const InputDecoration(
              hintText: 'ابحث عن مستخدم...',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (_) => (context as Element).markNeedsBuild(),
          ),
          const SizedBox(height: 10),
          Obx(() {
            final raw = controller.previousParticipants.toList();
            final q = tc.text.trim().toLowerCase();
            final filtered = q.isEmpty
                ? raw
                : raw.where((e) {
                    final pd = (e['participant_data'] is Map)
                        ? Map<String, dynamic>.from(e['participant_data'])
                        : <String, dynamic>{};
                    final name = (pd['name'] ?? '').toString().toLowerCase();
                    return name.contains(q);
                  }).toList();

            return Flexible(
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
                    leading: _SenderAvatar(url: avatar),
                    title: Text(name),
                    subtitle: Text(type ?? ''),
                    onTap: () async {
                      if (id == null || type == null) return;

                      Navigator.pop(context);
                      await controller.addParticipant(
                        conversationId: conversation.id,
                        participant: {'type': type, 'id': id},
                      );
                    },
                  );
                },
              ),
            );
          }),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// ---- helpers ----

bool _isImageUrl(String url) {
  final u = url.toLowerCase();
  return u.endsWith('.png') ||
      u.endsWith('.jpg') ||
      u.endsWith('.jpeg') ||
      u.endsWith('.webp') ||
      u.contains('image');
}

bool _isAudioUrl(String url) {
  final u = url.toLowerCase();
  return u.endsWith('.m4a') ||
      u.endsWith('.aac') ||
      u.endsWith('.mp3') ||
      u.endsWith('.wav') ||
      u.contains('audio');
}

bool _looksLikeAudio(String text, List<String> urls) {
  if (urls.any(_isAudioUrl)) return true;
  return false;
}


String _formatArabicTime(DateTime dt) {
  final local = dt.toLocal();
  int hour = local.hour;
  final minute = local.minute.toString().padLeft(2, '0');

  final isPm = hour >= 12;
  final suffix = isPm ? 'مساءً' : 'صباحًا';

  hour = hour % 12;
  if (hour == 0) hour = 12;

  final hh = hour.toString().padLeft(2, '0');
  return '$hh:$minute $suffix';
}


bool _isImagePath(String path) {
  final p = path.toLowerCase();
  return p.endsWith('.png') ||
      p.endsWith('.jpg') ||
      p.endsWith('.jpeg') ||
      p.endsWith('.webp');
}

String _fileName(String path) => path.split(Platform.pathSeparator).last;
