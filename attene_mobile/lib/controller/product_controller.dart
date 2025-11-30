// lib/controller/product_central_controller.dart
import 'dart:convert';
import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/models/section_model.dart';
import 'package:attene_mobile/my_app/may_app_controller.dart';
import 'package:attene_mobile/view/product_variations/product_variation_controller.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/view/media_library/media_model.dart';
import 'package:attene_mobile/utlis/sheet_controller.dart';

class ProductCentralController extends GetxController {
  static ProductCentralController get to => Get.find();

  // === بيانات الخطوة الأولى - المعلومات الأساسية ===
  var productName = ''.obs;
  var productDescription = ''.obs;
  var price = ''.obs;
  var selectedCategoryId = 0.obs;
  var selectedCondition = ''.obs;
  var selectedMedia = <MediaItem>[].obs;

  // === بيانات الخطوة الثانية - الكلمات المفتاحية ===
  var keywords = <String>[].obs;

  // === بيانات الخطوة الثالثة - المتغيرات ===
  var variations = <Map<String, dynamic>>[].obs;

  // === بيانات الخطوة الرابعة - المنتجات المرتبطة ===
  var relatedProducts = <Map<String, dynamic>>[].obs;

  // === قائمة الفئات ===
  var categories = <Map<String, dynamic>>[].obs;
  var isLoadingCategories = false.obs;
  var categoriesError = ''.obs;

  // === حالة التحميل ===
  var isSubmitting = false.obs;
  var selectedStore = Rx<Map<String, dynamic>?>(null);

  // ✅ إضافة متغير للقسم المختار
  var selectedSection = Rx<Section?>(null);

  @override
  void onInit() {
    super.onInit();
    print('🔄 [PRODUCT CENTRAL CONTROLLER INITIALIZED]');
  }

  // ✅ تحميل الفئات فقط عند الحاجة مع معالجة أفضل
  Future<void> loadCategoriesIfNeeded() async {
    if (categories.isNotEmpty || isLoadingCategories.value) {
      return;
    }
    await loadCategories();
  }

  // ✅ تحسين جلب الفئات مع التحقق من تسجيل الدخول
  Future<void> loadCategories() async {
    try {
      final MyAppController myAppController = Get.find<MyAppController>();
      if (!myAppController.isLoggedIn.value) {
        categoriesError('يجب تسجيل الدخول أولاً');
        print('⚠️ [CATEGORIES] User not logged in');
        return;
      }

      isLoadingCategories(true);
      categoriesError('');
      print('📡 [LOADING CATEGORIES FROM API]');
      
      final response = await ApiHelper.get(
        path: '/merchants/categories/select',
        withLoading: false,
      );

      if (response != null && response['status'] == true) {
        final categoriesList = List<Map<String, dynamic>>.from(response['categories'] ?? []);
        categories.assignAll(categoriesList);
        print('✅ تم تحميل ${categories.length} فئة بنجاح');
      } else {
        final errorMessage = response?['message'] ?? 'فشل في تحميل الفئات';
        categoriesError(errorMessage);
        print('❌ فشل في تحميل الفئات: $errorMessage');
      }
    } catch (e) {
      final error = 'حدث خطأ أثناء تحميل الفئات: $e';
      categoriesError(error);
      print('❌ خطأ في تحميل الفئات: $e');
    } finally {
      isLoadingCategories(false);
    }
  }

  // ✅ إعادة تحميل الفئات
  Future<void> reloadCategories() async {
    categories.clear();
    await loadCategories();
  }

  void updateSelectedStore(Map<String, dynamic> store) {
    selectedStore(store);
    print('🏪 [STORE UPDATED]: ${store['name']} (ID: ${store['id']})');
    printDataSummary();
  }

