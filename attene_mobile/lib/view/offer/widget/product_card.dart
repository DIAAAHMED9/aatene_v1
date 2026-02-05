// lib/views/flash_sale/components/product_card.dart
import 'package:attene_mobile/general_index.dart';
import 'package:flutter/material.dart';

/// بطاقة عرض المنتج في العرض الترويجي
class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // صورة المنتج مع بادج الخصم
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: Image.network(
                    "https://i.imgur.com/QCNbOAo.png",
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                Positioned(top: 8, right: 8, child: _DiscountBadge()),
              ],
            ),
          ),

          // معلومات المنتج
          const Padding(
            padding: EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "تي شيرت الأنجار",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      "21 دولار",
                      style: TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      "14 دولار",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// بادج عرض نسبة الخصم
class _DiscountBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "-20%",
        style: TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
