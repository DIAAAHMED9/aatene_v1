import 'package:get/get.dart';

class ProductAttribute {
  final String id;
  final String name;
  final RxList<AttributeValue> values;

  ProductAttribute({
    required this.id,
    required this.name,
    required List<AttributeValue> values,
  }) : values = values.obs;

  factory ProductAttribute.fromApiJson(Map<String, dynamic> json) {
    final options = List<Map<String, dynamic>>.from(json['options'] ?? []);
    
    return ProductAttribute(
      id: json['id'].toString(),
      name: json['title'] ?? 'بدون اسم',
      values: options.map((option) {
        return AttributeValue(
          id: option['id'].toString(),
          value: option['title'] ?? 'بدون قيمة',
          isSelected: false.obs,
        );
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'values': values.map((value) => value.toJson()).toList(),
    };
  }

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      id: json['id'],
      name: json['name'],
      values: (json['values'] as List).map((value) {
        return AttributeValue.fromJson(value);
      }).toList(),
    );
  }

  ProductAttribute copyWith({
    String? id,
    String? name,
    List<AttributeValue>? values,
  }) {
    return ProductAttribute(
      id: id ?? this.id,
      name: name ?? this.name,
      values: values ?? this.values.toList(),
    );
  }
}

class AttributeValue {
  final String id;
  final String value;
  final RxBool isSelected;

  AttributeValue({
    required this.id,
    required this.value,
    required RxBool isSelected,
  }) : isSelected = isSelected;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'isSelected': isSelected.value,
    };
  }

  factory AttributeValue.fromJson(Map<String, dynamic> json) {
    return AttributeValue(
      id: json['id'],
      value: json['value'],
      isSelected: (json['isSelected'] ?? false).obs,
    );
  }

  AttributeValue copyWith({
    String? id,
    String? value,
    bool? isSelected,
  }) {
    return AttributeValue(
      id: id ?? this.id,
      value: value ?? this.value,
      isSelected: (isSelected ?? this.isSelected.value).obs,
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
  })  : attributes = attributes.obs,
        price = price.obs,
        stock = stock.obs,
        sku = sku.obs,
        isActive = isActive.obs,
        images = images.obs;

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

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json['id'],
      attributes: Map<String, String>.from(json['attributes'] ?? {}),
      price: (json['price'] ?? 0.0).toDouble(),
      stock: (json['stock'] ?? 0).toInt(),
      sku: json['sku'] ?? '',
      isActive: json['isActive'] ?? true,
      images: List<String>.from(json['images'] ?? []),
    );
  }

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