// lib/views/flash_sale/components/products_page_view.dart
import 'package:attene_mobile/general_index.dart';
import 'package:flutter/material.dart';
import 'product_card.dart' hide ProductCard;

/// عرض المنتجات في شكل PageView مع GridView داخلي
class ProductsPageView extends StatelessWidget {
  final PageController controller;
  final ValueChanged<int> onPageChanged;

  const ProductsPageView({
    super.key,
    required this.controller,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: 6, // عدد التبويبات
      itemBuilder: (context, pageIndex) {
        // TODO: استبدال الـ 6 بعدد المنتجات الفعلي من الـ Controller
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.62,
          ),
          itemCount: 6, // عدد المنتجات لكل تبويب
          itemBuilder: (context, index) => const ProductCard(),
        );
      },
    );
  }
}
