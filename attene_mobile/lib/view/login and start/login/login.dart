import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
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
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(16),
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0071A7),
                  ),
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
                    errorValue: controller.emailError.value,
                    onChanged: controller.updateEmail,
                    isError: controller.emailError.isNotEmpty,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(16)),
                Obx(
                  () => TextFiledAatene(
                    isRTL: isRTL,
                    hintText: isRTL ? 'كلمة المرور' : 'Password',
                    errorValue: controller.passwordError.value,
                    onChanged: controller.updatePassword,
                    isError: controller.passwordError.isNotEmpty,
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
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: TextButton(
                    onPressed: controller.forgotPassword,
                    child: Text(
                      isRTL ? 'نسيت كلمة المرور؟' : 'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF0071A7),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      // onTap: () => controller.socialLogin('google'),
                      child: SizedBox(
                        width: ResponsiveDimensions.w(40),
                        height: ResponsiveDimensions.h(40),
                        child: Icon(Icons.g_mobiledata),
                      ),
                    ),
                    SizedBox(width: ResponsiveDimensions.w(20)),
                    GestureDetector(
                      onTap: () => controller.socialLogin('google'),
                      child: Container(
                        width: ResponsiveDimensions.w(40),
                        height: ResponsiveDimensions.h(40),
                        child: Icon(Icons.apple),
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
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveDimensions.f(14),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.createNewAccount,
                      child: Text(
                        isRTL ? 'إنشاء حساب جديد' : 'Create new account',
                        style: TextStyle(
                          color: Color(0xFF0071A7),
                          fontWeight: FontWeight.bold,
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