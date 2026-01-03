

import '../../../../general_index.dart';
import '../../../../utlis/responsive/index.dart';

class ForgetPassword extends StatelessWidget {
  final ForgetPasswordController controller = Get.put(
    ForgetPasswordController(),
  );

  ForgetPassword({super.key});

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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Align(
                  alignment: isRTL ? Alignment.topRight : Alignment.topLeft,
                  child: Container(
                    height: ResponsiveDimensions.h(40),
                    width: ResponsiveDimensions.w(40),
                    padding: EdgeInsets.all(ResponsiveDimensions.w(8)),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300]!,
                          blurRadius: 1,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(
                        isRTL ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                        color: Colors.black,
                        size: ResponsiveDimensions.f(16),
                      ),
                      onPressed: controller.goBack,
                    ),
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(60)),
                Text(
                  isRTL ? 'إعادة تعيين كلمة المرور' : 'Reset Password',
                  style: getBold(fontSize: ResponsiveDimensions.f(35)),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveDimensions.w(20),
                    vertical: ResponsiveDimensions.h(20),
                  ),
                  child: Text(
                    isRTL
                        ? 'الرجاء إدخال بريدك الإلكتروني لطلب إعادة تعيين كلمة المرور'
                        : 'Please enter your email to request a password reset',
                    style: getRegular(color: AppColors.colorForgetPassword),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(30)),
                Obx(
                  () => TextFiledAatene(
                    isRTL: isRTL,
                    hintText: isRTL ? 'البريد الإلكتروني' : 'Email',
                    errorText: controller.emailError.value,
                    onChanged: controller.updateEmail,
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(50)),
                Obx(
                  () => AateneButton(
                    textColor: Colors.white,
                    color: AppColors.primary400,
                    borderColor: AppColors.primary400,
                    isLoading: controller.isLoading.value,
                    onTap: controller.isLoading.value
                        ? null
                        : controller.sendPasswordReset,
                    buttonText: isRTL ? 'أرسل رابط التعيين' : 'Send Reset Link',
                  ),
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