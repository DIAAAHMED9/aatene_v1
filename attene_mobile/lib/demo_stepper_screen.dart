import 'package:attene_mobile/view/advance_info/keyword_management_screen.dart';
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
      title: 'المستخدم',
      subtitle: 'معلومات المستخدم',
    ),
    const StepperStep(
      title: 'المنتجات', 
      subtitle: 'عربة التسوق',
    ),
    const StepperStep(
      title: 'الشحن',
      subtitle: 'عنوان الشحن',
    ),
    const StepperStep(
      title: 'الدفع',
      subtitle: 'طريقة الدفع',
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('مثال توضيحي - عملية الشراء'),
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
        return  AddProductContent(); // فقط المحتوى بدون أي إضافات
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

  Widget _buildProductsStep() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildStepHeader(1),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildInfoCard(
              'عربة التسوق',
              Icons.shopping_cart_outlined,
              [
                _buildInfoRow('آيفون 14 برو', '4,500 ريال'),
                _buildInfoRow('سماعات ايربودز', '800 ريال'),
                _buildInfoRow('الإجمالي', '5,300 ريال', isBold: true, color: Colors.blue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingStep() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildStepHeader(2),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildInfoCard(
              'عنوان الشحن',
              Icons.location_on_outlined,
              [
                _buildInfoRow('العنوان:', 'حي النخيل، الرياض'),
                _buildInfoRow('طريقة الشحن:', 'توصيل سريع'),
                _buildInfoRow('التكلفة:', '25 ريال'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildStepHeader(3),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildInfoCard(
              'طريقة الدفع',
              Icons.credit_card_rounded,
              [
                _buildInfoRow('الطريقة:', 'بطاقة ائتمان'),
                _buildInfoRow('رقم البطاقة:', '**** **** **** 1234'),
                _buildInfoRow('المبلغ الإجمالي:', '5,325 ريال', isBold: true, color: Colors.green),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildStepHeader(4),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildInfoCard(
              'تأكيد الطلب',
              Icons.check_circle_outline_rounded,
              [
                _buildInfoRow('رقم الطلب:', '#123456'),
                _buildInfoRow('الحالة:', 'قيد المعالجة', color: Colors.orange),
                _buildInfoRow('وقت التوصيل:', '2-3 أيام'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildSuccessCard(),
          ),
        ],
      ),
    );
  }

  Widget _buildStepHeader(int stepIndex) {
    Map<int, Map<String, String>> stepInfo = {
      0: {'title': 'معلومات المستخدم', 'subtitle': 'تحقق من معلوماتك الشخصية'},
      1: {'title': 'عربة التسوق', 'subtitle': 'راجع المنتجات في سلة التسوق'},
      2: {'title': 'معلومات الشحن', 'subtitle': 'حدد عنوان الشحن وطريقة التوصيل'},
      3: {'title': 'طريقة الدفع', 'subtitle': 'اختر طريقة الدفع المناسبة'},
      4: {'title': 'تأكيد الطلب', 'subtitle': 'راجع الطلب قبل الإتمام'},
    };

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stepInfo[stepIndex]!['title']!,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            stepInfo[stepIndex]!['subtitle']!,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, IconData icon, List<Widget> content) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.blue, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...content,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.w600 : FontWeight.w400,
              color: Colors.grey[700],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.w700 : FontWeight.w500,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessCard() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.green[50],
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(
              Icons.celebration_rounded,
              size: 60,
              color: Colors.green,
            ),
            const SizedBox(height: 16),
            const Text(
              'تم تأكيد الطلب بنجاح! 🎉',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'شكراً لك على شرائك! تم استلام طلبك وسيتم تجهيزه للشحن.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green[800],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
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
            onPressed: _nextStep,
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
            child: Text(
              currentStep == steps.length - 1 ? 'إنهاء الطلب' : 'التالي',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
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
      _completeProcess();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void _completeProcess() {
    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.celebration_rounded, color: Colors.green, size: 28),
            SizedBox(width: 12),
            Text(
              'تهانينا!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Colors.green,
              ),
            ),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shopping_bag_rounded, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text(
              'تم إتمام عملية الشراء بنجاح!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
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
  }
}