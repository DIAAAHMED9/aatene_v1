import '../../../general_index.dart';

class StoryItemModel {
  final int id;

  /// One or more media URLs (full URLs) for this story frame.
  /// Backward compatible with APIs that return a single `image` string.
  final List<String> mediaUrls;

  final String? text;
  final int? colorDecimal; // may be null
  final DateTime? createdAt;

  StoryItemModel({
    required this.id,
    required this.mediaUrls,
    this.text,
    this.colorDecimal,
    this.createdAt,
  });

  /// Backward-compatible single thumbnail.
  String get imageUrl => mediaUrls.isNotEmpty ? mediaUrls.first : '';

  factory StoryItemModel.fromApiMap(Map<String, dynamic> map) {
    int parseColor(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      final s = v.toString().trim();
      return int.tryParse(s) ?? 0;
    }

    DateTime? parseDate(dynamic v) {
      if (v == null) return null;
      final s = v.toString().trim();
      if (s.isEmpty) return null;
      try {
        // API example: "2026-01-21 21:48:04" (no T)
        final normalized = s.contains('T') ? s : s.replaceFirst(' ', 'T');
        return DateTime.tryParse(normalized);
      } catch (_) {
        return null;
      }
    }

    // Support multiple possible keys:
    // - image: "https://..."
    // - images_url: ["https://...", ...]
    // - images: ["images/.."]  (if backend returns relative)
    final List<String> urls = [];

    void addIfValid(dynamic v) {
      if (v == null) return;
      if (v is String) {
        final s = v.trim();
        if (s.isNotEmpty) urls.add(s);
      }
    }

    final dynamic imagesUrl = map['images_url'];
    if (imagesUrl is List) {
      for (final it in imagesUrl) {
        addIfValid(it);
      }
    }

    final dynamic images = map['images'];
    if (images is List) {
      for (final it in images) {
        addIfValid(it);
      }
    }

    addIfValid(map['image']);

    return StoryItemModel(
      id: int.tryParse(map['id']?.toString() ?? '') ?? 0,
      mediaUrls: urls,
      text: map['text']?.toString(),
      colorDecimal: map['color'] == null ? null : parseColor(map['color']),
      createdAt: parseDate(map['created_at']),
    );
  }

  /// API sends decimal string (e.g. "5246456").
  /// We convert to Flutter Color, ensuring alpha is set.
  Color get backgroundColor {
    final c = colorDecimal ?? 0;
    if (c == 0) return Colors.black;
    final int argb = (c & 0xFF000000) == 0 ? (0xFF000000 | c) : c;
    return Color(argb);
  }
}
