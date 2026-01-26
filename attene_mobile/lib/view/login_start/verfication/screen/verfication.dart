import '../../../../general_index.dart';
import '../../../../utils/responsive/responsive_dimensions.dart';

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
        style: getBold(fontSize: ResponsiveDimensions.f(20)),
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
                  isRTL ? 'تأكد من رقم الهاتف' : 'Verify Phone Number',
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
                        ? 'لقد ارسلنا رمز التحقق الى +972599084404 اذا لم يتم تسلمها. فانقر فوق اعادة رمز التحقق'
                        : 'We have sent a verification code to +972599084404 If you didn\'t receive it, click Resend',
                    style: getRegular(
                      fontSize: ResponsiveDimensions.f(16),
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(30)),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (index) {
                      return VerificationCodeField(
                        controller: TextEditingController(
                          text: controller.codes[index],
                        ),
                        focusNode: controller.focusNodes[index],
                        onChanged: (value) =>
                            controller.updateCode(index, value),
                        hasError: controller.errorMessage.isNotEmpty,
                        autoFocus: index == 0,
                      );
                    }),
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(200)),
                Obx(
                  () => controller.errorMessage.isNotEmpty
                      ? Padding(
                          padding: EdgeInsets.only(
                            top: ResponsiveDimensions.h(16),
                            right: isRTL ? 0 : ResponsiveDimensions.w(12),
                            left: isRTL ? ResponsiveDimensions.w(12) : 0,
                          ),
                          child: Text(
                            controller.errorMessage.value,
                            style: getRegular(
                              color: Colors.red,
                              fontSize: ResponsiveDimensions.f(14),
                            ),
                            textAlign: isRTL ? TextAlign.right : TextAlign.left,
                          ),
                        )
                      : SizedBox(),
                ),
                SizedBox(height: ResponsiveDimensions.h(50)),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isRTL ? 'لم تستلم الرمز؟ ' : 'Didn\'t receive code? ',
                        style: getRegular(
                          color: Colors.grey,
                          fontSize: ResponsiveDimensions.f(14),
                        ),
                      ),
                      if (controller.canResend.value)
                        GestureDetector(
                          onTap: controller.isLoading.value
                              ? null
                              : controller.resendCode,
                          child: Text(
                            isRTL ? 'إعادة الإرسال' : 'Resend',
                            style: getBold(
                              color: AppColors.primary400,
                              fontSize: ResponsiveDimensions.f(14),
                            ),
                          ),
                        )
                      else
                        Text(
                          isRTL
                              ? 'إعادة الإرسال خلال ${controller.resendCountdown.value} ثانية'
                              : 'Resend in ${controller.resendCountdown.value}s',
                          style: getRegular(
                            color: Colors.grey,
                            fontSize: ResponsiveDimensions.f(14),
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(20)),
                Obx(
                  () => AateneButton(
                    textColor: Colors.white,
                    color: AppColors.primary400,
                    borderColor: AppColors.primary400,
                    isLoading: controller.isLoading.value,
                    onTap: controller.isLoading.value
                        ? null
                        : controller.verifyCode,
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
