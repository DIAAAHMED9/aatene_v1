import '../models/story_item_model.dart';

class StoryAnalytics {
  static void storyViewed(StoryItem item) {

    print('📊 Story Viewed: ${item.url}');
  }

  static void storyAdded(StoryItem item) {
    print('📊 Story Added: ${item.url}');
  }
}
