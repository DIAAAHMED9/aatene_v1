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

  var productName = ''.obs;
  var productDescription = ''.obs;
  var price = ''.obs;
  var selectedCategoryId = 0.obs;
  var selectedCondition = ''.obs;
  var selectedMedia = <MediaItem>[].obs;

  var keywords = <String>[].obs;

  var variations = <Map<String, dynamic>>[].obs;

  var relatedProducts = <Map<String, dynamic>>[].obs;

  var categories = <Map<String, dynamic>>[].obs;
  var isLoadingCategories = false.obs;
  var categoriesError = ''.obs;

  var isSubmitting = false.obs;
  var selectedStore = Rx<Map<String, dynamic>?>(null);

  var selectedSection = Rx<Section?>(null);

  bool _isUpdatingSection = false;

  @override
  void onInit() {
    super.onInit();
    print('🔄 [PRODUCT CENTRAL CONTROLLER INITIALIZED]');
  }

  Future<void> loadCategoriesIfNeeded() async {
    if (categories.isNotEmpty || isLoadingCategories.value) {
      return;
    }
    await loadCategories();
  }

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

  Future<void> reloadCategories() async {
    categories.clear();
    await loadCategories();
  }

  void updateSelectedStore(Map<String, dynamic> store) {
    selectedStore(store);
    print('🏪 [STORE UPDATED]: ${store['name']} (ID: ${store['id']})');
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

  bool isBasicInfoComplete() {
    return productName.isNotEmpty &&
        productDescription.isNotEmpty &&
        price.isNotEmpty &&
        selectedCategoryId > 0 &&
        selectedCondition.isNotEmpty &&
        selectedSection.value != null;
  }

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

      if (selectedSection.value == null) {
        return {
          'success': false,
          'message': 'يرجى اختيار قسم للمنتج'
        };
      }

      _updateVariationsData();

      final variationController = Get.find<ProductVariationController>();
      final variationsData = variationController.prepareVariationsForApi();

      print('🎯 [VARIATIONS DATA PREPARED]: ${variationsData.length} متغير');

      final productData = await _prepareProductData(variationsData);

      print('📤 [PRODUCT DATA TO SEND - FINAL]: ${jsonEncode(productData)}');

      final response = await ApiHelper.post(
        path: '/merchants/products',
        body: productData,
        withLoading: true,
      );

      print('📥 [PRODUCT API RESPONSE]: ${jsonEncode(response)}');

      if (response != null && response['status'] == true) {
        final product = response['data']?[0];
        print('✅ [PRODUCT CREATED SUCCESSFULLY]: ${product?['name']}');
        
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

  Future<Map<String, dynamic>> _prepareProductData(List<Map<String, dynamic>> variationsData) async {
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

    if (selectedMedia.isNotEmpty) {

          final firstMedia = selectedMedia.first;

      print('media selctor :: ${selectedMedia.map((media) => media.fileUrl).toList()}');
      productData['cover'] = _getFilePath(firstMedia.fileUrl!);
    productData['gallary'] = selectedMedia.map((media) => _getFilePath(media.fileUrl!)).toList();
    }
   print('🖼️ [MEDIA PATHS FORMATTED]:');
    print('   Cover: ${productData['cover']}');
    print('   Gallary: ${productData['gallary']}');
  
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
    
    print('✅ [VARIATIONS UPDATED]: Images cleaned for API');
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

void updateSelectedSection(Section section) {
  if (_isUpdatingSection) return;
  
  _isUpdatingSection = true;
  
  try {
    if (selectedSection.value?.id == section.id) {
      print('⚠️ [SECTION ALREADY UPDATED]: ${section.name} (ID: ${section.id})');
      return;
    }
    
    selectedSection(section);
    print('✅ [SECTION UPDATED]: ${section.name} (ID: ${section.id})');
    
    final bottomSheetController = Get.find<BottomSheetController>();
    bottomSheetController.selectSection(section);
  } finally {
    Future.delayed(Duration(milliseconds: 100), () {
      _isUpdatingSection = false;
    });
  }
}

  Future<Map<String, dynamic>> testWithCorrectStructure() async {
    try {
      print('🧪 [TESTING WITH CORRECT STRUCTURE]');
      
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
String _getFilePath(String url) {
  try {
    final uri = Uri.parse(url);
    String path = uri.path;
    
    print('🔄 [PATH CONVERSION]: Original: $path');
    
    if (path.startsWith('/storage/')) {
      final newPath = path.replaceFirst('/storage/', '');
      print('   → After removing /storage/: $newPath');
      return newPath;
    }
    
    if (path.startsWith('/gallery/')) {
      final newPath = path.substring(1);
      print('   → After removing first slash: $newPath');
      return newPath;
    }
    
    if (path.startsWith('/images/')) {
      final newPath = path.substring(1);
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
String _getFileName(String url) {
  try {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      return pathSegments.last;
    }
    return url;
  } catch (e) {
    return url;
  }
}
}