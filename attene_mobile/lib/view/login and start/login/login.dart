import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utlis/responsive/responsive_dimensions.dart';
import 'login_controller.dart';

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
                  isRTL ? 'أهلاً بك في اعطيني' : 'Welcome to Atene',
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
                    textInputAction: TextInputAction.next,
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
                    // GestureDetector(
                    //   child: SizedBox(
                    //     width: ResponsiveDimensions.w(40),
                    //     height: ResponsiveDimensions.h(40),
                    //     child: const Icon(Icons.g_mobiledata),
                    //   ),
                    // ),
                    GestureDetector(
                      onTap: () => controller.socialLogin('google'),
                      child: Container(
                        width: ResponsiveDimensions.w(150),
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
                    GestureDetector(
                      onTap: () => controller.socialLogin('google'),
                      child: Container(
                        width: ResponsiveDimensions.w(150),
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
