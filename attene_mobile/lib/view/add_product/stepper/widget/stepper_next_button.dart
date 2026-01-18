import '../../../../general_index.dart';

class StepperNextButton extends StatelessWidget {
  final RxBool isSubmitting;
  final int currentStep;
  final int totalSteps;
  final VoidCallback onNext;
  final VoidCallback onFinish;

  const StepperNextButton({
    super.key,
    required this.isSubmitting,
    required this.currentStep,
    required this.totalSteps,
    required this.onNext,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final submitting = isSubmitting.value;
      final isLast = currentStep == totalSteps - 1;

      return AateneButton(
        onTap: submitting ? null : (isLast ? onFinish : onNext),

        buttonText: isLast ? 'إنهاء وإرسال' : 'التالي',
        color: AppColors.primary400,
        textColor: AppColors.light1000,
        borderColor: AppColors.primary400,
      );

      // ElevatedButton(
      //   onPressed: submitting ? null : (isLast ? onFinish : onNext),
      //   style: ElevatedButton.styleFrom(
      //     padding: const EdgeInsets.symmetric(vertical: 16),
      //     backgroundColor: AppColors.primary400,
      //     foregroundColor: Colors.white,
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(12),
      //     ),
      //     elevation: 3,
      //   ),
      //   child: submitting
      //       ? const SizedBox(
      //           height: 20,
      //           width: 20,
      //           child: CircularProgressIndicator(
      //             strokeWidth: 2,
      //             valueColor: AlwaysStoppedAnimation<Color>(
      //               AppColors.primary400,
      //             ),
      //           ),
      //         )
      //       : Padding(
      //           padding: const EdgeInsets.symmetric(horizontal: 24),
      //           child: Text(
      //             isLast ? 'إنهاء وإرسال' : 'التالي',
      //             style: getMedium(color: Colors.white),
      //           ),
      //         ),
      // );
    });
  }
}
