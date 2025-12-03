import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/demo_stepper_screen.dart';
import 'package:attene_mobile/models/product_model.dart';
import 'package:attene_mobile/models/section_model.dart';
import 'package:attene_mobile/my_app/may_app_controller.dart';
import 'package:attene_mobile/utlis/sheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductController extends GetxController
    with SingleGetTickerProviderMixin {
  
  late TabController tabController;
  final TextEditingController searchTextController = TextEditingController();
  
  final RxInt currentTabIndex = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool _isInitialized = false.obs;
  
  final List<TabData> tabs = [
    TabData(label: 'جميع المنتجات', viewName: 'جميع المنتجات'),
    TabData(label: 'عروض', viewName: 'عروض'),
    TabData(label: 'مراجعات', viewName: 'مراجعات'),
  ];
  
  late BottomSheetController bottomSheetController;
  final MyAppController myAppController = Get.find<MyAppController>();
  
  final RxList<Product> _products = <Product>[].obs;
  final RxList<Product> _filteredProducts = <Product>[].obs;
  final RxBool _isLoadingProducts = false.obs;
  final RxString _productsErrorMessage = ''.obs;
  final RxMap<String, int> _productsCountBySection = <String, int>{}.obs;
  
  // New: Group products by section
  final RxMap<String, List<Product>> _productsBySection = <String, List<Product>>{}.obs;
  final RxList<Section> _allSections = <Section>[].obs;
  RxList<Product> get productsRx => _products;
  bool _isUpdatingTabs = false;

  @override
  void onInit() {
    super.onInit();
    
    bottomSheetController = Get.find<BottomSheetController>();
    
    _initializeBasicControllers();
    _setupAuthListener();
    _setupProductsListener();
    _setupSectionsListener();
  }

  void _initializeBasicControllers() {
    _initializeTabController();
    tabController.addListener(_handleTabChange);
    searchTextController.addListener(_handleSearchChange);
  }

  void _setupAuthListener() {
    ever(myAppController.isAppInitialized, (bool initialized) {
      if (initialized) {
        _checkAndInitialize();
      }
    });
    
    ever(myAppController.isLoggedIn, (bool isLoggedIn) {
      if (isLoggedIn) {
        _initializeProductController();
      } else {
        _resetProductController();
      }
    });
    
    if (myAppController.isAppInitialized.value) {
      _checkAndInitialize();
    }
  }

  void _setupSectionsListener() {
    ever(bottomSheetController.sectionsRx, (List<Section> sections) {
      _allSections.assignAll(sections);
      if (myAppController.isLoggedIn.value && _isInitialized.value && !_isUpdatingTabs) {
        _updateTabsWithSections();
      }
    });
  }

  void _setupProductsListener() {
    ever(searchQuery, (_) {
      _filterProducts();
    });
  }

  void _checkAndInitialize() {
    if (myAppController.isLoggedIn.value) {
      _initializeProductController();
    } else {
      print('⏸️ [PRODUCT] User not logged in, product controller paused');
    }
  }

  void _initializeProductController() {
    if (_isInitialized.value) return;
    
    print('🔄 [PRODUCT] Initializing ProductController for logged in user');
    
    _isInitialized.value = true;
    
    if (bottomSheetController.sections.isNotEmpty) {
      _updateTabsWithSections();
    }
    
    _loadProducts();
  }

  void _resetProductController() {
    if (!_isInitialized.value) return;
    
    print('🔁 [PRODUCT] Resetting ProductController due to logout');
    
    _isInitialized.value = false;
    tabs.clear();
    tabs.addAll([
      TabData(label: 'جميع المنتجات', viewName: 'جميع المنتجات'),
      TabData(label: 'عروض', viewName: 'عروض'),
      TabData(label: 'مراجعات', viewName: 'مراجعات'),
    ]);
    
    _safeDisposeTabController();
    _initializeTabController();
    tabController.addListener(_handleTabChange);
    
    _products.clear();
    _filteredProducts.clear();
    _productsCountBySection.clear();
    _productsBySection.clear();
    _allSections.clear();
    
    update();
  }

  void _safeDisposeTabController() {
    try {
      if (tabController.hasListeners) {
        tabController.removeListener(_handleTabChange);
      }
      tabController.dispose();
    } catch (e) {
      print('⚠️ Error disposing tab controller: $e');
    }
  }

  void _initializeTabController() {
    tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: currentTabIndex.value
    );
  }
  
