import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../component/aatene_button.dart';
import '../../../utlis/colors/app_color.dart';
import '../../../utlis/language/language_utils.dart';
import 'verfication_controller.dart';

class VerificationCodeField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) onChanged;
  final bool hasError;
  final bool autoFocus;
  final VoidCallback? onDelete; 
  const VerificationCodeField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.hasError,
    this.autoFocus = false,
    this.onDelete,
  });
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveDimensions.w(60),
      height: ResponsiveDimensions.h(60),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autoFocus,
        onChanged: (value) {
          onChanged(value);
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
        onTap: () {
          controller.selection = TextSelection(
            baseOffset: 0,
            extentOffset: controller.text.length,
          );
        },
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasError ? Colors.red : Colors.grey[300]!,
              width: hasError ? 2.0 : 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasError ? Colors.red : Colors.grey[300]!,
              width: hasError ? 2.0 : 1.0,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasError ? Colors.red : Colors.blue,
              width: hasError ? 2.0 : 1.0,
            ),
          ),
          filled: true,
          fillColor: hasError ? Colors.red.withOpacity(0.05) : Colors.grey[50],
        ),
        style: TextStyle(
          fontSize: ResponsiveDimensions.f(20),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
class Verification extends StatelessWidget {
  final VerificationController controller = Get.put(VerificationController());
  Verification({super.key});
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
                  alignment: isRTL ? Alignment.topLeft : Alignment.topRight,
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
                          offset: Offset(0, 2),
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
                  isRTL ? 'تأكد من رقم الهاتف' : 'Verify Phone Number',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(35),
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveDimensions.w(20),
                    vertical: ResponsiveDimensions.h(20),
                  ),
                  child: Text(
                    isRTL
                        ? 'لقد ارسلنا رمز التحقق الى +972599084404 اذا لم يتم تسلمها. فانقر فوق اعادة رمز التحقق'
                        : 'We have sent a verification code to +972599084404 If you didn\'t receive it, click Resend',
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.f(16),
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(30)),
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(5, (index) {
                    return VerificationCodeField(
                      controller: TextEditingController(text: controller.codes[index]),
                      focusNode: controller.focusNodes[index],
                      onChanged: (value) => controller.updateCode(index, value),
                      hasError: controller.errorMessage.isNotEmpty,
                      autoFocus: index == 0, 
                    );
                  }),
                )),
SizedBox(height: ResponsiveDimensions.h(200)),
                Obx(() => controller.errorMessage.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.only(
                          top: ResponsiveDimensions.h(16),
                          right: isRTL ? 0 : ResponsiveDimensions.w(12),
                          left: isRTL ? ResponsiveDimensions.w(12) : 0,
                        ),
                        child: Text(
                          controller.errorMessage.value,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: ResponsiveDimensions.f(14),
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: isRTL ? TextAlign.right : TextAlign.left,
                        ),
                      )
                    : SizedBox()),
                SizedBox(height: ResponsiveDimensions.h(50)),
   Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isRTL ? 'لم تستلم الرمز؟ ' : 'Didn\'t receive code? ',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: ResponsiveDimensions.f(14),
                      ),
                    ),
                    if (controller.canResend.value)
                      GestureDetector(
                        onTap: controller.isLoading.value ? null : controller.resendCode,
                        child: Text(
                          isRTL ? 'إعادة الإرسال' : 'Resend',
                          style: TextStyle(
                            color: AppColors.primary400,
                            fontWeight: FontWeight.bold,
                            fontSize: ResponsiveDimensions.f(14),
                          ),
                        ),
                      )
                    else
                      Text(
                        isRTL ? 
                          'إعادة الإرسال خلال ${controller.resendCountdown.value} ثانية' :
                          'Resend in ${controller.resendCountdown.value}s',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: ResponsiveDimensions.f(14),
                        ),
                      ),
                  ],
                )),
                SizedBox(height: ResponsiveDimensions.h(20)),
 Obx(
                  () => AateneButton(
                    textColor: Colors.white,
                    color: AppColors.primary400,
                    borderColor: AppColors.primary400,
                    isLoading: controller.isLoading.value,
                    onTap: controller.isLoading.value ? null : controller.verifyCode,
                    buttonText: isRTL ? 'تحقق' : 'Verify',
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