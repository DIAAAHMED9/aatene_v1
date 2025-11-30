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
  
  // Controllers
  late TabController tabController;
  final TextEditingController searchTextController = TextEditingController();
  
  // Reactive variables
  final RxInt currentTabIndex = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool _isInitialized = false.obs;
  
  // Tab data
  final List<TabData> tabs = [
    TabData(label: 'جميع المنتجات (0)', viewName: 'جميع المنتجات'),
    TabData(label: 'عروض', viewName: 'عروض'),
    TabData(label: 'مراجعات', viewName: 'مراجعات'),
  ];
  
  late BottomSheetController bottomSheetController;
  final MyAppController myAppController = Get.find<MyAppController>();
  
  // ✅ جديد: بيانات المنتجات
  final RxList<Product> _products = <Product>[].obs;
  final RxList<Product> _filteredProducts = <Product>[].obs;
  final RxBool _isLoadingProducts = false.obs;
  final RxString _productsErrorMessage = ''.obs;
  final RxMap<String, int> _productsCountBySection = <String, int>{}.obs;
  
  // ✅ إضافة متغير لمنع التكرار
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

  // ✅ جديد: الاستماع لتغيرات الأقسام مع منع التكرار
  void _setupSectionsListener() {
    ever(bottomSheetController.sectionsRx, (List<Section> sections) {
      if (myAppController.isLoggedIn.value && _isInitialized.value && !_isUpdatingTabs) {
        _updateTabsWithSections();
      }
    });
  }

  // ✅ جديد: الاستماع لتغيرات المنتجات
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
    
    // ✅ تحميل المنتجات عند التهيئة
    _loadProducts();
  }

  void _resetProductController() {
    if (!_isInitialized.value) return;
    
    print('🔁 [PRODUCT] Resetting ProductController due to logout');
    
    _isInitialized.value = false;
    tabs.clear();
    tabs.addAll([
      TabData(label: 'جميع المنتجات (0)', viewName: 'جميع المنتجات'),
      TabData(label: 'عروض', viewName: 'عروض'),
      TabData(label: 'مراجعات', viewName: 'مراجعات'),
    ]);
    
    _safeDisposeTabController();
    _initializeTabController();
    tabController.addListener(_handleTabChange);
    
    // ✅ إعادة تعيين بيانات المنتجات
    _products.clear();
    _filteredProducts.clear();
    _productsCountBySection.clear();
    
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
  
  // ✅ إصلاح: منع التكرار في تحديث التبويبات
  void _updateTabsWithSections() {
    if (!_isInitialized.value || _isUpdatingTabs) return;
    
    _isUpdatingTabs = true;
    
    try {
      final sections = bottomSheetController.getSections();
      
      final updatedTabs = <TabData>[
        TabData(label: 'جميع المنتجات (${_getTotalProductsCount()})', viewName: 'جميع المنتجات'),
        TabData(label: 'عروض', viewName: 'عروض'),
        TabData(label: 'مراجعات', viewName: 'مراجعات'),
      ];
      
      // إضافة تبويبات للأقسام مع عدد المنتجات
      for (final section in sections) {
        final productCount = _productsCountBySection[section.id.toString()] ?? 0;
        updatedTabs.add(TabData(
          label: '${section.name} ($productCount)',
          viewName: section.name,
        ));
      }
      
      // ✅ التحقق مما إذا كانت التبويبات مختلفة فعلاً
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

  // ✅ دالة للمقارنة لمنع التحديثات غير الضرورية
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
  
  // ✅ جديد: جلب المنتجات من API
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
        
        // ✅ تحديث عدد المنتجات لكل قسم
        _updateProductsCountBySection();
        
        // ✅ تحديث التبويبات بالأعداد الجديدة
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
  
  // ✅ جديد: تحديث عدد المنتجات لكل قسم
  void _updateProductsCountBySection() {
    _productsCountBySection.clear();
    
    for (final product in _products) {
      final sectionId = product.sectionId ?? '0';
      _productsCountBySection[sectionId] = (_productsCountBySection[sectionId] ?? 0) + 1;
    }
    
    print('📊 [PRODUCTS COUNT BY SECTION]: $_productsCountBySection');
  }
  
  // ✅ جديد: تصفية المنتجات حسب البحث
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
  
  // ✅ جديد: إعادة تحميل المنتجات
  Future<void> reloadProducts() async {
    await _loadProducts();
  }
  
  // ✅ جديد: الحصول على المنتجات للعرض
  List<Product> getProductsForTab(int tabIndex) {
    if (tabIndex == 0) {
      // جميع المنتجات
      return _filteredProducts.toList();
    } else if (tabIndex >= 3) {
      // تبويبات الأقسام (التبويب 3 فما فوق)
      final sectionIndex = tabIndex - 3;
      final sections = bottomSheetController.getSections();
      if (sectionIndex < sections.length) {
        final section = sections[sectionIndex];
        return _filteredProducts.where((product) => product.sectionId == section.id.toString()).toList();
      }
    }
    return []; // للتبويبات الأخرى (عروض، مراجعات)
  }
  
  int _getTotalProductsCount() {
    return _products.length;
  }
  
  // دوال فتح البوتوم شيت - محدثة
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
      // إذا لم يكن هناك أقسام، فتح بوتوم شيت إضافة قسم جديد مباشرة
      Get.snackbar(
        'تنبيه',
        'يجب إضافة قسم أولاً قبل إضافة المنتجات',
        backgroundColor: Colors.orange,
      );
      bottomSheetController.openAddNewSection();
    } else if (!bottomSheetController.hasSelectedSection) {
      // إذا كان هناك أقسام ولكن لم يتم اختيار قسم
      Get.snackbar(
        'تنبيه',
        'يرجى اختيار قسم أولاً',
        backgroundColor: Colors.orange,
      );
      bottomSheetController.openManageSections();
    } else {
      // الانتقال إلى شاشة إضافة المنتج
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
  
  // ✅ جديد: Getters للبيانات
  bool get isControllerInitialized => _isInitialized.value;
  RxBool get isLoadingProducts => _isLoadingProducts;
  RxString get productsErrorMessage => _productsErrorMessage;
  List<Product> get allProducts => _products.toList();
  List<Product> get filteredProducts => _filteredProducts.toList();
  int get totalProductsCount => _products.length;
}