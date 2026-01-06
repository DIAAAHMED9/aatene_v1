import '../../../../component/custom_stepper/stepper_step.dart';
import '../../../../general_index.dart';

class EditProductStepperScreen extends StepperScreenBase {
  final int productId;

  const EditProductStepperScreen({Key? key, required this.productId})
      : super(
          key: key,
          appBarTitle: 'تعديل المنتج',
          primaryColor: AppColors.light1000,
          showBackButton: true,
          isLinear: true,
        );

  @override
  State<EditProductStepperScreen> createState() => _EditProductStepperScreenState();
}

class _EditProductStepperScreenState
    extends StepperScreenBaseState<EditProductStepperScreen> {
  final Map<int, bool> _stepValidationStatus = {
    0: false,
    1: false,
    2: false,
    3: false,
  };

  
  @override
  Future<void> initializeControllers() async {
    // This method is required by StepperScreenBaseState and is called in super.initState().
    try {
      if (!Get.isRegistered<ProductCentralController>()) {
        Get.put<ProductCentralController>(
          ProductCentralController(),
          permanent: true,
        );
      }

      if (!Get.isRegistered<ProductService>()) {
        Get.put<ProductService>(
          ProductService(),
          permanent: true,
        );
      }

      if (!Get.isRegistered<AddProductController>()) {
        Get.put<AddProductController>(
          AddProductController(),
          permanent: true,
        );
      }

      if (!Get.isRegistered<KeywordController>()) {
        Get.put<KeywordController>(
          KeywordController(),
          permanent: true,
        );
      }

      if (!Get.isRegistered<ProductVariationController>()) {
        Get.put<ProductVariationController>(
          ProductVariationController(),
          permanent: true,
        );
      }

      if (!Get.isRegistered<RelatedProductsController>()) {
        Get.put<RelatedProductsController>(
          RelatedProductsController(),
          permanent: true,
        );
      }
    } catch (e) {
      print('❌ [EDIT STEPPER] initializeControllers error: $e');
    }

    // Load and prefill after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final central = Get.find<ProductCentralController>();

        // Start from a clean state (important if user previously opened the add-stepper)
        central.resetAllData();

        await UnifiedLoadingScreen.showWithFuture<bool>(
          central.loadProductForEdit(widget.productId),
          message: 'جاري تحميل بيانات المنتج...',
        );

        // Sync UI text fields in basic info step (if needed)
        if (Get.isRegistered<AddProductController>()) {
          Get.find<AddProductController>().applyCentralToTextFields();
        }
        if (Get.isRegistered<KeywordController>()) {
          Get.find<KeywordController>().syncFromProductController();
        }
      } catch (e) {
        print('❌ [EDIT STEPPER] Failed to load product: $e');
      }
    });
  }


  @override
  List<StepperStep> getSteps() {
    return const [
      StepperStep(
        title: 'المعلومات الأساسية',
        subtitle: 'بيانات المنتج الأساسية',
      ),
      StepperStep(
        title: 'الكلمات المفتاحية',
        subtitle: 'إدارة الكلمات المفتاحية',
      ),
      StepperStep(
        title: 'المتغيرات',
        subtitle: 'إدارة السمات والمتغيرات',
      ),
      StepperStep(
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

  @override
  void onStepChanged(int oldStep, int newStep) {
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
    try {
      final productCentralController = Get.find<ProductCentralController>();
      final validation = productCentralController.validateStep(stepIndex);

      if (validation['isValid'] != true) {
        final errors = Map<String, String>.from(validation['errors'] ?? {});
        if (errors.isNotEmpty) {
          Get.snackbar(
            'تحقق من البيانات',
            errors.values.first,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        }
        return false;
      }

      _stepValidationStatus[stepIndex] = true;
      return true;
    } catch (e) {
      print('❌ [EDIT STEPPER] validateStep error: $e');
      return true;
    }
  }

  // -------------------------
  // Finish / Submit (EDIT)
  // -------------------------
  @override
  Future<void> onFinish() async {
    bool allValid = true;

    // Validate all steps before submitting
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
      await _submitProductUpdate();
    }
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

  Future<void> _submitProductUpdate() async {
    final productController = Get.find<ProductCentralController>();

    try {
      final result = await productController.submitProduct();

      if (result == null) {
        Get.snackbar(
          'خطأ',
          'فشل في تحديث المنتج',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      if (result['success'] == true) {
        // Success dialog (same component used in add flow)
        AddProductStepperDialogs.showSuccessDialog(
          result: result,
          onOk: () {
            // After update, go back to previous screen or main.
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed('/mainScreen');
            }
          },
        );
      } else {
        final errorMessage =
            result['message']?.toString() ?? 'فشل في تحديث المنتج';
        Get.snackbar(
          'خطأ',
          errorMessage,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('خطأ', 'حدث خطأ غير متوقع: $e');
    }
  }
}
