import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/add_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum BottomSheetType {
  filter,
  sort,
  multiSelect,
  singleSelect,
  manageSections,
  addNewSection,
    addProduct,
}

class BottomSheetController extends GetxController {
  final Rx<BottomSheetType> currentType = BottomSheetType.filter.obs;
  final RxList<String> selectedOptions = <String>[].obs;
  final RxString selectedOption = ''.obs;
  final RxString newSectionName = ''.obs;
  final RxString sectionSearchText = ''.obs; // نص البحث في الأقسام
  final RxString selectedSection = ''.obs; // القسم المختار
  final isRTL = LanguageUtils.isRTL;

  // بيانات تجريبية - يمكن استبدالها ببيانات حقيقية
  final List<String> filterOptions = ['الفئة 1', 'الفئة 2', 'الفئة 3', 'الفئة 4'];
  final List<String> sortOptions = ['الأحدث', 'الأقدم', 'السعر من الأعلى', 'السعر من الأدنى'];
  final List<String> multiSelectOptions = ['خيار 1', 'خيار 2', 'خيار 3', 'خيار 4'];
  final List<String> singleSelectOptions = ['خيار أ', 'خيار ب', 'خيار ج', 'خيار د'];
  final RxList<String> storeSections = <String>[].obs;
    final RxInt currentStep = 0.obs;
  final RxString productName = ''.obs;
  final RxString productDescription = ''.obs;
  final RxDouble productPrice = 0.0.obs;
  final RxInt productQuantity = 0.obs;
  final RxList<String> productImages = <String>[].obs;
  final RxString selectedCategory = ''.obs;

  // بيانات تجريبية للفئات
  final List<String> productCategories = [
    'الكترونيات',
    'ملابس',
    'أغذية',
    'أثاث',
    'رياضة'
  ];

  
  // الحصول على الأقسام المصفاة حسب البحث
  List<String> get filteredSections {
    if (sectionSearchText.isEmpty) {
      return storeSections;
    }
    return storeSections.where((section) => 
      section.toLowerCase().contains(sectionSearchText.toLowerCase())
    ).toList();
  }
  
  // التحقق إذا كان النص المدخل يشابه نص موجود
  bool get isTextSimilarToExisting {
    if (sectionSearchText.isEmpty) return false;
    return storeSections.any((section) => 
      section.toLowerCase() == sectionSearchText.toLowerCase()
    );
  }
  
