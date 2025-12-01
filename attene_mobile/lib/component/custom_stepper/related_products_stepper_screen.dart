// في ملف related_products_screen.dart
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/custom_stepper/custom_stepper.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:attene_mobile/view/related_products/related_products_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RelatedProductsStepperScreen extends StatefulWidget {
  const RelatedProductsStepperScreen({super.key});

  @override
  _RelatedProductsStepperScreenState createState() => _RelatedProductsStepperScreenState();
}

class _RelatedProductsStepperScreenState extends State<RelatedProductsStepperScreen> {
  final RelatedProductsController controller = Get.put(RelatedProductsController());
  int _currentStep = 0;

  final List<StepperStep> _steps = [
    const StepperStep(
      title: 'اختيار المنتجات',
      subtitle: 'اختر المنتجات المرتبطة',
      icon: Icons.shopping_basket,
    ),
    const StepperStep(
      title: 'إضافة التخفيض',
      subtitle: 'حدد خصومات المنتجات',
      icon: Icons.discount,
    ),
    const StepperStep(
      title: 'التأكيد',
      subtitle: 'راجع المعلومات وأكمل',
      icon: Icons.check_circle,
    ),
  ];


  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('المنتجات المرتبطة'),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.back(),
          ),
        ),
        body: CustomStepper(
          steps: _steps,
          currentStep: _currentStep,
          onStepTapped: (step) {
            if (step <= _currentStep) {
              setState(() {
                _currentStep = step;
              });
            }
          },
          builder: (context, stepIndex) {
            return _buildStepContent(stepIndex);
          },
        ),
      ),
    );
  }

  Widget _buildStepContent(int stepIndex) {
    switch (stepIndex) {
      case 0:
        return _buildProductsSelectionStep();
      case 1:
        return _buildDiscountStep();
      case 2:
        return _buildConfirmationStep();
      default:
        return const SizedBox();
    }
  }

  Widget _buildProductsSelectionStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اختر المنتجات المرتبطة',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'اختر مجموعة من المنتجات المرتبطة لعرضها معاً',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          // زر اختيار المنتجات
          Center(
            child: AateneButton(
              buttonText: 'اختر المنتجات',
              color: AppColors.primary400,
              textColor: Colors.white,
              onTap: _showProductSelectionSheet,
            ),
          ),
          const SizedBox(height: 24),
          
          // المنتجات المختارة
          Expanded(
            child: Obx(() {
              if (controller.selectedProducts.isEmpty) {
                return _buildEmptyProductsState();
              }
              return _buildSelectedProductsList();
            }),
          ),
          
          const SizedBox(height: 24),
          _buildStepNavigation(),
        ],
      ),
    );
  }

  Widget _buildDiscountStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'إضافة التخفيض',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'حدد خصومات خاصة على المنتجات المختارة',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildPriceField('السعر الإجمالي', controller.originalPrice.value.toStringAsFixed(2)),
                  const SizedBox(height: 20),
                  _buildDiscountInput(),
                  const SizedBox(height: 20),
                  _buildDiscountNote(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          _buildStepNavigation(),
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تأكيد المعلومات',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'راجع المعلومات قبل الحفظ النهائي',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSummaryCard(),
                  const SizedBox(height: 20),
                  _buildDiscountSummary(),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          _buildFinalStepNavigation(),
        ],
      ),
    );
  }

  Widget _buildStepNavigation() {
    return Row(
      children: [
        if (_currentStep > 0)
          Expanded(
            child: OutlinedButton(
              onPressed: _previousStep,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: AppColors.primary400),
              ),
              child: Text(
                'رجوع',
                style: TextStyle(color: AppColors.primary400),
              ),
            ),
          ),
        if (_currentStep > 0) const SizedBox(width: 12),
        Expanded(
          child: AateneButton(
            buttonText: _currentStep == _steps.length - 1 ? 'إنهاء' : 'التالي',
            color: AppColors.primary400,
            textColor: Colors.white,
            onTap: _nextStep,
          ),
        ),
      ],
    );
  }

  Widget _buildFinalStepNavigation() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _previousStep,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: AppColors.primary400),
            ),
            child: Text(
              'رجوع',
              style: TextStyle(color: AppColors.primary400),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AateneButton(
            buttonText: 'حفظ والإكمال',
            color: Colors.green,
            textColor: Colors.white,
            onTap: _completeProcess,
          ),
        ),
      ],
    );
  }

  // باقي الدوال المساعدة (بنفس الطريقة السابقة)
  Widget _buildEmptyProductsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'لم يتم اختيار أي منتجات بعد',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'انقر على "اختر المنتجات" لبدء الإضافة',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedProductsList() {
    return Obx(() {
      return ListView.builder(
        itemCount: controller.selectedProducts.length,
        itemBuilder: (context, index) {
          final product = controller.selectedProducts[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: Icon(Icons.check_circle, color: AppColors.primary400),
              title: Text(product.name),
              subtitle: Text('${product.price.toStringAsFixed(2)} ريال'),
              trailing: IconButton(
                icon: const Icon(Icons.close, color: Colors.red),
                onPressed: () => controller.removeSelectedProduct(product),
              ),
            ),
          );
        },
      );
    });
  }

  Widget _buildPriceField(String label, String value) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: value,
        border: const OutlineInputBorder(),
        suffixText: 'ريال',
        prefixIcon: const Icon(Icons.attach_money),
      ),
    );
  }

  Widget _buildDiscountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: (value) {
            final parsed = double.tryParse(value) ?? 0.0;
            controller.discountedPrice.value = parsed;
          },
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'السعر بعد التخفيض',
            hintText: 'أدخل السعر المخفض',
            border: OutlineInputBorder(),
            suffixText: 'ريال',
            prefixIcon: Icon(Icons.discount),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'يجب أن يكون أقل من السعر الأصلي',
          style: TextStyle(
            fontSize: 12,
            color: Colors.orange[700],
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountNote() {
    return TextField(
      onChanged: (value) => controller.discountNote.value = value,
      decoration: const InputDecoration(
        labelText: 'ملاحظة على التخفيض',
        hintText: 'أضف ملاحظة عن التخفيض (اختياري)',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.note),
      ),
      maxLines: 3,
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'المنتجات المختارة',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              return Column(
                children: controller.selectedProducts.map((product) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.check, color: AppColors.primary400),
                    title: Text(product.name),
                    trailing: Text('${product.price.toStringAsFixed(2)} ريال'),
                  );
                }).toList(),
              );
            }),
            const Divider(),
            Obx(() {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'الإجمالي',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Text(
                  '${controller.originalPrice.value.toStringAsFixed(2)} ريال',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary400,
                    fontSize: 16,
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountSummary() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل التخفيض',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final discountAmount = controller.originalPrice.value - controller.discountedPrice.value;
              final discountPercentage = (discountAmount / controller.originalPrice.value) * 100;
              
              return Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.price_change, color: Colors.green),
                    title: Text('قيمة التخفيض'),
                    trailing: Text('${discountAmount.toStringAsFixed(2)} ريال'),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.percent, color: Colors.blue),
                    title: Text('نسبة التخفيض'),
                    trailing: Text('${discountPercentage.toStringAsFixed(1)}%'),
                  ),
                  if (controller.discountNote.value.isNotEmpty) ...[
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(Icons.note, color: Colors.orange),
                      title: Text('ملاحظة'),
                      subtitle: Text(controller.discountNote.value),
                    ),
                  ],
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

