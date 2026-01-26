import '../../../../general_index.dart';
import '../../../../utils/responsive/index.dart';


class Login extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  Login({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveDimensions.w(20),
            ),
            child: Column(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/png/logo_aatrne.png',
                  width: ResponsiveDimensions.w(120),
                  height: ResponsiveDimensions.h(120),
                  fit: BoxFit.cover,
                ),
                Text(
                  isRTL ? 'أهلاً بك في اعطيني' : 'Welcome to Aatene',
                  style: getBold(color: AppColors.primary400),
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveDimensions.w(110),
                  ),
                  child: Text(
                    isRTL
                        ? 'سجل دخول و استمتع بتجربه مميزه'
                        : 'Login and enjoy a special experience',
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.f(12),
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(16)),
                Obx(
                  () => TextFiledAatene(
                    isRTL: isRTL,
                    hintText: isRTL
                        ? 'البريد الإلكتروني / رقم الجوال'
                        : 'Email / Phone Number',
                    errorText: controller.emailError.value,
                    onChanged: controller.updateEmail,
                    textInputAction: TextInputAction.next, textInputType: null,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(16)),
                Obx(
                  () => TextFiledAatene(
                    isRTL: isRTL,
                    hintText: isRTL ? 'كلمة المرور' : 'Password',
                    errorText: controller.passwordError.value,
                    onChanged: controller.updatePassword,
                    obscureText: controller.obscurePassword.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscurePassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: controller.passwordError.isNotEmpty
                            ? Colors.red
                            : Colors.grey,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    textInputAction: TextInputAction.done,
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: controller.forgotPassword,
                    child: Text(
                      isRTL ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                      style: getRegular(
                        color: AppColors.neutral600,
                        fontSize: ResponsiveDimensions.f(14),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => AateneButton(
                    textColor: Colors.white,
                    color: AppColors.primary400,
                    borderColor: AppColors.primary400,
                    isLoading: controller.isLoading.value,
                    onTap: controller.isLoading.value ? null : controller.login,
                    buttonText: isRTL ? 'تسجيل الدخول' : 'Login',
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(10)),
                Row(
                  spacing: 20,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.socialLogin('google'),
                        child: Container(
                          height: ResponsiveDimensions.h(50),
                          decoration: BoxDecoration(
                            color: AppColors.neutral100,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.apple,
                                color: AppColors.light1000,
                                size: 25,
                              ),
                              Text(
                                " أبل",
                                style: getBold(color: AppColors.light1000),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.socialLogin('google'),
                        child: Container(
                          height: ResponsiveDimensions.h(50),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: AppColors.neutral600),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Image.asset(
                                  'assets/images/png/google.png',
                                  width: 24,
                                  height: 24,
                                ),
                                onPressed: () {},
                              ),
                      
                              Text(
                                " جوجل",
                                style: getBold(color: AppColors.neutral100),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveDimensions.h(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isRTL ? 'ليس لديك حساب؟ ' : 'Don\'t have an account? ',
                      style: getRegular(fontSize: ResponsiveDimensions.f(14)),
                    ),
                    GestureDetector(
                      onTap: controller.createNewAccount,
                      child: Text(
                        isRTL ? 'اشتراك' : 'Create new account',
                        style: getBold(
                          color: AppColors.primary400,
                          fontSize: ResponsiveDimensions.f(14),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveDimensions.h(120)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}