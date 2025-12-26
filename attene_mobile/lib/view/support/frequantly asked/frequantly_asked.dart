import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            FaqItem(
              title: 'كيف أقدر أضيف خدمتي على المنصة؟',
              content:
              'تقدر تضيف خدماتك بسهولة من خلال إنشاء حساب مجاني، ثم '
                  'الدخول إلى لوحة التحكم الخاصة بك، والضغط على "إضافة خدمة". '
                  'بعدها تعبئ البيانات المطلوبة مثل اسم الخدمة، وصفها، '
                  'السعر، مع صور أو تفاصيل مهمة، وبهذا تكون خدمتك جاهزة للعرض.',
              initiallyExpanded: true,
            ),
            FaqItem(
              title: 'كيف أقدر أضيف خدمتي على المنصة؟',
            ),
            FaqItem(
              title: 'هل أستطيع تعديل أو حذف الخدمة بعد نشرها؟',
            ),
            FaqItem(
              title: 'كيف يتم التواصل مع العملاء المهتمين بخدمتي؟',
            ),
            FaqItem(
              title: 'هل يوجد عمولة على المبيعات أو الحجز؟',
            ),
            FaqItem(
              title: 'كم يستغرق الوقت حتى يتم عرض خدمتي للناس؟',
            ),
          ],
        ),
      ),
    );
  }
}

class FaqItem extends StatelessWidget {
  final String title;
  final String? content;
  final bool initiallyExpanded;

  const FaqItem({
    super.key,
    required this.title,
    this.content,
    this.initiallyExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16),
          childrenPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D2F7F),
            ),
          ),
          trailing: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF2D2F7F),
          ),
          children: content == null
              ? []
              : [
            Text(
              content!,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
