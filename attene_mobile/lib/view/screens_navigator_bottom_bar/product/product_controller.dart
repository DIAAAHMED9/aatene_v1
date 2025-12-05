import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/models/section_model.dart';
import 'package:attene_mobile/models/product_model.dart';
import 'package:attene_mobile/utlis/sheet_controller.dart';
import '../../../controller/product_controller.dart';
import '../../../my_app/my_app_controller.dart';
import '../../Services/data_lnitializer_service.dart';
import '../../Services/unified_loading_screen.dart';

class ProductController extends GetxController with SingleGetTickerProviderMixin {
  final DataInitializerService dataService = Get.find<DataInitializerService>();
  final MyAppController myAppController = Get.find<MyAppController>();
  late BottomSheetController bottomSheetController;
  
  late TabController _tabController;
  
  TabController get tabController {
    try {
      if (!_tabController.hasListeners) {
        _tabController.addListener(_handleTabChange);
      }
      return _tabController;
    } catch (e) {
      print('❌ [PRODUCTS] خطأ في الوصول إلى TabController: $e');
      _initializeTabController();
      return _tabController;
    }
  }
  
  final TextEditingController searchTextController = TextEditingController();
  final RxInt currentTabIndex = 0.obs;
  final RxString searchQuery = ''.obs;
  
  final RxList<TabData> tabs = RxList<TabData>.from([
    TabData(label: 'جميع المنتجات', viewName: 'جميع المنتجات'),
    TabData(label: 'عروض', viewName: 'عروض'),
    TabData(label: 'مراجعات', viewName: 'مراجعات'),
  ]);
  
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
  
  final RxBool _sectionsLoaded = false.obs;
  final RxBool _productsLoaded = false.obs;
  final RxInt _initializationStep = 0.obs;
  
  final String appBarUpdateId = 'appbar_tabs_update';
  
  // قسم محدد حاليًا
  final Rx<Section?> _selectedSection = Rx<Section?>(null);
  Section? get selectedSection => _selectedSection.value;
  final RxString selectedSectionName = ''.obs;
  
  // إشارة لتحديد ما إذا كان يتم الانتقال لإضافة منتج جديد
  final RxBool _isNavigatingToAddProduct = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    bottomSheetController = Get.find<BottomSheetController>();
    