// في ملف related_products_stepper_screen.dart
void _showProductSelectionSheet() {
  Get.bottomSheet(
    Container(
      height: Get.height * 0.8,
      padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'اختر المنتجات المرتبطة',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.close),
              ),
            ],
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          
          // Search Bar
          TextField(
            onChanged: (value) => controller.searchQuery.value = value,
            decoration: InputDecoration(
              hintText: 'ابحث عن المنتجات...',
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide(color: AppColors.primary400),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          
          // Products List
          Expanded(
            child: Obx(() {
              final products = controller.filteredProducts;
              
              if (products.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
                      SizedBox(height: 16),
                      Text(
                        'لا توجد منتجات تطابق البحث',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Obx(() => CheckboxListTile(
                    value: product.isSelected.value,
                    onChanged: (value) => controller.toggleProductSelection(product),
                    title: Text(
                      product.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: Text(
                      '${product.price.toStringAsFixed(2)} ريال',
                      style: TextStyle(
                        color: Colors.green[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    secondary: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.shopping_bag,
                        color: Colors.grey[600],
                      ),
                    ),
                    activeColor: AppColors.primary400,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ));
                },
              );
            }),
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          
          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey[400]!),
                  ),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveDimensions.w(12)),
              Expanded(
                child: AateneButton(
                  buttonText: 'تأكيد الاختيار',
                  color: AppColors.primary400,
                  textColor: Colors.white,
                  onTap: () {
                    Get.back();
                    // تحديث الواجهة بعد اختيار المنتجات
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    isScrollControlled: true,
    enableDrag: true,
  );
}

// دالة لإظهار شاشة إضافة التخفيض
void _showAddDiscountSheet() {
  Get.bottomSheet(
    Container(
      height: Get.height * 0.7,
      padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إضافة خصم على المنتجات',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.close),
              ),
            ],
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // السعر الأصلي
                  _buildReadOnlyField(
                    'السعر الإجمالي الأصلي',
                    '${controller.originalPrice.value.toStringAsFixed(2)} ريال',
                    Icons.attach_money,
                  ),
                  SizedBox(height: ResponsiveDimensions.h(16)),
                  
                  // حقل السعر المخفض
                  TextField(
                    onChanged: (value) {
                      final parsed = double.tryParse(value) ?? 0.0;
                      controller.discountedPrice.value = parsed;
                    },
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'السعر بعد التخفيض',
                      hintText: 'أدخل السعر المخفض',
                      border: OutlineInputBorder(),
                      suffixText: 'ريال',
                      prefixIcon: Icon(Icons.discount, color: AppColors.primary400),
                    ),
                  ),
                  SizedBox(height: ResponsiveDimensions.h(8)),
                  Text(
                    'يجب أن يكون أقل من السعر الأصلي',
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.f(12),
                      color: Colors.orange[700],
                    ),
                  ),
                  
                  SizedBox(height: ResponsiveDimensions.h(16)),
                  
                  // ملاحظة التخفيض
                  TextField(
                    onChanged: (value) => controller.discountNote.value = value,
                    decoration: InputDecoration(
                      labelText: 'ملاحظة على التخفيض',
                      hintText: 'أضف ملاحظة عن التخفيض (اختياري)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.note, color: AppColors.primary400),
                    ),
                    maxLines: 3,
                  ),
                  
                  SizedBox(height: ResponsiveDimensions.h(16)),
                  
                  // تاريخ التخفيض
                  TextField(
                    controller: controller.dateController,
                    readOnly: true,
                    onTap: _showDatePicker,
                    decoration: InputDecoration(
                      labelText: 'تاريخ انتهاء التخفيض',
                      hintText: 'اختر التاريخ',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today, color: AppColors.primary400),
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                  ),
                  
                  SizedBox(height: ResponsiveDimensions.h(16)),
                  
                  // عدد المنتجات المختارة
                  Obx(() => Container(
                    padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
                    decoration: BoxDecoration(
                      color: AppColors.primary100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: AppColors.primary200),
                    ),
                    child: Center(
                      child: Text(
                        'الخصم سيطبق على ${controller.selectedProducts.length} منتج',
                        style: TextStyle(
                          fontSize: ResponsiveDimensions.f(16),
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary400,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
          
          SizedBox(height: ResponsiveDimensions.h(16)),
          
          // أزرار الإجراءات
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    side: BorderSide(color: Colors.grey[400]!),
                  ),
                  child: Text(
                    'إلغاء',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ),
              SizedBox(width: ResponsiveDimensions.w(12)),
              Expanded(
                child: Obx(() => ElevatedButton(
                  onPressed: controller.discountedPrice.value > 0 && 
                            controller.discountedPrice.value < controller.originalPrice.value
                      ? () {
                          if (_validateDiscount()) {
                            controller.addDiscount();
                            Get.back();
                            setState(() {});
                            _showSuccessMessage('تم إضافة التخفيض بنجاح');
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppColors.primary400,
                  ),
                  child: Text('تأكيد التخفيض', style: TextStyle(color: Colors.white)),
                )),
              ),
            ],
          ),
        ],
      ),
    ),
    isScrollControlled: true,
    enableDrag: true,
  );
}

