import 'dart:io';

import '../../general_index.dart';
import '../../view/stories/model/story_item_model.dart';
import '../core/api_helper.dart';

class StoryApi {
  static Future<List<StoryItemModel>> fetchStories({
    bool withLoading = false,
  }) async {
    final res = await ApiHelper.get(
      path: '/merchants/stories',
      withLoading: withLoading,
      shouldShowMessage: false,
    );

    if (res == null || res['status'] != true) {
      throw Exception(res?['message'] ?? 'فشل جلب القصص');
    }

    final List data = (res['data'] is List) ? res['data'] as List : <dynamic>[];
    return data
        .whereType<Map>()
        .map((e) => StoryItemModel.fromApiMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  static Future<StoryItemModel> fetchStory(int id) async {
    final res = await ApiHelper.get(
      path: '/merchants/stories/$id',
      shouldShowMessage: false,
    );

    if (res == null || res['status'] != true) {
      throw Exception(res?['message'] ?? 'فشل جلب القصة');
    }

    final record = (res['record'] is Map)
        ? Map<String, dynamic>.from(res['record'])
        : <String, dynamic>{};
    return StoryItemModel.fromApiMap(record);
  }

  /// Create story.
  /// API expects:
  /// { "image": "images/xxx.png", "text": "...", "color": "5246456" }
  static Future<void> createStory({
    required String imagePath,
    String? text,
    required String colorDecimal,
    bool withLoading = true,
  }) async {
    final res = await ApiHelper.post(
      path: '/merchants/stories',
      body: {
        'image': imagePath,
        'text': text ?? '',
        'color': colorDecimal,
      },
      withLoading: withLoading,
      shouldShowMessage: true,
    );

    if (res == null || res['status'] != true) {
      throw Exception(res?['message'] ?? 'فشل إنشاء القصة');
    }
  }

  static Future<void> updateStory({
    required int id,
    String? imagePath,
    String? text,
    String? colorDecimal,
    bool withLoading = true,
  }) async {
    final body = <String, dynamic>{
      'image': imagePath, // can be null
      'text': text ?? '',
      'color': colorDecimal ?? '',
    };

    final res = await ApiHelper.put(
      path: '/admin/stories/$id',
      body: body,
      withLoading: withLoading,
      shouldShowMessage: true,
    );

    if (res == null || res['status'] != true) {
      throw Exception(res?['message'] ?? 'فشل تحديث القصة');
    }
  }

  static Future<void> deleteStory({
    required int id,
    bool withLoading = true,
  }) async {
    final res = await ApiHelper.delete(
      path: '/merchants/stories/$id',
      withLoading: withLoading,
      shouldShowMessage: true,
    );

    if (res == null || res['status'] != true) {
      throw Exception(res?['message'] ?? 'فشل حذف القصة');
    }
  }

  /// Upload image via existing media library upload flow.
  /// Returns the most suitable path for Story create API (prefer "file_name" like "images/xxx.png").
  static Future<String> uploadStoryImage({
    required File file,
    bool withLoading = true,
  }) async {
    final res = await ApiHelper.uploadMedia(
      file: file,
      type: 'image',
      withLoading: withLoading,
    );

    if (res == null || res['status'] != true) {
      throw Exception(res?['message'] ?? 'فشل رفع الصورة');
    }

    final dynamic data = res['data'] ?? res;
    if (data is Map) {
      final m = Map<String, dynamic>.from(data);
      final fileName = (m['file_name'] ?? '').toString().trim();
      if (fileName.isNotEmpty) return fileName;

      final path = (m['path'] ?? '').toString().trim();
      if (path.isNotEmpty && !path.startsWith('http')) return path;

      final url = (m['url'] ?? m['file_url'] ?? '').toString().trim();
      if (url.isNotEmpty) {
        final idx = url.indexOf('/images/');
        if (idx != -1) return url.substring(idx + 1); // images/xxx.png
      }
    }

    throw Exception('فشل استخراج مسار الصورة بعد الرفع');
  }
}
