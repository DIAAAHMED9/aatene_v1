import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:attene_mobile/view/advance%20info/keyword_controller.dart';
import 'package:attene_mobile/view/advance%20info/keyword_management_screen.dart';
import 'package:attene_mobile/view/product%20variations/product_variation_controller.dart';
import 'package:attene_mobile/view/product%20variations/product_variations_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/controller/product_controller.dart';
import 'package:attene_mobile/view/related_products/related_products_screen.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/add_product.dart';

import 'component/custom_stepper/responsive_custom_stepper.dart';
import 'component/custom_stepper/stepper_screen_base.dart';
import 'utlis/colors/app_color.dart';
import 'view/related_products/related_products_controller.dart';
import 'view/screens_navigator_bottom_bar/product/add_product_controller.dart';

class DemoStepperScreen extends StepperScreenBase {
  const DemoStepperScreen({Key? key})
    : super(
        key: key,
        appBarTitle: 'إضافة منتج جديد',
        primaryColor: AppColors.light1000,
        showBackButton: true,
        isLinear: true,
      );

  @override
  State<DemoStepperScreen> createState() => _DemoStepperScreenState();
}

class _DemoStepperScreenState
    extends StepperScreenBaseState<DemoStepperScreen> {
  final Map<int, bool> _stepValidationStatus = {
    0: false,
    1: false,
    2: false,
    3: false,
  };

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  @override
  List<StepperStep> getSteps() {
    return [
      const StepperStep(
        title: 'المعلومات الأساسية',
        subtitle: 'بيانات المنتج الأساسية',
      ),
      const StepperStep(
        title: 'الكلمات المفتاحية',
        subtitle: 'إدارة الكلمات المفتاحية',
      ),
      const StepperStep(
        title: 'المتغيرات',
        subtitle: 'إدارة السمات والمتغيرات',
      ),
      const StepperStep(
        title: 'المنتجات المرتبطة',
        subtitle: 'إدارة المنتجات المرتبطة',
      ),
    ];
  }

  @override
  Widget buildStepContent(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return AddProductContent();
      case 1:
        return const KeywordManagementScreen();
      case 2:
        return const ProductVariationsScreen();
      case 3:
        return const RelatedProductsScreen();
      default:
        return Center(child: Text('محتوى الخطوة ${stepIndex + 1}'));
    }
  }

  void _initializeControllers() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!Get.isRegistered<ProductCentralController>()) {
        Get.put(ProductCentralController(), permanent: true);
      }
      if (!Get.isRegistered<ProductVariationController>()) {
        Get.put(ProductVariationController(), permanent: true);
      }
    });
  }

  @override
  Future<bool> onWillPop() async {
    if (currentStep > 0) {
      final result = await Get.defaultDialog<bool>(
        title: 'تأكيد',
        middleText: 'هل تريد حفظ التغييرات قبل المغادرة؟',
        textConfirm: 'حفظ والخروج',
        textCancel: 'الخروج بدون حفظ',
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
    print('تم الانتقال من الخطوة $oldStep إلى الخطوة $newStep');

    // Validate current step before moving forward
    if (oldStep < newStep && !validateStep(oldStep)) {
      // Prevent moving to next step
      setState(() {
        currentStep = oldStep;
      });
      return;
    }

    // Mark step as validated if moving forward successfully
    if (oldStep < newStep && validateStep(oldStep)) {
      _stepValidationStatus[oldStep] = true;
    }

    super.onStepChanged(oldStep, newStep);
  }

  @override
  bool validateStep(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return _validateBasicInfoStep();

      case 2:
        return _validateVariationsStep();

      default:
        return true;
    }
  }

  bool _validateBasicInfoStep() {
    try {
      // Try to use AddProductController first
      if (Get.isRegistered<AddProductController>()) {
        final addProductController = Get.find<AddProductController>();
        final validation = addProductController.validateStep();

        if (!validation['isValid']) {
          _showStepErrors(validation['errors'] ?? {}, 'المعلومات الأساسية');
          return false;
        }
        return true;
      }

      // Fallback to ProductCentralController
      if (Get.isRegistered<ProductCentralController>()) {
        final productController = Get.find<ProductCentralController>();
        final validation = productController.validateStep(0);

        if (!validation['isValid']) {
          _showStepErrors(validation['errors'] ?? {}, 'المعلومات الأساسية');
          return false;
        }
        return true;
      }

      return false;
    } catch (e) {
      print('❌ [STEP VALIDATION] Error validating step 0: $e');
      return false;
    }
  }

  bool _validateVariationsStep() {
    try {
      if (Get.isRegistered<ProductVariationController>()) {
        final variationController = Get.find<ProductVariationController>();

        if (variationController.hasVariations) {
          final validation = variationController.validateVariations();
          if (!validation.isValid) {
            Get.snackbar(
              'خطأ في المتغيرات',
              validation.errorMessage,
              backgroundColor: Colors.red,
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
            return false;
          }
        }
        return true;
      }
      return false;
    } catch (e) {
      print('❌ [STEP VALIDATION] Error validating step 2: $e');
      return false;
    }
  }

  void _showStepErrors(Map<String, String> errors, String stepName) {
    if (errors.isEmpty) return;

    final errorMessages = errors.entries
        .map((e) {
          final fieldName = _getFieldDisplayName(e.key);
          return '• ${e.value} ($fieldName)';
        })
        .join('\n');

    Get.dialog(
      AlertDialog(
        title: Text('أخطاء في $stepName'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('يوجد أخطاء في الحقول التالية:'),
              const SizedBox(height: 10),
              Text(errorMessages, style: getRegular(color: Colors.red)),
              const SizedBox(height: 20),
              Text(
                'يرجى تصحيح هذه الأخطاء قبل المتابعة',
                style: getRegular(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('حسناً', style: getRegular()),
          ),
        ],
      ),
    );
  }

  String _getFieldDisplayName(String fieldKey) {
    switch (fieldKey) {
      case 'productName':
        return 'اسم المنتج';
      case 'productDescription':
        return 'وصف المنتج';
      case 'price':
        return 'السعر';
      case 'category':
        return 'الفئة';
      case 'condition':
        return 'الحالة';
      case 'media':
        return 'الصور';
      case 'section':
        return 'القسم';
      case 'variations':
        return 'المتغيرات';
      default:
        return fieldKey;
    }
  }

  @override
  Future<void> onFinish() async {
    // Validate all steps before finishing
    bool allValid = true;
    for (int i = 0; i < steps.length; i++) {
      if (!validateStep(i)) {
        allValid = false;
        setState(() {
          currentStep = i;
        });
        break;
      }
    }

    if (allValid) {
      await _submitProduct();
    }
  }

  @override
  Future<void> onCancel() async {
    final result = await Get.defaultDialog<bool>(
      title: 'تأكيد الإلغاء',
      middleText: 'هل أنت متأكد من إلغاء عملية إضافة المنتج؟',
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
    final productController = Get.find<ProductCentralController>();

    return Obx(() {
      final isSubmitting = productController.isSubmitting.value;

      return ElevatedButton(
        onPressed: isSubmitting
            ? null
            : () {
                if (currentStep < steps.length - 1) {
                  if (validateStep(currentStep)) {
                    nextStep();
                  }
                } else {
                  onFinish();
                }
              },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppColors.primary400,
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
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.primary400,
                  ),
                ),
              )
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  currentStep == steps.length - 1 ? 'إنهاء وإرسال' : 'التالي',
                  style: getMedium(),
                ),
              ),
      );
    });
  }

  Future<void> _saveProgress() async {
    Get.snackbar(
      'تم الحفظ',
      'تم حفظ التقدم بنجاح',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> _submitProduct() async {
    final productController = Get.find<ProductCentralController>();

    try {
      final result = await productController.submitProduct();

      if (result == null) {
        Get.snackbar(
          'خطأ',
          'فشل في إضافة المنتج',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (result['success'] == true) {
        _showSuccessDialog(result);
      } else {
        final errorMessage =
            result['message']?.toString() ?? 'فشل في إضافة المنتج';
        Get.snackbar('خطأ', errorMessage);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع: $e');
    }
  }

  void _showSuccessDialog(Map<String, dynamic> result) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text(
              'تمت العملية بنجاح!',

              style: getBlack(color: Colors.green, fontSize: 20),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.shopping_bag_rounded,
              size: 60,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            Text(
              'تم إضافة المنتج بنجاح',
              style: getMedium(color: Colors.black87, fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            if (result['data'] != null && result['data'] is List)
              Text(
                'رقم المنتج: ${_extractProductSku(result)}',
                style: getRegular(fontSize: 14, color: Colors.grey),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.offAllNamed('/mainScreen');
              _resetControllers();
            },
            child: Text('حسناً', style: getMedium(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  String _extractProductSku(Map<String, dynamic> result) {
    try {
      if (result['data'] is List && (result['data'] as List).isNotEmpty) {
        final firstItem = result['data'][0] as Map<String, dynamic>;
        return firstItem['sku']?.toString() ?? 'N/A';
      }
    } catch (e) {
      print('Error extracting SKU: $e');
    }
    return 'N/A';
  }

  void _resetControllers() {
    final productController = Get.find<ProductCentralController>();
    productController.reset();

    final variationController = Get.find<ProductVariationController>();
    variationController.resetAllData();

    setState(() {
      currentStep = 0;
      _stepValidationStatus.clear();
      _stepValidationStatus[0] = false;
      _stepValidationStatus[1] = false;
      _stepValidationStatus[2] = false;
      _stepValidationStatus[3] = false;
    });
  }

  @override
  void initializeControllers() {
    print('🚀 [DEMO STEPPER] Initializing all required controllers');

    try {
      // تهيئة ProductCentralController (المتحكم الرئيسي)
      if (!Get.isRegistered<ProductCentralController>()) {
        Get.put<ProductCentralController>(
          ProductCentralController(),
          permanent: true,
        );
        print('✅ [DEMO STEPPER] ProductCentralController initialized');
      }

      // تهيئة ProductVariationController (للمتغيرات)
      if (!Get.isRegistered<ProductVariationController>()) {
        Get.put<ProductVariationController>(
          ProductVariationController(),
          permanent: true,
        );
        print('✅ [DEMO STEPPER] ProductVariationController initialized');
      }

      // تهيئة AddProductController (للمعلومات الأساسية)
      if (!Get.isRegistered<AddProductController>()) {
        Get.put<AddProductController>(AddProductController(), permanent: true);
        print('✅ [DEMO STEPPER] AddProductController initialized');
      }

      // تهيئة KeywordController (للكلمات المفتاحية)
      if (!Get.isRegistered<KeywordController>()) {
        Get.put<KeywordController>(KeywordController(), permanent: true);
        print('✅ [DEMO STEPPER] KeywordController initialized');
      }

      // تهيئة RelatedProductsController (للمنتجات المرتبطة)
      if (!Get.isRegistered<RelatedProductsController>()) {
        Get.put<RelatedProductsController>(
          RelatedProductsController(),
          permanent: true,
        );
        print('✅ [DEMO STEPPER] RelatedProductsController initialized');
      }

      print('✅ [DEMO STEPPER] All controllers initialized successfully');
    } catch (e) {
      print('❌ [DEMO STEPPER] Error initializing controllers: $e');
    }
  }
}
