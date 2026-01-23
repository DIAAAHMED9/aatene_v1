import '../../../general_index.dart';

class StoryProductPickResult {
  final String productId;

  final String? title;
  final String? imageUrl;

  StoryProductPickResult({
    required this.productId,
    this.title,
    this.imageUrl,
  });
}
