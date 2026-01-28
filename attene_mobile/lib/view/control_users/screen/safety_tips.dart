import '../../../general_index.dart';

enum UserType { merchant, buyer }

class SafetyTipsPage extends StatefulWidget {
  const SafetyTipsPage({super.key});

  @override
  State<SafetyTipsPage> createState() => _SafetyTipsPageState();
}

class _SafetyTipsPageState extends State<SafetyTipsPage> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  final List<UserType> userTypes = [UserType.merchant, UserType.buyer];

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

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          spacing: 15,
          children: [
            const SizedBox(height: 16),
            Text(
              "نصائح وإرشادات لضمان البيع والشراء بأمان عبر منصتنا، تحميك وتساعدك على تجنب المشاكل المحتملة.",
              style: getMedium(color: AppColors.neutral400),
            ),

            _tabs(),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: userTypes.length,
                onPageChanged: (index) {
                  setState(() => currentIndex = index);
                },
                itemBuilder: (context, index) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    transitionBuilder: (child, animation) {
                      final slide = Tween<Offset>(
                        begin: const Offset(0.2, 0),
                        end: Offset.zero,
                      ).animate(animation);

                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(position: slide, child: child),
                      );
                    },
                    child: SafetyContent(
                      key: ValueKey(userTypes[index]),
                      userType: userTypes[index],
                    ),
                  );
                },
              ),
            ),

            AateneButton(
              buttonText: 'تواصل معنا',
              color: AppColors.primary400,
              textColor: AppColors.light1000,
              borderColor: AppColors.primary400,
            ),
          ],
        ),
      ),
    );
  }

  Widget _tabs() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(children: [_tabItem('التاجر', 0), _tabItem('المشتري', 1)]),
    );
  }

  Widget _tabItem(String title, int index) {
    final bool isSelected = currentIndex == index;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: GestureDetector(
          onTap: () {
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeInOut,
            );
            setState(() => currentIndex = index);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
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
}

class SafetyContent extends StatelessWidget {
  final UserType userType;

  const SafetyContent({super.key, required this.userType});

  bool get isMerchant => userType == UserType.merchant;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _infoCard(),
          const SizedBox(height: 20),
          _sectionTitle('طرق المحافظة على أمان حسابك'),
          Text(
            "نصائح وإرشادات لضمان تجربة بيع وشراء آمنة",
            style: getMedium(fontSize: 12, color: AppColors.neutral600),
          ),
          Row(
            spacing: 10,
            children: const [
              Expanded(
                child: SecurityCard(
                  icon: Icons.info,
                  title: 'لا تشارك معلومات حسابك الشخصي مع اي احد',
                ),
              ),
              Expanded(
                child: SecurityCard(
                  icon: Icons.lock,
                  title:
                      'اختر كلمة سر صعبة التخمين، مكوّنة من 8 عناصر (حروف، أرقام، ورموز)، ولا تحفظ معلومات الدخول على متصفحك لأمان أعلى',
                ),
              ),
            ],
          ),
          _sectionTitle('اتخذ إجراءً إن شككت بمصداقية إعلان أو حساب'),
          Text(
            isMerchant
                ? 'البيع والشراء عبر أعطيني محاكاة لتجربة البيع والشراء التقليدية، أي أن عليك أن تقارن الأسعار، وتجمع المعلومات، وتتواصل مع الطرف الآخر وتطرح أسئلتك بكل شفافية، للتأكد من وصولك إلى هدفك من التصفح'
                : 'كـمشتري، تحقق من مصداقية البائع ولا تتردد في الإبلاغ عن أي سلوك مريب.',
            style: const TextStyle(color: Colors.black54),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _title() {
    final tips = isMerchant
        ? [
            'ضع شرحاً وافياً عن السلعة أو الخدمة',
            'تواصل مع المشتري عبر الدردشة أو الاتصال أو التعليقات',
            'اتفق مع المشتري على مكان عام للّقاء',
            'في حال بيعك سلعاً افتراضية (حسابات ألعاب فيديو)، يمكنك الاتفاق على موعد محدد للدفع الإلكتروني، ثم إرسال تفاصيل السلعة',
            'احرص أن يتفقّد المشتري السلعة أمامك قبل رحيله',
          ]
        : [
            'اقرأ تفاصيل الإعلان جيدًا',
            'تواصل مع البائع داخل المنصة',
            'قابل البائع في مكان عام',
            'لا تحول أموالًا مسبقًا',
            'افحص السلعة قبل الدفع',
          ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isMerchant ? 'نصائح وإرشادات للتاجر' : 'نصائح وإرشادات للمشتري',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...tips.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Text('• ', style: TextStyle(fontSize: 18)),
                  Expanded(child: Text(e)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard() {
    final tips = isMerchant
        ? [
            'قدم وصفًا دقيقًا للسلعة أو الخدمة',
            'التزم بالرد السريع على الاستفسارات',
            'اتفق على مكان عام للتسليم',
            'لا تشارك معلوماتك البنكية',
            'سلّم السلعة بعد تأكيد الاتفاق',
          ]
        : [
            'اقرأ تفاصيل الإعلان جيدًا',
            'تواصل مع البائع داخل المنصة',
            'قابل البائع في مكان عام',
            'لا تحول أموالًا مسبقًا',
            'افحص السلعة قبل الدفع',
          ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary50),
        color: AppColors.primary50.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isMerchant ? 'نصائح وإرشادات للتاجر' : 'نصائح وإرشادات للمشتري',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...tips.map(
            (e) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Text('• ', style: TextStyle(fontSize: 18)),
                  Expanded(child: Text(e)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(title, style: getBold());
  }
}

class SecurityCard extends StatelessWidget {
  const SecurityCard({super.key, required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 220,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: AppColors.primary400,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Icon(icon, size: 18, color: AppColors.light1000),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: getMedium(fontSize: 12),
          ),
        ],
      ),
    );
  }
}