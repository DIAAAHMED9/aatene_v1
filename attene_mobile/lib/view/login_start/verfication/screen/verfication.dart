import '../../../../general_index.dart';
import '../../../../utils/responsive/responsive_dimensions.dart';

class VerificationCodeField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final bool hasError;
  final bool autoFocus;

  const VerificationCodeField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.hasError,
    this.autoFocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ResponsiveDimensions.w(54),
      height: ResponsiveDimensions.h(54),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        autofocus: autoFocus,
        onChanged: onChanged,
        textAlign: TextAlign.center,
        textAlignVertical: TextAlignVertical.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        cursorHeight: ResponsiveDimensions.h(20),
        decoration: InputDecoration(
          counterText: '',
          isDense: true,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasError ? Colors.red : Colors.grey[300]!,
              width: hasError ? 2.0 : 1.2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasError ? Colors.red : Colors.grey[300]!,
              width: hasError ? 2.0 : 1.2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: hasError ? Colors.red : AppColors.primary400,
              width: 1.6,
            ),
          ),
          filled: true,
          fillColor: hasError ? Colors.red.withOpacity(0.05) : Colors.grey[50],
        ),
        style: getBold(
          fontSize: ResponsiveDimensions.f(18),
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
            padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.w(20)),
            child: Column(
              children: [
                SizedBox(height: ResponsiveDimensions.h(50)),
                Text(
                  isRTL ? 'تأكيد الرمز' : 'Verify Code',
                  style: getBold(fontSize: ResponsiveDimensions.f(32)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveDimensions.h(10)),
                Text(
                  isRTL
                      ? 'قم بإدخال رمز التحقق المكوّن من 4 أرقام'
                      : 'Enter the 4-digit verification code',
                  style: getRegular(
                    fontSize: ResponsiveDimensions.f(16),
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: ResponsiveDimensions.h(30)),

                Obx(() {
                  final len = controller.otpLength;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(len, (index) {
                      return VerificationCodeField(
                        controller: controller.textControllers[index],
                        focusNode: controller.focusNodes[index],
                        autoFocus: index == 0,
                        hasError: controller.errorMessage.value.isNotEmpty,
                        onChanged: (value) {
                          controller.setDigit(index, value);

                          final cleaned = value.replaceAll(RegExp(r'[^0-9]'), '');

                          if (cleaned.length > 1) {
                            final next = (index + cleaned.length) >= len
                                ? len - 1
                                : (index + cleaned.length);
                            FocusScope.of(context).requestFocus(controller.focusNodes[next]);
                            if (next == len - 1) FocusScope.of(context).unfocus();
                            return;
                          }

                          if (cleaned.isNotEmpty) {
                            if (index < len - 1) {
                              FocusScope.of(context).requestFocus(controller.focusNodes[index + 1]);
                            } else {
                              FocusScope.of(context).unfocus();
                            }
                          } else {
                            if (index > 0) {
                              FocusScope.of(context).requestFocus(controller.focusNodes[index - 1]);
                            }
                          }
                        },
                      );
                    }),
                  );
                }),

                SizedBox(height: ResponsiveDimensions.h(18)),
                Obx(
                  () => controller.errorMessage.value.isNotEmpty
                      ? Text(
                          controller.errorMessage.value,
                          style: getRegular(
                            color: Colors.red,
                            fontSize: ResponsiveDimensions.f(14),
                          ),
                          textAlign: TextAlign.center,
                        )
                      : const SizedBox.shrink(),
                ),

                SizedBox(height: ResponsiveDimensions.h(40)),

                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isRTL ? 'لم تستلم الرمز؟ ' : 'Didn\'t receive code? ',
                        style: getRegular(color: Colors.grey, fontSize: ResponsiveDimensions.f(14)),
                      ),
                      if (controller.canResend.value)
                        GestureDetector(
                          onTap: controller.isLoading.value ? null : controller.resendCode,
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
                          style: getRegular(color: Colors.grey, fontSize: ResponsiveDimensions.f(14)),
                        ),
                    ],
                  ),
                ),

                SizedBox(height: ResponsiveDimensions.h(16)),

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