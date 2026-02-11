import 'package:get/get.dart';

import 'variation_models.dart';

class Product {
  final int id;
  final String sku;
  final String name;

  final String? slug;
  final String? shortDescription;
  final String? description;

  final String? cover;
  final String? coverUrl;

  final List<String> gallery;
  final List<String> galleryUrls;

  final String? type;
  final String? condition;

  final String? categoryId;
  final ProductCategory? category;

  final String? sectionId;
  final ProductSection? section;

  final String? status;
  final String? endDate;
  final bool shown;

  final String favoritesCount;
  final String messagesCount;
  final String? viewCount;

  final String? price;

  final String? storeId;
  final ProductStore? store;

  final String? reviewRate;
  final String? reviewCount;

  final List<String> tags;
  final List<ProductVariation> variations;

  final String? sectionName;

  final RxBool isSelected;

  Product({
    required this.id,
    required this.sku,
    required this.name,
    this.slug,
    this.shortDescription,
    this.description,
    this.cover,
    this.coverUrl,
    this.gallery = const [],
    this.galleryUrls = const [],
    this.type,
    this.condition,
    this.categoryId,
    this.category,
    this.sectionId,
    this.section,
    this.status,
    this.endDate,
    required this.shown,
    required this.favoritesCount,
    required this.messagesCount,
    this.viewCount,
    this.price,
    this.storeId,
    this.store,
    this.reviewRate,
    this.reviewCount,
    this.tags = const [],
    this.variations = const [],
    this.sectionName,
    bool isSelected = false,
  }) : isSelected = RxBool(isSelected);

  List<String> get allImageUrls {
    final urls = <String>[];
    if ((coverUrl ?? '').trim().isNotEmpty) urls.add(coverUrl!.trim());
    for (final u in galleryUrls) {
      final t = u.trim();
      if (t.isNotEmpty && t != 'https://aatene.dev/storage') urls.add(t);
    }
    return urls.toSet().toList();
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    final dynamic rawGallery = json['gallery'] ?? json['gallery    '];
    final dynamic rawGalleryUrls = json['gallery_url'] ?? json['gallery_urls'];

    return Product(
      id: json['id'] ?? 0,
      sku: (json['sku'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),

      slug: json['slug']?.toString(),
      shortDescription: json['short_description']?.toString(),
      description: json['description']?.toString(),

      cover: json['cover']?.toString(),
      coverUrl: json['cover_url']?.toString(),

      gallery: _stringList(rawGallery),
      galleryUrls: _stringList(rawGalleryUrls),

      type: json['type']?.toString(),
      condition: json['condition']?.toString(),

      categoryId: json['category_id']?.toString(),
      category: json['category'] is Map<String, dynamic>
          ? ProductCategory.fromJson(Map<String, dynamic>.from(json['category']))
          : null,

      sectionId: json['section_id']?.toString(),
      section: json['section'] is Map<String, dynamic>
          ? ProductSection.fromJson(Map<String, dynamic>.from(json['section']))
          : null,

      status: json['status']?.toString(),
      endDate: json['end_date']?.toString(),
      shown: json['shown'] == true,

      favoritesCount: (json['favorites_count'] ?? '0').toString(),
      messagesCount: (json['messages_count'] ?? '0').toString(),
      viewCount: json['view_count']?.toString(),

      price: json['price']?.toString(),

      storeId: json['store_id']?.toString(),
      store: json['store'] is Map<String, dynamic>
          ? ProductStore.fromJson(Map<String, dynamic>.from(json['store']))
          : null,

      reviewRate: json['review_rate']?.toString(),
      reviewCount: json['review_count']?.toString(),

      tags: _stringList(json['tags']),
      variations: (json['variations'] is List)
          ? (json['variations'] as List)
              .whereType<Map>()
              .map((e) => ProductVariation.fromApiJson(
                    Map<String, dynamic>.from(e as Map),
                  ))
              .toList()
          : const [],

      sectionName: (json['section'] is Map && (json['section']['name'] != null))
          ? json['section']['name'].toString()
          : null,

      isSelected: false,
    );
  }

  factory Product.fromSectionJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      sku: (json['sku'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      sectionId: json['section_id']?.toString(),
      price: json['price']?.toString(),
      coverUrl: json['cover_url']?.toString(),
      shortDescription: json['short_description']?.toString(),
      description: json['description']?.toString(),
      shown: json['shown'] == true,
      favoritesCount: (json['favorites_count'] ?? '0').toString(),
      messagesCount: (json['messages_count'] ?? '0').toString(),
      slug: json['slug']?.toString(),
      storeId: json['store_id']?.toString(),
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
      'gallery': gallery,
      'gallery_url': galleryUrls,
      'type': type,
      'condition': condition,
      'category_id': categoryId,
      'category': category?.toJson(),
      'section_id': sectionId,
      'section': section?.toJson(),
      'status': status,
      'end_date': endDate,
      'shown': shown,
      'favorites_count': favoritesCount,
      'messages_count': messagesCount,
      'view_count': viewCount,
      'price': price,
      'store_id': storeId,
      'store': store,
      'review_rate': reviewRate,
      'review_count': reviewCount,
      'tags': tags,
      'variations': variations.map((e) => e.toJson()).toList(),
      'section_name': sectionName,
    };
  }

  int? get sectionIdAsInt => int.tryParse(sectionId ?? '');
  bool get isInSection => (sectionId ?? '').isNotEmpty && sectionId != '0';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          sectionId == other.sectionId;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ (sectionId ?? '').hashCode;

  Product copyWith({
    int? id,
    String? sku,
    String? name,
    String? slug,
    String? shortDescription,
    String? description,
    String? cover,
    String? coverUrl,
    List<String>? gallery,
    List<String>? galleryUrls,
    String? type,
    String? condition,
    String? categoryId,
    ProductCategory? category,
    String? sectionId,
    ProductSection? section,
    String? status,
    String? endDate,
    bool? shown,
    String? favoritesCount,
    String? messagesCount,
    String? viewCount,
    String? price,
    String? storeId,
    ProductStore? store,
    String? reviewRate,
    String? reviewCount,
    List<String>? tags,
    List<ProductVariation>? variations,
    String? sectionName,
    bool? isSelected,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      shortDescription: shortDescription ?? this.shortDescription,
      description: description ?? this.description,
      cover: cover ?? this.cover,
      coverUrl: coverUrl ?? this.coverUrl,
      gallery: gallery ?? this.gallery,
      galleryUrls: galleryUrls ?? this.galleryUrls,
      type: type ?? this.type,
      condition: condition ?? this.condition,
      categoryId: categoryId ?? this.categoryId,
      category: category ?? this.category,
      sectionId: sectionId ?? this.sectionId,
      section: section ?? this.section,
      status: status ?? this.status,
      endDate: endDate ?? this.endDate,
      shown: shown ?? this.shown,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      messagesCount: messagesCount ?? this.messagesCount,
      viewCount: viewCount ?? this.viewCount,
      price: price ?? this.price,
      storeId: storeId ?? this.storeId,
      store: store ?? this.store,
      reviewRate: reviewRate ?? this.reviewRate,
      reviewCount: reviewCount ?? this.reviewCount,
      tags: tags ?? this.tags,
      variations: variations ?? this.variations,
      sectionName: sectionName ?? this.sectionName,
      isSelected: isSelected ?? this.isSelected.value,
    );
  }

  static List<String> _stringList(dynamic v) {
    if (v is List) {
      return v.map((e) => (e ?? '').toString()).toList();
    }
    return const [];
  }
}

class ProductSection {
  final int id;
  final String name;
  final String? status;
  final String? image;
  final String? imageUrl;
  final String? storeId;

