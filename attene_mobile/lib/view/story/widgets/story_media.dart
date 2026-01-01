import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:video_player/video_player.dart';

import '../models/story_item_model.dart';

class StoryMedia extends StatefulWidget {
  final StoryItem item;
  const StoryMedia({super.key, required this.item});

  @override
  State<StoryMedia> createState() => _StoryMediaState();
}

class _StoryMediaState extends State<StoryMedia> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    if (widget.item.type == StoryType.video) {
      _controller = VideoPlayerController.network(widget.item.url)
        ..initialize().then((_) {
          _controller!.play();
          setState(() {});
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item.type == StoryType.image) {
      return CachedNetworkImage(
        imageUrl: widget.item.url,
        fit: BoxFit.cover,
        placeholder: (_, __) =>
        const Center(child: CircularProgressIndicator()),
        errorWidget: (_, __, ___) => const Icon(Icons.error),
      );
    }

    if (_controller?.value.isInitialized ?? false) {
      return VideoPlayer(_controller!);
    }

    return const Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
