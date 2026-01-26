import '../../../../component/custom_stepper/stepper_step.dart';
import '../../../../general_index.dart';
import '../../../../utils/responsive/index.dart';

class ServiceStepperScreen extends StepperScreenBase {
  final bool isEditMode;
  final String? serviceId;

  const ServiceStepperScreen({
    Key? key,
    this.isEditMode = false,
    this.serviceId,
  }) : super(
         key: key,
         appBarTitle: isEditMode ? 'تعديل الخدمة' : 'إضافة خدمة جديدة',
         primaryColor: AppColors.primary400,
         showBackButton: true,
         isLinear: true,
       );

  @override
  State<ServiceStepperScreen> createState() => _ServiceStepperScreenState();
}

class _ServiceStepperScreenState
    extends StepperScreenBaseState<ServiceStepperScreen> {
  @override
  List<StepperStep> getSteps() {
    return [
      const StepperStep(
        title: 'معلومات الخدمة',
        subtitle: 'المعلومات الأساسية والتصنيفات',
      ),
      const StepperStep(
        title: 'السعر والتطويرات',
        subtitle: 'تحديد السعر ومدة التنفيذ',
      ),
      const StepperStep(title: 'صور الخدمة', subtitle: 'إضافة صور للخدمة'),
      const StepperStep(
        title: 'الوصف والأسئلة الشائعة',
        subtitle: 'وصف الخدمة والأسئلة المتكررة',
      ),
      const StepperStep(
        title: 'الموافقة النهائية',
        subtitle: 'الموافقة على السياسات والشروط',
      ),
    ];
  }

  @override
  Widget buildStepContent(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return ServiceScreen();
      case 1:
        return PriceScreen();
      case 2:
        return ImagesScreen();
      case 3:
        return DescriptionScreen();
      case 4:
        return const PolicyScreen();
      default:
        return ServiceScreen();
    }
  }

  @override
  Future<void> initializeControllers() async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Get.isRegistered<ServiceController>()) {
        Get.put(ServiceController(), permanent: true);
      }

      final controller = Get.find<ServiceController>();

      if (widget.isEditMode && widget.serviceId != null) {
        controller.loadServiceForEditing(widget.serviceId!);
      }
    });
  }

  @override
  Future<bool> onWillPop() async {
    final controller = Get.find<ServiceController>();

    if (currentStep > 0 || controller.serviceTitle.value.isNotEmpty) {
      final result = await Get.defaultDialog<bool>(
        title: 'تأكيد',
        middleText: 'هل تريد حفظ التغييرات قبل المغادرة؟',
        // textConfirm: 'حفظ مؤقت',
        // textCancel: 'تجاهل والخروج',
        // confirmTextColor: Colors.white,
        actions: [
          AateneButton(
            onTap: () async {
              await _saveProgress();
              Get.back(result: true);
            },
            buttonText: 'حفظ مؤقت',
            color: AppColors.primary400,
            textColor: AppColors.light1000,
            borderColor: AppColors.primary400,
          ),
          SizedBox(height: 10),
          AateneButton(
            onTap: () => Get.back(result: true),
            buttonText: 'تجاهل والخروج',
            color: AppColors.light1000,
            textColor: AppColors.primary400,
            borderColor: AppColors.primary400,
          ),
        ],

        // onConfirm: () async {
        //   await _saveProgress();
        //   Get.back(result: true);
        // },
        // onCancel: () => Get.back(result: true),
      );
      return result ?? false;
    }
    return true;
  }

  @override
  void onStepChanged(int oldStep, int newStep) {
    final controller = Get.find<ServiceController>();

    if (oldStep < newStep) {
      switch (oldStep) {
        case 0:
          if (!controller.validateServiceForm()) {
            Get.snackbar(
              'تنبيه',
              'يرجى إكمال معلومات الخدمة أولاً',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            setState(() {
              currentStep = oldStep;
            });
          }
          break;
        case 1:
          if (!controller.validatePriceForm()) {
            Get.snackbar(
              'تنبيه',
              'يرجى إكمال السعر و أولاً',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            setState(() {
              currentStep = oldStep;
            });
          }
          break;
        case 2:
          if (!controller.validateImagesForm()) {
            Get.snackbar(
              'تنبيه',
              'يجب إضافة صورة واحدة على الأقل',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            setState(() {
              currentStep = oldStep;
            });
          }
          break;
        case 3:
          if (!controller.validateDescriptionForm()) {
            Get.snackbar(
              'تنبيه',
              'يرجى إدخال وصف للخدمة أولاً',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
            );
            setState(() {
              currentStep = oldStep;
            });
          }
          break;
      }
    }
  }

  @override
  bool validateStep(int stepIndex) {
    final controller = Get.find<ServiceController>();

    switch (stepIndex) {
      case 0:
        if (!controller.validateServiceForm()) {
          Get.snackbar(
            'خطأ',
            'يرجى إكمال معلومات الخدمة أولاً',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
        return true;

      case 1:
        if (!controller.validatePriceForm()) {
          Get.snackbar(
            'خطأ',
            'يرجى إكمال السعر و أولاً',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
        return true;

      case 2:
        if (!controller.validateImagesForm()) {
          Get.snackbar(
            'خطأ',
            'يجب إضافة صورة واحدة على الأقل',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
        return true;

      case 3:
        if (!controller.validateDescriptionForm()) {
          Get.snackbar(
            'خطأ',
            'يرجى إدخال وصف للخدمة أولاً',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
        return true;

      case 4:
        if (!controller.validatePoliciesForm()) {
          return false;
        }
        return true;

      default:
        return true;
    }
  }

  @override
  Future<void> onFinish() async {
    await _submitService();
  }

  @override
  Future<void> onCancel() async {
    final result = await Get.defaultDialog<bool>(
      title: 'تأكيد الإلغاء',
      middleText: 'هل أنت متأكد من إلغاء عملية إضافة/تعديل الخدمة؟',
      actions: [
        AateneButton(
          onTap: () {
            Get.back(result: true);
            Get.back();
          },
          buttonText: "لا، استمر",
          textColor: AppColors.light1000,
          borderColor: AppColors.primary400,
          color: AppColors.primary400,
        ),
        SizedBox(height: 10),
        AateneButton(
          onTap: () => Get.back(result: false),
          buttonText: "نعم، إلغاء",
          textColor: AppColors.primary400,
          borderColor: AppColors.primary400,
          color: AppColors.light1000,
        ),
      ],

      // textConfirm: 'نعم، إلغاء',
      // textCancel: 'لا، استمر',
      // confirmTextColor: Colors.white,
      // cancelTextColor: AppColors.primary400,
      // buttonColor: AppColors.primary400,
      // onConfirm: () {

      // },
      // onCancel: () => Get.back(result: false),
    );
  }

  @override
  Widget buildNextButton() {
    final controller = Get.find<ServiceController>();

    return Obx(() {
      final isSubmitting = controller.isSaving.value;
      final isLastStep = currentStep == steps.length - 1;
      final isEditMode = controller.isInEditMode;

      return ElevatedButton(
        onPressed: isSubmitting || controller.isUploading.value
            ? null
            : () {
                if (validateStep(currentStep)) {
                  if (isLastStep) {
                    onFinish();
                  } else {
                    nextStep();
                  }
                }
              },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: widget.primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          elevation: 3,
        ),
        child: isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  isLastStep
                      ? isEditMode
                            ? 'تحديث الخدمة'
                            : 'إنهاء ونشر الخدمة'
                      : 'التالي',
                  style: getMedium(color: Colors.white, fontSize: 14),
                ),
              ),
      );
    });
  }

  Future<void> _saveProgress() async {
    final controller = Get.find<ServiceController>();
    final data = controller.getAllData();

    await Future.delayed(const Duration(milliseconds: 500));

    Get.snackbar(
      'تم الحفظ',
      'تم حفظ التقدم بنجاح',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  Future<void> _submitService() async {
    final controller = Get.find<ServiceController>();

    try {
      if (!controller.validateAllForms()) {
        Get.snackbar(
          'خطأ',
          'يرجى ملء جميع الحقول المطلوبة',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      final result = await controller.saveService();

      if (result == null) {
        Get.snackbar(
          'خطأ',
          'فشل في إضافة/تحديث الخدمة',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (result['success'] == true) {
        _showSuccessDialog(result, controller.isInEditMode);
      } else {
        Get.snackbar(
          'خطأ',
          result['message'] ?? 'حدث خطأ غير معروف',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _showSuccessDialog(Map<String, dynamic> result, bool isEditMode) {
    Get.bottomSheet(
      Container(
        height: ResponsiveDimensions.h(500),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),

        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.check_circle,
                size: 170,
                color: Colors.green,
                shadows: [
                  Shadow(
                    blurRadius: 30,
                    color: AppColors.success100,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                isEditMode ? 'تم تحديث خدمتك بنجاح' : 'تم رفع خدمتك بنجاح',
                style: getBold(fontSize: 18, color: AppColors.primary400),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),

              Text(
                'تم رفع الخدمة بنجاح، وهي الآن قيد المراجعة من قبل الفريق المختص. سنوافيكم بالرد خلال 24 إلى 48 ساعة.',
                style: getBold(fontSize: 14, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),

              AateneButton(
                buttonText: 'قائمة الخدمات',
                color: AppColors.primary400,
                textColor: Colors.white,
                borderColor: AppColors.primary400,
                onTap: () {
                  // 1) إغلاق الـ BottomSheet
                  if (Get.isBottomSheetOpen == true) {
                    Get.back();
                  }

                  // 2) تنظيف بيانات الكنترولر
                  if (Get.isRegistered<ServiceController>()) {
                    Get.find<ServiceController>().resetAll();
                  }

                  // 3) الرجوع للشاشة السابقة مع نتيجة نجاح
                  // حتى تقوم شاشة القائمة بعمل Refresh مثل المنتجات
                  Get.back(result: true);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildPreviousButton() {
    return AateneButton(
      onTap: currentStep > 0 ? previousStep : null,
      buttonText: "السابق",
      textColor: AppColors.light1000,
      borderColor: AppColors.primary400,
      color: AppColors.primary400,
    );

    //   ElevatedButton(
    //   onPressed: currentStep > 0 ? previousStep : null,
    //   style: ElevatedButton.styleFrom(
    //     padding: const EdgeInsets.symmetric(vertical: 16),
    //     backgroundColor: Colors.grey[300],
    //     foregroundColor: Colors.grey[700],
    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    //     elevation: 1,
    //   ),
    //   child: const Padding(
    //     padding: EdgeInsets.symmetric(horizontal: 24),
    //     child: Text('السابق'),
    //   ),
    // );
  }

  @override
  Widget buildExtraButtons() {
    return TextButton(
      onPressed: () async {
        await _saveProgress();
      },
      child: Text(
        'حفظ مؤقت',
        style: getRegular(fontSize: 14, color: Colors.grey),
      ),
    );
  }
}
