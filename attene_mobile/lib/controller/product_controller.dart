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
  final RxList<Map<String, dynamic>> relatedProducts = <Map<String, dynamic>>[].obs;
  final Rx<Map<String, dynamic>?> selectedStore = Rx<Map<String, dynamic>?>(null);
  
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingCategories = false.obs;
  final RxString categoriesError = ''.obs;
  
  final RxBool isSubmitting = false.obs;
  final RxBool _isUpdatingSection = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    print('🔄 [PRODUCT CENTRAL] تهيئة متحكم المنتجات المركزي');
    _loadCachedCategories();
  }
  
  Future<void> _loadCachedCategories() async {
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
      _performLoadCategories(),
      message: 'جاري تحميل الفئات...',
    );
  }
  
  Future<void> _performLoadCategories() async {
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
    
    if (section != null) {
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
  }
  
  void addKeywords(List<String> newKeywords) {
    keywords.assignAll(newKeywords);
    print('🔤 [PRODUCT] تحديث الكلمات المفتاحية: ${newKeywords.length} كلمة');
  }
  
  void addVariations(List<Map<String, dynamic>> newVariations) {
    variations.assignAll(newVariations);
    print('🎨 [PRODUCT] تحديث المتغيرات: ${newVariations.length} متغير');
  }
  
  void addRelatedProducts(List<Map<String, dynamic>> products) {
    relatedProducts.assignAll(products);
    print('🔗 [PRODUCT] تحديط المنتجات المرتبطة: ${products.length} منتج');
  }
  
  bool isBasicInfoComplete() {
    return productName.isNotEmpty &&
        productDescription.isNotEmpty &&
        price.isNotEmpty &&
        selectedCategoryId > 0 &&
        selectedCondition.isNotEmpty;
        //  &&
        // selectedSection.value != null;
  }
  
  Future<Map<String, dynamic>?> submitProduct() async {
    return UnifiedLoadingScreen.showWithFuture<Map<String, dynamic>>(
      _performSubmitProduct(),
      message: 'جاري إضافة المنتج...',
    );
  }
  
  Future<Map<String, dynamic>> _performSubmitProduct() async {
    try {
      isSubmitting(true);
      
      print('''
🚀 [PRODUCT] إرسال المنتج - الحل النهائي:
   الاسم: ${productName.value}
   الفئة: ${selectedCategoryId.value}
   السعر: ${price.value}
   القسم: ${selectedSection.value?.name ?? 'غير محدد'} (ID: ${selectedSection.value?.id})
   الوسائط: ${selectedMedia.length}
   الكلمات المفتاحية: ${keywords.length}
   المنتجات المرتبطة: ${relatedProducts.length}
''');
  
      // if (selectedSection.value == null) {
      //   return {
      //     'success': false,
      //     'message': 'يرجى اختيار قسم للمنتج'
      //   };
      // }
  
      _updateVariationsData();
  
      final variationController = Get.find<ProductVariationController>();
      final variationsData = variationController.prepareVariationsForApi();
  
      print('🎯 [PRODUCT] بيانات المتغيرات المعدة: ${variationsData.length} متغير');
  
      final productData = await _prepareProductData(variationsData);
  
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
        
        _resetAfterSuccess(variationController);
        
        return {'success': true, 'data': response['data']};
      } else {
        final errorMessage = _parseErrorMessage(response);
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
  
  Future<Map<String, dynamic>> _prepareProductData(List<Map<String, dynamic>> variationsData) async {
    final productData = <String, dynamic>{
      'section_id': 44,
      // selectedSection.value!.id,
      'name': productName.value.trim(),
      'description': productDescription.value.trim(),
      'price': double.tryParse(price.value) ?? 0.0,
      'category_id': selectedCategoryId.value,
      'condition': _formatCondition(selectedCondition.value),
      'short_description': _getShortDescription(),
      'sku': _generateSku(),
    };
  
    if (selectedMedia.isNotEmpty) {
      final firstMedia = selectedMedia.first;
      productData['cover'] = _getFilePath(firstMedia.fileUrl);
      productData['gallary'] = selectedMedia.map((media) => _getFilePath(media.fileUrl)).toList();
    }
  
    if (keywords.isNotEmpty) {
      productData['tags'] = keywords;
    } else {
      productData['tags'] = [];
    }
  
    if (variationsData.isNotEmpty) {
      productData['type'] = 'variation';
      productData['variations'] = _prepareVariationsData(variationsData);
    } else {
      productData['type'] = 'simple';
      productData['variations'] = [];
    }
  
    if (relatedProducts.isNotEmpty) {
      productData['crossSells'] = relatedProducts.map((p) => p['id']).toList();
      productData['cross_sells_price'] = double.tryParse(price.value) ?? 0.0;
      
      final dueDate = DateTime.now().add(const Duration(days: 30));
      productData['cross_sells_due_date'] =
          '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}';
    } else {
      productData['crossSells'] = [];
      productData['cross_sells_price']=0;
      productData['cross_sells_due_date']='';
    }
  
    print('✅ [PRODUCT] بيانات المنتج النهائية: ${jsonEncode(productData)}');
    return productData;
  }
  
  List<Map<String, dynamic>> _prepareVariationsData(List<Map<String, dynamic>> variationsData) {
    return variationsData.map((variation) {
      final variationData = {
        'price': variation['price'],
        'attributeOptions': _prepareAttributeOptions(variation['attributeOptions'] ?? []),
      };
      
      if (variation['image'] != null && variation['image'].toString().isNotEmpty) {
        variationData['image'] = _getFilePath(variation['image'].toString());
      }
      
      return variationData;
    }).toList();
  }
  
  List<Map<String, dynamic>> _prepareAttributeOptions(List<dynamic> attributeOptions) {
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
  
  void _updateVariationsData() {
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
  
  String _parseErrorMessage(Map<String, dynamic>? response) {
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
  
  void _resetAfterSuccess(ProductVariationController variationController) {
    reset();
    variationController.toggleHasVariations(false);
    variationController.selectedAttributes.clear();
    variationController.variations.clear();
  }
  
  String _formatCondition(String condition) {
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
  
  String _generateSku() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp % 10000;
    return 'SKU${productName.value.replaceAll(' ', '_').toUpperCase()}_$random';
  }
  
  String _getShortDescription() {
    if (productDescription.value.length <= 100) {
      return productDescription.value;
    }
    return '${productDescription.value.substring(0, 100)}...';
  }
  
  String _getFilePath(String? url) {
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
  
  void reset() {
    productName('');
    productDescription('');
    price('');
    selectedCategoryId(0);
    selectedCondition('');
    selectedMedia.clear();
    keywords.clear();
    variations.clear();
    relatedProducts.clear();
    selectedSection(null);
    
    print('🔄 [PRODUCT] إعادة تعيين بيانات المنتج');
  }
  
  void printDataSummary() {
    final variationController = Get.find<ProductVariationController>();
    
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
   المنتجات المرتبطة: ${relatedProducts.length}
''');
  }
  
  void updateSelectedSection(Section section) {
    if (_isUpdatingSection.value) return;
    
    _isUpdatingSection.value = true;
    
    try {
      if (selectedSection.value?.id == section.id) {
        print('⚠️ [PRODUCT] القسم محدث بالفعل: ${section.name} (ID: ${section.id})');
        return;
      }
      
      selectedSection(section);
      print('✅ [PRODUCT] تحديث القسم: ${section.name} (ID: ${section.id})');
      
      final bottomSheetController = Get.find<BottomSheetController>();
      bottomSheetController.selectSection(section);
    } finally {
      Future.delayed(const Duration(milliseconds: 100), () {
        _isUpdatingSection.value = false;
      });
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
  
  @override
  void onClose() {
    print('🔚 [PRODUCT] إغلاق متحكم المنتجات المركزي');
    super.onClose();
  }
}