import 'package:flutter/foundation.dart';

class StoryAnalytics {
  static void opened(int index) {
    debugPrint('Story opened: $index');
  }

  static void completed(int index) {
    debugPrint('Story completed: $index');
  }

  static void paused(int index) {
    debugPrint('Story paused: $index');
  }

  static void resumed(int index) {
    debugPrint('Story resumed: $index');
  }
}
