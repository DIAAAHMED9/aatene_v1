import 'dart:convert';

import '../../../api/core/api_helper.dart';

/// Merchant Stories API wrapper.
///
/// Uses [ApiHelper] so headers (token/storeId/lang) are added automatically.
class MerchantStoriesApi {
  static const String _base = '/merchants/stories';

  static Future<List<MerchantStoryModel>> fetchAll({
    bool withLoading = false,
  }) async {
    final res = await ApiHelper.get(
      path: _base,
      withLoading: withLoading,
      shouldShowMessage: false,
    );

    if (res is Map && res['data'] is List) {
      return (res['data'] as List)
          .whereType<Map>()
          .map((e) => MerchantStoryModel.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }

    // Some backends wrap list in {data:{data:[...]}}
    if (res is Map && res['data'] is Map) {
      final inner = res['data'];
      if (inner is Map && inner['data'] is List) {
        return (inner['data'] as List)
            .whereType<Map>()
            .map((e) => MerchantStoryModel.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      }
    }

    return <MerchantStoryModel>[];
  }

  static Future<MerchantStoryModel?> fetchById(
    int id, {
    bool withLoading = false,
  }) async {
    final res = await ApiHelper.get(
      path: '$_base/$id',
      withLoading: withLoading,
      shouldShowMessage: false,
    );
    if (res is Map && res['record'] is Map) {
      return MerchantStoryModel.fromJson(Map<String, dynamic>.from(res['record']));
    }
    return null;
  }

  /// Create a new story.
  ///
  /// Backend expects:
  /// {"image": "images/...png", "text": "...", "color": "5246456"}
  static Future<MerchantStoryModel?> create({
    String? image,
    String? text,
    int? color,
    bool withLoading = true,
  }) async {
    final body = <String, dynamic>{};
    if (image != null && image.trim().isNotEmpty) body['image'] = image.trim();
    if (text != null && text.trim().isNotEmpty) body['text'] = text.trim();
    if (color != null) body['color'] = color.toString();

    final res = await ApiHelper.post(
      path: _base,
      body: jsonEncode(body),
      withLoading: withLoading,
      shouldShowMessage: true,
    );

    if (res is Map && res['record'] is Map) {
      return MerchantStoryModel.fromJson(Map<String, dynamic>.from(res['record']));
    }
    return null;
  }
}

class MerchantStoryModel {
  final int id;
  final String? imageUrl; // full URL from API (GET)
  final String? text;
  final int? color; // int color value, optional
  final String? createdAt;

  MerchantStoryModel({
    required this.id,
    this.imageUrl,
    this.text,
    this.color,
    this.createdAt,
  });

  factory MerchantStoryModel.fromJson(Map<String, dynamic> json) {
    final dynamic rawColor = json['color'];
    int? c;
    if (rawColor != null) {
      final s = rawColor.toString().trim();
      c = int.tryParse(s);
    }
    return MerchantStoryModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      imageUrl: json['image']?.toString(),
      text: json['text']?.toString(),
      color: c,
      createdAt: json['created_at']?.toString(),
    );
  }
}
