import 'dart:async';

import '../../../general_index.dart';
import '../../../utils/sheet_controller.dart';

class ProductController extends GetxController
    with SingleGetTickerProviderMixin {
  final DataInitializerService dataService = Get.find<DataInitializerService>();
  final MyAppController myAppController = Get.find<MyAppController>();
  final BottomSheetController bottomSheetController =
      Get.find<BottomSheetController>();
  final ProductService productService = Get.find<ProductService>();
  final productCentralController = Get.find<ProductCentralController>();

  TabController? _tabController;

  TabController get tabController {
    if (_tabController == null ||
        _tabController!.length != tabs.length ||
        _tabController!.index >= tabs.length) {
      _createTabController();
    }
    return _tabController!;
  }

  final TextEditingController searchTextController = TextEditingController();

  final RxInt currentTabIndex = 0.obs;
  final RxString searchQuery = ''.obs;
  final RxList<TabData> tabs = <TabData>[].obs;
  final RxList<Product> _products = <Product>[].obs;
  final RxList<Product> _filteredProducts = <Product>[].obs;
  final RxBool _isLoadingProducts = false.obs;
  final RxString _productsErrorMessage = ''.obs;
  final RxMap<String, int> _productsCountBySection = <String, int>{}.obs;
  final RxMap<String, List<Product>> _productsBySection =
      <String, List<Product>>{}.obs;
  final RxList<Section> _allSections = <Section>[].obs;
  final RxBool _isInitialized = false.obs;
  final RxBool _isUpdatingTabs = false.obs;
  final RxString _viewMode = 'list'.obs;
  final RxList<String> _selectedProductIds = <String>[].obs;
  final RxBool _isSelectionMode = false.obs;

  final RxBool _shouldUpdateUI = false.obs;
  Timer? _uiUpdateTimer;
  final RxBool _isTabControllerReady = false.obs;
  final RxBool _isDisposed = false.obs;

  Timer? _searchDebounceTimer;
  Timer? _tabChangeTimer;

  DateTime? _lastDataFetchTime;

  @override
  void onInit() {
    super.onInit();
    print('🚀 [PRODUCT CONTROLLER] onInit called');

    _initializeDefaultTabs();
    _createTabController();

    _setupListeners();

    _checkAndInitialize();
    productCentralController.loadCategories();
  }

  @override
  void onReady() {
    super.onReady();
    print('✅ [PRODUCT CONTROLLER] onReady called');

    _isTabControllerReady.value = true;

    Future.delayed(const Duration(milliseconds: 500), () {
      if (myAppController.isLoggedIn.value && !_isInitialized.value) {
        _initializeProductController();
      }
    });
  }

  void _initializeDefaultTabs() {
    tabs.clear();
    tabs.addAll([
      TabData(label: 'جميع المنتجات', viewName: 'جميع المنتجات'),
      TabData(label: 'عروض', viewName: 'عروض'),
      TabData(label: 'مراجعات', viewName: 'مراجعات'),
    ]);
  }

  void _createTabController() {
    if (_tabController != null) {
      if (_tabController!.hasListeners) {
        _tabController!.removeListener(_handleTabChange);
      }
      try {
        _tabController!.dispose();
      } catch (e) {
        print('⚠️ [PRODUCT CONTROLLER] Error disposing old tab controller: $e');
      }
    }

    final initialIndex = tabs.isNotEmpty
        ? currentTabIndex.value.clamp(0, tabs.length - 1)
        : 0;

    _tabController = TabController(
      length: tabs.length,
      vsync: this,
      initialIndex: initialIndex,
    );
    _tabController!.addListener(_handleTabChange);

    print(
      '✅ [PRODUCT CONTROLLER] Created TabController with ${tabs.length} tabs, initialIndex: $initialIndex',
    );
  }

  void _retryControllerInitialization() {
    Future.delayed(const Duration(milliseconds: 100), () {
      _createTabController();
      _isTabControllerReady.value = true;
    });
  }

  void _setupListeners() {
    print('🎯 [PRODUCT CONTROLLER] Setting up listeners');

    ever(myAppController.isLoggedIn, (bool isLoggedIn) {
      if (_isDisposed.value) return;
      print('🔐 [PRODUCT CONTROLLER] Auth state changed: $isLoggedIn');
      if (isLoggedIn) {
        _initializeProductController();
      } else {
        _resetProductController();
      }
    });

    ever(bottomSheetController.sectionsRx, (List<Section> sections) {
      if (_isDisposed.value) return;
      print(
        '📊 [PRODUCT CONTROLLER] Sections updated: ${sections.length} sections',
      );
      _allSections.assignAll(sections);
      if (myAppController.isLoggedIn.value && _isInitialized.value) {
        _updateTabsWithSections(forceUpdate: true);
      }
    });

    ever(searchQuery, (_) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_isDisposed.value) return;
        _filterProducts();
      });
    });

    ever(_products, (List<Product> products) {
      if (_isDisposed.value) return;
      print(
        '📈 [PRODUCT CONTROLLER] Products list updated: ${products.length} products',
      );
      _updateProductsCountBySection();
      if (_isInitialized.value) {
        _updateTabsWithSections();
      }
      _safeUpdateUI();
    });

    ever(tabs, (List<TabData> tabsList) {
      if (_isDisposed.value) return;
      print('📊 [PRODUCT CONTROLLER] Tabs updated to ${tabsList.length} tabs');

      if (!_isUpdatingTabs.value) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_isDisposed.value || !_isInitialized.value) return;

          try {
            if (_tabController == null ||
                _tabController!.length != tabsList.length) {
              _createTabController();
              _isTabControllerReady.value = true;
              _safeUpdateUI();
            }
          } catch (e) {
            print('❌ [PRODUCT CONTROLLER] Error recreating tab controller: $e');
          }
        });
      }
    });
  }

  void _checkAndInitialize() {
    if (myAppController.isLoggedIn.value) {
      print('🔍 [PRODUCT CONTROLLER] User is logged in, initializing...');
      _initializeProductController();
    } else {
      print('⏸️ [PRODUCT CONTROLLER] User not logged in, waiting...');
    }
  }

  Future<void> _initializeProductController() async {
    if (_isInitialized.value) {
      print('ℹ️ [PRODUCT CONTROLLER] Already initialized');
      return;
    }

    print('🚀 [PRODUCT CONTROLLER] Initializing product controller...');

    try {
      _isInitialized.value = true;

      await _loadCachedProducts();

      if (bottomSheetController.sections.isNotEmpty) {
        _updateTabsWithSections();
      }

      await _loadProducts();

      print('✅ [PRODUCT CONTROLLER] Initialization completed successfully');
    } catch (e) {
      print('❌ [PRODUCT CONTROLLER] Initialization error: $e');
      _isInitialized.value = false;
      rethrow;
    }
  }

  Future<void> _resetProductController() {
    print('🔄 [PRODUCT CONTROLLER] Resetting product controller');

    _isInitialized.value = false;
    _initializeDefaultTabs();

    _products.clear();
    _filteredProducts.clear();
    _productsCountBySection.clear();
    _productsBySection.clear();
    _allSections.clear();
    _selectedProductIds.clear();
    _isSelectionMode.value = false;
    _lastDataFetchTime = null;

    _createTabController();
    _safeUpdateUI();

    return Future.value();
  }

  void _handleTabChange() {
    if (_isDisposed.value ||
        !_isTabControllerReady.value ||
        _tabController == null)
      return;

    try {
      if (!_tabController!.indexIsChanging) {
        final newIndex = _tabController!.index;
        if (newIndex != currentTabIndex.value) {
          if (_tabChangeTimer?.isActive ?? false) {
            _tabChangeTimer?.cancel();
          }

          _tabChangeTimer = Timer(const Duration(milliseconds: 100), () {
            currentTabIndex.value = newIndex;
            _loadTabData(newIndex);
            _safeUpdateUI();
          });
        }
      }
    } catch (e) {
      print('⚠️ [PRODUCT CONTROLLER] Error in tab change: $e');
    }
  }

  Future<void> _loadCachedProducts() async {
    try {
      print('📂 [PRODUCT CONTROLLER] Loading cached products...');
      final cachedProducts = dataService.getProducts();

      if (cachedProducts.isNotEmpty) {
        print(
          '📂 [PRODUCT CONTROLLER] Found ${cachedProducts.length} cached products',
        );
        _products.assignAll(
          cachedProducts.map((product) => Product.fromJson(product)).toList(),
        );
        _filteredProducts.assignAll(_products);
        _updateProductsCountBySection();
        _groupProductsBySection();
        _safeUpdateUI();
      } else {
        print('📂 [PRODUCT CONTROLLER] No cached products found');
      }
    } catch (e) {
      print('⚠️ [PRODUCT CONTROLLER] Error loading cached products: $e');
    }
  }

  Future<void> _loadProducts({bool forceRefresh = false}) async {
    print(
      '📡 [PRODUCT CONTROLLER] Loading products, forceRefresh: $forceRefresh',
    );

    final now = DateTime.now();
    if (!forceRefresh && _lastDataFetchTime != null) {
      final difference = now.difference(_lastDataFetchTime!);
      if (difference.inSeconds < 30) {
        print(
          '⏱️ [PRODUCT CONTROLLER] Using cached data, last fetch was ${difference.inSeconds} seconds ago',
        );
        return;
      }
    }

    await _performLoadProducts();
  }

  Future<void> _performLoadProducts() async {
    print('🎯 [PRODUCT CONTROLLER] Performing product load...');

    try {
      if (!_isUserAuthenticated()) {
        print('⚠️ [PRODUCT CONTROLLER] User not authenticated');
        return;
      }

      _isLoadingProducts(true);
      _productsErrorMessage('');
      _lastDataFetchTime = DateTime.now();

      print('🌐 [PRODUCT CONTROLLER] Fetching products from API...');

      final response = await ApiHelper.get(
        path: '/merchants/products',
        withLoading: false,
      );

      if (response != null && response['status'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        final newProducts = data
            .map((product) => Product.fromJson(product))
            .toList();

        print(
          '✅ [PRODUCT CONTROLLER] API returned ${newProducts.length} products',
        );

        _products.assignAll(newProducts);
        _filteredProducts.assignAll(_products);

        _updateProductsCountBySection();
        _groupProductsBySection();

        await dataService.refreshProducts();

        _updateTabsWithSections();

        print('🎉 [PRODUCT CONTROLLER] Products loaded successfully');
      } else {
        final errorMessage = response?['message'] ?? 'فشل في تحميل المنتجات';
        _productsErrorMessage.value = errorMessage;
        print('❌ [PRODUCT CONTROLLER] Failed to load products: $errorMessage');
      }
    } catch (e, stackTrace) {
      _productsErrorMessage.value = 'خطأ في تحميل المنتجات: ${e.toString()}';
      print('❌ [PRODUCT CONTROLLER] Error loading products: $e');
      print('📝 Stack trace: $stackTrace');
    } finally {
      _isLoadingProducts(false);
      _safeUpdateUI();
    }
  }

  void _updateTabsWithSections({bool forceUpdate = false}) {
    if (_isDisposed.value ||
        !_isInitialized.value ||
        _isUpdatingTabs.value ||
        !_isTabControllerReady.value)
      return;

    _isUpdatingTabs.value = true;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (_isDisposed.value) return;

        final sections = bottomSheetController.getSections();
        _allSections.assignAll(sections);

        final updatedTabs = <TabData>[
          TabData(label: 'جميع المنتجات', viewName: 'جميع المنتجات'),
          TabData(label: 'عروض', viewName: 'عروض'),
          TabData(label: 'مراجعات', viewName: 'مراجعات'),
        ];

        for (final section in sections) {
          final productCount =
              _productsCountBySection[section.id.toString()] ?? 0;
          updatedTabs.add(
            TabData(
              label: '${section.name} ($productCount)',
              viewName: section.name,
              sectionId: section.id,
            ),
          );
        }

        final needsUpdate = forceUpdate || _needsTabUpdate(tabs, updatedTabs);

        if (needsUpdate) {
          print(
            '📊 [PRODUCT CONTROLLER] Updating tabs: ${updatedTabs.length} tabs',
          );

          tabs.assignAll(updatedTabs);
        }
      } catch (e) {
        print('❌ [PRODUCT CONTROLLER] Error updating tabs: $e');
      } finally {
        _isUpdatingTabs.value = false;
      }
    });
  }

  bool _needsTabUpdate(List<TabData> oldTabs, List<TabData> newTabs) {
    if (oldTabs.length != newTabs.length) return true;

    for (int i = 0; i < oldTabs.length; i++) {
      if (oldTabs[i].label != newTabs[i].label) return true;
      if (oldTabs[i].viewName != newTabs[i].viewName) return true;
      if (oldTabs[i].sectionId != newTabs[i].sectionId) return true;
    }

    return false;
  }

  void _updateProductsCountBySection() {
    _productsCountBySection.clear();

    for (final product in _filteredProducts) {
      final sectionId = product.sectionId ?? '0';
      _productsCountBySection[sectionId] =
          (_productsCountBySection[sectionId] ?? 0) + 1;
    }
  }

  void _groupProductsBySection() {
    _productsBySection.clear();

    for (final product in _filteredProducts) {
      final sectionId = product.sectionId ?? '0';

      if (!_productsBySection.containsKey(sectionId)) {
        _productsBySection[sectionId] = [];
      }
      _productsBySection[sectionId]!.add(product);
    }
  }

  void _filterProducts() {
    if (searchQuery.value.isEmpty) {
      _filteredProducts.assignAll(_products);
    } else {
      final filtered = _products
          .where(
            (product) =>
                product.name.toLowerCase().contains(
                  searchQuery.value.toLowerCase(),
                ) ||
                (product.description?.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ??
                    false) ||
                (product.sku?.toLowerCase().contains(
                      searchQuery.value.toLowerCase(),
                    ) ??
                    false),
          )
          .toList();
      _filteredProducts.assignAll(filtered);
    }
    _groupProductsBySection();
    _safeUpdateUI();
  }

  Future<void> _loadTabData(int tabIndex) async {
    try {
      if (tabIndex < tabs.length) {
        print(
          '📋 [PRODUCT CONTROLLER] Loading tab data: ${tabs[tabIndex].label}',
        );
      }
    } catch (e) {
      print('❌ [PRODUCT CONTROLLER] Error loading tab data: $e');
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

  void _scheduleUIUpdate() {
    if (_uiUpdateTimer?.isActive ?? false) {
      _uiUpdateTimer?.cancel();
    }

    _uiUpdateTimer = Timer(const Duration(milliseconds: 100), () {
      if (_shouldUpdateUI.value && !_isDisposed.value) {
        try {
          update();
        } catch (e) {
          print('⚠️ [PRODUCT CONTROLLER] Error in UI update: $e');
        }
        _shouldUpdateUI.value = false;
      }
    });
  }

  void _safeUpdateUI() {
    if (_isDisposed.value) return;
    _shouldUpdateUI.value = true;
    _scheduleUIUpdate();
  }

  Future<void> refreshProducts({bool showLoading = true}) async {
    print('🔄 [PRODUCT CONTROLLER] Manual refresh triggered');
    await _performLoadProducts();
  }

  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
    _filterProducts();
  }

  void changeTab(int index) {
    if (_isDisposed.value ||
        !_isTabControllerReady.value ||
        _tabController == null)
      return;

    if (index >= 0 && index < tabs.length) {
      try {
        _tabController!.animateTo(index);
        currentTabIndex.value = index;
        _safeUpdateUI();
      } catch (e) {
        print('⚠️ [PRODUCT CONTROLLER] Error changing tab: $e');
        _retryControllerInitialization();
      }
    }
  }

  Future<void> reloadProducts() async {
    print('🔃 [PRODUCT CONTROLLER] Reloading products...');
    await refreshProducts(showLoading: false);
  }

  Future<void> deleteProduct(Product product) async {
    try {
      UnifiedLoadingScreen.show(message: 'جاري حذف المنتج...');

      await Future.delayed(const Duration(seconds: 1));

      _products.removeWhere((p) => p.id == product.id);
      _filterProducts();

      Get.back();

      Get.snackbar(
        'تم الحذف',
        'تم حذف المنتج ${product.name} بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'خطأ',
        'فشل في حذف المنتج: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void toggleViewMode() {
    _viewMode.value = _viewMode.value == 'list' ? 'grid' : 'list';
    _safeUpdateUI();
  }

  void sortProducts(String sortBy, {bool ascending = true}) {
    switch (sortBy) {
      case 'name':
        _products.sort(
          (a, b) =>
              ascending ? a.name.compareTo(b.name) : b.name.compareTo(a.name),
        );
        break;
      case 'price':
        _products.sort((a, b) {
          final priceA = double.tryParse(a.price ?? '0') ?? 0;
          final priceB = double.tryParse(b.price ?? '0') ?? 0;
          return ascending
              ? priceA.compareTo(priceB)
              : priceB.compareTo(priceA);
        });
        break;
    }
    _filterProducts();
  }

  void applyFilters(Map<String, dynamic> filters) {
    _filterProducts();
  }

  void toggleProductSelection(String productId) {
    if (_selectedProductIds.contains(productId)) {
      _selectedProductIds.remove(productId);
    } else {
      _selectedProductIds.add(productId);
    }

    _isSelectionMode.value = _selectedProductIds.isNotEmpty;
    _safeUpdateUI();
  }

  void clearSelection() {
    _selectedProductIds.clear();
    _isSelectionMode.value = false;
    _safeUpdateUI();
  }

  Future<void> deleteSelectedProducts() async {
    if (_selectedProductIds.isEmpty) return;

    try {
      UnifiedLoadingScreen.show(message: 'جاري حذف المنتجات المحددة...');

      await Future.delayed(const Duration(seconds: 1));

      _products.removeWhere(
        (product) => _selectedProductIds.contains(product.id),
      );
      _filterProducts();
      clearSelection();

      Get.back();

      Get.snackbar(
        'تم الحذف',
        'تم حذف ${_selectedProductIds.length} منتج بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      Get.back();
      Get.snackbar(
        'خطأ',
        'فشل في حذف المنتجات: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
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

  String getSectionName(String sectionId) {
    if (sectionId == '0') return 'غير مصنف';

    final section = _allSections.firstWhere(
      (s) => s.id.toString() == sectionId,
      orElse: () => Section(id: 0, name: 'غير معروف', storeId: ''),
    );
    return section.name;
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

  List<Product> getProductsForTab(int tabIndex) {
    if (tabIndex >= tabs.length) return [];

    if (tabIndex == 0) {
      return _filteredProducts.toList();
    } else if (tabIndex == 1) {
      return _filteredProducts.where((product) {
        return false;
      }).toList();
    } else if (tabIndex == 2) {
      return _filteredProducts.where((product) {
        return int.tryParse(product.messagesCount ?? '0') != null &&
            int.tryParse(product.messagesCount!)! > 0;
      }).toList();
    } else if (tabIndex >= 3) {
      final sectionTab = tabs[tabIndex];
      if (sectionTab.sectionId != null) {
        return _filteredProducts
            .where(
              (product) => product.sectionId == sectionTab.sectionId.toString(),
            )
            .toList();
      }
    }
    return [];
  }

  void openFilter() => bottomSheetController.openFilter();

  void openSort() => bottomSheetController.openSort();

  void openMultiSelect() => bottomSheetController.openMultiSelect();

  void openSingleSelect() => bottomSheetController.openSingleSelect();

  void openManageSections() => bottomSheetController.openManageSections();

  void openAddNewSection() => bottomSheetController.openAddNewSection();

  @override
  void onClose() {
    print('🛑 [PRODUCT CONTROLLER] Closing controller...');

    _isDisposed.value = true;

    _searchDebounceTimer?.cancel();
    _uiUpdateTimer?.cancel();
    _tabChangeTimer?.cancel();

    if (_tabController != null) {
      if (_tabController!.hasListeners) {
        _tabController!.removeListener(_handleTabChange);
      }

      try {
        _tabController!.dispose();
      } catch (e) {
        print('⚠️ [PRODUCT CONTROLLER] Error disposing tab controller: $e');
      }
    }

    searchTextController.dispose();

    super.onClose();
    print('✅ [PRODUCT CONTROLLER] Controller closed successfully');
  }

  bool get isControllerDisposed => _isDisposed.value;

  bool get isControllerInitialized => _isInitialized.value;

  bool get isLoadingProducts => _isLoadingProducts.value;

  String get productsErrorMessage => _productsErrorMessage.value;

  List<Product> get allProducts => _products.toList();

  List<Product> get filteredProducts => _filteredProducts.toList();

  int get totalProductsCount => _products.length;

  Map<String, List<Product>> get productsBySection =>
      Map.from(_productsBySection);

  List<Section> get allSections => _allSections.toList();

  String get viewMode => _viewMode.value;

  List<String> get selectedProductIds => _selectedProductIds.toList();

  bool get isSelectionMode => _isSelectionMode.value;

  bool get hasSelectedProducts => _selectedProductIds.isNotEmpty;

  int get selectedProductsCount => _selectedProductIds.length;

  bool get isTabControllerReady =>
      _isTabControllerReady.value && _tabController != null;

  bool get isTabControllerValid => isTabControllerReady;

  /// Notifies listeners that products were updated.
  ///
  /// Used by screens that refresh product data and need UI updates.
  void notifyProductsUpdated() {
    update();
  }

}
