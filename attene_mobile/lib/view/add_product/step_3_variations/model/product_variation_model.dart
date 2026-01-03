import 'package:get/get.dart';


class ProductVariation {
  final String id;
  final RxMap<String, String> attributes;
  final RxDouble price;
  final RxInt stock;
  final RxString sku;
  final RxBool isActive;
  final RxList<String> images;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductVariation({
    required this.id,
    required Map<String, String> attributes,
    required double price,
    required int stock,
    required String sku,
    required bool isActive,
    required List<String> images,
    this.createdAt,
    this.updatedAt,
  }) : attributes = RxMap<String, String>.from(attributes),
       price = RxDouble(price),
       stock = RxInt(stock),
       sku = RxString(sku),
       isActive = RxBool(isActive),
       images = RxList<String>.from(images);

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json['id']?.toString() ?? '',
      attributes: Map<String, String>.from(json['attributes'] ?? {}),
      price: (json['price'] ?? 0.0).toDouble(),
      stock: (json['stock'] ?? 0).toInt(),
      sku: json['sku']?.toString() ?? '',
      isActive: json['isActive'] ?? true,
      images: List<String>.from(json['images'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': Map<String, String>.from(attributes),
      'price': price.value,
      'stock': stock.value,
      'sku': sku.value,
      'isActive': isActive.value,
      'images': images.toList(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get displayName {
    if (attributes.isEmpty) return 'بدون سمات';
    final attributeStrings = attributes.entries.map(
      (e) => '${e.key}: ${e.value}',
    );
    return attributeStrings.join(' | ');
  }

  String get formattedPrice => '${price.value.toStringAsFixed(2)} ر.س';

  String get stockStatus {
    if (stock.value <= 0) return 'غير متوفر';
    if (stock.value < 10) return 'كمية محدودة';
    return 'متوفر';
  }

  bool get hasImages => images.isNotEmpty;

  void toggleActive() => isActive.toggle();

  ProductVariation copyWith({
    String? id,
    Map<String, String>? attributes,
    double? price,
    int? stock,
    String? sku,
    bool? isActive,
    List<String>? images,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductVariation(
      id: id ?? this.id,
      attributes: attributes ?? Map<String, String>.from(this.attributes),
      price: price ?? this.price.value,
      stock: stock ?? this.stock.value,
      sku: sku ?? this.sku.value,
      isActive: isActive ?? this.isActive.value,
      images: images ?? this.images.toList(),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}