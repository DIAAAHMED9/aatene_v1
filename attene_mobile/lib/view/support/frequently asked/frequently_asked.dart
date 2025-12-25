import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utlis/language/language_utils.dart';

class ServicesPageView extends StatefulWidget {
  const ServicesPageView({super.key});

  @override
  State<ServicesPageView> createState() => _ServicesPageViewState();
}

class _ServicesPageViewState extends State<ServicesPageView> {
  final PageController _pageController = PageController();
  int selectedIndex = 0;

  final tabs = ['الخدمات', 'المنتجات', 'المنتجات المستعملة'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "الأسئلة الشائعة",
          style: TextStyle(
            color: AppColors.neutral100,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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

      body: Column(
        children: [
          Text("إجابات وافية على أكثر الأسئلة شيوعًا لضمان تجربة سلسة وواضحة.",style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
            fontWeight: FontWeight.w500
          ),),
          _buildTabs(),
          const SizedBox(height: 16),
          _buildSearch(),
          const SizedBox(height: 16),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => selectedIndex = index);
              },
              children: [
                _servicesFAQ(),
                const Center(child: Text('صفحة المنتجات')),
                const Center(child: Text('صفحة المنتجات المستعملة')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Tabs ----------
  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 35,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary400
                        : AppColors.primary50,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: Text(
                      tabs[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.primary400,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ---------- Search ----------
  Widget _buildSearch() {
    final isRTL = LanguageUtils.isRTL;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFiledAatene(
        isRTL: isRTL,
        hintText: "ابحث من خلال أي كلمة مفتاحية",
        prefixIcon: Icon(Icons.search, color: Colors.grey),
      ),
    );
  }

  // ---------- FAQ ----------
  Widget _servicesFAQ() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _faqItem(
          title: 'كيف أقدر أضيف خدمتي على المنصة؟',
          content:
              'تقدر تضيف خدمتك بسهولة من خلال إنشاء حساب مجاني، ثم الدخول إلى لوحة التحكم الخاصة بك والضغط على "إضافة خدمة". بعدها يتعين عليك ملء المعلومات المطلوبة مثل اسم الخدمة، وصفها، السعر وأي صور أو تفاصيل مهمة.',
          expanded: true,
        ),
        _faqItem(title: 'كيف أقدر أضيف خدمتي على المنصة؟'),
        _faqItem(title: 'هل أستطيع تعديل أو حذف الخدمة بعد نشرها؟'),
        _faqItem(title: 'كيف يتم التواصل مع العملاء المهتمين بخدمتي؟'),
        _faqItem(title: 'هل يوجد عمولة على المبيعات أو الحجز؟'),
        _faqItem(title: 'كم يستغرق الوقت حتى يتم عرض خدمتي للناس؟'),
      ],
    );
  }

  Widget _faqItem({
    required String title,
    String? content,
    bool expanded = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        initiallyExpanded: expanded,
        iconColor: Colors.grey,
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: AppColors.primary400,
          ),
        ),
        children: content != null
            ? [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    content,
                    style: TextStyle(
                      color: AppColors.neutral300,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ]
            : [],
      ),
    );
  }
}