void _updateTabsWithSections() {
  if (!_isInitialized.value || _isUpdatingTabs) return;
  
  _isUpdatingTabs = true;
  
  try {
    final sections = bottomSheetController.getSections();
    _allSections.assignAll(sections);
    
    final updatedTabs = <TabData>[
      TabData(label: 'جميع المنتجات', viewName: 'جميع المنتجات'),
      TabData(label: 'عروض', viewName: 'عروض'),
      TabData(label: 'مراجعات', viewName: 'مراجعات'),
    ];
    
    // إضافة فقط الأقسام النشطة
  for (final section in sections) {
  final productCount = _productsCountBySection[section.id.toString()] ?? 0;
  updatedTabs.add(TabData(
    label: '${section.name} ($productCount)',
    viewName: section.name,
    sectionId: section.id,
  ));
    }
    
    if (!_areTabsEqual(tabs, updatedTabs)) {
      tabs.clear();
      tabs.addAll(updatedTabs);
      
      if (tabController.length != updatedTabs.length) {
        final oldIndex = tabController.index;
        _safeDisposeTabController();
        _initializeTabController();
        final newIndex = oldIndex.clamp(0, updatedTabs.length - 1);
        tabController.index = newIndex;
        currentTabIndex.value = newIndex;
        tabController.addListener(_handleTabChange);
      }
      
      update();
      print('✅ [PRODUCT] Updated tabs with ${sections.length} sections');
    }
  } catch (e) {
    print('❌ [PRODUCT] Error updating tabs: $e');
  } finally {
    _isUpdatingTabs = false;
  }
}

  bool _areTabsEqual(List<TabData> list1, List<TabData> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].label != list2[i].label || list1[i].viewName != list2[i].viewName) {
        return false;
      }
    }
    return true;
  }
  
  void _handleTabChange() {
    if (!tabController.indexIsChanging) {
      currentTabIndex.value = tabController.index;
      _loadTabData(tabController.index);
    }
  }
  
  void _handleSearchChange() {
    searchQuery.value = searchTextController.text;
    _filterProducts();
  }
  
Future<void> _loadProducts() async {
  try {
    if (!_isUserAuthenticated()) {
      print('⚠️ [PRODUCTS] User not authenticated');
      return;
    }

    _isLoadingProducts(true);
    _productsErrorMessage('');
    
    print('📡 [LOADING PRODUCTS FROM API]');
    
    final response = await ApiHelper.get(
      path: '/merchants/products',
      withLoading: false,
    );
    
    if (response != null && response['status'] == true) {
      final List<dynamic> data = response['data'] ?? [];
      _products.assignAll(data.map((product) => Product.fromJson(product)).toList());
      _filteredProducts.assignAll(_products);
      
      _updateProductsCountBySection();
      _groupProductsBySection();
      
      // 🔍 طباعة معلومات المنتجات للتشخيص
      debugProductsInfo();
      
      _updateTabsWithSections();
      
      print('✅ [PRODUCTS] Loaded ${_products.length} products successfully');
    } else {
      _productsErrorMessage.value = response?['message'] ?? 'فشل في تحميل المنتجات';
      print('❌ [PRODUCTS] Failed to load: ${_productsErrorMessage.value}');
    }
  } catch (e) {
    _productsErrorMessage.value = 'خطأ في تحميل المنتجات: ${e.toString()}';
    print('❌ [PRODUCTS] Error loading: $e');
  } finally {
    _isLoadingProducts(false);
  }
}
  // دالة لعرض تفاصيل المنتجات (للتشخيص)
