// lib/model/product_model.dart
class Product {
  final int id;
  final String sku;
  final String name;
  final String? slug;
  final String? shortDescription;
  final String? description;
  final String? cover;
  final String? coverUrl;
  final String? endDate;
  final bool shown;
  final String favoritesCount;
  final String messagesCount;
  final String? viewCount;
  final String? sectionId; // ✅ تحديث: من String وليس int
  final String? status;
  final Map<String, dynamic>? section; // ✅ إضافة حقل section

  Product({
    required this.id,
    required this.sku,
    required this.name,
    this.slug,
    this.shortDescription,
    this.description,
    this.cover,
    this.coverUrl,
    this.endDate,
    required this.shown,
    required this.favoritesCount,
    required this.messagesCount,
    this.viewCount,
    this.sectionId, // ✅ تحديث
    this.status,
    this.section, // ✅ جديد
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'],
      shortDescription: json['short_description'],
      description: json['description'],
      cover: json['cover'],
      coverUrl: json['cover_url'],
      endDate: json['end_date'],
      shown: json['shown'] ?? false,
      favoritesCount: json['favorites_count']?.toString() ?? '0',
      messagesCount: json['messages_count']?.toString() ?? '0',
      viewCount: json['view_count']?.toString(),
      sectionId: json['section_id']?.toString(), // ✅ تحويل إلى String
      status: json['status'],
      section: json['section'] != null ? Map<String, dynamic>.from(json['section']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'slug': slug,
      'short_description': shortDescription,
      'description': description,
      'cover': cover,
      'cover_url': coverUrl,
      'end_date': endDate,
      'shown': shown,
      'favorites_count': favoritesCount,
      'messages_count': messagesCount,
      'view_count': viewCount,
      'section_id': sectionId, // ✅ تحديث
      'status': status,
      'section': section,
    };
  }

  // ✅ دالة مساعدة للحصول على sectionId كـ int (إذا احتجنا)
  int? get sectionIdAsInt {
    if (sectionId == null) return null;
    return int.tryParse(sectionId!);
  }
}