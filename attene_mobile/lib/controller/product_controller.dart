import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/models/section_model.dart';
import 'package:attene_mobile/utlis/sheet_controller.dart';
import 'package:attene_mobile/view/media_library/media_model.dart';
import 'package:attene_mobile/view/product_variations/product_variation_controller.dart';

import '../my_app/my_app_controller.dart';
import '../view/Services/data_lnitializer_service.dart';
import '../view/Services/unified_loading_screen.dart';
import '../view/related_products/related_products_controller.dart';
import '../view/screens_navigator_bottom_bar/product/product_controller.dart';

class ProductCentralController extends GetxController {
  static ProductCentralController get to => Get.find();
  
  final DataInitializerService dataService = Get.find<DataInitializerService>();
  final GetStorage storage = GetStorage();
  final MyAppController myAppController = Get.find<MyAppController>();
  
  final RxString productName = ''.obs;
  final RxString productDescription = ''.obs;
  final RxString price = ''.obs;
  final RxInt selectedCategoryId = 0.obs;
  final RxString selectedCondition = ''.obs;
  final RxList<MediaItem> selectedMedia = <MediaItem>[].obs;
  final Rx<Section?> selectedSection = Rx<Section?>(null);
  
  final RxList<String> keywords = <String>[].obs;
  final RxList<Map<String, dynamic>> variations = <Map<String, dynamic>>[].obs;
  final Rx<Map<String, dynamic>?> selectedStore = Rx<Map<String, dynamic>?>(null);
  
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingCategories = false.obs;
  final RxString categoriesError = ''.obs;
  
  final RxBool isSubmitting = false.obs;
  final RxBool isUpdatingSection = false.obs;
  final RxBool isProductReadyForSubmission = false.obs;
  
  // Validation errors
  final RxMap<String, String> validationErrors = <String, String>{}.obs;
  
  // Step validation status
  final RxMap<int, bool> stepValidationStatus = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    print('🔄 [PRODUCT CENTRAL] تهيئة متحكم المنتجات المركزي');
    loadCachedCategories();
    
    // Initialize step validation status
    for (int i = 0; i < 4; i++) {
      stepValidationStatus[i] = false;
    }
    
