
import '../../../../general_index.dart';

class ProductAttribute {
  final String id;
  final String name;
  RxList<AttributeValue> values;
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
  }) : values = RxList<AttributeValue>.from(values);

  factory ProductAttribute.fromApiJson(Map<String, dynamic> json) {
    final options = List<Map<String, dynamic>>.from(json['options'] ?? []);

    return ProductAttribute(
      id: json['id'].toString(),
      name: json['title'] ?? 'بدون اسم',
      type: json['type'],
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
    final valuesList =
        (json['values'] as List?)?.map((value) {
          return AttributeValue.fromJson(value);
        }).toList() ??
        [];

    return ProductAttribute(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      type: json['type'],
      values: valuesList,
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
      'type': type,
      'values': values.map((value) => value.toJson()).toList(),
      'isRequired': isRequired,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get displayName => name;

  bool get hasSelectedValues => values.any((value) => value.isSelected.value);

  List<String> get selectedValueNames => values
      .where((value) => value.isSelected.value)
      .map((value) => value.value)
      .toList();

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
  final DateTime? createdAt;
  final DateTime? updatedAt;

  AttributeValue({
    required this.id,
    required this.value,
    required this.isSelected,
    this.colorCode,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory AttributeValue.fromJson(Map<String, dynamic> json) {
    return AttributeValue(
      id: json['id']?.toString() ?? '',
      value: json['value'] ?? '',
      isSelected: RxBool(json['isSelected'] ?? false),
      colorCode: json['colorCode'],
      imageUrl: json['imageUrl'],
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
      'value': value,
      'isSelected': isSelected.value,
      'colorCode': colorCode,
      'imageUrl': imageUrl,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get displayValue {
    if (colorCode != null) {
      return '$value (${colorCode!.replaceAll('#', '')})';
    }
    return value;
  }

  AttributeValue copyWith({
    String? id,
    String? value,
    RxBool? isSelected,
    String? colorCode,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AttributeValue(
      id: id ?? this.id,
      value: value ?? this.value,
      isSelected: isSelected ?? RxBool(this.isSelected.value),
      colorCode: colorCode ?? this.colorCode,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
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
