import 'dart:io';
import '../../../general_index.dart';

class StoriesController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<StoryItemModel> stories = <StoryItemModel>[].obs;

  Future<void> fetchStories({bool withLoading = false}) async {
    try {
      if (withLoading) isLoading.value = true;
      final items = await StoryApi.fetchStories(withLoading: withLoading);
      stories.assignAll(items);
    } catch (e) {
      if (withLoading) {
        Get.snackbar('خطأ', e.toString());
      }
    } finally {
      if (withLoading) isLoading.value = false;
    }
  }

  /// Convert selected MediaItem to "image" path expected by stories API.
  String extractStoryImagePath(MediaItem item) {
    final fn = (item.fileName ?? '').trim();
    if (fn.isNotEmpty) return fn;

    final p = item.path.trim();
    if (p.isNotEmpty && !p.startsWith('http')) return p;

    final url = (item.fileUrl ?? '').trim();
    if (url.isNotEmpty) {
      final idx = url.indexOf('/images/');
      if (idx != -1) return url.substring(idx + 1);
    }

    if (p.isNotEmpty) {
      final idx = p.indexOf('/images/');
      if (idx != -1) return p.substring(idx + 1);
    }

    return p;
  }

  Future<void> addStoryUsingUploadedMedia({
    required MediaItem mediaItem,
    String? text,
    required Color color,
  }) async {
    try {
      isLoading.value = true;

      final imagePath = extractStoryImagePath(mediaItem);
      if (imagePath.isEmpty) {
        throw Exception('لم يتم العثور على مسار الصورة');
      }

      await StoryApi.createStory(
        imagePath: imagePath,
        text: text,
        colorDecimal: color.value.toString(),
        withLoading: true,
      );

      await fetchStories(withLoading: false);
    } finally {
      isLoading.value = false;
    }
  }

  /// Optional: upload file then create story (if you want direct pick from local).
  Future<void> addStoryWithUpload({
    required File imageFile,
    String? text,
    required Color color,
  }) async {
    try {
      isLoading.value = true;

      final imagePath = await StoryApi.uploadStoryImage(
        file: imageFile,
        withLoading: true,
      );

      await StoryApi.createStory(
        imagePath: imagePath,
        text: text,
        colorDecimal: color.value.toString(),
        withLoading: true,
      );

      await fetchStories(withLoading: false);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addStoriesUsingUploadedMediaBulk({
    required List<MediaItem> mediaItems,
    String? text,
    required Color color,
  }) async {
    if (mediaItems.isEmpty) return;
    try {
      isLoading.value = true;

      // Create stories sequentially to avoid server overload.
      for (final item in mediaItems) {
        final imagePath = extractStoryImagePath(item);
        if (imagePath.isEmpty) continue;

        await StoryApi.createStory(
          imagePath: imagePath,
          text: text,
          colorDecimal: color.value.toString(),
          withLoading: false,
        );
      }

      // Refresh list and notify listeners immediately.
      await fetchStories(withLoading: false);
      stories.refresh();
    } finally {
      isLoading.value = false;
    }
  }
}
