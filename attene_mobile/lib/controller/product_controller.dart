import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/models/section_model.dart';
import 'package:attene_mobile/view/media_library/media_model.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';

class ProductCentralController extends GetxController {
  final isRTL = LanguageUtils.isRTL;
  
  // معلومات المنتج الأساسية
  final RxString productName = ''.obs;
  final RxString productDescription = ''.obs;
  final RxString price = ''.obs;
  final RxInt selectedCategoryId = 0.obs;
  final RxString selectedCondition = ''.obs;
  
  // الوسائط
  final RxList<MediaItem> selectedMedia = <MediaItem>[].obs;
  
  // القسم المختار
  final Rx<Section?> selectedSection = Rx<Section?>(null);
  final RxString selectedSectionName = ''.obs;
  
  // الفئات
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingCategories = false.obs;
  final RxString categoriesError = ''.obs;
  
  // حالة التقديم
  final RxBool isSubmitting = false.obs;
  final RxString submitError = ''.obs;
  
  // البيانات المخزنة مؤقتاً
  final _storage = GetStorage();
  
  // ============ البيانات الجديدة ============
  
  // الكلمات المفتاحية
  final RxList<String> keywords = <String>[].obs;
  
  // الاختلافات
  final RxList<Map<String, dynamic>> variations = <Map<String, dynamic>>[].obs;
  
  // المتجر المختار
  final RxMap<String, dynamic> selectedStore = <String, dynamic>{}.obs;
  
  // المنتجات المرتبطة
  final RxList<Map<String, dynamic>> relatedProducts = <Map<String, dynamic>>[].obs;
  
  // هل تم تخطي المنتجات المرتبطة؟
  final RxBool skipRelatedProducts = false.obs;
  
  // حالة الخطوات
  final RxInt currentStep = 0.obs;
  final RxMap<String, bool> completedSteps = {
    'basic_info': false,
    'keywords': false,
    'variations': false,
    'related_products': false,
    'store': false,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    _loadStoredData();
    _checkCompletedSteps();
  }
  
  void _loadStoredData() {
    try {
      final storedName = _storage.read('product_name');
      final storedDescription = _storage.read('product_description');
      final storedPrice = _storage.read('product_price');
      final storedCategoryId = _storage.read('product_category_id');
      final storedCondition = _storage.read('product_condition');
      
      if (storedName != null) productName.value = storedName;
      if (storedDescription != null) productDescription.value = storedDescription;
      if (storedPrice != null) price.value = storedPrice;
      if (storedCategoryId != null) selectedCategoryId.value = storedCategoryId;
      if (storedCondition != null) selectedCondition.value = storedCondition;
      
      // تحميل الكلمات المفتاحية المخزنة
      final storedKeywords = _storage.read<List<String>>('product_keywords');
      if (storedKeywords != null) keywords.assignAll(storedKeywords);
      
      // تحميل الاختلافات المخزنة
      final storedVariations = _storage.read<List<Map<String, dynamic>>>('product_variations');
      if (storedVariations != null) variations.assignAll(storedVariations);
      
      // تحميل المتجر المختار
      final storedStore = _storage.read<Map<String, dynamic>>('selected_store');
      if (storedStore != null) selectedStore.value = storedStore;
      
      // تحميل المنتجات المرتبطة
      final storedRelatedProducts = _storage.read<List<Map<String, dynamic>>>('related_products');
      if (storedRelatedProducts != null) relatedProducts.assignAll(storedRelatedProducts);
      
      // تحميل حالة التخطي
      final storedSkipRelated = _storage.read<bool>('skip_related_products');
      if (storedSkipRelated != null) skipRelatedProducts.value = storedSkipRelated;
      
      // تحميل الخطوة الحالية
      final storedStep = _storage.read<int>('current_step');
      if (storedStep != null) currentStep.value = storedStep;
      
    } catch (e) {
      print('❌ [PRODUCT CENTRAL] خطأ في تحميل البيانات المخزنة: $e');
    }
  }
  
