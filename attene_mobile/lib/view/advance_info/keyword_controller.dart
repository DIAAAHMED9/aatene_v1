import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/models/section_model.dart';

import '../../controller/product_controller.dart' show ProductCentralController;
import '../../models/store_model.dart';
import '../../my_app/my_app_controller.dart';

class KeywordController extends GetxController {
  static KeywordController get to => Get.find();

  final MyAppController myAppController = Get.find();
  final ProductCentralController productController = Get.find();

  // المتاجر
  final RxList<Store> stores = <Store>[].obs;
  final Rx<Store?> selectedStore = Rx<Store?>(null);
  final RxBool isLoadingStores = false.obs;
  final RxString storesError = ''.obs;
  final RxBool hasAttemptedLoad = false.obs;

  // الكلمات المفتاحية
  final RxList<String> availableKeywords = <String>[].obs;
  final RxList<String> selectedKeywords = <String>[].obs;
  final RxList<String> filteredKeywords = <String>[].obs;

  // البحث
  final TextEditingController searchController = TextEditingController();
  final RxBool isSearchInputEmpty = true.obs;

  // حالة التحميل
  final RxBool isLoadingKeywords = false.obs;

  // الحد الأقصى
  final int maxKeywords = 15;

  @override
  void onInit() {
    super.onInit();
    print('🔄 [KEYWORD CONTROLLER] Initializing...');

    searchController.addListener(_onSearchChanged);
    _loadDefaultKeywords();
    _syncWithProductController();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _syncWithProductController() {
    // مزامنة الكلمات المختارة مع متحكم المنتجات
    selectedKeywords.assignAll(productController.keywords);
  }

  Future<void> loadStoresOnOpen() async {
    if (hasAttemptedLoad.value && stores.isNotEmpty) {
      return;
    }
    await loadStores();
  }

  Future<void> loadStores() async {
    try {
      if (!myAppController.isLoggedIn.value) {
        storesError('يجب تسجيل الدخول أولاً');
        print('⚠️ [KEYWORD] User not logged in');
        return;
      }

      hasAttemptedLoad(true);
      isLoadingStores(true);
      storesError('');

      print('🏪 [KEYWORD] Fetching stores from API...');

      final response = await ApiHelper.get(
        path: '/merchants/stores',
        queryParameters: {'orderDir': 'asc'},
        withLoading: false,
      );

      print('📥 [KEYWORD] API response status: ${response?['status']}');

      if (response != null && response['status'] == true) {
        final storesList = List<Map<String, dynamic>>.from(
          response['data'] ?? [],
        );
        final loadedStores = storesList
            .map((storeJson) => Store.fromJson(storeJson))
            .toList();

        stores.assignAll(loadedStores);
        print('✅ [KEYWORD] Loaded ${stores.length} stores successfully');

        if (stores.isNotEmpty) {
          selectedStore(stores.first);
          print('✅ [KEYWORD] Store selected by default: ${stores.first.name}');
        } else {
          selectedStore(null);
          storesError('لا توجد متاجر متاحة');
        }
      } else {
        final errorMessage = response?['message'] ?? 'فشل في تحميل المتاجر';
        storesError(errorMessage);
        print('❌ [KEYWORD] Failed to load stores: $errorMessage');
      }
    } catch (e) {
      final error = 'حدث خطأ أثناء تحميل المتاجر: $e';
      storesError(error);
      print('❌ [KEYWORD] Stores error: $e');
    } finally {
      isLoadingStores(false);
    }
  }

  Future<void> reloadStores() async {
    stores.clear();
    await loadStores();
  }

  void refreshStores() {
    loadStores();
  }

  void setSelectedStore(Store store) {
    selectedStore(store);
    print('✅ [KEYWORD] Store selected: ${store.name} (ID: ${store.id})');
    _loadKeywordsForStore(int.parse(store.id));
  }

  void _loadDefaultKeywords() {
    final defaultKeywords = [
      'ملابس',
      'أحذية',
      'إلكترونيات',
      'هواتف',
      'لابتوبات',
      'إكسسوارات',
      'منزلية',
      'رياضية',
      'عطور',
      'جمال',
      'أطفال',
      'رجال',
      'نساء',
      'رياضة',
      'موضة',
      'ديكور',
      'مطبخ',
      'أجهزة',
    ];

    availableKeywords.assignAll(defaultKeywords);
    filteredKeywords.assignAll(defaultKeywords);

    print('🔤 [KEYWORD] Loaded ${defaultKeywords.length} default keywords');
  }

  void _loadKeywordsForStore(int storeId) {
    print('🔄 [KEYWORD] Loading keywords for store: $storeId');
    // يمكن هنا جلب الكلمات المفتاحية الخاصة بالمتجر من API
  }

  void _onSearchChanged() {
    final query = searchController.text.trim();
    isSearchInputEmpty.value = query.isEmpty;

    if (query.isEmpty) {
      filteredKeywords.assignAll(availableKeywords);
    } else {
      final filtered = availableKeywords.where((keyword) {
        return keyword.contains(query);
      }).toList();
      filteredKeywords.assignAll(filtered);
    }
  }

  void addCustomKeyword() {
    final text = searchController.text.trim();

    if (text.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى إدخال كلمة مفتاحية',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (isDuplicateKeyword(text)) {
      Get.snackbar(
        'خطأ',
        'هذه الكلمة مفتاحية مضاف مسبقاً',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (!canAddMoreKeywords) {
      Get.snackbar(
        'خطأ',
        'تم الوصول للحد الأقصى ($maxKeywords كلمة)',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    selectedKeywords.add(text);
    searchController.clear();

    print('✅ [KEYWORD] Custom keyword added: $text');
    _updateProductControllerKeywords();
  }

  void addKeyword(String keyword) {
    if (isKeywordSelected(keyword)) {
      Get.snackbar(
        'خطأ',
        'هذه الكلمة مفتاحية مضاف مسبقاً',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    if (!canAddMoreKeywords) {
      Get.snackbar(
        'خطأ',
        'تم الوصول للحد الأقصى ($maxKeywords كلمة)',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    selectedKeywords.add(keyword);
    print('✅ [KEYWORD] Keyword added: $keyword');
    _updateProductControllerKeywords();
  }

  void removeKeyword(String keyword) {
    selectedKeywords.remove(keyword);
    print('🗑️ [KEYWORD] Keyword removed: $keyword');
    _updateProductControllerKeywords();
  }

  void _updateProductControllerKeywords() {
    productController.addKeywords(selectedKeywords);

    print(
      '🔄 [KEYWORD] Keywords synced with product controller: ${selectedKeywords.length} keywords',
    );
    productController.printDataSummary();
  }

  void confirmSelection() {
    if (selectedStore.value == null) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار متجر',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      print('✅ [KEYWORD] Selection confirmed');
      print('   Store: ${selectedStore.value!.name}');
      print('   Keywords: ${selectedKeywords.length} keywords');

      // حفظ المتجر المحدد
      productController.updateSelectedStore({
        'id': selectedStore.value!.id,
        'name': selectedStore.value!.name,
        'logo_url': selectedStore.value!.logoUrl,
        'status': selectedStore.value!.status,
      });

      Get.back();

      Get.snackbar(
        'نجاح',
        'تم حفظ الكلمات المفتاحية بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('❌ [KEYWORD] Confirm selection error: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء الحفظ',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  bool get canAddMoreKeywords => selectedKeywords.length < maxKeywords;

  bool isDuplicateKeyword(String text) {
    return selectedKeywords.any((keyword) => keyword == text);
  }

  bool isKeywordSelected(String keyword) {
    return selectedKeywords.contains(keyword);
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
   Store: ${selectedStore.value?.name ?? 'Not selected'}
   Selected Keywords: ${selectedKeywords.length}
   Available Keywords: ${availableKeywords.length}
   Can Add More: $canAddMoreKeywords
''');
  }

  void clearSelection() {
    selectedKeywords.clear();
    selectedStore(null);
    searchController.clear();
    print('🧹 [KEYWORD] Selection cleared');
  }
}
