// lib/view/related_products/related_products_model.dart
import 'package:get/get.dart';

class RelatedProduct {
  final String id;
  final String name;
  final String image;
  final double price;
  final RxBool isSelected;

  RelatedProduct({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    bool isSelected = false,
  }) : isSelected = RxBool(isSelected);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RelatedProduct && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
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
  double get discountPercentage => (discountAmount / originalPrice) * 100;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductDiscount && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}