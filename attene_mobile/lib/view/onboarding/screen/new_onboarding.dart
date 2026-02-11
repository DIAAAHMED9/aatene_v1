import '../../../general_index.dart';

class OnboardingView extends StatelessWidget {
   OnboardingView({super.key});

  final controller = Get.put(OnboardingController());

  final pages = const [
    OnboardingModel(
      gif: 'assets/images/png/onboarding1.png',
      title: 'تسوق كل اللي تحتاجه بسهولة',
      description:
      'اكتشف منتجات متنوعة، قارن الأسعار وعاين التفاصيل قبل الشراء.',
    ),
    OnboardingModel(
      gif: 'assets/images/png/onboarding2.png',
      title: 'خدمات متكاملة في مكان واحد',
      description: 'احجز خدماتك بسهولة وتابع كل التفاصيل من خلال التطبيق.',
    ),
    OnboardingModel(
      gif: 'assets/images/png/onboarding3.png',
      title: 'مساعد ذكي معك دائمًا',
      description: 'اسأل، اختر، وتابع طلبك مع مساعد ذكي يسهل عليك كل خطوة.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [
            const CurvedBackground(),

            Positioned(
              top: 25,
              right: 10,
              child: TextButton(
                onPressed: () => controller.finish(),
                child: const Text(
                    'تخطي', style: TextStyle(color: Colors.white)),
              ),
            ),

            PageView.builder(
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemCount: pages.length,
              itemBuilder: (_, i) => OnboardingPage(data: pages[i]),
            ),

            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Obx(() {
                return OnboardingDots(
                  current: controller.currentIndex.value,
                  count: pages.length,
                );
              }),
            ),

            Positioned(
              bottom: 24,
              left: 24,
              right: 24,
              child: Obx(() {
                final isLast = controller.currentIndex.value ==
                    pages.length - 1;
                return AateneButton(
                  onTap: controller.next,
                  buttonText: isLast ? 'التالي' : 'التالي',
                  color: AppColors.primary400,
                  textColor: AppColors.light1000,
                  borderColor: AppColors.primary400,
                );
              }),
            ),
          ],
        ),
      );
  }
}