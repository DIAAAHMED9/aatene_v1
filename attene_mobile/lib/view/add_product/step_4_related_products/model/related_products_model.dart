import '../../../../general_index.dart';

class RelatedAttributeValue {
  final String id;
  final String value;
  final RxBool isSelected;
  final String? colorCode;
  final String? imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  RelatedAttributeValue({
    required this.id,
    required this.value,
    required this.isSelected,
    this.colorCode,
    this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory RelatedAttributeValue.fromJson(Map<String, dynamic> json) {
    return RelatedAttributeValue(
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

  RelatedAttributeValue copyWith({
    String? id,
    String? value,
    RxBool? isSelected,
    String? colorCode,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RelatedAttributeValue(
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