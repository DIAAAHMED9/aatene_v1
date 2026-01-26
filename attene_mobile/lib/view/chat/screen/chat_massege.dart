
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:attene_mobile/utils/platform/xfile_fs.dart';

import '../../../general_index.dart' hide ChatController;
import '../index.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';

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
  final List<XFile> _pendingFiles = [];

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
      // listen to blockedVersion so UI updates immediately after block/unblock
      c.blockedVersion.value;
      final isBlocked = c.isConversationBlocked(conv);

      return Scaffold(
        appBar: AppBar(
          elevation: 3,
          title: Text(title),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: _openConversationActions,
            ),
          ],
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Colors.grey[100],
              ),
              child: Icon(Icons.arrow_back, color: AppColors.neutral100),
            ),
          ),
        ),
        body: Column(
          children: [
            if (isBlocked)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                color: Colors.red.withOpacity(0.07),
                child: Row(
                  children: const [
                    Icon(Icons.block, size: 18, color: AppColors.primary400),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'هذا المستخدم محظور — لن تتمكن من إرسال رسائل.',
                      ),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: Obx(() {
                if (c.isLoadingMessages.value && c.currentMessages.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                final msgs = c.currentMessages;

                return ListView.builder(
                  controller: _scroll,
                  reverse: true,
                  // newest at bottom (like WhatsApp)
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 12,
                  ),
                  itemCount: msgs.length,
                  itemBuilder: (context, index) {
                    final m =
                        msgs[msgs.length - 1 - index]; // because reverse:true
                    final isMe = _isMe(m);
                    return MessageBubble(
                      message: m,
                      isMe: isMe,
                      isGroup: widget.conversation.type == 'group',
                    );
                  },
                );
              }),
            ),

            if (_pendingFiles.isNotEmpty)
              PendingAttachmentsBar(
                files: _pendingFiles,
                onRemove: (i) => setState(() => _pendingFiles.removeAt(i)),
              ),

            Composer(
              textController: _text,
              isRecording: _isRecording,
              recordDuration: _recordDuration,
              onPickImages: _pickImages,
              onPickFiles: _pickFiles,
              onSend: _send,
              onStartRecord: _startRecording,
              onStopRecord: _stopRecordingAndSend,
              onCancelRecord: _cancelRecording,
              isBlocked: isBlocked,
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
    final blocked =
        isDirect &&
        other != null &&
        c.isBlockedEntity(type: other['type']!, id: other['id']!);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isDirect && other != null)
              ListTile(
                leading: Icon(
                  blocked ? Icons.lock_open : Icons.block,
                  color: AppColors.primary400,
                ),
                title: Text(blocked ? 'إلغاء الحظر' : 'حظر المستخدم'),
                onTap: () async {
                  Navigator.pop(context);
                  if (!blocked) {
                    final reason = await _askReason(
                      title: 'سبب الحظر (اختياري)',
                    );
                    await c.blockEntity(
                      blockedType: other['type']!,
                      blockedId: other['id']!,
                      reason: reason,
                    );
                  } else {
                    await c.unBlockEntity(
                      blockedType: other['type']!,
                      blockedId: other['id']!,
                    );
                  }
                  if (mounted) setState(() {});
                },
              ),
            if (isDirect && other != null)
              ListTile(
                leading: Icon(
                  Icons.report_gmailerrorred_outlined,
                  color: AppColors.primary400,
                ),
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
              leading: Icon(Icons.person_add_alt, color: AppColors.primary400),
              title: const Text('إضافة مستخدم للمحادثة'),
              onTap: () {
                Navigator.pop(context);
                _openAddParticipantSheet();
              },
            ),
            if ((widget.conversation.type ?? '').toLowerCase() == 'group')
              ListTile(
                leading: const Icon(Icons.edit, color: AppColors.primary400),
                title: const Text('تعديل اسم المجموعة'),
                onTap: () {
                  Navigator.pop(context);
                  _renameGroup();
                },
              ),
            ListTile(
              leading: const Icon(
                Icons.delete_outline,
                color: AppColors.primary400,
              ),
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
      builder: (_) =>
          AddParticipantSheet(conversation: widget.conversation, controller: c),
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
          AateneButton(
            onTap: () => Navigator.pop(context, tc.text.trim()),
            buttonText: "حفظ",
            color: AppColors.primary400,
            textColor: AppColors.light1000,
            borderColor: AppColors.primary400,
          ),
          SizedBox(height: 10),
          AateneButton(
            onTap: () => Navigator.pop(context),
            buttonText: "إلغاء",
            color: AppColors.light1000,
            textColor: AppColors.primary400,
            borderColor: AppColors.primary400,
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
          AateneButton(
            onTap: () => Navigator.pop(context, tc.text.trim()),
            buttonText: "تم",
            color: AppColors.primary400,
            textColor: AppColors.light1000,
            borderColor: AppColors.primary400,
          ),
          SizedBox(height: 10),
          AateneButton(
            onTap: () => Navigator.pop(context),
            buttonText: "إلغاء",
            color: AppColors.light1000,
            textColor: AppColors.primary400,
            borderColor: AppColors.primary400,
          ),
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

    // max 10 images total in selection
    final toAdd = paths
        .take(10 - _pendingFiles.length)
        .map((p) => XFile(p))
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

    // max 10 files at once
    final toAdd = paths
        .take(10 - _pendingFiles.length)
        .map((p) => XFile(p))
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
      final files = List<XFile>.from(_pendingFiles);
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

    if (kIsWeb) {
      Get.snackbar('تنبيه', 'حفظ الملفات غير مدعوم على الويب حالياً');
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
        final f = XFile(p);
        if (await xfileExists(f)) {
          await xfileDelete(f);
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

      final f = XFile(path);
      if (!await xfileExists(f)) return;

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