// lib/model/product_model.dart
class Product {
  final int id;
  final String sku;
  final String name;
  final String? slug;
  final String? shortDescription;
  final String? cover;
  final String? coverUrl;
  final String? endDate;
  final bool shown;
  final String favoritesCount;
  final String messagesCount;
  final String? viewCount;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    this.slug,
    this.shortDescription,
    this.cover,
    this.coverUrl,
    this.endDate,
    required this.shown,
    required this.favoritesCount,
    required this.messagesCount,
    this.viewCount,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'],
      shortDescription: json['short_description'],
      cover: json['cover'],
      coverUrl: json['cover_url'],
      endDate: json['end_date'],
      shown: json['shown'] ?? false,
      favoritesCount: json['favorites_count']?.toString() ?? '0',
      messagesCount: json['messages_count']?.toString() ?? '0',
      viewCount: json['view_count']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sku': sku,
      'name': name,
      'slug': slug,
      'short_description': shortDescription,
      'cover': cover,
      'cover_url': coverUrl,
      'end_date': endDate,
      'shown': shown,
      'favorites_count': favoritesCount,
      'messages_count': messagesCount,
      'view_count': viewCount,
    };
  }
}