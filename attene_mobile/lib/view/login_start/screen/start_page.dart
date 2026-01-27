

import '../../../general_index.dart';
import '../../../utils/responsive/index.dart';

class StartLogin extends StatelessWidget {
  const StartLogin({super.key});

  Future<void> _continueAsGuest() async {
    final storage = GetStorage();

    // Enable guest mode
    await storage.write('is_guest', true);

    // Clear any previous authenticated session to avoid mixed states
    await storage.remove('token');
    await storage.remove('user_data');
    await storage.remove('store_id');
    await storage.remove('active_store_id');
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveDimensions.w(8),
                vertical: ResponsiveDimensions.h(60),
              ),
              child: Column(
                children: [
                  Image.asset('assets/images/png/girl_shop.png'),
                  SizedBox(height: ResponsiveDimensions.h(15)),
                  Center(
                    child: Text(
                      isRTL
                          ? 'مرحبا بك في تطبيق اعطيني قم بالدخول الى التطبيق عبر الطرق التالية'
                          : 'Welcome to the app — please sign in using one of the following methods',
                      style: getRegular(
                        fontSize: ResponsiveDimensions.f(18),
                        color: AppColors.neutral100,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(height: ResponsiveDimensions.h(30)),
                  AateneButton(
                    buttonText: isRTL ? 'تسجيل الدخول' : 'Sign in',
                    textColor: Colors.white,
                    color: AppColors.primary400,
                    borderColor: AppColors.primary400,
                    onTap: () {
                      Get.offAndToNamed('/login');
                    },
                  ),
                  SizedBox(height: ResponsiveDimensions.h(20)),
                  AateneButton(
                    color: AppColors.primary300.withAlpha(50),
                    textColor: AppColors.primary500,
                    borderColor: AppColors.primary500,
                    buttonText: isRTL ? 'إنشاء حساب' : 'Create account',
                    onTap: () {
                      Get.offAndToNamed('/register');
                    },
                  ),
                  SizedBox(height: ResponsiveDimensions.h(20)),
                  AateneButton(
                    color: Colors.white,
                    borderColor: AppColors.neutral500,
                    buttonText: isRTL ? 'متابعة كزائر' : 'Continue as guest',
                    onTap: () {
                      _continueAsGuest().then((_) {
                        // Go directly to the main app in guest mode
                        Get.offAllNamed('/mainScreen');
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}