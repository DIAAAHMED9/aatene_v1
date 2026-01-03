import 'package:get/get.dart';



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
  final String? sectionId;
  final String? status;
  final Map<String, dynamic>? section;
  final String? price;
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
    this.endDate,
    required this.shown,
    required this.favoritesCount,
    required this.messagesCount,
    this.viewCount,
    this.sectionId,
    this.status,
    this.section,
    this.price,
    this.sectionName,
    bool isSelected = false,
  }) : isSelected = RxBool(isSelected);

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
      sectionId: json['section_id']?.toString(),
      status: json['status'],
      section: json['section'] != null
          ? Map<String, dynamic>.from(json['section'])
          : null,
      price: json['price']?.toString(),
      sectionName: json['section'] != null
          ? json['section']['name']?.toString()
          : null,
      isSelected: false,
    );
  }

  factory Product.fromSectionJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      sku: json['sku'] ?? '',
      name: json['name'] ?? '',
      sectionId: json['section_id']?.toString(),
      price: json['price']?.toString(),
      coverUrl: json['cover_url'],
      shortDescription: json['short_description'],
      description: json['description'],
      shown: json['shown'] ?? false,
      favoritesCount: json['favorites_count']?.toString() ?? '0',
      messagesCount: json['messages_count']?.toString() ?? '0',
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
      'section_id': sectionId,
      'status': status,
      'section': section,
      'price': price,
      'section_name': sectionName,
    };
  }

  int? get sectionIdAsInt {
    if (sectionId == null) return null;
    return int.tryParse(sectionId!);
  }

  bool get isInSection =>
      sectionId != null && sectionId != '0' && sectionId != '';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          sectionId == other.sectionId;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ sectionId.hashCode;

  @override
  String toString() {
    return 'Product{id: $id, name: $name, sectionId: $sectionId, price: $price}';
  }

  Product copyWith({
    int? id,
    String? sku,
    String? name,
    String? slug,
    String? shortDescription,
    String? description,
    String? cover,
    String? coverUrl,
    String? endDate,
    bool? shown,
    String? favoritesCount,
    String? messagesCount,
    String? viewCount,
    String? sectionId,
    String? status,
    Map<String, dynamic>? section,
    String? price,
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
      endDate: endDate ?? this.endDate,
      shown: shown ?? this.shown,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      messagesCount: messagesCount ?? this.messagesCount,
      viewCount: viewCount ?? this.viewCount,
      sectionId: sectionId ?? this.sectionId,
      status: status ?? this.status,
      section: section ?? this.section,
      price: price ?? this.price,
      sectionName: sectionName ?? this.sectionName,
      isSelected: isSelected ?? this.isSelected.value,
    );
  }
}