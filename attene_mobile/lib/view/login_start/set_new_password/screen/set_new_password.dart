import '../../../../general_index.dart';
import '../../../../utils/responsive/responsive_dimensions.dart';

class SetNewPassword extends StatelessWidget {
  final SetNewPasswordController controller = Get.put(
    SetNewPasswordController(),
  );

  SetNewPassword({super.key});

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
                //   alignment: isRTL ? Alignment.topLeft : Alignment.topRight,
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
                  isRTL ? 'أعد ضبط كلمة المرور' : 'Reset Password',
                  style: getBold(fontSize: ResponsiveDimensions.f(35)),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveDimensions.w(20),
                    vertical: ResponsiveDimensions.h(10),
                  ),
                  child: Text(
                    isRTL
                        ? 'قم بإنشاء كلمة مرور جديدة'
                        : 'Create a new password',
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.f(16),
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(20)),
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
                    textInputAction: TextInputAction.next,
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
                    textInputAction: TextInputAction.done,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(20)),
                Obx(
                  () => AateneButton(
                    textColor: Colors.white,
                    color: AppColors.primary400,
                    borderColor: AppColors.primary400,
                    isLoading: controller.isLoading.value,
                    onTap: controller.isLoading.value ? null : () {},
                    buttonText: isRTL ? 'تحديث' : 'Update',
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
