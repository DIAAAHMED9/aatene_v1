import 'dart:convert';
import 'package:attene_mobile/api/api_request.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/my_app/my_app_controller.dart';
import 'package:attene_mobile/models/store_model.dart';
import 'package:attene_mobile/view/add%20new%20store/choose_type_store/type_store.dart';
import 'package:attene_mobile/view/add%20new%20store/add_new_store.dart';
import 'package:attene_mobile/view/Services/data_lnitializer_service.dart';
import 'package:attene_mobile/view/Services/unified_loading_screen.dart';

class ManageAccountStoreController extends GetxController with GetTickerProviderStateMixin {
  final MyAppController myAppController = Get.find<MyAppController>();
  final DataInitializerService dataService = Get.find<DataInitializerService>();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxList<Store> stores = <Store>[].obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchQuery = ''.obs;
  
  late TabController tabController;
  
  final List<TabData> tabs = [
    TabData(label: 'جميع المتاجر', viewName: 'all_stores'),
    TabData(label: 'المتاجر النشطة', viewName: 'active_stores'),
    TabData(label: 'المتاجر المعلقة', viewName: 'pending_stores'),
  ];

  @override
  void onInit() {
    tabController = TabController(length: tabs.length, vsync: this);
    super.onInit();
    loadStores();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
Future<void> loadStores() async {
  return UnifiedLoadingScreen.showWithFuture<void>(
    _performLoadStores(),
    message: 'جاري تحميل المتاجر...',
  );
}

Future<void> _performLoadStores() async {
  try {
    isLoading.value = true;
    errorMessage.value = '';
    
    // محاولة استخدام البيانات المخزنة محليًا أولاً
    final cachedStores = dataService.getStores();
    if (cachedStores.isNotEmpty) {
      // تحويل البيانات المخزنة إلى كائنات Store
      stores.assignAll(cachedStores.map((storeData) => Store.fromJson(storeData)).toList());
    }
    
    // ثم جلب التحديثات من الخادم
    final response = await ApiHelper.get(
      path: '/merchants/stores',
      queryParameters: {'orderDir': 'asc'},
      withLoading: false,
      shouldShowMessage: false,
    );

    if (response != null && response['status'] == true) {
      final List<dynamic> data = response['data'];
      // تحديث القائمة بالبيانات الجديدة
      stores.assignAll(data.map((storeData) => Store.fromJson(storeData)).toList());
      
      // تحديث التخزين المحلي
      await dataService.refreshStores();
    } else {
      errorMessage.value = response?['message'] ?? 'فشل تحميل المتاجر';
    }
  } catch (e) {
    errorMessage.value = 'حدث خطأ في تحميل المتاجر: $e';
  } finally {
    isLoading.value = false;
  }
}



  void addNewStore() {
    Get.to(() => TypeStore());
  }

  void editStore(Store store) {
    Get.to(() => AddNewStore(), arguments: {'storeId': int.parse(store.id)});
  }

  void deleteStore(Store store) {
    Get.dialog(
      AlertDialog(
        title: Text('حذف المتجر'),
        content: Text('هل أنت متأكد من حذف المتجر "${store.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              await _performDeleteStore(store);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('حذف'),
          ),
        ],
      ),
    );
  }

  Future<void> _performDeleteStore(Store store) async {
    return UnifiedLoadingScreen.showWithFuture<void>(
      _performDeleteStoreInternal(store),
      message: 'جاري حذف المتجر...',
    );
  }

  Future<void> _performDeleteStoreInternal(Store store) async {
    try {
      final storeId = int.tryParse(store.id);
      if (storeId == null) {
        Get.snackbar('خطأ', 'معرف المتجر غير صالح');
        return;
      }
      
      final response = await ApiHelper.deleteStore(storeId);
      
      if (response != null && response['status'] == true) {
        stores.removeWhere((s) => s.id == store.id);
        
        // تحديث التخزين المحلي
        await dataService.deleteStore(storeId);
        
        Get.snackbar(
          'تم الحذف',
          'تم حذف المتجر بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'خطأ',
          response?['message'] ?? 'فشل حذف المتجر',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في حذف المتجر: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  void navigateBack() {
    Get.back();
  }

  void onSearchChanged(String value) {
    searchQuery.value = value;
  }

  void onFilterPressed() {
    Get.snackbar(
      'تصفية',
      'سيتم فتح شاشة التصفية',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void onSortPressed() {
    Get.snackbar(
      'ترتيب',
      'سيتم فتح شاشة الترتيب',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}