  void _checkCompletedSteps() {
    completedSteps['basic_info'] = isBasicInfoComplete();
    completedSteps['keywords'] = areKeywordsComplete();
    completedSteps['variations'] = areVariationsComplete();
    completedSteps['related_products'] = skipRelatedProducts.value || relatedProducts.isNotEmpty;
    completedSteps['store'] = isStoreSelected();
  }
  
  void saveToStorage() {
    try {
      _storage.write('product_name', productName.value);
      _storage.write('product_description', productDescription.value);
      _storage.write('product_price', price.value);
      _storage.write('product_category_id', selectedCategoryId.value);
      _storage.write('product_condition', selectedCondition.value);
      _storage.write('product_keywords', keywords.toList());
      _storage.write('product_variations', variations.toList());
      _storage.write('selected_store', selectedStore.value);
      _storage.write('related_products', relatedProducts.toList());
      _storage.write('skip_related_products', skipRelatedProducts.value);
      _storage.write('current_step', currentStep.value);
      
    } catch (e) {
      print('❌ [PRODUCT CENTRAL] خطأ في حفظ البيانات: $e');
    }
  }
  
  void reset() {
    productName.value = '';
    productDescription.value = '';
    price.value = '';
    selectedCategoryId.value = 0;
    selectedCondition.value = '';
    selectedMedia.clear();
    selectedSection.value = null;
    selectedSectionName.value = '';
    categories.clear();
    isSubmitting.value = false;
    submitError.value = '';
    keywords.clear();
    variations.clear();
    selectedStore.clear();
    relatedProducts.clear();
    skipRelatedProducts.value = false;
    currentStep.value = 0;
    
    // إعادة تعيين الخطوات
    completedSteps.updateAll((key, value) => false);
    
    // مسح التخزين
    _storage.remove('product_name');
    _storage.remove('product_description');
    _storage.remove('product_price');
    _storage.remove('product_category_id');
    _storage.remove('product_condition');
    _storage.remove('product_keywords');
    _storage.remove('product_variations');
    _storage.remove('selected_store');
    _storage.remove('related_products');
    _storage.remove('skip_related_products');
    _storage.remove('current_step');
    
    print('🔄 [PRODUCT CENTRAL] تم إعادة تعيين المتحكم');
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
    
    if (section != null) {
      updateSelectedSection(section);
    }
    
    completedSteps['basic_info'] = true;
    
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
    
    saveToStorage();
  }
  
  void updateSelectedSection(Section section) {
    selectedSection.value = section;
    selectedSectionName.value = section.name;
    
    print('✅ [PRODUCT CENTRAL] تم تحديث القسم المختار: ${section.name}');
    saveToStorage();
  }
  
  void clearSelectedSection() {
    selectedSection.value = null;
    selectedSectionName.value = '';
    
    print('🗑️ [PRODUCT CENTRAL] تم مسح القسم المختار');
    saveToStorage();
  }
  
  // ============ دوال إدارة الخطوات ============
  
  void goToStep(int step) {
    currentStep.value = step;
    saveToStorage();
    print('➡️ [PRODUCT CENTRAL] الانتقال إلى الخطوة: $step');
  }
  