void debugProductsInfo() {
  print('🔍 [DEBUG PRODUCTS INFO]');
  print('📊 Total products: ${_products.length}');
  print('📊 Filtered products: ${_filteredProducts.length}');
  
  int uncategorized = 0;
  Map<String, int> sectionCounts = {};
  
  for (final product in _products) {
    final sectionId = product.sectionId ?? '0';
    if (sectionId == '0' || sectionId.isEmpty) {
      uncategorized++;
      print('📦 Uncategorized product: ${product.name}');
    } else {
      sectionCounts[sectionId] = (sectionCounts[sectionId] ?? 0) + 1;
    }
  }
  
  print('📊 Uncategorized products: $uncategorized');
  print('📊 Products by section: $sectionCounts');
  
  // طباعة أسماء الأقسام المتاحة
  print('📊 Available sections:');
  for (final section in _allSections) {
    print('   - ${section.name} (ID: ${section.id})');
  }
}
  void _updateProductsCountBySection() {
    _productsCountBySection.clear();
    
    for (final product in _products) {
      final sectionId = product.sectionId ?? '0';
      _productsCountBySection[sectionId] = (_productsCountBySection[sectionId] ?? 0) + 1;
    }
    
    print('📊 [PRODUCTS COUNT BY SECTION]: $_productsCountBySection');
  }
  
  void _groupProductsBySection() {
    _productsBySection.clear();
    
    print('🔍 [GROUPING] Total products: ${_products.length}');
    
    // تجميع المنتجات حسب القسم
    for (final product in _products) {
      final sectionId = product.sectionId ?? '0';
      
      if (!_productsBySection.containsKey(sectionId)) {
        _productsBySection[sectionId] = [];
      }
      _productsBySection[sectionId]!.add(product);
    }
    
    // طباعة تفاصيل المجموعات
    print('📊 [PRODUCTS GROUPED BY SECTION]: ${_productsBySection.length} sections');
    _productsBySection.forEach((key, value) {
      print('   Section $key: ${value.length} products');
    });
  }
  void _filterProducts() {
    if (searchQuery.value.isEmpty) {
      _filteredProducts.assignAll(_products);
      _groupProductsBySection();
    } else {
      final filtered = _products.where((product) =>
        product.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        (product.sku?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false)
      ).toList();
      _filteredProducts.assignAll(filtered);
      
      // Re-group filtered products
      final tempGroup = <String, List<Product>>{};
      for (final product in filtered) {
        final sectionId = product.sectionId ?? '0';
        if (!tempGroup.containsKey(sectionId)) {
          tempGroup[sectionId] = [];
        }
        tempGroup[sectionId]!.add(product);
      }
      _productsBySection.assignAll(tempGroup);
    }
  }
    Map<String, List<Product>> getFilteredProductsBySection() {
    final Map<String, List<Product>> result = {};
    
    for (final product in _filteredProducts) {
      final sectionId = product.sectionId ?? '0';
      
      if (!result.containsKey(sectionId)) {
        result[sectionId] = [];
      }
      result[sectionId]!.add(product);
    }
    
    return result;
  }
  Future<void> _loadTabData(int tabIndex) async {
    try {
      if (tabIndex < tabs.length) {
        print('جاري تحميل بيانات التبويب: ${tabs[tabIndex].label}');
      }
    } catch (e) {
      errorMessage.value = 'فشل في تحميل بيانات التبويب: $e';
    }
  }
  
  Future<void> _performSearch() async {
    try {
      if (searchQuery.value.length >= 2) {
        print('جاري البحث عن: ${searchQuery.value}');
        _filterProducts();
      }
    } catch (e) {
      errorMessage.value = 'فشل في البحث: $e';
    }
  }
  
  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    _filterProducts();
  }
  
  void changeTab(int index) {
    if (index >= 0 && index < tabs.length) {
      tabController.animateTo(index);
      currentTabIndex.value = index;
    }
  }
  
  Future<void> reloadProducts() async {
    await _loadProducts();
  }
  // دالة للحصول على جميع المنتجات المجمعة مع قسم "غير مصنف"
Map<String, List<Product>> getAllProductsGrouped() {
  final Map<String, List<Product>> result = {};
  
  // قسم "غير مصنف" للمنتجات التي لا تنتمي لأي قسم
  final uncategorizedProducts = <Product>[];
  
  for (final product in _filteredProducts) {
    final sectionId = product.sectionId;
    
    if (sectionId == null || sectionId.isEmpty || sectionId == '0') {
      uncategorizedProducts.add(product);
    } else {
      if (!result.containsKey(sectionId)) {
        result[sectionId] = [];
      }
      result[sectionId]!.add(product);
    }
  }
  
  // إضافة قسم "غير مصنف" إذا كان يحتوي على منتجات
  if (uncategorizedProducts.isNotEmpty) {
    result['0'] = uncategorizedProducts;
  }
  
  return result;
}

