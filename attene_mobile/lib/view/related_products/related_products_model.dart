import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  ProductDiscount({
    required this.id,
    required this.originalPrice,
    required this.discountedPrice,
    required this.note,
    required this.date,
    required this.productCount,
  });

  double get discountAmount => originalPrice - discountedPrice;
  
  double get discountPercentage => originalPrice > 0 ? (discountAmount / originalPrice) * 100 : 0;
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
  })  : attributes = attributes.obs,
        price = price.obs,
        stock = stock.obs,
        sku = sku.obs,
        isActive = isActive.obs,
        images = images.obs;

  String get displayName {
    if (attributes.isEmpty) return 'بدون سمات';
    final attributeStrings = attributes.entries.map((e) => '${e.key}: ${e.value}');
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
}