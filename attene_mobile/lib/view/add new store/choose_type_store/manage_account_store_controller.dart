// lib/view/manage_account_store/manage_account_store_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/my_app/my_app_controller.dart';
import 'package:attene_mobile/models/store_model.dart';

class ManageAccountStoreController extends GetxController {
  final MyAppController myAppController = Get.find<MyAppController>();
  
  final RxList<Store> _stores = <Store>[].obs;
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxString _searchQuery = ''.obs;
  late TextEditingController _searchController;
  
  // المتجر المحدد
  final Rx<Store?> _selectedStore = Rx<Store?>(null);
  final RxBool _isControllerInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    print('🔄 [ManageAccountStoreController] تهيئة المتحكم');
    
    // تأخير تهيئة المتحكمات
    Future.delayed(Duration.zero, () {
      _initializeController();
    });
  }

  void _initializeController() {
    if (_isControllerInitialized.value) return;
    
    _searchController = TextEditingController();
    _searchController.addListener(() {
      _searchQuery.value = _searchController.text;
    });
    
    // تحميل المتاجر عند بدء التطبيق
    if (myAppController.isLoggedIn.value) {
      loadStores();
    } else {
      _errorMessage.value = 'يجب تسجيل الدخول أولاً';
    }
    
    // الاستماع لتغير حالة تسجيل الدخول
    ever(myAppController.isLoggedIn, (bool isLoggedIn) {
      if (isLoggedIn && !_isLoading.value) {
        loadStores();
      } else if (!isLoggedIn) {
        clearStores();
      }
    });
    
    _isControllerInitialized.value = true;
    print('✅ [ManageAccountStoreController] تم تهيئة المتحكم بنجاح');
  }

  @override
  void onClose() {
    print('🔚 [ManageAccountStoreController] إغلاق المتحكم');
    _cleanupController();
    super.onClose();
  }

  void _cleanupController() {
    if (_isControllerInitialized.value) {
      // فقط نوقف الـlistener ولا نحذف الـcontroller
      // حتى لا يحدث خطأ "used after being disposed"
      try {
        if (_searchController.hasListeners) {
          _searchController.removeListener(() {});
        }
      } catch (e) {
        print('⚠️ [ManageAccountStoreController] خطأ في تنظيف المتحكم: $e');
      }
    }
  }

  // ==================== Getters ====================
  
  List<Store> get stores => _stores;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;
  String get searchQuery => _searchQuery.value;
  TextEditingController get searchController => _searchController;
  
  // إضافة: Getters للمتجر المحدد
  Store? get selectedStore => _selectedStore.value;
  bool get hasSelectedStore => _selectedStore.value != null;
  bool get isControllerInitialized => _isControllerInitialized.value;

  // ==================== وظائف المتاجر ====================
  
  Future<void> loadStores() async {
    if (!myAppController.isLoggedIn.value) {
      _errorMessage.value = 'يجب تسجيل الدخول أولاً';
      return;
    }
    
    if (_isLoading.value) {
      print('⏳ [ManageAccountStoreController] التحميل قيد التنفيذ بالفعل');
      return;
    }
    
    _isLoading.value = true;
    _errorMessage.value = '';
    
    try {
      print('🔄 [ManageAccountStoreController] تحميل المتاجر...');
      
      final response = await ApiHelper.get(
        path: '/merchants/stores',
        queryParameters: {'orderDir': 'asc'},
        withLoading: false,
        shouldShowMessage: false,
      );
      
      if (response != null && response['status'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        _stores.assignAll(data.map((store) => Store.fromJson(store)).toList());
        
        print('✅ [ManageAccountStoreController] تم تحميل ${_stores.length} متجر');
        
        // عند تحميل المتاجر لأول مرة، لا يتم تحديد أي متجر تلقائيا
        if (_stores.isNotEmpty) {
          print('ℹ️ [ManageAccountStoreController] يرجى اختيار متجر من القائمة');
        }
      } else {
        _errorMessage.value = response?['message'] ?? 'فشل في تحميل المتاجر';
        print('❌ [ManageAccountStoreController] فشل في تحميل المتاجر: ${_errorMessage.value}');
      }
    } catch (e) {
      _errorMessage.value = 'خطأ في تحميل المتاجر: ${e.toString()}';
      print('❌ [ManageAccountStoreController] خطأ في تحميل المتاجر: $e');
    } finally {
      _isLoading.value = false;
    }
  }
  
  void clearStores() {
    _stores.clear();
    _selectedStore.value = null;
    print('🗑️ [ManageAccountStoreController] تم مسح قائمة المتاجر');
  }
  
  // ==================== وظائف اختيار المتجر ====================
  
  void selectStore(Store store) {
    if (_selectedStore.value?.id == store.id) {
      // إذا تم الضغط على نفس المتجر، قم بإلغاء التحديد
      _selectedStore.value = null;
      myAppController.updateSelectedStore(0);
      print('🔓 [ManageAccountStoreController] إلغاء تحديد المتجر: ${store.name}');
      
      Get.snackbar(
        'تم إلغاء التحديد',
        'تم إلغاء تحديد متجر ${store.name}',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } else {
      // تحديد المتجر الجديد
      _selectedStore.value = store;
      myAppController.updateSelectedStore(int.parse(store.id));
      
      print('✅ [ManageAccountStoreController] تحديد المتجر: ${store.name} (ID: ${store.id})');
      
      // إشعار المستخدم
      Get.snackbar(
        'تم التحديد',
        'تم اختيار متجر ${store.name}',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }
  
  bool isStoreSelected(Store store) {
    return _selectedStore.value?.id == store.id;
  }
  
  // ==================== وظائف إدارة المتاجر ====================
  
  void addNewStore() {
    print('➕ [ManageAccountStoreController] الذهاب لإضافة متجر جديد');
    Get.toNamed('/add_new_store');
  }
  
  void editStore(Store store) {
    print('✏️ [ManageAccountStoreController] تعديل متجر: ${store.name}');
    Get.toNamed('/edit_store', arguments: {'store': store.toJson()});
  }
  
  Future<void> deleteStore(Store store) async {
    final confirm = await _showDeleteConfirmation(store);
    if (!confirm) return;
    
    try {
      final response = await ApiHelper.deleteStore(int.parse(store.id));
      if (response != null && response['status'] == true) {
        _stores.remove(store);
        
        // إذا كان المتجر المحذوف هو المحدد، نزيل التحديد
        if (_selectedStore.value?.id == store.id) {
          _selectedStore.value = null;
          myAppController.updateSelectedStore(0);
        }
        
        Get.snackbar(
          'تم الحذف',
          'تم حذف المتجر ${store.name} بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        
        print('🗑️ [ManageAccountStoreController] تم حذف المتجر: ${store.name}');
      } else {
        Get.snackbar(
          'خطأ',
          response?['message'] ?? 'فشل في حذف المتجر',
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
  
  Future<bool> _showDeleteConfirmation(Store store) async {
    return await Get.dialog<bool>(
      AlertDialog(
        title: const Text('حذف المتجر'),
        content: Text('هل أنت متأكد من حذف المتجر "${store.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    ) ?? false;
  }
  
  void onSearchChanged(String query) {
    _searchQuery.value = query;
  }
}