    _initializeTabController();
    _initializeBasicControllers();
    _setupAuthListener();
    _setupProductsListener();
    _setupSectionsListener();
    _setupStoreListener();
    _setupSelectedSectionSync();
  }
  
  void _initializeTabController() {
    try {
      if (_tabController.hasListeners) {
        _tabController.removeListener(_handleTabChange);
      }
      _tabController.dispose();
    } catch (e) {}
    
    try {
      _tabController = TabController(
        length: tabs.length,
        vsync: this,
        initialIndex: currentTabIndex.value
      );
      
      _tabController.addListener(_handleTabChange);
      
      print('✅ [PRODUCTS] تم تهيئة TabController جديد مع ${tabs.length} تبويب');
    } catch (e) {
      print('❌ [PRODUCTS] خطأ في تهيئة TabController: $e');
      Future.delayed(const Duration(milliseconds: 100), () {
        try {
          _tabController = TabController(
            length: tabs.length,
            vsync: this,
            initialIndex: currentTabIndex.value
          );
          _tabController.addListener(_handleTabChange);
          print('✅ [PRODUCTS] تم تهيئة TabController في المحاولة الثانية');
        } catch (e2) {
          print('❌ [PRODUCTS] فشل في تهيئة TabController: $e2');
        }
      });
    }
  }
  
  void _initializeBasicControllers() {
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
      print('📋 [PRODUCTS] استلام تحديث الأقسام: ${sections.length} قسم');
      if (sections.isNotEmpty) {
        _allSections.assignAll(sections);
        _sectionsLoaded.value = true;
        
        if (_productsLoaded.value && myAppController.isLoggedIn.value && _isInitialized.value) {
          _updateProductsBySection();
          _updateTabsWithSections();
        }
      }
    });
  }
  
  void _setupStoreListener() {
    ever(myAppController.selectedStoreId, (int storeId) {
      if (storeId > 0 && _isInitialized.value) {
        print('🏪 [PRODUCTS] تغيير المتجر إلى: $storeId');
        _reloadAllDataForStore(storeId);
      }
    });
  }
  
  void _setupSelectedSectionSync() {
    // مزامنة القسم المختار مع BottomSheetController
    ever(bottomSheetController.selectedSectionNameRx, (String sectionName) {
      if (sectionName.isNotEmpty) {
        selectedSectionName.value = sectionName;
        print('🔄 [PRODUCTS] مزامنة اسم القسم: $sectionName');
      }
    });
    
    // استمع لتغيرات القسم المحدد في BottomSheetController
    ever(bottomSheetController.selectedSectionRx, (Section? section) {
      if (section != null) {
        _selectedSection.value = section;
        selectedSectionName.value = section.name;
        print('✅ [PRODUCTS] تم مزامنة القسم المحدد: ${section.name}');
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
  
  Future<void> _initializeProductController() async {
    if (_isInitialized.value) return;
    
    print('🔄 [PRODUCTS] بدء تهيئة متحكم المنتجات');
    
    _isInitialized.value = true;
    
    _initializationStep.value = 1;
    await _loadSectionsFirst();
    
    _initializationStep.value = 2;
    await _loadProducts();
    
    _initializationStep.value = 3;
    print('✅ [PRODUCTS] اكتمال تهيئة متحكم المنتجات');
  }
  
  Future<void> _loadSectionsFirst() async {
    try {
      final storeId = myAppController.selectedStoreId.value;
      
      if (storeId > 0) {
        print('🏪 [PRODUCTS] تحميل أقسام المتجر: $storeId');
        await bottomSheetController.loadSectionsByStore(storeId, forceRefresh: true);
      } else {
        print('📋 [PRODUCTS] تحميل جميع الأقسام');
        await bottomSheetController.refreshSectionsImmediately();
      }
      
      int attempts = 0;
      while (bottomSheetController.sections.isEmpty && attempts < 10) {
        await Future.delayed(const Duration(milliseconds: 300));
        attempts++;
      }
      
      if (bottomSheetController.sections.isNotEmpty) {
        _allSections.assignAll(bottomSheetController.sections);
        _sectionsLoaded.value = true;
        print('✅ [PRODUCTS] تم تحميل ${_allSections.length} قسم');
      } else {
        print('⚠️ [PRODUCTS] لم يتم تحميل أي أقسام');
      }
    } catch (e) {
      print('❌ [PRODUCTS] خطأ في تحميل الأقسام: $e');
    }
  }
  
  void _resetProductController() {
    if (!_isInitialized.value) return;
    
    print('🔁 [PRODUCTS] إعادة تعيين متحكم المنتجات بسبب تسجيل الخروج');
    
    _isInitialized.value = false;
    _sectionsLoaded.value = false;
    _productsLoaded.value = false;
    _initializationStep.value = 0;
    
    tabs.assignAll([
      TabData(label: 'جميع المنتجات', viewName: 'جميع المنتجات'),
      TabData(label: 'عروض', viewName: 'عروض'),
      TabData(label: 'مراجعات', viewName: 'مراجعات'),
    ]);
    
    _products.clear();
    _filteredProducts.clear();
    _productsCountBySection.clear();
    _productsBySection.clear();
    _allSections.clear();
    _selectedSection.value = null;
    selectedSectionName.value = '';
    
    currentTabIndex.value = 0;
    _updateTabController();
    
    update([appBarUpdateId]);
  }
  
  void _updateTabController() {
    try {
      _tabController.dispose();
      
      _tabController = TabController(
        length: tabs.length,
        vsync: this,
        initialIndex: currentTabIndex.value < tabs.length ? currentTabIndex.value : 0
      );
      
      _tabController.addListener(_handleTabChange);
      
      print('🔄 [PRODUCTS] تم تحديث TabController مع ${tabs.length} تبويب');
    } catch (e) {
      print('❌ [PRODUCTS] خطأ في تحديث TabController: $e');
    }
  }
  
  void onSectionsUpdated(List<Section> sections) {
    print('🔄 [PRODUCTS] استلام تحديث الأقسام: ${sections.length} قسم');
    
    _allSections.assignAll(sections);
    _sectionsLoaded.value = true;
    
    if (_productsLoaded.value) {
      _updateProductsBySection();
      _updateTabsWithSections();
    }
    
    update([appBarUpdateId]);
  }
  
  void refreshSectionsImmediately(List<Section> sections) {
    print('⚡ [PRODUCTS] تحديث فوري للأقسام: ${sections.length} قسم');
    onSectionsUpdated(sections);
  }
  
  void updateSelectedSection(Section section) {
    try {
      print('✅ [PRODUCTS] تحديث القسم المحدد: ${section.name} (ID: ${section.id})');
      _selectedSection.value = section;
      selectedSectionName.value = section.name;
      
      bottomSheetController.selectSection(section);
      
      update([appBarUpdateId]);
    } catch (e) {
      print('❌ [PRODUCTS] خطأ في تحديث القسم المحدد: $e');
    }
  }
  
  // دالة جديدة: الحصول على القسم الحالي المحدد
  Section? getCurrentSelectedSection() {
    if (_selectedSection.value != null) {
      return _selectedSection.value;
    }
    
    // محاولة الحصول من BottomSheetController
    final bottomSheetSection = bottomSheetController.selectedSection;
    if (bottomSheetSection != null) {
      _selectedSection.value = bottomSheetSection;
      selectedSectionName.value = bottomSheetSection.name;
      return bottomSheetSection;
    }
    
    return null;
  }
  
  int _findTabIndexBySectionId(int sectionId) {
    for (int i = 0; i < tabs.length; i++) {
      if (tabs[i].sectionId == sectionId) {
        return i;
      }
    }
    return -1;
  }
  
  void _updateTabsWithSections() {
    if (!_isInitialized.value || _isUpdatingTabs.value || !_sectionsLoaded.value) return;
    
    _isUpdatingTabs.value = true;
    
    try {
      print('🔄 [PRODUCTS] تحديث التاب بار بالأقسام والمنتجات');
      
      final sections = _allSections.toList();
      
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
        final int currentIndex = currentTabIndex.value < updatedTabs.length 
            ? currentTabIndex.value 
            : 0;
        
        tabs.assignAll(updatedTabs);
        
        _updateTabController();
        
        currentTabIndex.value = currentIndex;
        
        update([appBarUpdateId]);
        
        print('✅ [PRODUCTS] تم تحديث ${tabs.length} تاب بار');
      } else {
        print('ℹ️ [PRODUCTS] لا حاجة لتحديث التابوات - لم تتغير');
      }
      
    } catch (e) {
      print('❌ [PRODUCTS] خطأ في تحديث التابوات: $e');
    } finally {
      _isUpdatingTabs.value = false;
    }
  }
  
  Future<void> _reloadAllDataForStore(int storeId) async {
    try {
      print('🔄 [PRODUCTS] إعادة تحميل جميع البيانات للمتجر: $storeId');
      
      _sectionsLoaded.value = false;
      _productsLoaded.value = false;
      _initializationStep.value = 1;
      
      await bottomSheetController.loadSectionsByStore(storeId, forceRefresh: true);
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      await _loadProducts();
      
    } catch (e) {
      print('❌ [PRODUCTS] خطأ في إعادة تحميل البيانات للمتجر: $e');
    }
  }
  
  void _handleTabChange() {
    try {
      if (!_tabController.indexIsChanging) {
        currentTabIndex.value = _tabController.index;
        _loadTabData(_tabController.index);
      }
    } catch (e) {
      print('❌ [PRODUCTS] خطأ في معالجة تغيير التبويب: $e');
    }
  }
  
  void _handleSearchChange() {
    searchQuery.value = searchTextController.text;
    _filterProducts();
  }
  
  Future<void> _loadProducts() async {
    if (!_sectionsLoaded.value) {
      print('⏳ [PRODUCTS] انتظار تحميل الأقسام قبل تحميل المنتجات...');
      await _waitForSections();
    }
    
    return UnifiedLoadingScreen.showWithFuture<void>(
      _performLoadProducts(),
      message: 'جاري تحميل المنتجات...',
    );
  }
  
  Future<void> _waitForSections() async {
    int attempts = 0;
    while (!_sectionsLoaded.value && attempts < 10) {
      await Future.delayed(const Duration(milliseconds: 300));
      attempts++;
    }
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
      
      final storeId = myAppController.selectedStoreId.value;
      final queryParameters = storeId > 0 ? {'store_id': storeId} : null;
      
      final response = await ApiHelper.get(
        path: '/merchants/products',
        queryParameters: queryParameters,
        withLoading: false,
      );
      
      if (response != null && response['status'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        final loadedProducts = data.map((product) => Product.fromJson(product)).toList();
        
        _products.assignAll(loadedProducts);
        _filteredProducts.assignAll(_products);
        _productsLoaded.value = true;
        
        _updateProductsCountBySection();
        _updateProductsBySection();
        _updateTabsWithSections();
        
        await dataService.refreshProducts();
        
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
        final products = cachedProducts.map((product) => Product.fromJson(product)).toList();
        _products.assignAll(products);
        _filteredProducts.assignAll(_products);
        _productsLoaded.value = true;
        
        _updateProductsCountBySection();
        _updateProductsBySection();
        
        print('📂 [PRODUCTS] تم تحميل ${_products.length} منتج من التخزين المحلي');
      }
    } catch (e) {
      print('⚠️ [PRODUCTS] خطأ في تحميل المنتجات المخزنة: $e');
    }
  }
  
  void _updateProductsCountBySection() {
    _productsCountBySection.clear();
    
    for (final product in _filteredProducts) {
      final sectionId = product.sectionId ?? '0';
      _productsCountBySection[sectionId] = (_productsCountBySection[sectionId] ?? 0) + 1;
    }
  }
  
  void _updateProductsBySection() {
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
      final filtered = _products.where((product) =>
        product.name.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
      _filteredProducts.assignAll(filtered);
    }
    
    _updateProductsCountBySection();
    _updateProductsBySection();
    _updateTabsWithSections();
  }
  
  void _loadTabData(int tabIndex) {
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
    try {
      if (index >= 0 && index < tabs.length) {
        try {
          _tabController.animateTo(index);
          currentTabIndex.value = index;
          print('✅ [PRODUCTS] تم التبديل إلى التبويب: ${tabs[index].label}');
        } catch (e) {
          print('❌ [PRODUCTS] خطأ في التبديل: $e');
        }
      } else {
        print('⚠️ [PRODUCTS] مؤشر تبويب غير صالح: $index');
      }
    } catch (e) {
      print('❌ [PRODUCTS] خطأ في تغيير التبويب: $e');
    }
  }
  
  Future<void> reloadProducts() async {
    await _loadProducts();
  }
  
  List<Map<String, dynamic>> getDisplaySections() {
    final sections = <Map<String, dynamic>>[];
    final groupedProducts = _getAllProductsGrouped();
    
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
  
  Map<String, List<Product>> _getAllProductsGrouped() {
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
    try {
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
      } else if (tabIndex >= 3 && tabIndex < tabs.length) {
        final sectionTab = tabs[tabIndex];
        if (sectionTab.sectionId != null) {
          return _filteredProducts.where((product) => 
              product.sectionId == sectionTab.sectionId.toString()
          ).toList();
        }
      }
    } catch (e) {
      print('❌ [PRODUCTS] خطأ في getProductsForTab: $e');
    }
    return [];
  }
  
  String getSectionName(String sectionId) {
    if (sectionId == '0') return 'غير مصنف';
    
    try {
      final section = _allSections.firstWhere(
        (s) => s.id.toString() == sectionId,
        orElse: () => Section(id: 0, name: 'غير معروف', storeId: ''),
      );
      return section.name;
    } catch (e) {
      return 'غير معروف';
    }
  }
  
  int get totalProductsCount => _products.length;
  
  void navigateToAddProduct() {
    if (!_isUserAuthenticated()) {
      _showLoginRequiredMessage();
      return;
    }
  
    final hasSections = _allSections.isNotEmpty;
    
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
      
      // تعيين إشارة التنقل
      _isNavigatingToAddProduct.value = true;
      
      // فتح شاشة إدارة الأقسام مع رد نداء عند اختيار القسم
      Get.bottomSheet(
        _buildSectionSelectionSheet(),
        isScrollControlled: true,
      );
      
    } else {
      _navigateToAddProductWithSection();
    }
  }
  
  Widget _buildSectionSelectionSheet() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'اختر قسم للمنتج',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  Get.back();
                  _isNavigatingToAddProduct.value = false;
                },
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'يرجى اختيار قسم لإضافة المنتج الجديد إليه',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Get.back();
              bottomSheetController.openManageSections();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text(
              'اختر من الأقسام الحالية',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton(
            onPressed: () {
              Get.back();
              bottomSheetController.openAddNewSection();
            },
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            child: const Text('إنشاء قسم جديد'),
          ),
        ],
      ),
    );
  }
  
  void _navigateToAddProductWithSection() {
    _isNavigatingToAddProduct.value = true;
    
    // تأخير بسيط للسماح بتحديث الحالة
    Future.delayed(const Duration(milliseconds: 300), () {
      try {
        final section = getCurrentSelectedSection();
        if (section != null) {
          print('🚀 [PRODUCTS] الانتقال لإضافة منتج بالقسم: ${section.name}');
          
          // تأكد من تحديث ProductCentralController بالقسم المختار
          if (Get.isRegistered<ProductCentralController>()) {
            final productCentralController = Get.find<ProductCentralController>();
            productCentralController.updateSelectedSection(section);
          }
        }
        
        bottomSheetController.navigateToAddProductStepper();
        _isNavigatingToAddProduct.value = false;
      } catch (e) {
        print('❌ [PRODUCTS] خطأ في التنقل: $e');
        _isNavigatingToAddProduct.value = false;
      }
    });
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
    );
  }
  
  void openFilter() => bottomSheetController.openFilter();
  void openSort() => bottomSheetController.openSort();
  
  @override
  void onClose() {
    print('🔚 [PRODUCTS] إغلاق متحكم المنتجات');
    
    try {
      searchTextController.removeListener(_handleSearchChange);
      if (_tabController.hasListeners) {
        _tabController.removeListener(_handleTabChange);
      }
      _tabController.dispose();
      searchTextController.dispose();
      print('✅ [PRODUCTS] تم تنظيف المتحكم بنجاح');
    } catch (e) {
      print('⚠️ [PRODUCTS] خطأ في التنظيف: $e');
    }
    
    super.onClose();
  }
  
  bool _areTabsEqual(List<TabData> list1, List<TabData> list2) {
    if (list1.length != list2.length) return false;
    for (int i = 0; i < list1.length; i++) {
      if (list1[i].label != list2[i].label || 
          list1[i].viewName != list2[i].viewName ||
          list1[i].sectionId != list2[i].sectionId) {
        return false;
      }
    }
    return true;
  }
  
  Widget getInitializationStatus() {
    return Obx(() {
      switch (_initializationStep.value) {
        case 0:
          return const SizedBox();
        case 1:
          return Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 8),
                const Text('جاري تحميل الأقسام...'),
              ],
            ),
          );
        case 2:
          return Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 8),
                const Text('جاري تحميل المنتجات...'),
              ],
            ),
          );
        case 3:
          return const SizedBox();
        default:
          return const SizedBox();
      }
    });
  }
  
  bool get sectionsLoaded => _sectionsLoaded.value;
  bool get productsLoaded => _productsLoaded.value;
  int get initializationStep => _initializationStep.value;
  RxBool get isLoadingProducts => _isLoadingProducts;
  RxString get productsErrorMessage => _productsErrorMessage;
  List<Product> get allProducts => _products.toList();
  List<Product> get filteredProducts => _filteredProducts.toList();
  List<TabData> get tabsList => tabs.toList();
  
  // Getter للإشارة إلى القسم المحدد
  Rx<Section?> get selectedSectionRx => _selectedSection;
  
  // Getter للإشارة إلى حالة التنقل
  bool get isNavigatingToAddProduct => _isNavigatingToAddProduct.value;
}