import '../../../general_index.dart';

enum UserType { merchant, buyer }

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<UserType> pages = [UserType.merchant, UserType.buyer];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "الأسئلة الشائعة",
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            Text(
              "إجابات وافية على أكثر الأسئلة شيوعًا لضمان تجربة سلسة وواضحة.",
              style: getMedium(color: AppColors.neutral400),
            ),

            _buildTabs(),

            _searchField(),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.1, 0),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: FaqContent(
                      key: ValueKey(pages[index]),
                      userType: pages[index],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      height: 44,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _tabItem('الخدمات', 0),
          _tabItem('المنتجات', 1),
          _tabItem('المنتجات المستعملة', 2),
        ],
      ),
    );
  }

  Widget _tabItem(String title, int index) {
    final isSelected = currentIndex == index;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(3.0),
        child: GestureDetector(
          onTap: () {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOutCubic,
            );
            setState(() => currentIndex = index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary400 : AppColors.primary50,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              title,
              style: getBold(
                color: isSelected ? Colors.white : AppColors.primary400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _searchField() {
    final isRTL = LanguageUtils.isRTL;

    return TextFiledAatene(
      isRTL: isRTL,
      hintText: 'ابحث من خلال أي كلمة مفتاحية',
      textInputAction: TextInputAction.done,
      prefixIcon: const Icon(Icons.search),
      textInputType: TextInputType.name,
    );
  }
}

class FaqContent extends StatelessWidget {
  final UserType userType;

  const FaqContent({super.key, required this.userType});

  bool get isMerchant => userType == UserType.merchant;

  @override
  Widget build(BuildContext context) {
    final questions = isMerchant ? merchantFaq : buyerFaq;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: questions.length,
      itemBuilder: (context, index) {
        return FaqItem(
          question: questions[index]['q']!,
          answer: questions[index]['a']!,
        );
      },
    );
  }
}

class FaqItem extends StatefulWidget {
  final String question;
  final String answer;

  const FaqItem({super.key, required this.question, required this.answer});

  @override
  State<FaqItem> createState() => _FaqItemState();
}

class _FaqItemState extends State<FaqItem> with SingleTickerProviderStateMixin {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() => isOpen = !isOpen),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: getBold(color: AppColors.primary400),
                  ),
                ),
                AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: isOpen ? 0.5 : 0,
                  child: const Icon(Icons.keyboard_arrow_down),
                ),
              ],
            ),
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isOpen
                ? Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Text(widget.answer, style: getMedium()),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

final merchantFaq = [
  {
    'q': 'كيف أقدر أضيف خدمتي على المنصة؟',
    'a':
        'تقدر تضيف خدمتك بسهولة من خلال إنشاء حساب مجاني ثم الدخول للوحة التحكم.',
  },
  {
    'q': 'هل أستطيع تعديل أو حذف الخدمة بعد نشرها؟',
    'a': 'نعم، يمكنك التعديل أو الحذف في أي وقت.',
  },
  {
    'q': 'كيف يتم التواصل مع العملاء؟',
    'a': 'يتم التواصل عبر الدردشة داخل المنصة.',
  },
];

final buyerFaq = [
  {'q': 'هل يوجد عمولة على المبيعات؟', 'a': 'لا، لا توجد عمولات إضافية.'},
  {'q': 'كم يستغرق عرض الخدمة؟', 'a': 'عادة يتم عرض الخدمة خلال دقائق.'},
];
final usedFaq = [
  {'q': 'هل يوجد عمولة على المبيعات؟', 'a': 'لا، لا توجد عمولات إضافية.'},
  {'q': 'كم يستغرق عرض الخدمة؟', 'a': 'عادة يتم عرض الخدمة خلال دقائق.'},
];