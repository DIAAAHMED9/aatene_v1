import 'package:attene_mobile/api/api_request.dart';
import 'package:get/get.dart';

class Section {
  final int id;
  final String name;
  final String? image;
  final String? imageUrl;
  final String storeId;

  Section({
    required this.id,
    required this.name,
    this.image,
    this.imageUrl,
    required this.storeId,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      image: json['image'],
      imageUrl: json['image_url'],
      storeId: json['store_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'image_url': imageUrl,
      'store_id': storeId,
    };
  }
}

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
  final String? price;
  final String? sectionId;

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
    this.price,
    this.sectionId,
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
      price: json['price']?.toString(),
      sectionId: json['section_id']?.toString(),
    );
  }
}
