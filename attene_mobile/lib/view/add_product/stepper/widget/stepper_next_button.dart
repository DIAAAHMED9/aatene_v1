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
    });
  }
}