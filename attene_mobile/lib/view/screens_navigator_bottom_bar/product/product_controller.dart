// lib/view/screens_navigator_bottom_bar/product/product_controller.dart
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utlis/sheet_controller.dart';

class ProductController extends GetxController 
    with SingleGetTickerProviderMixin {
  
  // Tab Controller
  late TabController tabController;
  
  // Text Editing Controller
  final TextEditingController searchTextController = TextEditingController();
  
  // Reactive variables
  final RxInt currentTabIndex = 0.obs;
  final RxString searchQuery = ''.obs;
  
  // Tab data - باستخدام TabData من الملف الموحد
  final List<TabData> tabs = [
    TabData(label: 'جميع المنتجات (0)', viewName: 'جميع المنتجات'),
    TabData(label: 'عروض', viewName: 'عروض'),
    TabData(label: 'مراجعات', viewName: 'مراجعات'),
    TabData(label: 'تصنيف رقم 1', viewName: 'تصنيف رقم 1'),
    TabData(label: 'تصنيف رقم 2', viewName: 'تصنيف رقم 2'),
    TabData(label: 'تصنيف رقم 3', viewName: 'تصنيف رقم 3'),
    TabData(label: 'تصنيف رقم 4', viewName: 'تصنيف رقم 4'),
    TabData(label: 'تصنيف رقم 5', viewName: 'تصنيف رقم 5'),
  ];

  // إضافة متغيرات للتحكم في حالة التحميل والأخطاء
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  
  final bottomSheetController = Get.put(BottomSheetController());
  
  @override
  void onInit() {
    super.onInit();
    // Initialize tab controller with tabs length
    tabController = TabController(
      length: tabs.length, 
      vsync: this,
      initialIndex: currentTabIndex.value
    );
    
    // Listen to tab changes
    tabController.addListener(_handleTabChange);
    
    // Listen to search text changes
    searchTextController.addListener(_handleSearchChange);
    
    // تحميل البيانات الأولية
    _loadInitialData();
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
  
  // دالة لتحميل البيانات الأولية
  Future<void> _loadInitialData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      await Future.delayed(Duration(milliseconds: 500));
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      errorMessage.value = 'فشل في تحميل البيانات: $e';
    }
  }
  
  // دالة لتحميل بيانات تبويب معين
  Future<void> _loadTabData(int tabIndex) async {
    try {
      print('جاري تحميل بيانات التبويب: ${tabs[tabIndex].label}');
    } catch (e) {
      errorMessage.value = 'فشل في تحميل بيانات التبويب: $e';
    }
  }
  
  // دالة للبحث
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
  
  // دالة إضافية لتحديث عدد المنتجات في التبويب
  void updateProductCount(int tabIndex, int count) {
    if (tabIndex >= 0 && tabIndex < tabs.length) {
      print('تحديث عدد المنتجات في التبويب $tabIndex إلى $count');
    }
  }
  
  // دالة لإعادة تحميل البيانات
  Future<void> refreshData() async {
    await _loadInitialData();
  }
  
  void openFilter() {
    bottomSheetController.showBottomSheet(BottomSheetType.filter);
  }
  
  void openSort() {
    bottomSheetController.showBottomSheet(BottomSheetType.sort);
  }
  
  void openMultiSelect() {
    bottomSheetController.showBottomSheet(BottomSheetType.multiSelect);
  }
  
  void openSingleSelect() {
    bottomSheetController.showBottomSheet(BottomSheetType.singleSelect);
  }
  
  // دالة لفتح إدارة الأقسام
  void openManageSections() {
    bottomSheetController.openManageSections();
  }
  
  // دالة لفتح إضافة قسم جديد
  void openAddNewSection() {
    bottomSheetController.openAddNewSection();
  }
  
  @override
  void onClose() {
    tabController.removeListener(_handleTabChange);
    searchTextController.removeListener(_handleSearchChange);
    tabController.dispose();
    searchTextController.dispose();
    super.onClose();
  }
}

// ⚠️ تم إزالة التعريف المحلي لـ TabData تماماً