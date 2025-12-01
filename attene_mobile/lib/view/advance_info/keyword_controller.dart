import 'dart:convert';
import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/controller/product_controller.dart';
import 'package:attene_mobile/my_app/may_app_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Store {
  final int id;
  final String name;
  final String? logoUrl;
  final String status;

  Store({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.status,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'] as int,
      name: json['name'] as String,
      logoUrl: json['logo_url'] as String?,
      status: json['status'] as String,
    );
  }

  @override
  String toString() => name;
}

class Keyword {
  final int id;
  final String text;

  Keyword({required this.id, required this.text});
}

class KeywordController extends GetxController {
  // === إدارة المتاجر ===
  var stores = <Store>[].obs;
  var selectedStore = Rx<Store?>(null);
  var isLoadingStores = false.obs;
  var storesError = ''.obs;
  var hasAttemptedLoad = false.obs;

  // === إدارة الكلمات المفتاحية ===
  var availableKeywords = <Keyword>[].obs;
  var selectedKeywords = <Keyword>[].obs;
  var filteredAvailableKeywords = <Keyword>[].obs;

  // === البحث ===
  final searchController = TextEditingController();
  var isSearchInputEmpty = true.obs;

  // === الحد الأقصى ===
  final int maxKeywords = 15;

  @override
  void onInit() {
    super.onInit();
    print('🔑 [KEYWORD CONTROLLER INITIALIZED]');
    
    searchController.addListener(_onSearchChanged);
    _loadDefaultKeywords();
    
    // لا نحمل المتاجر تلقائياً، سننتظر حتى يفتح المستخدم الشاشة
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // ✅ جديد: تحميل المتاجر فقط عند فتح الشاشة
  Future<void> loadStoresOnOpen() async {
    if (hasAttemptedLoad.value && stores.isNotEmpty) {
      return; // لا نحمل إذا كانت محملة مسبقاً
    }
    await loadStores();
  }

  // ✅ محدث: تحسين جلب المتاجر مع معالجة أفضل
  Future<void> loadStores() async {
    try {
      // التحقق من تسجيل الدخول أولاً
      final MyAppController myAppController = Get.find<MyAppController>();
      if (!myAppController.isLoggedIn.value) {
        storesError('يجب تسجيل الدخول أولاً');
        print('⚠️ [STORES] User not logged in');
        return;
      }

      hasAttemptedLoad(true);
      isLoadingStores(true);
      storesError('');
      print('🏪 [LOADING STORES FROM API]');

      final response = await ApiHelper.get(
        path: '/merchants/stores',
        queryParameters: {'orderDir': 'asc'},
        withLoading: false,
      );

      print('🎯 [STORES API RESPONSE STATUS]: ${response?['status']}');
      print('🎯 [STORES API DATA LENGTH]: ${response?['data']?.length ?? 0}');

      if (response != null && response['status'] == true) {
        final storesList = List<Map<String, dynamic>>.from(response['data'] ?? []);
        final loadedStores = storesList.map((storeJson) => Store.fromJson(storeJson)).toList();
        
        stores.assignAll(loadedStores);
        print('✅ تم تحميل ${stores.length} متجر بنجاح');
        
        if (stores.isNotEmpty) {
          selectedStore(stores.first);
          print('✅ [STORE SELECTED BY DEFAULT]: ${stores.first.name}');
        } else {
          selectedStore(null);
          storesError('لا توجد متاجر متاحة');
          print('⚠️ لا توجد متاجر متاحة');
        }
      } else {
        final errorMessage = response?['message'] ?? 'فشل في تحميل المتاجر';
        storesError(errorMessage);
        print('❌ فشل في تحميل المتاجر: $errorMessage');
      }
    } catch (e) {
      final error = 'حدث خطأ أثناء تحميل المتاجر: $e';
      storesError(error);
      print('❌ خطأ في تحميل المتاجر: $e');
    } finally {
      isLoadingStores(false);
    }
  }

  // ✅ جديد: إعادة تحميل المتاجر
  Future<void> reloadStores() async {
    stores.clear();
    await loadStores();
  }

  void refreshStores() {
    loadStores();
  }

  void setSelectedStore(Store store) {
    selectedStore(store);
    print('✅ [STORE SELECTED]: ${store.name} (ID: ${store.id})');
    _loadKeywordsForStore(store.id);
  }

  void _loadDefaultKeywords() {
    final defaultKeywords = [
      Keyword(id: 1, text: 'ملابس'),
      Keyword(id: 2, text: 'أحذية'),
      Keyword(id: 3, text: 'إلكترونيات'),
      Keyword(id: 4, text: 'هواتف'),
      Keyword(id: 5, text: 'لابتوبات'),
      Keyword(id: 6, text: 'إكسسوارات'),
      Keyword(id: 7, text: 'منزلية'),
      Keyword(id: 8, text: 'رياضية'),
      Keyword(id: 9, text: 'عطور'),
      Keyword(id: 10, text: 'جمال'),
    ];
    
    availableKeywords.assignAll(defaultKeywords);
    filteredAvailableKeywords.assignAll(defaultKeywords);
    print('🔤 [DEFAULT KEYWORDS LOADED]: ${defaultKeywords.length} كلمة مفتاحية');
  }

  void _loadKeywordsForStore(int storeId) {
    print('🔄 [LOADING KEYWORDS FOR STORE]: $storeId');
  }

  void _onSearchChanged() {
    final query = searchController.text.trim();
    isSearchInputEmpty.value = query.isEmpty;

    if (query.isEmpty) {
      filteredAvailableKeywords.assignAll(availableKeywords);
    } else {
      final filtered = availableKeywords.where((keyword) {
        return keyword.text.contains(query);
      }).toList();
      filteredAvailableKeywords.assignAll(filtered);
    }
  }

  void addCustomKeyword() {
    final text = searchController.text.trim();
    
    if (text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال كلمة مفتاحية', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (isDuplicateKeyword) {
      Get.snackbar('خطأ', 'هذه الكلمة مفتاحية مضاف مسبقاً', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (!canAddMoreKeywords) {
      Get.snackbar('خطأ', 'تم الوصول للحد الأقصى (15 كلمة)', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    final newKeyword = Keyword(
      id: DateTime.now().millisecondsSinceEpoch,
      text: text,
    );

    selectedKeywords.add(newKeyword);
    searchController.clear();
    
    print('✅ [CUSTOM KEYWORD ADDED]: $text');
    _updateProductControllerKeywords();
  }

  void addKeyword(Keyword keyword) {
    if (isKeywordSelected(keyword)) {
      Get.snackbar('خطأ', 'هذه الكلمة مفتاحية مضاف مسبقاً', backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    if (!canAddMoreKeywords) {
      Get.snackbar('خطأ', 'تم الوصول للحد الأقصى (15 كلمة)', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    selectedKeywords.add(keyword);
    print('✅ [KEYWORD ADDED]: ${keyword.text}');
    _updateProductControllerKeywords();
  }

  void removeKeyword(int keywordId) {
    selectedKeywords.removeWhere((keyword) => keyword.id == keywordId);
    print('🗑️ [KEYWORD REMOVED]: ID $keywordId');
    _updateProductControllerKeywords();
  }

  void _updateProductControllerKeywords() {
    try {
      final productController = Get.find<ProductCentralController>();
      final keywordTexts = selectedKeywords.map((k) => k.text).toList();
      productController.addKeywords(keywordTexts);
      
      print('🔄 [KEYWORDS UPDATED IN PRODUCT CONTROLLER]: ${keywordTexts.length} كلمة');
      productController.printDataSummary();
    } catch (e) {
      print('❌ [ERROR UPDATING PRODUCT CONTROLLER]: $e');
    }
  }

  void confirmSelection() {
    if (selectedStore.value == null) {
      Get.snackbar('خطأ', 'يرجى اختيار متجر', backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    try {
      final productController = Get.find<ProductCentralController>();
      
      print('✅ [SELECTION CONFIRMED]');
      print('   🏪 المتجر: ${selectedStore.value!.name}');
      print('   🔤 الكلمات: ${selectedKeywords.length} كلمة مفتاحية');
      
      Get.back();
      Get.snackbar('نجاح', 'تم حفظ الكلمات المفتاحية بنجاح', backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      print('❌ [ERROR CONFIRMING SELECTION]: $e');
      Get.snackbar('خطأ', 'حدث خطأ أثناء الحفظ', backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  bool get canAddMoreKeywords => selectedKeywords.length < maxKeywords;

  bool get isDuplicateKeyword {
    final text = searchController.text.trim();
    return selectedKeywords.any((keyword) => keyword.text == text);
  }

  bool isKeywordSelected(Keyword keyword) {
    return selectedKeywords.any((k) => k.text == keyword.text);
  }

  String getStoreStatusText(String status) {
    switch (status) {
      case 'active':
        return 'نشط';
      case 'not-active':
        return 'غير نشط';
      case 'pending':
        return 'قيد المراجعة';
      default:
        return status;
    }
  }

  Color getStoreStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'not-active':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  void printDataSummary() {
    print('''
📊 [KEYWORD CONTROLLER SUMMARY]:
   المتجر: ${selectedStore.value?.name ?? 'لم يتم الاختيار'}
   الكلمات المختارة: ${selectedKeywords.length}
   الكلمات المتاحة: ${availableKeywords.length}
   يمكن إضافة المزيد: $canAddMoreKeywords
''');
  }
}