  void showBottomSheet(BottomSheetType type) {
    currentType.value = type;
    selectedOptions.clear();
    selectedOption.value = '';
    newSectionName.value = '';
    sectionSearchText.value = '';
    selectedSection.value = '';
    
    Get.bottomSheet(
      _buildBottomSheetContent(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
    );
  }
  
  Widget _buildBottomSheetContent() {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          SizedBox(height: 20),
          _buildContent(),
          if (currentType.value != BottomSheetType.manageSections && 
              currentType.value != BottomSheetType.addNewSection) 
            SizedBox(height: 20),
          if (currentType.value != BottomSheetType.manageSections && 
              currentType.value != BottomSheetType.addNewSection)
            _buildActions(),
        ],
      ),
    );
  }
  
  Widget _buildHeader() {
    String title = '';
    switch (currentType.value) {
      case BottomSheetType.filter:
        title = 'الفلاتر';
        break;
      case BottomSheetType.sort:
        title = 'ترتيب المنتجات';
        break;
      case BottomSheetType.multiSelect:
        title = 'اختيار متعدد';
        break;
      case BottomSheetType.singleSelect:
        title = 'اختيار واحد';
        break;
      case BottomSheetType.manageSections:
        title = 'إدارة أقسام المتجر';
        break;
      case BottomSheetType.addNewSection:
        title = 'إضافة قسم جديد';
        break;
        case BottomSheetType.addProduct:
        title = 'إضافة منتج جديد';

    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.close),
        ),
      ],
    );
  }
  
  Widget _buildContent() {
    return Obx(() {
      switch (currentType.value) {
        case BottomSheetType.filter:
          return _buildFilterContent();
        case BottomSheetType.sort:
          return _buildSortContent();
        case BottomSheetType.multiSelect:
          return _buildMultiSelectContent();
        case BottomSheetType.singleSelect:
          return _buildSingleSelectContent();
        case BottomSheetType.manageSections:
          return _buildManageSectionsContent();
        case BottomSheetType.addNewSection:
          return _buildAddNewSectionContent();
                  case BottomSheetType.addProduct: // أضف هذه الحالة
          return _buildAddProductContent();
      }
    });
  }
  
  // المحتوى الخاص بإدارة الأقسام - المحدث
  Widget _buildManageSectionsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أضف وعدّل الأقسام الخاصة بمتجرك لترتيب منتجاتك بالطريقة التي تناسبك، هذه الأقسام لا تؤثر على التصنيفات الرئيسية للمنصة، بل تسهل على عملائك تصفح متجرك',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 20),
        
        // إذا لم يكن هناك أقسام، نعرض زر الإضافة فقط
        Obx(() {
          if (storeSections.isEmpty) {
            return AateneButton(
              color: AppColors.primary300.withAlpha(50),
              textColor: AppColors.primary400,
              borderColor: Colors.transparent,
              buttonText: isRTL ? 'إضافة قسم جديد' : 'Add a new section',
              onTap: () {
                openAddNewSection(); 
                Get.back(); 
              },
            );
          } else {
            // إذا كان هناك أقسام، نعرض مربع البحث والأقسام والأزرار
            return Column(
              children: [
                // مربع البحث
                TextFiledAatene(
                  heightTextFiled: 50,
                  onChanged: (value) => sectionSearchText.value = value,
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  isRTL: isRTL, 
                  hintText: isRTL ? 'ابحث في الأقسام' : 'Search sections',
                ),
                SizedBox(height: 20),
                
                // قائمة الأقسام المصفاة
                Container(
                  constraints: BoxConstraints(
                    maxHeight: 200, // ارتفاع أقصى للقائمة
                  ),
                  child: Obx(() {
                    if (filteredSections.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'لا توجد أقسام تطابق البحث',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredSections.length,
                      itemBuilder: (context, index) {
                        final section = filteredSections[index];
                        return Obx(() => RadioListTile<String>(
                          title: Text(section),
                          value: section,
                          groupValue: selectedSection.value,
                          onChanged: (value) {
                            selectedSection.value = value!;
                          },
                        ));
                      },
                    );
                  }),
                ),
                SizedBox(height: 20),
                
                // زر التالي
                AateneButton(
                  color: AppColors.primary400,
                  textColor: Colors.white,
                  borderColor: Colors.transparent,
                  buttonText: isRTL ? 'التالي' : 'Next',
                 onTap: selectedSection.isNotEmpty ? () {
                    // فتح شاشة إضافة المنتج مع القسم المختار
                    Get.back(); // إغلاق شاشة إدارة الأقسام
                   Get.to(() => AddProductScreen());
                  
                  } : null, // تعطيل الزر إذا لم يتم اختيار قسم
                ),
                SizedBox(height: 10),
                
                // زر إضافة قسم جديد مع التحقق من عدم تشابه النص
                AateneButton(
                  color: AppColors.primary300.withAlpha(50),
                  textColor: AppColors.primary400,
                  borderColor: Colors.transparent,
                  buttonText: isRTL ? 'إضافة قسم جديد' : 'Add a new section',
                  onTap: () {
                    if (sectionSearchText.isNotEmpty && !isTextSimilarToExisting) {
                      // إذا كان هناك نص في البحث ولا يشابه نص قديم، نضيفه مباشرة
                      _addSectionFromSearch();
                    } else {
                      // وإلا نفتح شاشة إضافة قسم جديد
                      openAddNewSection(); 
                      Get.back(); 
                    }
                  },
                ),
                
                // رسالة تحذير إذا كان النص يشابه نص موجود
                Obx(() {
                  if (sectionSearchText.isNotEmpty && isTextSimilarToExisting) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'هذا الاسم مشابه لقسم موجود مسبقاً',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return SizedBox.shrink();
                }),
              ],
            );
          }
        }),
      ],
    );
  }
    // دالة لفتح شاشة إضافة المنتج
  void openAddProduct() {
    showBottomSheet(BottomSheetType.addProduct);
  }

  // بناء واجهة إضافة المنتج
  Widget _buildAddProductContent() {
    return Container(
      height: Get.height * 0.8, // ارتفاع مناسب للشاشة
      child: Column(
        children: [
          // الهيدر
          _buildHeader(),
          SizedBox(height: 10),
          
          // عرض القسم المختار مع إمكانية تغييره
          _buildSelectedSectionCard(),
          SizedBox(height: 20),
          
          // الـ Stepper
          Expanded(
            child: _buildProductStepper(),
          ),
        ],
      ),
    );
  }
    // بطاقة عرض القسم المختار
  Widget _buildSelectedSectionCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'سيتم إضافة المنتج إلى:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary500,
            ),
          ),
          Row(
            children: [
              Text(
                selectedSection.value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary400,
                ),
              ),
              SizedBox(width: 8),
              // زر تغيير القسم
              InkWell(
                onTap: () {
                  Get.back(); // إغلاق شاشة إضافة المنتج
                  openManageSections(); // فتح شاشة إدارة الأقسام من جديد
                },
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 16,
                    color: AppColors.primary400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  // بناء الـ Stepper
  Widget _buildProductStepper() {
    return Obx(() => Stepper(
      type: StepperType.horizontal,
      currentStep: currentStep.value,
      onStepContinue: _nextStep,
      onStepCancel: _previousStep,
      onStepTapped: (step) => currentStep.value = step,
      elevation: 0,
      controlsBuilder: (context, details) {
        return Row(
          children: [
            if (currentStep.value > 0)
              OutlinedButton(
                onPressed: details.onStepCancel,
                child: Text('السابق'),
              ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: details.onStepContinue,
              child: Text(currentStep.value == 2 ? 'إنهاء' : 'التالي'),
            ),
          ],
        );
      },
      steps: [
        Step(
          title:SizedBox(),
          content: _buildBasicInfoStep(),
          isActive: currentStep.value >= 0,
          state: currentStep.value > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: SizedBox(),
          content: _buildImagesAndPriceStep(),
          isActive: currentStep.value >= 1,
          state: currentStep.value > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: SizedBox(),
          content: _buildReviewStep(),
          isActive: currentStep.value >= 2,
        ),
      ],
    ));
  }
  // خطوة المعلومات الأساسية
  Widget _buildBasicInfoStep() {
    return Column(
      children: [
        TextFiledAatene(
          heightTextFiled: 50,
          onChanged: (value) => productName.value = value,
          hintText: 'اسم المنتج',
          isRTL: isRTL,
        ),
        SizedBox(height: 16),
        TextFiledAatene(
          heightTextFiled: 80,
          onChanged: (value) => productDescription.value = value,
          hintText: 'وصف المنتج',
          // m: 3,
          isRTL: isRTL,
        ),
        SizedBox(height: 16),
        // اختيار الفئة
        DropdownButtonFormField<String>(
          value: selectedCategory.value.isEmpty ? null : selectedCategory.value,
          items: productCategories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) => selectedCategory.value = value!,
          decoration: InputDecoration(
            labelText: 'الفئة',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
  // خطوة الصور والسعر
  Widget _buildImagesAndPriceStep() {
    return Column(
      children: [
        // رفع الصور
        Text(
          'صور المنتج',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Obx(() => Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            // الصور المرفوعة
            ...productImages.map((image) => Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(image), // أو AssetImage حسب مصدر الصورة
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: -5,
                  right: -5,
                  child: IconButton(
                    icon: Icon(Icons.close, size: 16),
                    onPressed: () => productImages.remove(image),
                  ),
                ),
              ],
            )).toList(),
            
            // زر إضافة صورة
            if (productImages.length < 5)
              GestureDetector(
                onTap: _addProductImage,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate, color: Colors.grey),
                      Text('إضافة', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
          ],
        )),
        SizedBox(height: 20),
        
        // السعر والكمية
        Row(
          children: [
            Expanded(
              child: TextFiledAatene(
                heightTextFiled: 50,
                onChanged: (value) => productPrice.value = double.tryParse(value) ?? 0.0,
                hintText: 'السعر',
                // keyboardType: TextInputType.number,
                isRTL: isRTL,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFiledAatene(
                heightTextFiled: 50,
                onChanged: (value) => productQuantity.value = int.tryParse(value) ?? 0,
                hintText: 'الكمية',
                // keyboardType: TextInputType.number,
                isRTL: isRTL,
              ),
            ),
          ],
        ),
      ],
    );
  }
  // خطوة المراجعة النهائية
  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('مراجعة المعلومات:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        _buildReviewItem('القسم', selectedSection.value),
        _buildReviewItem('اسم المنتج', productName.value),
        _buildReviewItem('الوصف', productDescription.value),
        _buildReviewItem('الفئة', selectedCategory.value),
        _buildReviewItem('السعر', '${productPrice.value} ريال'),
        _buildReviewItem('الكمية', productQuantity.value.toString()),
        _buildReviewItem('عدد الصور', productImages.length.toString()),
      ],
    );
  }

  Widget _buildReviewItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$title: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value.isEmpty ? 'غير محدد' : value)),
        ],
      ),
    );
  }
  // دوال التنقل بين الخطوات
  void _nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    } else {
      _submitProduct();
    }
  }

  void _previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }
    // دالة إضافة صورة (محاكاة)
  void _addProductImage() {
    // في التطبيق الحقيقي، هنا ستستخدم image_picker
    // هذه مجرد محاكاة
    if (productImages.length < 5) {
      productImages.add('https://via.placeholder.com/150');
      Get.snackbar(
        'تمت الإضافة',
        'تم إضافة صورة المنتج',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }
    // دالة إرسال المنتج
  void _submitProduct() {
    // التحقق من صحة البيانات
    if (productName.isEmpty || selectedCategory.isEmpty || productPrice.value <= 0) {
      Get.snackbar(
        'خطأ',
        'يرجى ملء جميع الحقول المطلوبة',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // هنا سيتم إرسال البيانات إلى الخادم
    print('''
    تم إضافة المنتج:
    - القسم: ${selectedSection.value}
    - الاسم: ${productName.value}
    - الوصف: ${productDescription.value}
    - الفئة: ${selectedCategory.value}
    - السعر: ${productPrice.value}
    - الكمية: ${productQuantity.value}
    - عدد الصور: ${productImages.length}
    ''');

    Get.back(); // إغلاق الشاشة
    
    // إعادة تعيين البيانات
    _resetProductData();
    
    Get.snackbar(
      'نجح',
      'تم إضافة المنتج بنجاح إلى قسم ${selectedSection.value}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  // إعادة تعيين بيانات المنتج
  void _resetProductData() {
    currentStep.value = 0;
    productName.value = '';
    productDescription.value = '';
    productPrice.value = 0.0;
    productQuantity.value = 0;
    productImages.clear();
    selectedCategory.value = '';
  }

  // إضافة قسم من نص البحث
  void _addSectionFromSearch() {
    if (sectionSearchText.isNotEmpty && !isTextSimilarToExisting) {
      storeSections.add(sectionSearchText.value);
      
      // تفريغ حقل البحث بعد الإضافة
      sectionSearchText.value = '';
      
      Get.snackbar(
        'تمت الإضافة',
        'تم إضافة القسم الجديد بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }
  
  // المحتوى الخاص بإضافة قسم جديد
  Widget _buildAddNewSectionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أضف قسماً جديداً ليسهُل على عملائك تصفح منتجاتك بترتيب أوضح.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 20),
        TextFiledAatene(
          heightTextFiled: 50,
          onChanged: (value) => newSectionName.value = value,
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          isRTL: isRTL, 
          hintText: isRTL ? 'أضف اسم القسم' : 'Add department name',
        ),
        SizedBox(height: 20),
        
        // رسالة تحذير إذا كان النص يشابه نص موجود
        Obx(() {
          if (newSectionName.isNotEmpty && _isSectionNameExists(newSectionName.value)) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'هذا الاسم مشابه لقسم موجود مسبقاً',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
              ),
            );
          }
          return SizedBox.shrink();
        }),
        
        // زرين الإضافة والإلغاء
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('إلغاء'),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Obx(() => ElevatedButton(
                onPressed: newSectionName.isNotEmpty && !_isSectionNameExists(newSectionName.value) 
                    ? _addNewSection 
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('إضافة'),
              )),
            ),
          ],
        ),
      ],
    );
  }
  
  // التحقق من وجود قسم بنفس الاسم
  bool _isSectionNameExists(String name) {
    return storeSections.any((section) => 
      section.toLowerCase() == name.toLowerCase()
    );
  }
  
  void _addNewSection() {
    if (newSectionName.isNotEmpty && !_isSectionNameExists(newSectionName.value)) {
      storeSections.add(newSectionName.value);
      newSectionName.value = '';
      Get.back();
      
      // إظهار رسالة نجاح
      Get.snackbar(
        'تمت الإضافة',
        'تم إضافة القسم الجديد بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }
  
  // باقي الدوال الموجودة سابقاً...
  Widget _buildFilterContent() {
    return Column(
      children: [
        _buildFilterOption('نطاق السعر', Icons.attach_money),
        _buildFilterOption('الفئة', Icons.category),
        _buildFilterOption('الماركة', Icons.branding_watermark),
        _buildFilterOption('التقييم', Icons.star),
      ],
    );
  }
  
  Widget _buildFilterOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        print('فتح $title');
      },
    );
  }
  
  Widget _buildSortContent() {
    return Column(
      children: sortOptions.map((option) {
        return Obx(() => RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: selectedOption.value,
          onChanged: (value) {
            selectedOption.value = value!;
          },
        ));
      }).toList(),
    );
  }
  
  Widget _buildMultiSelectContent() {
    return Column(
      children: multiSelectOptions.map((option) {
        return Obx(() => CheckboxListTile(
          title: Text(option),
          value: selectedOptions.contains(option),
          onChanged: (value) {
            if (value == true) {
              selectedOptions.add(option);
            } else {
              selectedOptions.remove(option);
            }
          },
        ));
      }).toList(),
    );
  }
  
  Widget _buildSingleSelectContent() {
    return Column(
      children: singleSelectOptions.map((option) {
        return Obx(() => RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: selectedOption.value,
          onChanged: (value) {
            selectedOption.value = value!;
          },
        ));
      }).toList(),
    );
  }
  
  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              selectedOptions.clear();
              selectedOption.value = '';
              Get.back();
            },
            child: Text('إلغاء'),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: _applySelection,
            child: Text('تطبيق'),
          ),
        ),
      ],
    );
  }
  
  void _applySelection() {
    switch (currentType.value) {
      case BottomSheetType.filter:
        print('تطبيق الفلاتر');
        break;
      case BottomSheetType.sort:
        print('تم الترتيب حسب: ${selectedOption.value}');
        break;
      case BottomSheetType.multiSelect:
        print('الخيارات المحددة: ${selectedOptions.join(', ')}');
        break;
      case BottomSheetType.singleSelect:
        print('الخيار المحدد: ${selectedOption.value}');
        break;
      default:
        break;
    }
    Get.back();
  }
  
  // دالة لفتح إدارة الأقسام
  void openManageSections() {
    showBottomSheet(BottomSheetType.manageSections);
  }
  
  // دالة لفتح إضافة قسم جديد مباشرة
  void openAddNewSection() {
    showBottomSheet(BottomSheetType.addNewSection);
  }
}