// دالة التحقق من صحة التخفيض
bool _validateDiscount() {
  if (controller.discountedPrice.value >= controller.originalPrice.value) {
    _showErrorMessage('السعر المخفض يجب أن يكون أقل من السعر الأصلي');
    return false;
  }
  
  if (controller.discountedPrice.value <= 0) {
    _showErrorMessage('يرجى إدخال سعر مخفض صحيح');
    return false;
  }
  
  return true;
}

// دالة عرض منتقي التاريخ
void _showDatePicker() async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: controller.discountDate.value,
    firstDate: DateTime.now(),
    lastDate: DateTime(2100),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary400,
            onPrimary: Colors.white,
            onSurface: Colors.grey[800]!,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary400,
            ),
          ),
        ),
        child: child!,
      );
    },
  );
  
  if (picked != null) {
    final TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(controller.discountDate.value),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary400,
              onPrimary: Colors.white,
              onSurface: Colors.grey[800]!,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (time != null) {
      final selectedDateTime = DateTime(
        picked.year,
        picked.month,
        picked.day,
        time.hour,
        time.minute,
      );
      controller.setDiscountDate(selectedDateTime);
      setState(() {});
    }
  }
}

// دالة لحقل القراءة فقط
Widget _buildReadOnlyField(String label, String value, IconData icon) {
  return TextField(
    readOnly: true,
    decoration: InputDecoration(
      labelText: label,
      hintText: value,
      border: OutlineInputBorder(),
      prefixIcon: Icon(icon, color: AppColors.primary400),
    ),
  );
}

