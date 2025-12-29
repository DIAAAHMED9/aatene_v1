import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../component/text/aatene_custom_text.dart';
import '../../../utlis/colors/app_color.dart';

class SafetyRulesScreen extends StatelessWidget {
  const SafetyRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "قواعد السلامة",
          style: getBold(color: AppColors.neutral100, fontSize: 20),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[100],
            ),
            child: Icon(Icons.arrow_back, color: AppColors.neutral100),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            spacing: 20,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "نصائح وإرشادات لضمان البيع والشراء بأمان عبر منصتنا، تحميك وتساعدك على تجنب المشاكل المحتملة.",
                style: getRegular(fontSize: 14, color: Colors.grey),
              ),

              Row(
                children: [
                  Expanded(
                    child: _tabButton(
                      text: 'أشخاص تتابعهم',
                      selected: true,
                      icon: Icon(Icons.store, color: AppColors.light1000),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _tabButton(
                      text: 'المتابعين',
                      selected: false,
                      icon: Icon(Icons.sell, color: AppColors.primary400),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    BulletText(text: 'ضع شرحًا وافيًا عن السلعة أو الخدمة'),
                    BulletText(
                      text:
                          'تواصل مع المشتري عبر الدردشة أو الاتصال أو التعليقات',
                    ),
                    BulletText(text: 'اتفق مع المشتري على مكان عام للقاء'),
                    BulletText(
                      text:
                          'في حال بيعك سلعًا افتراضية (حسابات ألعاب فيديو)، يمكنك الاتفاق على موعد محدد للدفع الإلكتروني، ثم إرسال تفاصيل السلعة',
                    ),
                    BulletText(
                      text: 'احرص أن يتفقد المشتري السلعة أمامك قبل رحيله',
                    ),
                  ],
                ),
              ),
              Text("طرق المحافظة على أمان حسابك", style: getBold()),
              Text(
                "نصائح وإرشادات لضمان تجربة بيع وشراء آمنة",
                style: getRegular(color: Colors.grey, fontSize: 12),
              ),
              SizedBox(
                height: 170,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: const [
                    SafetyCard(
                      icon: Icons.lock_outline,
                      text:
                          'اختر كلمة سر صعبة التخمين، مكونة من أحرف وأرقام ورموز، ولا تشارك معلومات الدخول على متصفحك لأمان أعلى',
                    ),
                    SizedBox(width: 12),
                    SafetyCard(
                      icon: Icons.warning_amber_rounded,
                      text: 'لا تشارك معلومات حسابك الشخصي مع أي شخص',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _dot(isActive: false),
                  _dot(isActive: false),
                  _dot(isActive: true),
                ],
              ),
              Text(
                "اتخذ إجراءً إن شككت بمصداقية إعلان أو حساب",
                style: getBold(),
              ),
              Text(
                "البيع والشراء عبر أعطيني محاكاة لتجربة البيع والشراء التقليدية، أي أن عليك أن تقارن الأسعار، وتجمع المعلومات، وتتواصل مع الطرف الآخر وتطرح أسئلتك بكل شفافية، للتأكد من وصولك إلى هدفك من التصفح",
                style: getRegular(color: Colors.grey, fontSize: 12),
              ),
              AateneButton(
                buttonText: "تواصل معنا",
                color: AppColors.primary400,
                textColor: AppColors.light1000,
                borderColor: AppColors.primary400,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dot({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 22 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF3F5B78) : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  static Widget _tabButton({
    required String text,
    required bool selected,
    required Icon icon,
  }) {
    return Container(
      height: 42,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF3E5C7F) : const Color(0xFFDCE6F3),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Row(
          spacing: 10,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            Text(
              text,
              style: getMedium(
                color: selected ? Colors.white : Color(0xFF3E5C7F),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BulletText extends StatelessWidget {
  final String text;

  const BulletText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: Colors.black87),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: getRegular(fontSize: 15))),
        ],
      ),
    );
  }
}

class SafetyCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const SafetyCard({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6F9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF3F5B78),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(height: 12),
          Text(
            text,
            textAlign: TextAlign.center,
            style: getRegular(fontSize: 14),
          ),
        ],
      ),
    );
  }
}