import '../../../../general_index.dart';
import '../../../../utils/responsive/index.dart';

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
      appBar: AppBar(
        backgroundColor: Colors.white,
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
                // Align(
                //   alignment: isRTL ? Alignment.topRight : Alignment.topLeft,
                //   child:  IconButton(
                //     onPressed: () => Get.back(),
                //     icon: Container(
                //       width: 50,
                //       height: 50,
                //       decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(100),
                //         color: Colors.grey[100],
                //       ),
                //       child: Icon(Icons.arrow_back, color: AppColors.neutral100),
                //     ),
                //   ),
                // ),
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
