import 'dart:ui';

import 'package:get/get.dart';

class ProductAttribute {
  final String id;
  final String name;
  final RxList<AttributeValue> values;
  final String? type; // إضافة حقل type
  final bool isRequired;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductAttribute({
    required this.id,
    required this.name,
    required List<AttributeValue> values,
    this.type,
    this.isRequired = false,
    this.createdAt,
    this.updatedAt,
  }) : values = values.obs;

  factory ProductAttribute.fromApiJson(Map<String, dynamic> json) {
    final options = List<Map<String, dynamic>>.from(json['options'] ?? []);

    return ProductAttribute(
      id: json['id'].toString(),
      name: json['title'] ?? 'بدون اسم',
      type: json['type'],
      // قراءة type من الـAPI
      isRequired: json['is_required'] ?? false,
      values: options.map((option) {
        return AttributeValue(
          id: option['id']?.toString() ?? '',
          value: option['title'] ?? 'بدون قيمة',
          isSelected: false.obs,
        );
      }).toList(),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    final valuesList = json['values'] != null
        ? (json['values'] as List).map((value) {
            return AttributeValue.fromJson(value);
          }).toList()
        : [];

    return ProductAttribute(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      type: json['type'],
      values: valuesList as List<AttributeValue>,
      isRequired: json['isRequired'] ?? false,
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
      'name': name,
      'type': type, // إضافة type إلى الـJSON
      'values': values.map((value) => value.toJson()).toList(),
      'isRequired': isRequired,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get displayName {
    return name;
  }

  bool get hasSelectedValues {
    return values.any((value) => value.isSelected.value);
  }

  List<String> get selectedValueNames {
    return values
        .where((value) => value.isSelected.value)
        .map((value) => value.value)
        .toList();
  }

  void clearSelection() {
    for (final value in values) {
      value.isSelected.value = false;
    }
  }

  void selectAll() {
    for (final value in values) {
      value.isSelected.value = true;
    }
  }

  // إضافة دالة copyWith
  ProductAttribute copyWith({
    String? id,
    String? name,
    List<AttributeValue>? values,
    String? type,
    bool? isRequired,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductAttribute(
      id: id ?? this.id,
      name: name ?? this.name,
      values: values ?? this.values.toList(),
      type: type ?? this.type,
      isRequired: isRequired ?? this.isRequired,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

class AttributeValue {
  final String id;
  final String value;
  final RxBool isSelected;
  final String? colorCode;
  final String? imageUrl;

  AttributeValue({
    required this.id,
    required this.value,
    required RxBool isSelected,
    this.colorCode,
    this.imageUrl,
  }) : isSelected = isSelected;

  factory AttributeValue.fromJson(Map<String, dynamic> json) {
    return AttributeValue(
      id: json['id']?.toString() ?? '',
      value: json['value'] ?? '',
      isSelected: (json['isSelected'] ?? false).obs,
      colorCode: json['colorCode'],
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'isSelected': isSelected.value,
      'colorCode': colorCode,
      'imageUrl': imageUrl,
    };
  }

  String get displayValue {
    if (colorCode != null) {
      return '$value (${colorCode!.replaceAll('#', '')})';
    }
    return value;
  }

  Color? get color {
    if (colorCode == null) return null;
    try {
      return Color(int.parse(colorCode!.replaceAll('#', '0xFF')));
    } catch (e) {
      return null;
    }
  }

  // إضافة دالة copyWith
  AttributeValue copyWith({
    String? id,
    String? value,
    RxBool? isSelected,
    String? colorCode,
    String? imageUrl,
  }) {
    return AttributeValue(
      id: id ?? this.id,
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
      colorCode: colorCode ?? this.colorCode,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class ProductVariation {
  final String id;
  final RxMap<String, String> attributes;
  final RxDouble price;
  final RxInt stock;
  final RxString sku;
  final RxBool isActive;
  final RxList<String> images;

  ProductVariation({
    required this.id,
    required Map<String, String> attributes,
    required double price,
    required int stock,
    required String sku,
    required bool isActive,
    required List<String> images,
  }) : attributes = attributes.obs,
       price = price.obs,
       stock = stock.obs,
       sku = sku.obs,
       isActive = isActive.obs,
       images = images.obs;

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json['id']?.toString() ?? '',
      attributes: Map<String, String>.from(json['attributes'] ?? {}),
      price: (json['price'] ?? 0.0).toDouble(),
      stock: (json['stock'] ?? 0).toInt(),
      sku: json['sku']?.toString() ?? '',
      isActive: json['isActive'] ?? true,
      images: List<String>.from(json['images'] ?? []),
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
    };
  }

  String get displayName {
    if (attributes.isEmpty) return 'بدون سمات';
    final attributeStrings = attributes.entries.map(
      (e) => '${e.key}: ${e.value}',
    );
    return attributeStrings.join(' | ');
  }

  String get formattedPrice {
    return '${price.value.toStringAsFixed(2)} ريال';
  }

  String get stockStatus {
    if (stock.value <= 0) return 'غير متوفر';
    if (stock.value < 10) return 'كمية محدودة';
    return 'متوفر';
  }

  bool get hasImages => images.isNotEmpty;

  void toggleActive() => isActive.toggle();

  // إضافة دالة copyWith
  ProductVariation copyWith({
    String? id,
    Map<String, String>? attributes,
    double? price,
    int? stock,
    String? sku,
    bool? isActive,
    List<String>? images,
  }) {
    return ProductVariation(
      id: id ?? this.id,
      attributes: attributes ?? Map<String, String>.from(this.attributes),
      price: price ?? this.price.value,
      stock: stock ?? this.stock.value,
      sku: sku ?? this.sku.value,
      isActive: isActive ?? this.isActive.value,
      images: images ?? this.images.toList(),
    );
  }
}
