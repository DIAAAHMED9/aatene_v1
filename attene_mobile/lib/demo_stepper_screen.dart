import 'package:attene_mobile/controller/product_controller.dart';
import 'package:attene_mobile/view/advance_info/keyword_management_screen.dart';
import 'package:attene_mobile/view/product_variations/product_variation_controller.dart';
import 'package:attene_mobile/view/product_variations/product_variations_screen.dart';
import 'package:attene_mobile/view/related_products/related_products_screen.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/add_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/custom_stepper/custom_stepper.dart';

class DemoStepperScreen extends StatefulWidget {
  const DemoStepperScreen({super.key});

  @override
  State<DemoStepperScreen> createState() => _DemoStepperScreenState();
}

class _DemoStepperScreenState extends State<DemoStepperScreen> {
  int currentStep = 0;
  
  final List<StepperStep> steps = [
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

  @override
  void initState() {
    super.initState();
    // ✅ التأكد من تسجيل الـ Controllers
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('إضافة منتج جديد'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // الـ Stepper
           Padding(
             padding: const EdgeInsets.only(top: 25),
             child: CustomStepper(
                steps: steps,
                currentStep: currentStep,
                onStepTapped: (step) {
                  if (step <= currentStep) {
                    setState(() {
                      currentStep = step;
                    });
                  }
                },
                builder: (context, stepIndex) {
                  return _buildStepBody(stepIndex);
                },
              ),
           ),
          
          // محتوى الخطوة - هذا هو المكان الوحيد الذي يظهر فيه المحتوى
          Expanded(
            child: _buildStepBody(currentStep),
          ),
          
          // أزرار التنقل
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey[300]!,
                  width: 1.5,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: _buildStepNavigation(),
          ),
        ],
      ),
    );
  }

  // إزالة الدالة _buildStepContent نهائياً واستخدام _buildStepBody مباشرة
  Widget _buildStepBody(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return AddProductContent(); // فقط المحتوى بدون أي إضافات
      case 1:
        return KeywordManagementScreen();
      case 2:
        return ProductVariationsScreen();
      case 3:
        return RelatedProductsScreen();

      default:
        return const SizedBox();
    }
  }

Widget _buildStepNavigation() {
  return Row(
    children: [
      if (currentStep > 0)
        Expanded(
          child: OutlinedButton(
            onPressed: _previousStep,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.blue, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'رجوع',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ),
        ),
      if (currentStep > 0) const SizedBox(width: 16),
      Expanded(
        child: ElevatedButton(
          onPressed: currentStep == steps.length - 1 ? _submitProduct : _nextStep,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 3,
            shadowColor: Colors.blue.withOpacity(0.3),
          ),
          child: Obx(() {
            final productController = Get.find<ProductCentralController>();
            return productController.isSubmitting.isTrue
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    currentStep == steps.length - 1 ? 'إنهاء وإرسال' : 'التالي',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  );
          }),
        ),
      ),
    ],
  );
}

  void _nextStep() {
    if (currentStep < steps.length - 1) {
      setState(() {
        currentStep++;
      });
    } else {
      _submitProduct();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

void _submitProduct() async {
  final ProductCentralController productController = Get.find<ProductCentralController>();
  
  print('🚀 [FINAL SUBMISSION STARTED]');
  productController.printDataSummary();

  if (!productController.isBasicInfoComplete()) {
    Get.snackbar(
      'خطأ', 
      'يرجى إكمال المعلومات الأساسية أولاً', 
      backgroundColor: Colors.red, 
      colorText: Colors.white
    );
    return;
  }

  // التحقق من صحة المتغيرات إذا كانت موجودة
  final variationController = Get.find<ProductVariationController>();
  if (variationController.hasVariations.value) {
    final validation = variationController.validateVariations();
    if (!validation.isValid) {
      Get.snackbar(
        'خطأ', 
        validation.errorMessage, 
        backgroundColor: Colors.red, 
        colorText: Colors.white
      );
      return;
    }
  }

  final result = await productController.submitProduct();
  
  if (result['success'] == true) {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text(
              'تمت العملية بنجاح!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.green,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_bag_rounded, size: 60, color: Colors.green),
            const SizedBox(height: 20),
            const Text(
              'تم إضافة المنتج بنجاح',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            if (result['data'] != null && result['data'].isNotEmpty)
              Text(
                'رقم المنتج: ${result['data'][0]['sku'] ?? 'N/A'}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
              productController.reset();
              setState(() {
                currentStep = 0;
              });
            },
            child: const Text(
              'حسناً',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  } else {
    Get.snackbar(
      'خطأ', 
      result['message'] ?? 'فشل في إضافة المنتج', 
      backgroundColor: Colors.red, 
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }
}
}