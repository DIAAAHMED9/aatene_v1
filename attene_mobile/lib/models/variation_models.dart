import 'package:get/get.dart';

class AttributeValue {
  final String id;
  final String value;

  final String? colorCode;

  final RxBool isSelected;

  AttributeValue({
    required this.id,
    required this.value,
    this.colorCode,
    bool isSelected = false,
  }) : isSelected = isSelected.obs;

  AttributeValue copyWith({
    String? id,
    String? value,
    String? colorCode,
    bool? isSelected,
  }) {
    return AttributeValue(
      id: id ?? this.id,
      value: value ?? this.value,
      colorCode: colorCode ?? this.colorCode,
      isSelected: isSelected ?? this.isSelected.value,
    );
  }

  factory AttributeValue.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    final rawValue = json['value'] ?? json['title'] ?? '';

    String? color;
    if (json.containsKey('colorCode')) color = json['colorCode']?.toString();
    if (color == null && json.containsKey('color_code')) {
      color = json['color_code']?.toString();
    }
    if (color == null && json.containsKey('data')) {
      final d = json['data'];
      if (d is Map && d['color_code'] != null) {
        color = d['color_code']?.toString();
      } else if (d is String && d.trim().startsWith('#')) {
        color = d.trim();
      }
    }

    return AttributeValue(
      id: rawId?.toString() ?? '',
      value: rawValue?.toString() ?? '',
      colorCode: color,
      isSelected: (json['isSelected'] == true),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      if (colorCode != null) 'colorCode': colorCode,
      'isSelected': isSelected.value,
    };
  }
}

class ProductAttribute {
  final String id;
  final String name;
  final bool isActive;

  final String? type;

  final List<AttributeValue> values;

  const ProductAttribute({
    required this.id,
    required this.name,
    this.isActive = true,
    this.type,
    this.values = const [],
  });

  String get title => name;

  ProductAttribute copyWith({
    String? id,
    String? name,
    bool? isActive,
    String? type,
    List<AttributeValue>? values,
  }) {
    return ProductAttribute(
      id: id ?? this.id,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      type: type ?? this.type,
      values: values ?? this.values,
    );
  }

  factory ProductAttribute.fromApiJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final name = (json['name'] ?? json['title'] ?? '').toString();
    final isActive = (json['is_active'] ?? json['isActive'] ?? true) == true;
    final type = json['type']?.toString();

    final List<dynamic> rawValues =
        (json['values'] as List?) ?? (json['options'] as List?) ?? const [];

    final values = rawValues
        .whereType<Map>()
        .map((e) => AttributeValue.fromJson(Map<String, dynamic>.from(e)))
        .toList();

    return ProductAttribute(
      id: id,
      name: name,
      isActive: isActive,
      type: type,
      values: values,
    );
  }

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute.fromApiJson(json);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'isActive': isActive,
      if (type != null) 'type': type,
      'values': values.map((e) => e.toJson()).toList(),
    };
  }
}

class ProductVariation {
  final String id;
  final RxDouble price;
  final RxInt stock;
  final RxString sku;
  final RxBool isActive;

  final Map<String, String> attributes;

  final List<String> images;

  ProductVariation({
    required this.id,
    required double price,
    int stock = 0,
    String sku = '',
    bool isActive = true,
    Map<String, String>? attributes,
    List<String>? images,
  })  : price = price.obs,
        stock = stock.obs,
        sku = sku.obs,
        isActive = isActive.obs,
        attributes = attributes ?? <String, String>{},
        images = images ?? <String>[];

  ProductVariation copyWith({
    String? id,
    double? price,
    int? stock,
    String? sku,
    bool? isActive,
    Map<String, String>? attributes,
    List<String>? images,
  }) {
    return ProductVariation(
      id: id ?? this.id,
      price: price ?? this.price.value,
      stock: stock ?? this.stock.value,
      sku: sku ?? this.sku.value,
      isActive: isActive ?? this.isActive.value,
      attributes: attributes ?? Map<String, String>.from(this.attributes),
      images: images ?? List<String>.from(this.images),
    );
  }

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('attributes') || json.containsKey('sku')) {
      return ProductVariation(
        id: json['id']?.toString() ?? '',
        price: (json['price'] is num)
            ? (json['price'] as num).toDouble()
            : double.tryParse(json['price']?.toString() ?? '') ?? 0,
        stock: (json['stock'] is int)
            ? (json['stock'] as int)
            : int.tryParse(json['stock']?.toString() ?? '') ?? 0,
        sku: json['sku']?.toString() ?? '',
        isActive: json['isActive'] == true,
        attributes: (json['attributes'] is Map)
            ? Map<String, String>.from(json['attributes'] as Map)
            : <String, String>{},
        images: (json['images'] as List?)?.map((e) => e.toString()).toList() ??
            const <String>[],
      );
    }

    return ProductVariation.fromApiJson(json);
  }

  factory ProductVariation.fromApiJson(Map<String, dynamic> json) {
    final rawPrice = json['price'];
    final price = (rawPrice is num)
        ? rawPrice.toDouble()
        : double.tryParse(rawPrice?.toString() ?? '') ?? 0.0;

    final status = (json['status'] ?? json['active'] ?? '').toString();
    final isActive = status.isEmpty ? true : status == 'active' || status == '1';

    final Map<String, String> attrs = {};
    final rawAttrOpts = json['attributeOptions'];
    if (rawAttrOpts is List) {
      for (final item in rawAttrOpts) {
        if (item is Map) {
          final attr = item['attribute'];
          final opt = item['option'];
          final attrTitle = (attr is Map)
              ? (attr['title'] ?? attr['name'] ?? '').toString()
              : '';
          final optTitle = (opt is Map)
              ? (opt['title'] ?? opt['value'] ?? '').toString()
              : '';
          if (attrTitle.isNotEmpty && optTitle.isNotEmpty) {
            attrs[attrTitle] = optTitle;
          }
        }
      }
    }

    final List<String> images = [];
    if (json['image_url'] != null && json['image_url'].toString().isNotEmpty) {
      images.add(json['image_url'].toString());
    }

    return ProductVariation(
      id: json['id']?.toString() ?? '',
      price: price,
      stock: int.tryParse(json['stock']?.toString() ?? '') ?? 0,
      sku: json['sku']?.toString() ?? '',
      isActive: isActive,
      attributes: attrs,
      images: images,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'price': price.value,
      'stock': stock.value,
      'sku': sku.value,
      'isActive': isActive.value,
      'attributes': attributes,
      'images': images,
    };
  }
}