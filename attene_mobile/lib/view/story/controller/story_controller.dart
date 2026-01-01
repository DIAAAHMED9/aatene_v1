import 'dart:async';
import 'package:get/get.dart';
import '../models/story_item_model.dart';
import 'story_analytics.dart';

class StoryController extends GetxController {
  final stories = <StoryItem>[].obs;
  final currentIndex = 0.obs;
  final progress = 0.0.obs;

  Timer? _timer;

  void setStories(List<StoryItem> items) {
    stories.assignAll(items);
    startCurrent();
  }

  void startCurrent() {
    _timer?.cancel();
    progress.value = 0;

    final story = stories[currentIndex.value];
    StoryAnalytics.storyViewed(story);

    final step = 50;
    final ticks = story.duration.inMilliseconds ~/ step;
    int tick = 0;

    _timer = Timer.periodic(
      Duration(milliseconds: step),
          (_) {
        tick++;
        progress.value = tick / ticks;
        if (tick >= ticks) next();
      },
    );
  }

  void next() {
    _timer?.cancel();

    if (currentIndex.value < stories.length - 1) {
      currentIndex.value++;
    } else {
      // 🔄 LOOP
      currentIndex.value = 0;
    }

    startCurrent();
  }

  void previous() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
      startCurrent();
    }
  }

  void pause() => _timer?.cancel();
}
