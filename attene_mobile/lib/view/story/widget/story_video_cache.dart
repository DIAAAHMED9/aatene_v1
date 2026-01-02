import 'package:video_player/video_player.dart';

class StoryVideoCache {
  static final Map<String, VideoPlayerController> _cache = {};

  static Future<VideoPlayerController> load(String url) async {
    if (_cache.containsKey(url)) {
      return _cache[url]!;
    }

    final controller = VideoPlayerController.network(url);
    await controller.initialize();
    _cache[url] = controller;
    return controller;
  }

  static void disposeAll() {
    for (final controller in _cache.values) {
      controller.dispose();
    }
    _cache.clear();
  }
}