import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/view/login%20and%20start/Register/register_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utlis/responsive/responsive_dimensions.dart';

class Register extends StatelessWidget {
  final RegisterController controller = Get.put(RegisterController());

  Register({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveDimensions.w(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: ResponsiveDimensions.h(20)),
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
                    color: const Color(0xFF0071A7),
                  ),
                  textAlign: isRTL ? TextAlign.right : TextAlign.left,
                ),
                SizedBox(height: ResponsiveDimensions.h(24)),
                Obx(
                  () => TextFiledAatene(
                    isRTL: isRTL,
                    hintText: isRTL ? 'الاسم الكامل' : 'Full Name',
                    errorText: controller.nameError.value,
                    onChanged: controller.updateName,
                    textInputType: TextInputType.name,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(16)),
                Obx(
                  () => TextFiledAatene(
                    isRTL: isRTL,
                    hintText: isRTL ? 'البريد الإلكتروني' : 'Email',
                    errorText: controller.emailError.value,
                    onChanged: controller.updateEmail,
                    textInputType: TextInputType.emailAddress,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(16)),
                Obx(
                  () => TextFiledAatene(
                    isRTL: isRTL,
                    hintText: isRTL ? 'رقم الجوال' : 'Phone Number',
                    errorText: controller.phoneError.value,
                    onChanged: controller.updatePhone,
                    textInputType: TextInputType.phone,
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
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(16)),
                Obx(
                  () => TextFiledAatene(
                    isRTL: isRTL,
                    hintText: isRTL ? 'تأكيد كلمة المرور' : 'Confirm Password',
                    errorText: controller.confirmPasswordError.value,
                    onChanged: controller.updateConfirmPassword,
                    obscureText: controller.obscureConfirmPassword.value,
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.obscureConfirmPassword.value
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: controller.confirmPasswordError.isNotEmpty
                            ? Colors.red
                            : Colors.grey,
                      ),
                      onPressed: controller.toggleConfirmPasswordVisibility,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(30)),
           Obx(
  () => AateneButton(
    textColor: Colors.white,
    color: AppColors.primary400,
    borderColor: AppColors.primary400,
    isLoading: controller.isLoading.value,
    onTap: controller.isLoading.value ? null : controller.register,
    buttonText: isRTL ? 'إنشاء حساب' : 'Create account',
  ),
),
                SizedBox(height: ResponsiveDimensions.h(16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isRTL
                          ? 'لديك حساب بالفعل؟ '
                          : 'Already have an account? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: ResponsiveDimensions.f(14),
                      ),
                    ),
                    GestureDetector(
                      onTap: controller.goToLogin,
                      child: Text(
                        isRTL ? 'تسجيل الدخول' : 'Login',
                        style: TextStyle(
                          color: const Color(0xFF0071A7),
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveDimensions.f(14),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ResponsiveDimensions.h(40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}