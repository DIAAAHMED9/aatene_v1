import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:just_audio/just_audio.dart';

import '../../../general_index.dart';
import '../index.dart' hide ChatController;
import 'package:image_picker/image_picker.dart';
import '../../../utils/platform/local_image.dart';

class PendingAttachmentsBar extends StatelessWidget {
  final List<XFile> files;
  final void Function(int index) onRemove;

  const PendingAttachmentsBar({required this.files, required this.onRemove});

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
                        ? buildLocalImage(f.path, fit: BoxFit.cover)
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                _fileName(f.path),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 11),
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
                      child: const SizedBox(width: 22, height: 22, child: Icon(Icons.close, size: 14, color: Colors.white)),
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

class Composer extends StatelessWidget {
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

  const Composer({
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
                  ? RecordingBar(duration: recordDuration, onCancel: onCancelRecord)
                  : TextField(
                      controller: textController,
                      enabled: !isBlocked,
                      minLines: 1,
                      maxLines: 4,
                      textInputAction: TextInputAction.newline,
                      decoration: InputDecoration(
                        hintText: 'اكتب رسالة...',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                  color: isRecording ? Theme.of(context).colorScheme.primary : Colors.grey.shade800,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RecordingBar extends StatefulWidget {
  final Duration duration;
  final Future<void> Function() onCancel;
  const RecordingBar({required this.duration, required this.onCancel});

  @override
  State<RecordingBar> createState() => RecordingBarState();
}

class RecordingBarState extends State<RecordingBar> with SingleTickerProviderStateMixin {
  late final AnimationController _a = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..repeat(reverse: true);

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
          Text(t, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(width: 10),
          Expanded(child: FakeWaves(animation: _a)),
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

class FakeWaves extends AnimatedWidget {
  const FakeWaves({required Animation<double> animation}) : super(listenable: animation);
  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    final v = animation.value;
    // 12 bars
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(12, (i) {
        final h = (8 + ((i % 4) * 6)) * (0.6 + v * 0.4);
        return Container(width: 3, height: h, decoration: BoxDecoration(color: Colors.grey.shade700, borderRadius: BorderRadius.circular(99)));
      }),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;
  final bool isGroup;

  const MessageBubble({
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
    final bubbleColor = isMe ? Theme.of(context).colorScheme.primary.withOpacity(0.14) : Colors.grey.shade200;

    final created = DateTime.tryParse(message.createdAt ?? '');
    final timeText = created == null ? '' : _formatArabicTime(created);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe && isGroup) ...[
            SenderAvatar(url: message.senderData?.avatar),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: align,
              children: [
                if (!isMe && isGroup && (message.senderData?.name?.trim().isNotEmpty ?? false))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text(
                      message.senderData!.name!,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade700),
                    ),
                  ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
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
                        if (hasAttachments) AttachmentsGrid(urls: urls),
                        if (hasAttachments && text.isNotEmpty) const SizedBox(height: 8),
                        if (text.isNotEmpty) Text(text),
                        if (!hasAttachments && _looksLikeAudio(text, urls)) ...[
                          // if API puts audio as attachment url, handled below
                        ],
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
                      style: TextStyle(
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

class SenderAvatar extends StatelessWidget {
  final String? url;
  const SenderAvatar({this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.trim().isEmpty) {
      return const CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16));
    }
    return ClipOval(
      child: CachedNetworkImage(
        imageUrl: url!,
        width: 28,
        height: 28,
        fit: BoxFit.cover,
        placeholder: (_, __) => const CircleAvatar(radius: 14),
        errorWidget: (_, __, ___) => const CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)),
      ),
    );
  }
}

class AttachmentsGrid extends StatelessWidget {
  final List<String> urls;
  const AttachmentsGrid({required this.urls});

  @override
  Widget build(BuildContext context) {
    // WhatsApp-like: 1 big, 2 side-by-side, 3/4 grid, >4 grid with "+N"
    final count = urls.length;

    if (count == 1) return AttachmentTile(url: urls[0], big: true);

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
              Positioned.fill(child: AttachmentTile(url: url)),
              if (isLast)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black45, borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text(
                        '+${show.length - 3}',
                        style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
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

class AttachmentTile extends StatelessWidget {
  final String url;
  final bool big;
  const AttachmentTile({required this.url, this.big = false});

  @override
  Widget build(BuildContext context) {
    final isImage = _isImageUrl(url);
    final isAudio = _isAudioUrl(url);

    if (isAudio) {
      return AudioTile(url: url);
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
                placeholder: (_, __) => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                errorWidget: (_, __, ___) => const Center(child: Icon(Icons.broken_image_outlined)),
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

class AudioTile extends StatefulWidget {
  final String url;
  const AudioTile({required this.url});

  @override
  State<AudioTile> createState() => AudioTileState();
}

class AudioTileState extends State<AudioTile> {
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
    } catch (_) {
      // ignore
    }
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
              icon: Icon(playing ? Icons.pause_circle_filled : Icons.play_circle_fill),
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
            Text(_fmt(_pos), style: const TextStyle(fontSize: 12)),
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

class AddParticipantSheet extends StatelessWidget {
  final ChatConversation conversation;
  final ChatController controller;
  const AddParticipantSheet({required this.conversation, required this.controller});

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
                    final pd = (e['participant_data'] is Map) ? Map<String, dynamic>.from(e['participant_data']) : <String, dynamic>{};
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
                    leading: SenderAvatar(url: avatar),
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
  return u.endsWith('.png') || u.endsWith('.jpg') || u.endsWith('.jpeg') || u.endsWith('.webp') || u.contains('image');
}

bool _isAudioUrl(String url) {
  final u = url.toLowerCase();
  return u.endsWith('.m4a') || u.endsWith('.aac') || u.endsWith('.mp3') || u.endsWith('.wav') || u.contains('audio');
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
  return p.endsWith('.png') || p.endsWith('.jpg') || p.endsWith('.jpeg') || p.endsWith('.webp');
}

String _fileName(String path) => path.split(RegExp(r'[\\/]')).last;