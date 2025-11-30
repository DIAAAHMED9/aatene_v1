// lib/view/screens_navigator_bottom_bar/product/product_controller.dart
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/demo_stepper_screen.dart';
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
  
  @override
  void onInit() {
    super.onInit();
    
    // ✅ تهيئة الـ Controllers الأساسية فقط
    bottomSheetController = Get.find<BottomSheetController>();
    
    _initializeBasicControllers();
    _setupAuthListener();
  }

  void _initializeBasicControllers() {
    // Initialize tab controller فقط
    _initializeTabController();
    
    // Listen to tab changes
    tabController.addListener(_handleTabChange);
    
    // Listen to search text changes
    searchTextController.addListener(_handleSearchChange);
  }

  void _setupAuthListener() {
    // الاستماع لتغير حالة التهيئة أولاً
    ever(myAppController.isAppInitialized, (bool initialized) {
      if (initialized) {
        _checkAndInitialize();
      }
    });
    
    // الاستماع لتغير حالة تسجيل الدخول
    ever(myAppController.isLoggedIn, (bool isLoggedIn) {
      if (isLoggedIn) {
        _initializeProductController();
      } else {
        _resetProductController();
      }
    });
    
    // ✅ التصحيح: الاستماع لتغيرات الأقسام باستخدام RxList
    ever(bottomSheetController.sectionsRx, (_) {
      if (myAppController.isLoggedIn.value && _isInitialized.value) {
        _updateTabsWithSections();
      }
    });
    
    // إذا كان التطبيق مهيأ بالفعل، نتحقق مباشرة
    if (myAppController.isAppInitialized.value) {
      _checkAndInitialize();
    }
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
    
    // ✅ تحديث التبويبات فور التهيئة إذا كانت هناك أقسام
    if (bottomSheetController.sections.isNotEmpty) {
      _updateTabsWithSections();
    }
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
    
    // إعادة تهيئة الـ TabController - استخدام طريقة آمنة
    _safeDisposeTabController();
    _initializeTabController();
    tabController.addListener(_handleTabChange);
    
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
    if (!_isInitialized.value) return;
    
    try {
      // ✅ التصحيح: استخدام getSections() بدلاً من sections مباشرة
      final sections = bottomSheetController.getSections();
      
      // إنشاء قائمة تبويبات جديدة
      final updatedTabs = <TabData>[
        TabData(label: 'جميع المنتجات (0)', viewName: 'جميع المنتجات'),
        TabData(label: 'عروض', viewName: 'عروض'),
        TabData(label: 'مراجعات', viewName: 'مراجعات'),
      ];
      
      // إضافة تبويبات للأقسام
      for (final section in sections) {
        updatedTabs.add(TabData(
          label: '${section.name} (0)',
          viewName: section.name,
        ));
      }
      
      // تحديث التبويبات
      tabs.clear();
      tabs.addAll(updatedTabs);
      
      // إعادة تهيئة الـ TabController إذا تغير عدد التبويبات
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
    } catch (e) {
      print('❌ [PRODUCT] Error updating tabs: $e');
    }
  }
  
  void _handleTabChange() {
    if (!tabController.indexIsChanging) {
      currentTabIndex.value = tabController.index;
      _loadTabData(tabController.index);
    }
  }
  
  void _handleSearchChange() {
    searchQuery.value = searchTextController.text;
    if (searchQuery.value.isNotEmpty) {
      _performSearch();
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
      }
    } catch (e) {
      errorMessage.value = 'فشل في البحث: $e';
    }
  }
  
  void clearSearch() {
    searchTextController.clear();
    searchQuery.value = '';
  }
  
  void changeTab(int index) {
    if (index >= 0 && index < tabs.length) {
      tabController.animateTo(index);
      currentTabIndex.value = index;
    }
  }
  
  // دوال فتح البوتوم شيت
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

    // ✅ التصحيح: استخدام hasSelectedSection بدلاً من getSelectedSection()
    if (!bottomSheetController.hasSelectedSection) {
      Get.snackbar(
        'تنبيه',
        'يرجى اختيار قسم أولاً',
        backgroundColor: Colors.orange,
      );
      bottomSheetController.openManageSections();
    } else {
      // ✅ التصحيح: استخدام openAddProductScreen بدلاً من Get.to مباشرة
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
  
  // Getter للإطلاع على حالة التهيئة
  bool get isControllerInitialized => _isInitialized.value;
}