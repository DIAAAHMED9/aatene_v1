import '../../../general_index.dart';
import '../screen/onbording.dart';

class OnboardingController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;

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
    Get.to(Onboarding());
  }
}
