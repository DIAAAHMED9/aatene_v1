import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/models/product_model.dart';

class ProductAttribute {
  final String id;
  final String name;
  final RxList<AttributeValue> values;
  final String? type;
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
      isRequired: json['is_required'] ?? false,
      values: options.map((option) {
        return AttributeValue(
          id: option['id'].toString(),
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

  String get displayName => name;

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
}

class ProductDiscount {
  final String id;
  final double originalPrice;
  final double discountedPrice;
  final String note;
  final DateTime date;
  final int productCount;
  final List<Product>? products;

  ProductDiscount({
    required this.id,
    required this.originalPrice,
    required this.discountedPrice,
    required this.note,
    required this.date,
    required this.productCount,
    this.products,
  });

  double get discountAmount => originalPrice - discountedPrice;

  double get discountPercentage {
    if (originalPrice <= 0) return 0;
    return (discountAmount / originalPrice) * 100;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'originalPrice': originalPrice,
      'discountedPrice': discountedPrice,
      'note': note,
      'date': date.toIso8601String(),
      'productCount': productCount,
      'discountAmount': discountAmount,
      'discountPercentage': discountPercentage,
    };
  }

  factory ProductDiscount.fromJson(Map<String, dynamic> json) {
    return ProductDiscount(
      id: json['id'] ?? '',
      originalPrice: (json['originalPrice'] ?? 0).toDouble(),
      discountedPrice: (json['discountedPrice'] ?? 0).toDouble(),
      note: json['note'] ?? '',
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      productCount: json['productCount'] ?? 0,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': Map<String, String>.from(attributes),
      'price': price.value,
      'stock': stock.value,
      'sku': sku.value,
      'isActive': isActive.value,
      'images': List<String>.from(images),
    };
  }

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json['id'] ?? '',
      attributes: Map<String, String>.from(json['attributes'] ?? {}),
      price: (json['price'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      sku: json['sku'] ?? '',
      isActive: json['isActive'] ?? false,
      images: List<String>.from(json['images'] ?? []),
    );
  }
}