// دالة لعرض رسالة النجاح
void _showSuccessMessage(String message) {
  Get.snackbar(
    'نجاح',
    message,
    backgroundColor: Colors.green,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: Duration(seconds: 3),
  );
}

// دالة لعرض رسالة الخطأ
void _showErrorMessage(String message) {
  Get.snackbar(
    'خطأ',
    message,
    backgroundColor: Colors.red,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: Duration(seconds: 3),
  );
}

// دالة لإكمال العملية
void _completeProcess() {
  // التحقق من وجود منتجات مختارة
  if (controller.selectedProducts.isEmpty) {
    _showErrorMessage('يرجى اختيار منتجات أولاً');
    return;
  }
  
  // التحقق من وجود تخفيض إذا كان المستخدم في الخطوة الثانية أو الثالثة
  if (_currentStep >= 1 && controller.discountedPrice.value <= 0) {
    _showErrorMessage('يرجى إضافة تخفيض للمنتجات');
    return;
  }
  
  // عرض تأكيد نهائي
  Get.dialog(
    AlertDialog(
      title: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 8),
          Text('تم الإكمال بنجاح'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('تم حفظ المعلومات التالية:'),
          SizedBox(height: 16),
          _buildSummaryItem('عدد المنتجات', '${controller.selectedProducts.length} منتج'),
          _buildSummaryItem('السعر الإجمالي', '${controller.originalPrice.value.toStringAsFixed(2)} ريال'),
          if (controller.discountedPrice.value > 0)
            _buildSummaryItem('السعر بعد التخفيض', '${controller.discountedPrice.value.toStringAsFixed(2)} ريال'),
          if (controller.discountNote.value.isNotEmpty)
            _buildSummaryItem('ملاحظة', controller.discountNote.value),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
            Get.back(); // العودة للشاشة السابقة
          },
          child: Text('حسناً', style: TextStyle(color: AppColors.primary400)),
        ),
      ],
    ),
  );
}

// عنصر عرض في الملخص
Widget _buildSummaryItem(String title, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(value),
      ],
    ),
  );
}

// دالة لمسح كل البيانات
void _resetAllData() {
  controller.clearAllSelections();
  controller.discountedPrice.value = 0.0;
  controller.discountNote.value = '';
  controller.setDiscountDate(DateTime.now());
  setState(() {
    _currentStep = 0;
  });
}

// دالة للتحقق مما إذا كان يمكن الانتقال للخطوة التالية
bool _canProceedToNextStep() {
  switch (_currentStep) {
    case 0:
      return controller.selectedProducts.isNotEmpty;
    case 1:
      return controller.discountedPrice.value > 0 && 
             controller.discountedPrice.value < controller.originalPrice.value;
    case 2:
      return true;
    default:
      return false;
  }
}

// دالة معدلة للخطوة التالية مع التحقق
void _nextStep() {
  if (!_canProceedToNextStep()) {
    _showCurrentStepErrorMessage();
    return;
  }
  
  if (_currentStep < _steps.length - 1) {
    setState(() {
      _currentStep++;
    });
  } else {
    _completeProcess();
  }
}

// دالة لعرض رسالة خطأ حسب الخطوة الحالية
void _showCurrentStepErrorMessage() {
  switch (_currentStep) {
    case 0:
      _showErrorMessage('يرجى اختيار منتج واحد على الأقل للمتابعة');
      break;
    case 1:
      _showErrorMessage('يرجى إضافة تخفيض صحيح للمنتجات المختارة');
      break;
    default:
      _showErrorMessage('يرجى إكمال البيانات المطلوبة');
  }
}
}