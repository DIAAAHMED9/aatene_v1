import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/view/add_services/service_controller.dart';
import 'package:attene_mobile/view/add_services/service_screen.dart';
import 'package:attene_mobile/view/add_services/price_screen.dart';
import 'package:attene_mobile/view/add_services/description_screen.dart';
import 'package:attene_mobile/view/add_services/images_screen.dart';
import 'package:attene_mobile/view/add_services/policy_screen.dart';

import '../component/custom_stepper/responsive_custom_stepper.dart';
import '../component/custom_stepper/stepper_screen_base.dart';
import 'component/aatene_button/aatene_button.dart';
import 'utlis/colors/app_color.dart';

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
          primaryColor: Colors.blue,
          showBackButton: true,
          isLinear: true,
        );

  @override
  State<ServiceStepperScreen> createState() => _ServiceStepperScreenState();
}

class _ServiceStepperScreenState extends StepperScreenBaseState<ServiceStepperScreen> {
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
      const StepperStep(
        title: 'صور الخدمة',
        subtitle: 'إضافة صور للخدمة',
      ),
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
      case 0: return ServiceScreen();
      case 1: return PriceScreen();
      case 2: return ImagesScreen();
      case 3: return DescriptionScreen();
      case 4: return const PolicyScreen();
      default: return ServiceScreen();
    }
  }

  @override
  void initializeControllers() {
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
        textConfirm: 'حفظ مؤقت',
        textCancel: 'تجاهل والخروج',
        confirmTextColor: Colors.white,
        onConfirm: () async {
          await _saveProgress();
          Get.back(result: true);
        },
        onCancel: () => Get.back(result: true),
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
              'يرجى إكمال السعر ومدة التنفيذ أولاً',
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
            'يرجى إكمال السعر ومدة التنفيذ أولاً',
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
      textConfirm: 'نعم، إلغاء',
      textCancel: 'لا، استمر',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back(result: true);
        Get.back();
      },
      onCancel: () => Get.back(result: false),
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
        onPressed: isSubmitting || controller.isUploading.value ? null : () {
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
            borderRadius: BorderRadius.circular(12),
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(25))
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.rocket_launch,
              size: 250,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              isEditMode
                ? 'تم تحديث خدمتك بنجاح'
                : 'تم رفع خدمتك بنجاح',
              style:  TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.primary400,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
        
            Text(
              'تم رفع الخدمة بنجاح، وهي الآن قيد المراجعة من قبل الفريق المختص. سنوافيكم بالرد خلال 24 إلى 48 ساعة.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),
                        const SizedBox(height: 10),

          AateneButton(
            buttonText: 'قائمة الرغبات',
            color: AppColors.primary400,
            textColor: Colors.white,
            onTap: () {
              Get.until((route) => route.isFirst);
              Get.find<ServiceController>().resetAll();
              setState(() {
                currentStep = 0;
              });
            },
          )
          ],
        ),
      )
    );
    // Get.dialog(
    //   AlertDialog(
    //     backgroundColor: Colors.white,
    //     shape: RoundedRectangleBorder(
    //       borderRadius: BorderRadius.circular(20),
    //     ),
    //     title: Row(
    //       children: [
    //         Icon(
    //           Icons.check_circle,
    //           color: Colors.green,
    //           size: 28
    //         ),
    //         const SizedBox(width: 12),
    //         Text(
    //           isEditMode ? 'تم التحديث بنجاح!' : 'تمت الإضافة بنجاح!',
    //           style: const TextStyle(
    //             fontSize: 20,
    //             fontWeight: FontWeight.w800,
    //             color: Colors.green,
    //           ),
    //         ),
    //       ],
    //     ),
    //     content: Column(
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Icon(
    //           Icons.rocket_launch,
    //           size: 60,
    //           color: Colors.green,
    //         ),
    //         const SizedBox(height: 20),
    //         Text(
    //           isEditMode
    //             ? 'تم تحديث خدمتك بنجاح'
    //             : 'تم نشر خدمتك بنجاح',
    //           style: const TextStyle(
    //             fontSize: 18,
    //             fontWeight: FontWeight.w600,
    //             color: Colors.black87,
    //           ),
    //           textAlign: TextAlign.center,
    //         ),
    //         const SizedBox(height: 10),
    //         if (result['service_id'] != null)
    //           Text(
    //             'رقم الخدمة: ${result['service_id']}',
    //             style: TextStyle(
    //               fontSize: 14,
    //               color: Colors.grey[600],
    //             ),
    //             textAlign: TextAlign.center,
    //           ),
    //         Text(
    //           'يمكنك الآن عرض الخدمة في قائمة خدماتك',
    //           style: TextStyle(
    //             fontSize: 14,
    //             color: Colors.grey[600],
    //           ),
    //           textAlign: TextAlign.center,
    //         ),
    //       ],
    //     ),
    //     actions: [
    //       TextButton(
    //         onPressed: () {
    //           Get.until((route) => route.isFirst);
    //           Get.find<ServiceController>().resetAll();
    //           setState(() {
    //             currentStep = 0;
    //           });
    //         },
    //         child: const Text(
    //           'حسناً',
    //           style: TextStyle(
    //             fontSize: 16,
    //             fontWeight: FontWeight.w600,
    //             color: Colors.blue,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }

  @override
  Widget buildPreviousButton() {
    return ElevatedButton(
      onPressed: currentStep > 0 ? previousStep : null,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.grey[700],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Text(
          'السابق',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildExtraButtons() {
    return TextButton(
      onPressed: () async {
        await _saveProgress();
      },
      child: const Text(
        'حفظ مؤقت',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey,
        ),
      ),
    );
  }
}