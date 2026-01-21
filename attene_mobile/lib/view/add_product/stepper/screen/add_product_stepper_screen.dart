import '../../../../component/custom_stepper/stepper_step.dart';
import '../../../../general_index.dart';

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

      // ✅ IMPORTANT:
      // Controllers are registered as permanent to survive step navigation.
      // When user returns from Edit -> Add, previous edited product data may
      // still be stored in ProductCentralController and reflected in text fields.
      // So we must reset the whole add flow state when opening this screen.
      final central = Get.find<ProductCentralController>();
      final variation = Get.find<ProductVariationController>();

      // Preserve the selected section passed from the previous screen (Add flow)
      final Section? argSection = Get.arguments?['selectedSection'] as Section?;

      // Reset all shared data
      central.resetAllData();
      if (argSection != null) {
        central.selectedSection(argSection);
      }

      // Reset variations/related/keywords state
      variation.resetAllData();
      if (Get.isRegistered<RelatedProductsController>()) {
        Get.find<RelatedProductsController>().resetAll();
      }
      if (Get.isRegistered<KeywordController>()) {
        // Keyword controller reads from central; central is already reset.
        // Ensure its UI is refreshed.
        Get.find<KeywordController>().syncFromProductController();
      }

      // Reset step-1 text fields if controller already exists
      if (Get.isRegistered<AddProductController>()) {
        Get.find<AddProductController>().resetForNewProduct();
      }
    });
  }

  @override
  Future<bool> onWillPop() async {
    if (currentStep > 0) {
      final result = await Get.defaultDialog<bool>(
        title: 'تأكيد',
        middleText: 'هل تريد حفظ التغييرات قبل المغادرة؟',
        // textConfirm: 'حفظ والخروج',
        // textCancel:,
        actions: [
          AateneButton(
            onTap: () async {
              await _saveProgress();
              Get.back(result: true);
            },
            buttonText: 'حفظ والخروج',
            color: AppColors.primary400,
            textColor: AppColors.light1000,
            borderColor: AppColors.primary400,
          ),
          SizedBox(height: 10),
          AateneButton(
            onTap: () => Get.back(result: true),
            buttonText: 'الخروج بدون حفظ',
            color: AppColors.light1000,
            textColor: AppColors.primary400,
            borderColor: AppColors.primary400,
          ),
        ],

        // confirmTextColor: Colors.white,
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
    print('تم الانتقال من الخطوة $oldStep إلى الخطوة $newStep');

    if (oldStep < newStep && !validateStep(oldStep)) {
      setState(() {
        currentStep = oldStep;
      });
      return;
    }

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
      if (Get.isRegistered<AddProductController>()) {
        final addProductController = Get.find<AddProductController>();
        final validation = addProductController.validateStep();

        if (!validation['isValid']) {
          AddProductStepperDialogs.showStepErrors(
            errors: validation['errors'] ?? {},
            stepName: 'المعلومات الأساسية',
            fieldNameResolver: _getFieldDisplayName,
          );
          return false;
        }
        return true;
      }

      if (Get.isRegistered<ProductCentralController>()) {
        final productController = Get.find<ProductCentralController>();
        final validation = productController.validateStep(0);

        if (!validation['isValid']) {
          AddProductStepperDialogs.showStepErrors(
            errors: validation['errors'] ?? {},
            stepName: 'المعلومات الأساسية',
            fieldNameResolver: _getFieldDisplayName,
          );
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
    await AddProductStepperDialogs.confirmCancel();
  }

  @override
  Widget buildNextButton() {
    final productController = Get.find<ProductCentralController>();

    return StepperNextButton(
      isSubmitting: productController.isSubmitting,
      currentStep: currentStep,
      totalSteps: steps.length,
      onNext: () {
        if (validateStep(currentStep)) {
          nextStep();
        }
      },
      onFinish: () => onFinish(),
    );
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
        AddProductStepperDialogs.showSuccessDialog(
          result: result,
          onOk: () {
            Get.offAllNamed('/mainScreen');
            _resetControllers();
          },
        );
      } else {
        final errorMessage =
            result['message']?.toString() ?? 'فشل في إضافة المنتج';
        Get.snackbar('خطأ', errorMessage);
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع: $e');
    }
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
  Future<void> initializeControllers() async {
    print('🚀 [DEMO STEPPER] Initializing all required controllers');

    try {
      if (!Get.isRegistered<ProductCentralController>()) {
        Get.put<ProductCentralController>(
          ProductCentralController(),
          permanent: true,
        );
        print('✅ [DEMO STEPPER] ProductCentralController initialized');
      }

      if (!Get.isRegistered<ProductVariationController>()) {
        Get.put<ProductVariationController>(
          ProductVariationController(),
          permanent: true,
        );
        print('✅ [DEMO STEPPER] ProductVariationController initialized');
      }

      if (!Get.isRegistered<AddProductController>()) {
        Get.put<AddProductController>(AddProductController(), permanent: true);
        print('✅ [DEMO STEPPER] AddProductController initialized');
      }

      if (!Get.isRegistered<KeywordController>()) {
        Get.put<KeywordController>(KeywordController(), permanent: true);
        print('✅ [DEMO STEPPER] KeywordController initialized');
      }

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