    ever(productName, (_) => _checkProductReadiness());
    ever(productDescription, (_) => _checkProductReadiness());
    ever(price, (_) => _checkProductReadiness());
    ever(selectedCategoryId, (_) => _checkProductReadiness());
    ever(selectedCondition, (_) => _checkProductReadiness());
    ever(selectedSection, (_) => _checkProductReadiness());
  }
  
  void _checkProductReadiness() {
    final isBasicComplete = productName.isNotEmpty &&
        productDescription.isNotEmpty &&
        price.isNotEmpty &&
        selectedCategoryId > 0 &&
        selectedCondition.isNotEmpty;
    
    final hasSection = selectedSection.value != null;
    
    isProductReadyForSubmission(isBasicComplete && hasSection);
    
    print('''
🔍 [PRODUCT READINESS CHECK]:
   Basic Info: $isBasicComplete
   Has Section: $hasSection
   Section ID: ${selectedSection.value?.id}
   Ready for Submission: ${isProductReadyForSubmission.value}
''');
  }
  
  Map<String, dynamic> validateStep(int stepIndex) {
    validationErrors.clear();
    
    switch (stepIndex) {
      case 0: // Basic info step
        return _validateBasicInfoStep();
      case 2: // Variations step
        return _validateVariationsStep();
      default:
        return {'isValid': true, 'errors': {}};
    }
  }
  
  Map<String, dynamic> _validateBasicInfoStep() {
    bool isValid = true;
    
    if (productName.isEmpty) {
      validationErrors['productName'] = 'اسم المنتج مطلوب';
      isValid = false;
    }
    
    if (productDescription.isEmpty) {
      validationErrors['productDescription'] = 'وصف المنتج مطلوب';
      isValid = false;
    }
    
    if (price.isEmpty) {
      validationErrors['price'] = 'سعر المنتج مطلوب';
      isValid = false;
    } else {
      final priceValue = double.tryParse(price.value);
      if (priceValue == null || priceValue <= 0) {
        validationErrors['price'] = 'يرجى إدخال سعر صحيح';
        isValid = false;
      }
    }
    
    if (selectedCategoryId <= 0) {
      validationErrors['category'] = 'فئة المنتج مطلوبة';
      isValid = false;
    }
    
    if (selectedCondition.isEmpty) {
      validationErrors['condition'] = 'حالة المنتج مطلوبة';
      isValid = false;
    }
    
    if (selectedMedia.isEmpty) {
      validationErrors['media'] = 'صور المنتج مطلوبة';
      isValid = false;
    }
    
    if (selectedSection.value == null) {
      validationErrors['section'] = 'قسم المنتج مطلوب';
      isValid = false;
    }
    
    return {
      'isValid': isValid,
      'errors': Map<String, String>.from(validationErrors),
    };
  }
  
  Map<String, dynamic> _validateVariationsStep() {
    try {
      if (Get.isRegistered<ProductVariationController>()) {
        final variationController = Get.find<ProductVariationController>();
        
        if (variationController.hasVariations) {
          final validation = variationController.validateVariations();
          if (!validation.isValid) {
            return {
              'isValid': false,
              'errors': {'variations': validation.errorMessage}
            };
          }
        }
      }
    } catch (e) {
      print('❌ [VARIATIONS VALIDATION] Error: $e');
    }
    
    return {'isValid': true, 'errors': {}};
  }
  
  void markStepAsValidated(int stepIndex) {
    stepValidationStatus[stepIndex] = true;
  }
  
  void clearStepValidation(int stepIndex) {
    stepValidationStatus[stepIndex] = false;
  }
  
  bool isStepValidated(int stepIndex) {
    return stepValidationStatus[stepIndex] == true;
  }
  
  Future<void> loadCachedCategories() async {
    try {
      final cachedCategories = dataService.getCategories();
      if (cachedCategories.isNotEmpty) {
        categories.assignAll(List<Map<String, dynamic>>.from(cachedCategories));
        print('✅ [PRODUCT] تم تحميل ${categories.length} فئة من التخزين المحلي');
      }
    } catch (e) {
      print('⚠️ [PRODUCT] خطأ في تحميل الفئات المخزنة: $e');
    }
  }
  
  Future<void> loadCategoriesIfNeeded() async {
    if (categories.isNotEmpty || isLoadingCategories.value) {
      return;
    }
    await loadCategories();
  }
  
  Future<void> loadCategories() async {
    return UnifiedLoadingScreen.showWithFuture<void>(
      performLoadCategories(),
      message: 'جاري تحميل الفئات...',
    );
  }
  
  Future<void> performLoadCategories() async {
    try {
      if (!myAppController.isLoggedIn.value) {
        categoriesError('يجب تسجيل الدخول أولاً');
        print('⚠️ [PRODUCT] المستخدم غير مسجل دخول');
        return;
      }
  
      isLoadingCategories(true);
      categoriesError('');
      print('📡 [PRODUCT] جلب الفئات من API');
      
      final response = await ApiHelper.get(
        path: '/merchants/categories/select',
        withLoading: false,
      );
  
      if (response != null && response['status'] == true) {
        final categoriesList = List<Map<String, dynamic>>.from(response['categories'] ?? []);
        categories.assignAll(categoriesList);
        print('✅ [PRODUCT] تم تحميل ${categories.length} فئة بنجاح');
      } else {
        final errorMessage = response?['message'] ?? 'فشل في تحميل الفئات';
        categoriesError(errorMessage);
        print('❌ [PRODUCT] فشل في تحميل الفئات: $errorMessage');
      }
    } catch (e) {
      final error = 'حدث خطأ أثناء تحميل الفئات: $e';
      categoriesError(error);
      print('❌ [PRODUCT] خطأ في تحميل الفئات: $e');
    } finally {
      isLoadingCategories(false);
    }
  }
  
  Future<void> reloadCategories() async {
    categories.clear();
    await loadCategories();
  }
  
  void updateSelectedStore(Map<String, dynamic> store) {
    selectedStore(store);
    print('🏪 [PRODUCT] تم تحديث المتجر: ${store['name']} (ID: ${store['id']})');
    printDataSummary();
  }
  
  void updateBasicInfo({
    required String name,
    required String description,
    required String productPrice,
    required int categoryId,
    required String condition,
    required List<MediaItem> media,
    Section? section,
  }) {
    productName(name);
    productDescription(description);
    price(productPrice);
    selectedCategoryId(categoryId);
    selectedCondition(condition);
    selectedMedia.assignAll(media);
    
    if(section != null){
      updateSelectedSection(section);
    }
 
    print('''
📦 [PRODUCT] تحديث المعلومات الأساسية:
   الاسم: $name
   الوصف: ${description.length} حرف
   السعر: $productPrice
   الفئة: $categoryId
   الحالة: $condition
   القسم: ${section?.name ?? 'غير محدد'}
   الوسائط: ${media.length} عنصر
''');
    _checkProductReadiness();
  }
  
  void addKeywords(List<String> newKeywords) {
    keywords.assignAll(newKeywords);
    print('🔤 [PRODUCT] تحديث الكلمات المفتاحية: ${newKeywords.length} كلمة');
  }
  
  void addVariations(List<Map<String, dynamic>> newVariations) {
    variations.assignAll(newVariations);
    print('🎨 [PRODUCT] تحديث المتغيرات: ${newVariations.length} متغير');
  }
  
  void updateRelatedProductsFromRelatedController() {
    try {
      final relatedController = Get.find<RelatedProductsController>();
      
      print('🔗 [PRODUCT] تم استقبال طلب الربط من RelatedProductsController');
      print('🔗 [PRODUCT] عدد المنتجات المختارة: ${relatedController.selectedProductsCount}');
      
      Get.snackbar(
        'تم الربط',
        'تم ربط ${relatedController.selectedProductsCount} منتج بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('⚠️ [PRODUCT] خطأ في تحديث المنتجات المرتبطة: $e');
    }
  }
  
  Map<String, dynamic> getCrossSellData() {
    try {
      if (Get.isRegistered<RelatedProductsController>()) {
        final relatedController = Get.find<RelatedProductsController>();
        return relatedController.getCrossSellData();
      }
    } catch (e) {
      print('⚠️ [PRODUCT] خطأ في جلب بيانات cross sell: $e');
    }
    
    return {
      'crossSells': [],
      'cross_sells_price': 0.0,
      'cross_sells_due_date': '',
    };
  }
  
  bool isBasicInfoComplete() {
    return productName.isNotEmpty &&
        productDescription.isNotEmpty &&
        price.isNotEmpty &&
        selectedCategoryId > 0 &&
        selectedCondition.isNotEmpty;
  }
  
  bool isSectionSelected() {
    final hasSection = selectedSection.value != null;
    final hasValidSectionId = selectedSection.value?.id != null;
    
    print('''
🔍 [SECTION CHECK]:
   Has Section: $hasSection
   Has Valid Section ID: $hasValidSectionId
   Section ID: ${selectedSection.value?.id}
   Section Name: ${selectedSection.value?.name}
''');
    
    return hasValidSectionId;
  }
  
  void printCurrentSection() {
    print('''
📋 [CURRENT SECTION INFO]:
   Section: ${selectedSection.value?.name}
   Section ID: ${selectedSection.value?.id}
   Is Null: ${selectedSection.value == null}
''');
  }
  
  Future<Map<String, dynamic>?> submitProduct() async {
    return UnifiedLoadingScreen.showWithFuture<Map<String, dynamic>>(
      performSubmitProduct(),
      message: 'جاري إضافة المنتج...',
    );
  }
  
  Future<Map<String, dynamic>> performSubmitProduct() async {
    try {
      isSubmitting(true);
      
      if (!isSectionSelected()) {
        print('❌ [PRODUCT] فشل: لم يتم اختيار قسم للمنتج');
        return {
          'success': false,
          'message': 'يجب اختيار قسم للمنتج قبل الإرسال'
        };
      }
      
      printCurrentSection();
      
      print('''
🚀 [PRODUCT] إرسال المنتج:
   الاسم: ${productName.value}
   الفئة: ${selectedCategoryId.value}
   السعر: ${price.value}
   القسم: ${selectedSection.value?.name} (ID: ${selectedSection.value?.id})
   الوسائط: ${selectedMedia.length}
   الكلمات المفتاحية: ${keywords.length}
''');
  
      updateVariationsData();
  
      final variationController = Get.find<ProductVariationController>();
      final variationsData = variationController.prepareVariationsForApi();
  
      print('🎯 [PRODUCT] بيانات المتغيرات المعدة: ${variationsData.length} متغير');
  
      final productData = await prepareProductData(variationsData);
  
      print('📤 [PRODUCT] بيانات المنتج المرسلة: ${jsonEncode(productData)}');
  
      final response = await ApiHelper.post(
        path: '/merchants/products',
        body: productData,
        withLoading: false,
      );
  
      print('📥 [PRODUCT] استجابة API: ${jsonEncode(response)}');
  
      if (response != null && response['status'] == true) {
        final product = response['data']?[0];
        print('✅ [PRODUCT] تم إنشاء المنتج بنجاح: ${product?['name']}');
        
        await dataService.refreshProducts();
        
        _notifyProductUpdate();
        
        resetAfterSuccess(variationController);
        
        return {'success': true, 'data': response['data']};
      } else {
        final errorMessage = parseErrorMessage(response);
        print('❌ [PRODUCT] فشل إنشاء المنتج: $errorMessage');
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('❌ [PRODUCT] خطأ في إرسال المنتج: $e');
      return {'success': false, 'message': 'حدث خطأ أثناء إضافة المنتج: $e'};
    } finally {
      isSubmitting(false);
    }
  }
  
  Future<Map<String, dynamic>> prepareProductData(List<Map<String, dynamic>> variationsData) async {
    if (selectedSection.value == null || selectedSection.value!.id == null) {
      throw Exception('القسم غير محدد. يرجى اختيار قسم للمنتج.');
    }
    
    print('selectedSection.value?.id :: ${selectedSection.value?.id}');
    final productData = <String, dynamic>{
      'section_id': selectedSection.value!.id,
      'name': productName.value.trim(),
      'description': productDescription.value.trim(),
      'price': double.tryParse(price.value) ?? 0.0,
      'category_id': selectedCategoryId.value,
      'condition': formatCondition(selectedCondition.value),
      'short_description': getShortDescription(),
      'sku': generateSku(),
    };
  
    if (selectedMedia.isNotEmpty) {
      final firstMedia = selectedMedia.first;
      productData['cover'] = getFilePath(firstMedia.fileUrl);
      productData['gallary'] = selectedMedia.map((media) => getFilePath(media.fileUrl)).toList();
    }
  
    if (keywords.isNotEmpty) {
      productData['tags'] = keywords;
    } else {
      productData['tags'] = [];
    }
  
    if (variationsData.isNotEmpty) {
      productData['type'] = 'variation';
      productData['variations'] = prepareVariationsData(variationsData);
    } else {
      productData['type'] = 'simple';
      productData['variations'] = [];
    }
  
    final crossSellData = getCrossSellData();
    
    productData['crossSells'] = crossSellData['crossSells'] ?? [];
    
    if (crossSellData['crossSells'] != null && (crossSellData['crossSells'] as List).isNotEmpty) {
      productData['cross_sells_price'] = crossSellData['cross_sells_price'] ?? 0.0;
      
      if (crossSellData['cross_sells_due_date'] != null &&
          (crossSellData['cross_sells_due_date'] as String).isNotEmpty) {
        productData['cross_sells_due_date'] = crossSellData['cross_sells_due_date'];
      } else {
        final dueDate = DateTime.now().add(const Duration(days: 30));
        productData['cross_sells_due_date'] =
            '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}';
      }
    } else {
      productData['cross_sells_price'] = 0;
      productData['cross_sells_due_date'] = '';
    }
  
    print('''
📤 [PRODUCT] بيانات cross sell:
   crossSells: ${productData['crossSells']}
   cross_sells_price: ${productData['cross_sells_price']}
   cross_sells_due_date: ${productData['cross_sells_due_date']}
''');
  
    return productData;
  }
  
  List<Map<String, dynamic>> prepareVariationsData(List<Map<String, dynamic>> variationsData) {
    return variationsData.map((variation) {
      final variationData = {
        'price': variation['price'],
        'attributeOptions': prepareAttributeOptions(variation['attributeOptions'] ?? []),
      };
      
      if (variation['image'] != null && variation['image'].toString().isNotEmpty) {
        variationData['image'] = getFilePath(variation['image'].toString());
      }
      
      return variationData;
    }).toList();
  }
  
  List<Map<String, dynamic>> prepareAttributeOptions(List<dynamic> attributeOptions) {
    final List<Map<String, dynamic>> result = [];
    
    for (final option in attributeOptions) {
      if (option is Map<String, dynamic>) {
        final attributeId = option['attribute_id'];
        final optionId = option['option_id'];
        
        if (attributeId != null && optionId != null) {
          result.add({
            'attribute_id': attributeId is int ? attributeId : int.tryParse(attributeId.toString()) ?? 0,
            'option_id': optionId is int ? optionId : int.tryParse(optionId.toString()) ?? 0,
          });
        }
      } else if (option is Map) {
        final attributeId = option['attribute_id'];
        final optionId = option['option_id'];
        
        if (attributeId != null && optionId != null) {
          result.add({
            'attribute_id': attributeId is int ? attributeId : int.tryParse(attributeId.toString()) ?? 0,
            'option_id': optionId is int ? optionId : int.tryParse(optionId.toString()) ?? 0,
          });
        }
      }
    }
    
    return result;
  }
  
  void updateVariationsData() {
    final variationController = Get.find<ProductVariationController>();
    
    for (final variation in variationController.variations) {
      if (variation.images.isNotEmpty) {
        if (variation.images.first.contains('variation_default.jpg') ||
            variation.images.first.isEmpty) {
          variation.images.clear();
        }
      }
    }
    
    print('✅ [PRODUCT] تحديث بيانات المتغيرات: تم تنظيف الصور لـ API');
  }
  
  String parseErrorMessage(Map<String, dynamic>? response) {
    if (response == null) {
      return 'فشل في الاتصال بالخادم';
    }
  
    if (response['errors'] != null && response['errors'] is Map) {
      final errors = Map<String, dynamic>.from(response['errors']);
      if (errors.isNotEmpty) {
        final firstError = errors.entries.first;
        final errorMessages = List<String>.from(firstError.value);
        return errorMessages.isNotEmpty ? errorMessages.first : 'حدث خطأ غير معروف';
      }
    }
  
    return response['message'] ?? 'فشل في إضافة المنتج';
  }
  
  void resetAfterSuccess(ProductVariationController variationController) {
    reset(resetSection: true);
    variationController.toggleHasVariations(false);
    variationController.selectedAttributes.clear();
    variationController.variations.clear();
  }
  
  void reset({bool resetSection = false}) {
    productName('');
    productDescription('');
    price('');
    selectedCategoryId(0);
    selectedCondition('');
    selectedMedia.clear();
    keywords.clear();
    variations.clear();
    validationErrors.clear();
    
    // Reset all step validations
    for (int i = 0; i < 4; i++) {
      stepValidationStatus[i] = false;
    }
    
    if (resetSection) {
      selectedSection(null);
    }
    
    print('🔄 [PRODUCT] إعادة تعيين بيانات المنتج ${resetSection ? 'مع القسم' : 'بدون القسم'}');
    _checkProductReadiness();
  }
  
  String formatCondition(String condition) {
    switch (condition) {
      case 'جديد':
        return 'new';
      case 'مستعمل':
        return 'used';
      case 'مجدول':
        return 'refurbished';
      default:
        return 'new';
    }
  }
  
  String generateSku() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp % 10000;
    return 'SKU${productName.value.replaceAll(' ', '_').toUpperCase()}_$random';
  }
  
  String getShortDescription() {
    if (productDescription.value.length <= 100) {
      return productDescription.value;
    }
    return '${productDescription.value.substring(0, 100)}...';
  }
  
  String getFilePath(String? url) {
    if (url == null || url.isEmpty) return '';
    
    try {
      final uri = Uri.parse(url);
      String path = uri.path;
      
      if (path.startsWith('/storage/')) {
        final newPath = path.replaceFirst('/storage/', '');
        return newPath;
      }
      
      if (path.startsWith('/gallery/')) {
        final newPath = path.substring(1);
        return newPath;
      }
      
      if (path.startsWith('/images/')) {
        final newPath = path.substring(1);
        return newPath;
      }
      
      return path;
    } catch (e) {
      print('❌ [PRODUCT] خطأ في تحويل المسار: $e');
      return url;
    }
  }
  
  void printDataSummary() {
    final variationController = Get.find<ProductVariationController>();
    
    try {
      final relatedProductsCount = Get.isRegistered<RelatedProductsController>()
          ? Get.find<RelatedProductsController>().selectedProductsCount
          : 0;
      
      print('''
📊 [PRODUCT SUMMARY]:
   الاسم: ${productName.value}
   الوصف: ${productDescription.value.length} حرف
   السعر: ${price.value}
   الفئة: ${selectedCategoryId.value}
   الحالة: ${selectedCondition.value}
   القسم: ${selectedSection.value?.name ?? 'غير محدد'} (ID: ${selectedSection.value?.id})
   الوسائط: ${selectedMedia.length}
   الكلمات المفتاحية: ${keywords.length}
   السمات المختارة: ${variationController.selectedAttributes.length}
   المتغيرات: ${variationController.variations.length}
   المنتجات المرتبطة: $relatedProductsCount
   جاهز للإرسال: ${isProductReadyForSubmission.value}
   أخطاء التحقق: ${validationErrors.length}
''');
    } catch (e) {
      print('⚠️ [PRODUCT] خطأ في طباعة ملخص البيانات: $e');
    }
  }
  
  void updateSelectedSection(Section section) {
    if (isUpdatingSection.value) return;
    
    isUpdatingSection.value = true;
    
    try {
      if (selectedSection.value?.id == section.id) {
        print('⚠️ [PRODUCT] القسم محدث بالفعل: ${section.name} (ID: ${section.id})');
        return;
      }
      
      selectedSection(section);
      print('✅ [PRODUCT] تحديث القسم: ${section.name} (ID: ${section.id})');
      
      // Clear section validation error if exists
      if (validationErrors.containsKey('section')) {
        validationErrors.remove('section');
      }
      
      if (Get.isRegistered<BottomSheetController>()) {
        final bottomSheetController = Get.find<BottomSheetController>();
        bottomSheetController.updateSelectedSectionInBottomSheet(section);
      }
    } finally {
      Future.delayed(const Duration(milliseconds: 100), () {
        isUpdatingSection.value = false;
        _checkProductReadiness();
      });
    }
  }
  
  void setSectionDirectly(Section section) {
    selectedSection(section);
    print('🎯 [PRODUCT] تم تعيين القسم مباشرة: ${section.name} (ID: ${section.id})');
    _checkProductReadiness();
  }
  
  void _notifyProductUpdate() {
    try {
      dataService.refreshProducts();
      
      if (Get.isRegistered<ProductController>()) {
        final productController = Get.find<ProductController>();
        productController.notifyProductsUpdated();
      }
      
      if (Get.isRegistered<BottomSheetController>()) {
        final bottomSheetController = Get.find<BottomSheetController>();
        bottomSheetController.notifySectionsUpdated();
      }
      
      print('📢 [PRODUCT CENTRAL] تم إشعار جميع المتحكمين بتحديث المنتجات');
      
      Get.snackbar(
        'تمت الإضافة',
        'تم إضافة المنتج بنجاح وتحديث القوائم',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
    } catch (e) {
      print('⚠️ [PRODUCT CENTRAL] خطأ في إشعار التحديث: $e');
    }
  }
  
  Future<Map<String, dynamic>> testWithCorrectStructure() async {
    try {
      print('🧪 [PRODUCT] اختبار الهيكل الصحيح');
      
      final testData = {
        "section_id": 18,
        "name": "منتج تجريبي",
        "price": 100.0,
        "condition": "new",
        "category_id": 83,
        "short_description": "هذا وصف مختصر للمنتج",
        "description": "<p>هذا وصف مفصل للمنتج التجريبي</p>",
        "tags": ["تجريبي", "اختبار"],
        "type": "simple",
        "variations": [],
        "crossSells": [],
      };
  
      print('🧪 [PRODUCT] بيانات الاختبار: ${jsonEncode(testData)}');
  
      final response = await ApiHelper.post(
        path: '/merchants/products',
        body: testData,
        withLoading: false,
      );
  
      print('🧪 [PRODUCT] استجابة الاختبار: ${jsonEncode(response)}');
  
      if (response != null && response['status'] == true) {
        return {'success': true, 'message': '✅ الاختبار نجح - الهيكل صحيح'};
      } else {
        return {'success': false, 'message': '❌ فشل الاختبار: ${response?['message']}'};
      }
    } catch (e) {
      return {'success': false, 'message': '❌ خطأ في الاختبار: $e'};
    }
  }
  
  Map<String, dynamic> getCategoryById(int id) {
    return categories.firstWhere(
      (category) => category['id'] == id,
      orElse: () => {'name': 'غير محدد'},
    );
  }
  
  String getCategoryName(int id) {
    final category = getCategoryById(id);
    return category['name']?.toString() ?? 'غير محدد';
  }
  
  Map<String, dynamic> validateProductData() {
    final errors = <String>[];
    
    if (productName.isEmpty) errors.add('اسم المنتج مطلوب');
    if (productDescription.isEmpty) errors.add('وصف المنتج مطلوب');
    if (price.isEmpty) errors.add('سعر المنتج مطلوب');
    if (selectedCategoryId <= 0) errors.add('فئة المنتج مطلوبة');
    if (selectedCondition.isEmpty) errors.add('حالة المنتج مطلوبة');
    if (selectedSection.value == null) errors.add('قسم المنتج مطلوب');
    
    return {
      'isValid': errors.isEmpty,
      'errors': errors,
      'sectionId': selectedSection.value?.id,
      'sectionName': selectedSection.value?.name,
    };
  }
  
  Map<String, dynamic> getProductSummary() {
    return {
      'productName': productName.value,
      'productDescription': productDescription.value,
      'price': price.value,
      'categoryId': selectedCategoryId.value,
      'categoryName': getCategoryName(selectedCategoryId.value),
      'condition': selectedCondition.value,
      'sectionId': selectedSection.value?.id,
      'sectionName': selectedSection.value?.name,
      'mediaCount': selectedMedia.length,
      'keywordsCount': keywords.length,
      'variationsCount': variations.length,
      'isReadyForSubmission': isProductReadyForSubmission.value,
      'validation': validateProductData(),
      'validationErrors': Map<String, String>.from(validationErrors),
    };
  }
  
  @override
  void onClose() {
    print('🔚 [PRODUCT] إغلاق متحكم المنتجات المركزي');
    super.onClose();
  }
}