  void nextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
      saveToStorage();
      print('⏭️ [PRODUCT CENTRAL] الانتقال إلى الخطوة التالية: ${currentStep.value}');
    }
  }
  
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      saveToStorage();
      print('⏮️ [PRODUCT CENTRAL] العودة إلى الخطوة السابقة: ${currentStep.value}');
    }
  }
  
  bool isStepComplete(String stepKey) {
    return completedSteps[stepKey] ?? false;
  }
  
  // ============ دوال إدارة المنتجات المرتبطة ============
  
  void toggleSkipRelatedProducts(bool value) {
    skipRelatedProducts.value = value;
    if (value) {
      relatedProducts.clear();
    }
    completedSteps['related_products'] = value;
    print('✅ [PRODUCT CENTRAL] تخطي المنتجات المرتبطة: $value');
    saveToStorage();
  }
  
  void skipRelatedProductsStep() {
    skipRelatedProducts.value = true;
    relatedProducts.clear();
    completedSteps['related_products'] = true;
    print('⏭️ [PRODUCT CENTRAL] تخطي خطوة المنتجات المرتبطة');
    saveToStorage();
  }
  
  void includeRelatedProducts() {
    skipRelatedProducts.value = false;
    completedSteps['related_products'] = relatedProducts.isNotEmpty;
    print('✅ [PRODUCT CENTRAL] إعادة تفعيل خطوة المنتجات المرتبطة');
    saveToStorage();
  }
  
  // ============ الدوال الأخرى ============
  
  void addKeywords(List<String> newKeywords) {
    keywords.assignAll(newKeywords);
    completedSteps['keywords'] = true;
    print('✅ [PRODUCT CENTRAL] تم إضافة ${newKeywords.length} كلمة مفتاحية');
    saveToStorage();
  }
  
  void addVariations(List<Map<String, dynamic>> newVariations) {
    variations.assignAll(newVariations);
    completedSteps['variations'] = true;
    print('✅ [PRODUCT CENTRAL] تم إضافة ${newVariations.length} اختلاف');
    saveToStorage();
  }
  
  void updateSelectedStore(Map<String, dynamic> store) {
    selectedStore.value = store;
    completedSteps['store'] = true;
    print('✅ [PRODUCT CENTRAL] تم تحديث المتجر المختار: ${store['name'] ?? 'غير معروف'}');
    saveToStorage();
  }
  
  void addRelatedProducts(List<Map<String, dynamic>> products) {
    relatedProducts.assignAll(products);
    skipRelatedProducts.value = false;
    completedSteps['related_products'] = true;
    print('✅ [PRODUCT CENTRAL] تم إضافة ${products.length} منتج مرتبط');
    saveToStorage();
  }
  
  void clearKeywords() {
    keywords.clear();
    completedSteps['keywords'] = false;
    print('🗑️ [PRODUCT CENTRAL] تم مسح الكلمات المفتاحية');
    saveToStorage();
  }
  
  void clearVariations() {
    variations.clear();
    completedSteps['variations'] = false;
    print('🗑️ [PRODUCT CENTRAL] تم مسح الاختلافات');
    saveToStorage();
  }
  
  void clearRelatedProducts() {
    relatedProducts.clear();
    skipRelatedProducts.value = false;
    completedSteps['related_products'] = false;
    print('🗑️ [PRODUCT CENTRAL] تم مسح المنتجات المرتبطة');
    saveToStorage();
  }
  
  Future<void> loadCategoriesIfNeeded() async {
    if (categories.isNotEmpty) return;
    
    await loadCategories();
  }
  
  Future<void> loadCategories() async {
    try {
      isLoadingCategories(true);
      categoriesError('');
      
      print('📡 [PRODUCT] جلب الفئات من API');
      
      final response = await ApiHelper.get(
        path: '/merchants/categories',
        withLoading: false,
      );
      
      if (response != null && response['status'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        categories.assignAll(data.cast<Map<String, dynamic>>());
        print('✅ [PRODUCT] تم تحميل ${categories.length} فئة');
      } else {
        categoriesError.value = response?['message'] ?? 'فشل في تحميل الفئات';
        print('❌ [PRODUCT] فشل في تحميل الفئات: ${categoriesError.value}');
      }
    } catch (e) {
      categoriesError.value = 'خطأ في تحميل الفئات: ${e.toString()}';
      print('❌ [PRODUCT] خطأ في تحميل الفئات: $e');
    } finally {
      isLoadingCategories(false);
    }
  }
  
  void reloadCategories() {
    categories.clear();
    loadCategories();
  }
  
  bool isBasicInfoComplete() {
    return productName.value.isNotEmpty &&
           productDescription.value.isNotEmpty &&
           price.value.isNotEmpty &&
           selectedCategoryId.value > 0 &&
           selectedCondition.value.isNotEmpty &&
           selectedMedia.isNotEmpty;
  }
  
  bool areKeywordsComplete() {
    return keywords.isNotEmpty;
  }
  
  bool areVariationsComplete() {
    return variations.isNotEmpty;
  }
  
  bool isStoreSelected() {
    return selectedStore.isNotEmpty && selectedStore.containsKey('id');
  }
  
  bool isAllStepsComplete() {
    return completedSteps.values.every((value) => value);
  }
  
  void printDataSummary() {
    print('''
📊 [PRODUCT DATA SUMMARY]
   الاسم: ${productName.value}
   الوصف: ${productDescription.value.length} حرف
   السعر: ${price.value}
   الفئة ID: ${selectedCategoryId.value}
   الحالة: ${selectedCondition.value}
   القسم: ${selectedSectionName.value.isNotEmpty ? selectedSectionName.value : 'غير محدد'}
   الوسائط: ${selectedMedia.length} عنصر
   الفئات المحملة: ${categories.length}
   الكلمات المفتاحية: ${keywords.length} كلمة
   الاختلافات: ${variations.length} اختلاف
   المنتجات المرتبطة: ${relatedProducts.length} منتج
   المتجر المختار: ${selectedStore.isNotEmpty ? selectedStore['name'] ?? 'غير معروف' : 'غير محدد'}
   تخطي المنتجات المرتبطة: ${skipRelatedProducts.value ? 'نعم' : 'لا'}
   الخطوة الحالية: ${currentStep.value}
   جميع الخطوات مكتملة: ${isAllStepsComplete()}
''');
  }
  
  Future<Map<String, dynamic>?> submitProduct() async {
    try {
      isSubmitting(true);
      submitError('');
      
      print('🚀 [PRODUCT] بدء إرسال المنتج...');
      printDataSummary();
      
      // التحقق من اكتمال البيانات الأساسية
      if (!isBasicInfoComplete()) {
        submitError.value = 'الرجاء إكمال المعلومات الأساسية للمنتج';
        return {
          'success': false,
          'message': submitError.value,
        };
      }
      
      // التحقق من اختيار المتجر
      if (!isStoreSelected()) {
        submitError.value = 'الرجاء اختيار متجر للمنتج';
        return {
          'success': false,
          'message': submitError.value,
        };
      }
      
      // تحضير البيانات
      final Map<String, dynamic> productData = {
        'name': productName.value,
        'description': productDescription.value,
        'price': price.value,
        'category_id': selectedCategoryId.value,
        'condition': selectedCondition.value,
        'status': 'active',
        'section_id': selectedSection.value?.id ?? 0,
        'media': selectedMedia.map((media) => media.id).toList(),
        'keywords': keywords.toList(),
        'variations': variations.toList(),
        'related_products': relatedProducts.map((p) => p['id']).toList(),
        'store_id': selectedStore['id'] ?? 0,
        'skip_related_products': skipRelatedProducts.value,
      };
      
      print('📤 [PRODUCT] إرسال البيانات:');
      print(jsonEncode(productData));
      
      final response = await ApiHelper.post(
        path: '/merchants/products',
        body: productData,
        withLoading: true,
      );
      
      if (response != null && response['status'] == true) {
        print('✅ [PRODUCT] تم إرسال المنتج بنجاح');
        
        // إعادة تعيين البيانات بعد النجاح
        reset();
        
        return {
          'success': true,
          'message': response['message'] ?? 'تم إضافة المنتج بنجاح',
          'data': response['data'],
        };
      } else {
        submitError.value = response?['message'] ?? 'فشل في إضافة المنتج';
        print('❌ [PRODUCT] فشل في الإرسال: ${submitError.value}');
        
        return {
          'success': false,
          'message': submitError.value,
        };
      }
    } catch (e) {
      submitError.value = 'خطأ في إرسال المنتج: ${e.toString()}';
      print('❌ [PRODUCT] خطأ في الإرسال: $e');
      
      return {
        'success': false,
        'message': submitError.value,
      };
    } finally {
      isSubmitting(false);
    }
  }
  
  void refreshSectionsFromBottomSheet() {
    print('🔄 [PRODUCT CENTRAL] تحديث الأقسام من BottomSheet');
  }
  
  // دالة مساعدة للحصول على ID المتجر
  int get storeId => selectedStore['id'] ?? 0;
  
  // دالة مساعدة للحصول على اسم المتجر
  String get storeName => selectedStore['name'] ?? 'غير محدد';
  
  @override
  void onClose() {
    saveToStorage();
    print('🔚 [PRODUCT CENTRAL] إغلاق المتحكم');
    super.onClose();
  }
}