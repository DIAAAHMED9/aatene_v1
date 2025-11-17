// lib/view/media_library/media_model.dart
enum MediaType { image, video }

class MediaItem {
  final String id;
  final String path;
  final MediaType type;
  final String name;
  final DateTime dateAdded;
  final int size;
  final bool? isLocal; // ✅ إضافة حقل جديد للتمييز بين الملفات المحلية والملفات من API

  MediaItem({
    required this.id,
    required this.path,
    required this.type,
    required this.name,
    required this.dateAdded,
    required this.size,
    this.isLocal = false,
  });
}