  ProductSection({
    required this.id,
    required this.name,
    this.status,
    this.image,
    this.imageUrl,
    this.storeId,
  });

  factory ProductSection.fromJson(Map<String, dynamic> json) {
    return ProductSection(
      id: json['id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      status: json['status']?.toString(),
      image: json['image']?.toString(),
      imageUrl: json['image_url']?.toString(),
      storeId: json['store_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'status': status,
        'image': image,
        'image_url': imageUrl,
        'store_id': storeId,
      };

  dynamic operator [](String key) {
    switch (key) {
      case 'id':
        return id;
      case 'name':
        return name;
      case 'store_id':
      case 'storeId':
        return storeId;
      default:
        return null;
    }
  }

}

class ProductCategory {
  final int id;
  final String name;
  final String? type;
  final bool? isActive;
  final String? parentId;

  ProductCategory({
    required this.id,
    required this.name,
    this.type,
    this.isActive,
    this.parentId,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] ?? 0,
      name: (json['name'] ?? '').toString(),
      type: json['type']?.toString(),
      isActive: json['is_active'] == true,
      parentId: json['parent_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'is_active': isActive,
        'parent_id': parentId,
      };
}

class ProductStore {
  final int id;
  final String slug;
  final String name;
  final String? type;
  final String? logoUrl;
  final String? address;
  final String? reviewRate;
  final String? followersCount;
  final String? productsCount;
  final String? viewsCount;

  ProductStore({
    required this.id,
    required this.slug,
    required this.name,
    this.type,
    this.logoUrl,
    this.address,
    this.reviewRate,
    this.followersCount,
    this.productsCount,
    this.viewsCount,
  });

  factory ProductStore.fromJson(Map<String, dynamic> json) {
    return ProductStore(
      id: json['id'] ?? 0,
      slug: (json['slug'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      type: json['type']?.toString(),
      logoUrl: json['logo_url']?.toString(),
      address: json['address']?.toString(),
      reviewRate: json['review_rate']?.toString(),
      followersCount: json['followers_count']?.toString(),
      productsCount: json['products_count']?.toString(),
      viewsCount: json['views_count']?.toString(),
    );
  }
}