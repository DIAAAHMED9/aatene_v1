import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/models/section_model.dart';
import 'package:attene_mobile/view/media_library/media_model.dart';
import 'package:attene_mobile/view/media_library/media_library_screen.dart';
import 'package:attene_mobile/view/product_variations/product_variations_screen.dart';

import '../../../controller/product_controller.dart';

class AddProductController extends GetxController {
  final ProductCentralController productCentralController = Get.find<ProductCentralController>();
  
  final TextEditingController productNameController = TextEditingController();
  final TextEditingController productDescriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  
  final RxString _selectedCondition = ''.obs;
  final RxInt _characterCount = 0.obs;
  final RxBool _isFormValid = false.obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _selectedCategoryName = ''.obs;
  
  static const int maxDescriptionLength = 140;
  static const List<String> productConditions = ['جديد', 'مستعمل', 'مجدول'];
  
  @override
  void onInit() {
    super.onInit();
    print('🚀 [ADD PRODUCT CONTROLLER] Initialized');
    _loadStoredData();
    _setupListeners();
    _initializeCategories();
  }
  
  void _loadStoredData() {
    try {
      final central = productCentralController;
      
      if (central.productName.isNotEmpty) {
        productNameController.text = central.productName.value;
      }
      
      if (central.productDescription.isNotEmpty) {
        productDescriptionController.text = central.productDescription.value;
        _characterCount.value = central.productDescription.value.length;
      }
      
      if (central.price.isNotEmpty) {
        priceController.text = central.price.value;
      }
      
      if (central.selectedCondition.isNotEmpty) {
        _selectedCondition.value = central.selectedCondition.value;
      }
      
      if (central.selectedCategoryId.value > 0) {
        _updateSelectedCategoryName();
      }
      
      _validateForm();
      printDataSummary();
      
    } catch (e) {
      print('❌ [ADD PRODUCT] Error loading stored data: $e');
    }
  }
  
  void _setupListeners() {
    productNameController.addListener(_onProductNameChanged);
    productDescriptionController.addListener(_onDescriptionChanged);
    priceController.addListener(_onPriceChanged);
    
    ever(_selectedCondition, (_) => _validateForm());
    
    ever(productCentralController.isLoadingCategories, (isLoading) {
      _isLoading.value = isLoading;
      if (!isLoading) {
        _updateSelectedCategoryName();
      }
    });
  }
  
