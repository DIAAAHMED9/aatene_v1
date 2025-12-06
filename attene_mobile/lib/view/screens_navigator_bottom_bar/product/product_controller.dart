import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/models/section_model.dart';
import 'package:attene_mobile/utlis/sheet_controller.dart';

import '../../../models/product_model.dart';
import '../../../my_app/my_app_controller.dart';
import '../../Services/data_lnitializer_service.dart';
import '../../Services/unified_loading_screen.dart';

class ProductController extends GetxController with SingleGetTickerProviderMixin {
  final DataInitializerService dataService = Get.find<DataInitializerService>();
  final MyAppController myAppController = Get.find<MyAppController>();
  late BottomSheetController bottomSheetController;
  
  late TabController tabController;
  final TextEditingController searchTextController = TextEditingController();
  final RxInt currentTabIndex = 0.obs;
  final RxString searchQuery = ''.obs;
  
  final List<TabData> tabs = [
    TabData(label: 'جميع المنتجات', viewName: 'جميع المنتجات'),
    TabData(label: 'عروض', viewName: 'عروض'),
    TabData(label: 'مراجعات', viewName: 'مراجعات'),
  ];
  
  final RxList<Product> _products = <Product>[].obs;
  final RxList<Product> _filteredProducts = <Product>[].obs;
  final RxBool _isLoadingProducts = false.obs;
  final RxString _productsErrorMessage = ''.obs;
  final RxMap<String, int> _productsCountBySection = <String, int>{}.obs;
  final RxMap<String, List<Product>> _productsBySection = <String, List<Product>>{}.obs;
  final RxList<Section> _allSections = <Section>[].obs;
  
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool _isInitialized = false.obs;
  final RxBool _isUpdatingTabs = false.obs;

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
      if (myAppController.isLoggedIn.value && _isInitialized.value && !_isUpdatingTabs.value) {
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
      print('⏸️ [PRODUCTS] المستخدم غير مسجل دخول، إيقاف متحكم المنتجات');
    }
  }
  
  void _initializeProductController() {
    if (_isInitialized.value) return;
    
    print('🔄 [PRODUCTS] تهيئة متحكم المنتجات للمستخدم المسجل');
    
    _isInitialized.value = true;
    
    if (bottomSheetController.sections.isNotEmpty) {
      _updateTabsWithSections();
    }
    
    _loadProducts();
  }
  
  void _resetProductController() {
    if (!_isInitialized.value) return;
    
    print('🔁 [PRODUCTS] إعادة تعيين متحكم المنتجات بسبب تسجيل الخروج');
    
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
      print('⚠️ [PRODUCTS] خطأ في التخلص من متحكم التبويب: $e');
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
    if (!_isInitialized.value || _isUpdatingTabs.value) return;
    
    _isUpdatingTabs.value = true;
    
    try {
      final sections = bottomSheetController.getSections();
      _allSections.assignAll(sections);
      
      final updatedTabs = <TabData>[
        TabData(label: 'جميع المنتجات', viewName: 'جميع المنتجات'),
        TabData(label: 'عروض', viewName: 'عروض'),
        TabData(label: 'مراجعات', viewName: 'مراجعات'),
      ];
      
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
        print('✅ [PRODUCTS] تم تحديث التبويبات بـ ${sections.length} قسم');
      }
    } catch (e) {
      print('❌ [PRODUCTS] خطأ في تحديث التبويبات: $e');
    } finally {
      _isUpdatingTabs.value = false;
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
    return UnifiedLoadingScreen.showWithFuture<void>(
      _performLoadProducts(),
      message: 'جاري تحميل المنتجات...',
    );
  }
  
  Future<void> _performLoadProducts() async {
    try {
      if (!_isUserAuthenticated()) {
        print('⚠️ [PRODUCTS] المستخدم غير مصادق عليه');
        return;
      }
  
      _isLoadingProducts(true);
      _productsErrorMessage('');
      
      print('📡 [PRODUCTS] جلب المنتجات من API');
      
      await _loadCachedProducts();
      
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
        
        await dataService.refreshProducts();
        
        _updateTabsWithSections();
        
        print('✅ [PRODUCTS] تم تحميل ${_products.length} منتج بنجاح');
      } else {
        _productsErrorMessage.value = response?['message'] ?? 'فشل في تحميل المنتجات';
        print('❌ [PRODUCTS] فشل في التحميل: ${_productsErrorMessage.value}');
      }
    } catch (e) {
      _productsErrorMessage.value = 'خطأ في تحميل المنتجات: ${e.toString()}';
      print('❌ [PRODUCTS] خطأ في التحميل: $e');
    } finally {
      _isLoadingProducts(false);
    }
  }
  
  Future<void> _loadCachedProducts() async {
    try {
      final cachedProducts = dataService.getProducts();
      if (cachedProducts.isNotEmpty) {
        _products.assignAll(cachedProducts.map((product) => Product.fromJson(product)).toList());
        _filteredProducts.assignAll(_products);
        _updateProductsCountBySection();
        _groupProductsBySection();
        print('📂 [PRODUCTS] تم تحميل ${_products.length} منتج من التخزين المحلي');
      }
    } catch (e) {
      print('⚠️ [PRODUCTS] خطأ في تحميل المنتجات المخزنة: $e');
    }
  }
  
  void debugProductsInfo() {
    print('🔍 [PRODUCTS] معلومات المنتجات');
    print('📊 إجمالي المنتجات: ${_products.length}');
    print('📊 المنتجات المصفاة: ${_filteredProducts.length}');
    
    int uncategorized = 0;
    Map<String, int> sectionCounts = {};
    
    for (final product in _products) {
      final sectionId = product.sectionId ?? '0';
      if (sectionId == '0' || sectionId.isEmpty) {
        uncategorized++;
      } else {
        sectionCounts[sectionId] = (sectionCounts[sectionId] ?? 0) + 1;
      }
    }
    
    print('📊 المنتجات غير المصنفة: $uncategorized');
    print('📊 المنتجات حسب القسم: $sectionCounts');
    
    print('📊 الأقسام المتاحة:');
    for (final section in _allSections) {
      print('   - ${section.name} (ID: ${section.id})');
    }
  }
  
  void _updateProductsCountBySection() {
    _productsCountBySection.clear();
    
    for (final product in _filteredProducts) {
      final sectionId = product.sectionId ?? '0';
      _productsCountBySection[sectionId] = (_productsCountBySection[sectionId] ?? 0) + 1;
    }
    
    print('📊 [PRODUCTS] عدد المنتجات حسب القسم: $_productsCountBySection');
  }
  
  void _groupProductsBySection() {
    _productsBySection.clear();
    
    print('🔍 [PRODUCTS] تجميع المنتجات حسب القسم');
    print('📊 إجمالي المنتجات: ${_products.length}');
    
    for (final product in _filteredProducts) {
      final sectionId = product.sectionId ?? '0';
      
      if (!_productsBySection.containsKey(sectionId)) {
        _productsBySection[sectionId] = [];
      }
      _productsBySection[sectionId]!.add(product);
    }
    
    print('📊 [PRODUCTS] المنتجات المجمعة حسب القسم: ${_productsBySection.length} قسم');
    _productsBySection.forEach((key, value) {
      print('   القسم $key: ${value.length} منتج');
    });
  }
  
  void _filterProducts() {
    if (searchQuery.value.isEmpty) {
      _filteredProducts.assignAll(_products);
    } else {
      final filtered = _products.where((product) =>
        product.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        (product.sku?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false)
      ).toList();
      _filteredProducts.assignAll(filtered);
    }
    _groupProductsBySection();
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
        print('📊 [PRODUCTS] جاري تحميل بيانات التبويب: ${tabs[tabIndex].label}');
      }
    } catch (e) {
      errorMessage.value = 'فشل في تحميل بيانات التبويب: $e';
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
  
  Map<String, List<Product>> getAllProductsGrouped() {
    final Map<String, List<Product>> result = {};
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
    
    if (uncategorizedProducts.isNotEmpty) {
      result['0'] = uncategorizedProducts;
    }
    
    return result;
  }
  
  List<Map<String, dynamic>> getDisplaySections() {
    final sections = <Map<String, dynamic>>[];
    final groupedProducts = getAllProductsGrouped();
    
    if (groupedProducts.containsKey('0') && groupedProducts['0']!.isNotEmpty) {
      sections.add({
        'id': '0',
        'name': 'غير مصنف',
        'products': groupedProducts['0']!,
        'isUncategorized': true,
      });
    }
    
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
    if (tabIndex == 0) {
      return _filteredProducts.toList();
    } else if (tabIndex == 1) {
      return _filteredProducts.where((product) {
        return false;
      }).toList();
    } else if (tabIndex == 2) {
      return _filteredProducts.where((product) {
        return int.tryParse(product.messagesCount) != null && 
               int.tryParse(product.messagesCount)! > 0;
      }).toList();
    } else if (tabIndex >= 3) {
      final sectionTab = tabs[tabIndex];
      if (sectionTab.sectionId != null) {
        return _filteredProducts.where((product) => 
            product.sectionId == sectionTab.sectionId.toString()
        ).toList();
      }
    }
    return [];
  }
  
  Map<String, List<Product>> getProductsGroupedBySection() {
    return Map.from(_productsBySection);
  }
  
  String getSectionName(String sectionId) {
    if (sectionId == '0') return 'غير مصنف';
    
    final section = _allSections.firstWhere(
      (s) => s.id.toString() == sectionId,
      orElse: () => Section(
        id: 0,
        name: 'غير معروف',
        storeId: '',
      ),
    );
    return section.name;
  }
  
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