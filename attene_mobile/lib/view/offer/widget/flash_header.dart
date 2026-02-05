// lib/views/flash_sale/components/flash_header.dart
import 'package:attene_mobile/general_index.dart';
import 'package:flutter/material.dart';

/// رأس صفحة Flash Sale - يعرض التايمر والعنوان
class FlashHeader extends StatelessWidget {
  const FlashHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: Stack(
        children: [
          // خلفية الفقاعات
          Positioned.fill(
            right: 0,
            top: 0,
            child: Image.asset(
              "assets/images/png/Bubbles.png",
              width: double.infinity,
            ),
          ),

          // محتوى الرأس
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // مؤقت العد التنازلي
                    const _TimeBox(value: "58"),
                    const _TimeBox(value: "36"),
                    const _TimeBox(value: "00"),
                    const SizedBox(width: 8),
                    const Icon(Icons.timer_outlined, color: Colors.white),

                    const Spacer(),

                    // عنوان الصفحة
                    Column(
                      children: [
                        Text("بيع فلاش", style: getBold(fontSize: 28)),
                        const SizedBox(height: 6),
                        Text("اختر الخصم الخاص بك", style: getMedium()),
                      ],
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

/// مربع عرض الوقت في العد التنازلي
class _TimeBox extends StatelessWidget {
  final String value;

  const _TimeBox({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(value, style: getBold(fontSize: 18)),
    );
  }
}
