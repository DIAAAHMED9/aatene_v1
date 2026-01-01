enum StoryType { image, video }

class StoryItem {
  final StoryType type;
  final String url;
  final Duration duration;
  final String? text;

  StoryItem({
    required this.type,
    required this.url,
    required this.duration,
    this.text,
  });
}
