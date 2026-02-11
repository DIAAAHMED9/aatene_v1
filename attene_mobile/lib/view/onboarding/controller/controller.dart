import '../../../general_index.dart';
import '../screen/onbording.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;

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

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  Future<void> next() async {
    if (currentIndex.value == 2) {
      await finish();
    } else {
      pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);

    Get.to(() => Onboarding());
  }
}