  void _initializeCategories() {
    if (productCentralController.categories.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        productCentralController.reloadCategories();
      });
    } else {
      _updateSelectedCategoryName();
    }
  }
  
  void _onProductNameChanged() {
    final value = productNameController.text.trim();
    productCentralController.productName.value = value;
    _validateForm();
    update();
  }
  
  void _onDescriptionChanged() {
    final value = productDescriptionController.text.trim();
    _characterCount.value = value.length;
    productCentralController.productDescription.value = value;
    _validateForm();
    update();
  }
  
  void _onPriceChanged() {
    final value = priceController.text.trim();
    productCentralController.price.value = value;
    _validateForm();
    update();
  }
  
  void _validateForm() {
    final hasName = productNameController.text.trim().isNotEmpty;
    final hasDescription = productDescriptionController.text.trim().isNotEmpty;
    final hasPrice = priceController.text.trim().isNotEmpty;
    final hasCondition = _selectedCondition.value.isNotEmpty;
    final hasCategory = productCentralController.selectedCategoryId.value > 0;
    final hasMedia = productCentralController.selectedMedia.isNotEmpty;
    
    _isFormValid.value = hasName && hasDescription && hasPrice &&
                         hasCondition && hasCategory && hasMedia;
  }
  
  void _updateSelectedCategoryName() {
    final categoryId = productCentralController.selectedCategoryId.value;
    if (categoryId <= 0) {
      _selectedCategoryName.value = '';
      return;
    }
    
    try {
      final category = productCentralController.categories.firstWhere(
        (cat) => cat['id'] == categoryId,
        orElse: () => {},
      );
      
      if (category.isNotEmpty) {
        _selectedCategoryName.value = category['name'] as String? ?? '';
      } else {
        _selectedCategoryName.value = '';
      }
    } catch (e) {
      print('⚠️ [ADD PRODUCT] Error updating category name: $e');
      _selectedCategoryName.value = '';
    }
  }
  
  Future<void> openMediaLibrary() async {
    try {
      print('🖼️ [ADD PRODUCT] Opening media library');
      
      final List<MediaItem>? result = await Get.to(
        () => MediaLibraryScreen(
          isSelectionMode: true,
          onMediaSelected: (selectedMedia) {
            productCentralController.selectedMedia.assignAll(selectedMedia);
            print('✅ [ADD PRODUCT] Media selected: ${selectedMedia.length} items');
            _validateForm();
            update();
          },
        ),
      );
      
      if (result != null) {
        productCentralController.selectedMedia.assignAll(result);
        _validateForm();
        update();
        print('✅ [ADD PRODUCT] Media updated: ${result.length} items');
      }
    } catch (e) {
      print('❌ [ADD PRODUCT] Error opening media library: $e');
      _errorMessage.value = 'فشل في فتح مكتبة الوسائط';
      _showErrorSnackbar(_errorMessage.value);
    }
  }
  
  void removeMedia(int index) {
    if (index >= 0 && index < productCentralController.selectedMedia.length) {
      productCentralController.selectedMedia.removeAt(index);
      _validateForm();
      update();
      print('🗑️ [ADD PRODUCT] Media removed at index $index');
    }
  }
  
  void updateCondition(String? condition) {
    if (condition != null && condition.isNotEmpty) {
      _selectedCondition.value = condition;
      productCentralController.selectedCondition.value = condition;
      print('✅ [ADD PRODUCT] Condition updated: $condition');
      update();
    }
  }
  
  void updateCategory(int? categoryId) {
    if (categoryId != null && categoryId > 0) {
      productCentralController.selectedCategoryId.value = categoryId;
      _updateSelectedCategoryName();
      _validateForm();
      update();
      print('✅ [ADD PRODUCT] Category updated: $categoryId');
    }
  }
  
  bool validateForm() {
    final errors = <String>[];
    
    if (productNameController.text.isEmpty) {
      errors.add('اسم المنتج');
    }
    
    if (productDescriptionController.text.isEmpty) {
      errors.add('وصف المنتج');
    }
    
    if (priceController.text.isEmpty) {
      errors.add('سعر المنتج');
    }
    
    if (_selectedCondition.value.isEmpty) {
      errors.add('حالة المنتج');
    }
    
    if (productCentralController.selectedCategoryId.value <= 0) {
      errors.add('فئة المنتج');
    }
    
    if (productCentralController.selectedMedia.isEmpty) {
      errors.add('صور المنتج');
    }
    
    if (errors.isNotEmpty) {
      final errorMessage = 'يرجى ملء الحقول التالية: ${errors.join('، ')}';
      _showValidationError(errorMessage);
      return false;
    }
    
    return true;
  }
  
  void saveBasicInfo(Section selectedSection) {
    try {
      if (!validateForm()) {
        return;
      }
      
      productCentralController.updateBasicInfo(
        name: productNameController.text.trim(),
        description: productDescriptionController.text.trim(),
        productPrice: priceController.text.trim(),
        categoryId: productCentralController.selectedCategoryId.value,
        condition: _selectedCondition.value,
        media: productCentralController.selectedMedia,
        section: selectedSection,
      );
      
      print('💾 [ADD PRODUCT] Basic info saved successfully');
      productCentralController.printDataSummary();
      
      Get.snackbar(
        'نجاح',
        'تم حفظ المعلومات الأساسية بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
      
      Get.to(() => ProductVariationsScreen());
      
    } catch (e) {
      print('❌ [ADD PRODUCT] Error saving basic info: $e');
      _errorMessage.value = 'فشل في حفظ المعلومات';
      _showErrorSnackbar(_errorMessage.value);
    }
  }
  
  Future<void> reloadCategories() async {
    try {
      await productCentralController.reloadCategories();
      update();
    } catch (e) {
      print('❌ [ADD PRODUCT] Error reloading categories: $e');
      _errorMessage.value = 'فشل في تحميل الفئات';
      _showErrorSnackbar(_errorMessage.value);
    }
  }
  
  void navigateToKeywordManagement() {
    Get.toNamed('/keyword-management');
  }
  
  void printDataSummary() {
    print('''
📊 [ADD PRODUCT SUMMARY]:
   الاسم: ${productNameController.text}
   الوصف: ${productDescriptionController.text.length} حرف
   السعر: ${priceController.text}
   الفئة: ${productCentralController.selectedCategoryId.value} (${_selectedCategoryName.value})
   الحالة: ${_selectedCondition.value}
   الوسائط: ${productCentralController.selectedMedia.length}
   حالة النموذج: ${_isFormValid.value}
''');
  }
  
  void _showValidationError(String message) {
    Get.snackbar(
      'خطأ في التحقق',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
  
  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'خطأ',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
  
  String get selectedCondition => _selectedCondition.value;
  int get characterCount => _characterCount.value;
  bool get isFormValid => _isFormValid.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get selectedCategoryName => _selectedCategoryName.value;
  
  List<String> get conditions => productConditions;
  
  List<Map<String, dynamic>> get categories =>
      productCentralController.categories;
  bool get isLoadingCategories =>
      productCentralController.isLoadingCategories.value;
  String get categoriesError =>
      productCentralController.categoriesError.value;
  List<MediaItem> get selectedMedia =>
      productCentralController.selectedMedia;
  
  @override
  void onClose() {
    print('🛑 [ADD PRODUCT CONTROLLER] Closing...');
    productNameController.removeListener(_onProductNameChanged);
    productDescriptionController.removeListener(_onDescriptionChanged);
    priceController.removeListener(_onPriceChanged);
    productNameController.dispose();
    productDescriptionController.dispose();
    priceController.dispose();
    super.onClose();
  }
}