  // ✅ تحديث: إضافة معلمة section
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
      selectedSection(section);
    }

    print('''
📦 [BASIC INFO UPDATED]:
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
    print('🔤 [KEYWORDS UPDATED]: ${newKeywords.length} كلمة مفتاحية');
  }

  void addVariations(List<Map<String, dynamic>> newVariations) {
    variations.assignAll(newVariations);
    print('🎨 [VARIATIONS UPDATED]: ${newVariations.length} متغير');
  }

  void addRelatedProducts(List<Map<String, dynamic>> products) {
    relatedProducts.assignAll(products);
    print('🔗 [RELATED PRODUCTS UPDATED]: ${products.length} منتج مرتبط');
  }

  // ✅ محدث: التحقق من اكتمال المعلومات الأساسية بما فيها القسم
  bool isBasicInfoComplete() {
    return productName.isNotEmpty &&
        productDescription.isNotEmpty &&
        price.isNotEmpty &&
        selectedCategoryId > 0 &&
        selectedCondition.isNotEmpty &&
        selectedSection.value != null;
  }

  // ✅ **الحل النهائي**: دالة submitProduct مع إصلاحات كاملة
  Future<Map<String, dynamic>> submitProduct() async {
    try {
      isSubmitting(true);
      
      print('''
🚀 [SUBMITTING PRODUCT - FINAL SOLUTION]:
   الاسم: ${productName.value}
   الفئة: ${selectedCategoryId.value}
   السعر: ${price.value}
   القسم: ${selectedSection.value?.name ?? 'غير محدد'} (ID: ${selectedSection.value?.id})
   الوسائط: ${selectedMedia.length} (IDs: ${selectedMedia.map((m) => m.id).toList()})
   الكلمات المفتاحية: ${keywords.length}
   المنتجات المرتبطة: ${relatedProducts.length}
''');

      // ✅ التحقق من وجود قسم مطلوب
      if (selectedSection.value == null) {
        return {
          'success': false, 
          'message': 'يرجى اختيار قسم للمنتج'
        };
      }

      // ✅ تحديث بيانات الاختلافات أولاً
      _updateVariationsData();

      // ✅ الحصول على بيانات المتغيرات
      final variationController = Get.find<ProductVariationController>();
      final variationsData = variationController.prepareVariationsForApi();

      print('🎯 [VARIATIONS DATA PREPARED]: ${variationsData.length} متغير');

      // ✅ تحضير البيانات للإرسال بالهيكل الصحيح
      final productData = await _prepareProductData(variationsData);

      print('📤 [PRODUCT DATA TO SEND - FINAL]: ${jsonEncode(productData)}');

      // ✅ إرسال الطلب
      final response = await ApiHelper.post(
        path: '/merchants/products',
        body: productData,
        withLoading: true,
      );

      print('📥 [PRODUCT API RESPONSE]: ${jsonEncode(response)}');

      if (response != null && response['status'] == true) {
        final product = response['data']?[0];
        print('✅ [PRODUCT CREATED SUCCESSFULLY]: ${product?['name']}');
        
        // ✅ إعادة تعيين البيانات بعد النجاح
        _resetAfterSuccess(variationController);
        
        return {'success': true, 'data': response['data']};
      } else {
        final errorMessage = _parseErrorMessage(response);
        print('❌ [PRODUCT CREATION FAILED]: $errorMessage');
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('❌ [PRODUCT SUBMISSION ERROR]: $e');
      return {'success': false, 'message': 'حدث خطأ أثناء إضافة المنتج: $e'};
    } finally {
      isSubmitting(false);
    }
  }

  // ✅ **الحل النهائي**: تحضير بيانات المنتج بدون مشاكل الصور
  Future<Map<String, dynamic>> _prepareProductData(List<Map<String, dynamic>> variationsData) async {
    // ✅ الهيكل الأساسي للمنتج - بدون صور
    final productData = <String, dynamic>{
      'section_id': selectedSection.value!.id,
      'name': productName.value.trim(),
      'description': productDescription.value.trim(),
      'price': double.parse(price.value),
      'category_id': selectedCategoryId.value,
      'condition': _formatCondition(selectedCondition.value),
      'short_description': _getShortDescription(),
      'sku': _generateSku(),

          "crossSells": [
        14,
        13
    ],
    "cross_sells_price": 1400,
    "cross_sells_due_date": "2025-02-02"
    };

    // ✅ **الحل: إرسال معرفات الوسائط فقط**
    
    if (selectedMedia.isNotEmpty) {
      /**
       * 
        "cover": "images/lAh7E2s8XMCP1VGghBWE0FMkXe5WTAOSCxmzvkKR.jpg",
        "gallary": [
            "gallery/Ffj4GWbIbgZOCJDNt9t4T93pGLvVdCTwrwyCYIoW.jpg",
            "gallery/1Zl4RDER5a7BqxwkGmVCqDW4mrI6dHYSWsbO4BM5.jpg",
            "gallery/QgHghJAVRR0It0eJTBSujhWCHp0mpeU8pooSNKDj.jpg"
        ],

       */
          final firstMedia = selectedMedia.first;

      print('media selctor :: ${selectedMedia.map((media) => media.fileUrl).toList()}');
      productData['cover'] = _getFilePath(firstMedia.fileUrl!);
      // map((media) => media.path).toList();
    productData['gallary'] = selectedMedia.map((media) => _getFilePath(media.fileUrl!)).toList();
      // productData['media'] = selectedMedia.map((media) => media.path).toList();
    }
   print('🖼️ [MEDIA PATHS FORMATTED]:');
    print('   Cover: ${productData['cover']}');
    print('   Gallary: ${productData['gallary']}');
  
    // ✅ إضافة tags
    if (keywords.isNotEmpty) {
      productData['tags'] = keywords;
    } else {
      productData['tags'] = [];
    }

    // ✅ إضافة نوع المنتج والاختلافات
    if (variationsData.isNotEmpty) {
      productData['type'] = 'variation';
      productData['variations'] = _prepareVariationsData(variationsData);
    } else {
      productData['type'] = 'simple';
      productData['variations'] = [];
    }

    // ✅ إضافة related_products
    if (relatedProducts.isNotEmpty) {
      productData['crossSells'] = relatedProducts.map((p) => p['id']).toList();
      productData['cross_sells_price'] = double.parse(price.value);
      
      final dueDate = DateTime.now().add(Duration(days: 30));
      productData['cross_sells_due_date'] = 
          '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}';
    } else {
      productData['crossSells'] = [];
    }

    print('✅ [FINAL PRODUCT DATA - SAFE]: ${jsonEncode(productData)}');
    return productData;
  }

  // ✅ **الحل النهائي**: تحضير بيانات الاختلافات بدون صور
// ✅ **الحل النهائي**: تحضير بيانات الاختلافات مع المسارات الصحيحة
List<Map<String, dynamic>> _prepareVariationsData(List<Map<String, dynamic>> variationsData) {
  return variationsData.map((variation) {
    final variationData = {
      'price': variation['price'],
      'attributeOptions': _prepareAttributeOptions(variation['attributeOptions'] ?? []),
    };
    
    // ✅ إذا كانت هناك صورة للمتغير، أرسل مسارها فقط
    if (variation['image'] != null && variation['image'].toString().isNotEmpty) {
      variationData['image'] = _getFilePath(variation['image'].toString());
    }
    
    return variationData;
  }).toList();
}

  // ✅ **الحل النهائي**: تحضير attributeOptions
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

  // ✅ تحديث بيانات الاختلافات
  void _updateVariationsData() {
    final variationController = Get.find<ProductVariationController>();
    
    // ✅ تنظيف صور الاختلافات لتجنب الأخطاء
    for (final variation in variationController.variations) {
      if (variation.images.isNotEmpty) {
        // إذا كانت الصورة مسار افتراضي، امسحها
        if (variation.images.first.contains('variation_default.jpg') || 
            variation.images.first.isEmpty) {
          variation.images.clear();
        }
      }
    }
    
    print('✅ [VARIATIONS UPDATED]: Images cleaned for API');
  }

  // ✅ تحليل رسالة الخطأ
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

  // ✅ إعادة التعيين بعد النجاح
  void _resetAfterSuccess(ProductVariationController variationController) {
    reset();
    variationController.toggleHasVariations(false);
    variationController.selectedAttributes.clear();
    variationController.variations.clear();
  }

  // ✅ دالة مساعدة لتصحيح صيغة condition
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

  // ✅ إعادة تعيين كافة البيانات
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
    
    print('🔄 [PRODUCT DATA RESET]');
  }

  // ✅ عرض ملخص البيانات مع القسم
  void printDataSummary() {
    final variationController = Get.find<ProductVariationController>();
    
    print('''
📊 [PRODUCT DATA SUMMARY]:
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

  // ✅ دالة لتحديث القسم المختار
  void updateSelectedSection(Section section) {
    selectedSection(section);
    print('✅ [SECTION UPDATED]: ${section.name} (ID: ${section.id})');
  }

  // ✅ دالة اختبار للبيانات الصحيحة
  Future<Map<String, dynamic>> testWithCorrectStructure() async {
    try {
      print('🧪 [TESTING WITH CORRECT STRUCTURE]');
      
      // ✅ بيانات تجريبية تطابق الهيكل الصحيح تماماً
      final testData = {
        "section_id": 18,
        // "sku": "TEST_SKU_${DateTime.now().millisecondsSinceEpoch}",
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

      print('🧪 [TEST DATA WITH CORRECT STRUCTURE]: ${jsonEncode(testData)}');

      final response = await ApiHelper.post(
        path: '/merchants/products',
        body: testData,
        withLoading: true,
      );

      print('🧪 [TEST RESPONSE]: ${jsonEncode(response)}');

      if (response != null && response['status'] == true) {
        return {'success': true, 'message': '✅ الاختبار نجح - الهيكل صحيح'};
      } else {
        return {'success': false, 'message': '❌ فشل الاختبار: ${response?['message']}'};
      }
    } catch (e) {
      return {'success': false, 'message': '❌ خطأ في الاختبار: $e'};
    }
  }
  // ✅ استخراج مسار الملف فقط من URL الوسائط
// ✅ تحويل مسارات التخزين إلى المسارات المتوقعة من الخادم
// ✅ إزالة الجزء /storage/ من بداية المسار
String _getFilePath(String url) {
  try {
    final uri = Uri.parse(url);
    String path = uri.path;
    
    print('🔄 [PATH CONVERSION]: Original: $path');
    
    // إزالة /storage/ من البداية إذا موجود
    if (path.startsWith('/storage/')) {
      final newPath = path.replaceFirst('/storage/', '');
      print('   → After removing /storage/: $newPath');
      return newPath;
    }
    
    // إذا كان المسار يبدأ بـ /gallery/ أو /images/ أزل الـ /
    if (path.startsWith('/gallery/')) {
      final newPath = path.substring(1); // إزالة أول /
      print('   → After removing first slash: $newPath');
      return newPath;
    }
    
    if (path.startsWith('/images/')) {
      final newPath = path.substring(1); // إزالة أول /
      print('   → After removing first slash: $newPath');
      return newPath;
    }
    
    print('   → No conversion needed: $path');
    return path;
  } catch (e) {
    print('❌ [PATH CONVERSION ERROR]: $e');
    return url;
  }
}
// ✅ استخراج اسم الملف فقط (بدون المسار الكامل)
String _getFileName(String url) {
  try {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      return pathSegments.last; // يعيد اسم الملف فقط مثل: xxx.jpg
    }
    return url;
  } catch (e) {
    return url;
  }
}
}