// دالة للحصول على أسماء الأقسام مع قسم "غير مصنف"
List<Map<String, dynamic>> getDisplaySections() {
  final sections = <Map<String, dynamic>>[];
  final groupedProducts = getAllProductsGrouped();
  
  // إضافة قسم "غير مصنف" أولاً
  if (groupedProducts.containsKey('0') && groupedProducts['0']!.isNotEmpty) {
    sections.add({
      'id': '0',
      'name': 'غير مصنف',
      'products': groupedProducts['0']!,
      'isUncategorized': true,
    });
  }
  
  // إضافة الأقسام الأخرى
  for (final section in _allSections) {
    final sectionId = section.id.toString();
    final products = groupedProducts[sectionId] ?? [];
    
    if (products.isNotEmpty) {
      sections.add({
        'id': sectionId,
        'name': section.name,
        'products': products,
        'isUncategorized': false,
      });
    }
  }
  
  return sections;
}
  List<Product> getProductsForTab(int tabIndex) {
    if (tabIndex == 0) { // All products
      return _filteredProducts.toList();
    } else if (tabIndex == 1) { // Offers
      // إرجاع المنتجات التي لها عروض
      return _filteredProducts.where((product) {
        return false;
        // product.hasOffers == true; // أو أي شرط آخر للعروض
      }).toList();
    } else if (tabIndex == 2) { // Reviews
      // إرجاع المنتجات التي لها مراجعات
      return _filteredProducts.where((product) {
        return int.tryParse(product.messagesCount) != null && 
               int.tryParse(product.messagesCount)! > 0;
      }).toList();
    } else if (tabIndex >= 3) { // Section tabs
      final sectionTab = tabs[tabIndex];
      if (sectionTab.sectionId != null) {
        // ✅ التصحيح: تصفية المنتجات حسب القسم
        return _filteredProducts.where((product) => 
            product.sectionId == sectionTab.sectionId.toString()
        ).toList();
      }
    }
    return [];
  }

  // New: Get products grouped by section for all products view
  Map<String, List<Product>> getProductsGroupedBySection() {
    return Map.from(_productsBySection);
  }
  
  // New: Get section name by ID
String getSectionName(String sectionId) {
  if (sectionId == '0') return 'غير مصنف';
  
  final section = _allSections.firstWhere(
    (s) => s.id.toString() == sectionId,
    orElse: () => Section(
      id: 0,
      name: 'غير معروف',
      storeId: '', // إضافة storeId مطلوب
    ),
  );
  return section.name;
}
  
  // New: Get all sections
 // New: Get all sections (only active ones)
List<Section> getAllSections() {
  return _allSections.toList();
}

  
  int _getTotalProductsCount() {
    return _products.length;
  }
  
  void openManageSections() {
    bottomSheetController.openManageSections();
  }
  
  void openAddNewSection() {
    bottomSheetController.openAddNewSection();
  }
  
  void navigateToAddProduct() {
    if (!_isUserAuthenticated()) {
      _showLoginRequiredMessage();
      return;
    }

    final hasSections = bottomSheetController.sections.isNotEmpty;
    
    if (!hasSections) {
      Get.snackbar(
        'تنبيه',
        'يجب إضافة قسم أولاً قبل إضافة المنتجات',
        backgroundColor: Colors.orange,
      );
      bottomSheetController.openAddNewSection();
    } else if (!bottomSheetController.hasSelectedSection) {
      Get.snackbar(
        'تنبيه',
        'يرجى اختيار قسم أولاً',
        backgroundColor: Colors.orange,
      );
      bottomSheetController.openManageSections();
    } else {
      bottomSheetController.openAddProductScreen();
    }
  }
  
  bool _isUserAuthenticated() {
    final userData = myAppController.userData;
    return userData.isNotEmpty && userData['token'] != null;
  }

  void _showLoginRequiredMessage() {
    Get.snackbar(
      'يجب تسجيل الدخول',
      'يرجى تسجيل الدخول لإضافة منتجات',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
  
  void openFilter() => bottomSheetController.openFilter();
  void openSort() => bottomSheetController.openSort();
  void openMultiSelect() => bottomSheetController.openMultiSelect();
  void openSingleSelect() => bottomSheetController.openSingleSelect();
  
  @override
  void onClose() {
    tabController.removeListener(_handleTabChange);
    searchTextController.removeListener(_handleSearchChange);
    _safeDisposeTabController();
    searchTextController.dispose();
    super.onClose();
  }
  
  bool get isControllerInitialized => _isInitialized.value;
  RxBool get isLoadingProducts => _isLoadingProducts;
  RxString get productsErrorMessage => _productsErrorMessage;
  List<Product> get allProducts => _products.toList();
  List<Product> get filteredProducts => _filteredProducts.toList();
  int get totalProductsCount => _products.length;
  RxMap<String, List<Product>> get productsBySection => _productsBySection;
}