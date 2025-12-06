import 'package:get/get.dart';
import 'package:attene_mobile/api/api_request.dart';

import '../../models/section_model.dart';
import '../../utlis/sheet_controller.dart';
import '../screens_navigator_bottom_bar/product/product_controller.dart';

class DataSyncService extends GetxService {
  static DataSyncService get to => Get.find();
  
  final RxBool _isSyncing = false.obs;
  final RxMap<String, DateTime> _lastSyncTimes = <String, DateTime>{}.obs;
  
  @override
  void onInit() {
    super.onInit();
    print('🔄 [SYNC] تهيئة خدمة مزامنة البيانات');
  }
  
  Future<void> syncStoreSections(int storeId) async {
    if (_isSyncing.value) return;
    
    _isSyncing(true);
    
    try {
      print('🔄 [SYNC] مزامنة أقسام المتجر: $storeId');
      
      final response = await ApiHelper.get(
        path: '/merchants/sections',
        queryParameters: {'store_id': storeId, 'force_refresh': true},
        withLoading: false,
      );
      
      if (response != null && response['status'] == true) {
        // إشعار جميع المتحكمات بالبيانات المحدثة
        _notifyControllersAboutSections(response['data'] ?? []);
        
        _lastSyncTimes['sections_$storeId'] = DateTime.now();
        
        print('✅ [SYNC] تمت مزامنة أقسام المتجر $storeId');
      }
    } catch (e) {
      print('❌ [SYNC] خطأ في مزامنة أقسام المتجر: $e');
    } finally {
      _isSyncing(false);
    }
  }
  
  // في DataSyncService - تحديث دالة _notifyControllersAboutSections
  void _notifyControllersAboutSections(List<dynamic> sectionsData) {
    try {
      // تحويل البيانات إلى كائنات Section
      final sections = sectionsData.map((section) => Section.fromJson(section)).toList();
      
      // // إشعار BottomSheetController
      // if (Get.isRegistered<BottomSheetController>()) {
      //   final bottomSheetController = Get.find<BottomSheetController>();
      //   bottomSheetController.onSectionsUpdated(sections);
        
      //   // تحديث مباشر للمراقبين
      //   bottomSheetController.sectionsRx.assignAll(sections);
      // }
      
      // إشعار ProductController باستخدام الدالة الصحيحة
      // if (Get.isRegistered<ProductController>()) {
      //   final productController = Get.find<ProductController>();
      //   productController.onSectionsUpdated(sections);
      // }
      
      print('📢 [SYNC] تم إشعار المتحكمات بـ ${sections.length} قسم');
    } catch (e) {
      print('⚠️ [SYNC] خطأ في إشعار المتحكمات: $e');
    }
  }
  
  Future<void> syncImmediately(String type, {int? storeId}) async {
    switch (type) {
      case 'sections':
        if (storeId != null) {
          await syncStoreSections(storeId);
        }
        break;
      case 'products':
        // إضافة مزامنة المنتجات إذا لزم الأمر
        break;
    }
  }
  
  bool isDataFresh(String key, {int maxAgeMinutes = 5}) {
    final lastSync = _lastSyncTimes[key];
    if (lastSync == null) return false;
    
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    
    return difference.inMinutes < maxAgeMinutes;
  }
  
  // وظيفة مساعدة لتحميل الأقسام بسرعة
  Future<void> quickLoadSections(int storeId) async {
    try {
      final response = await ApiHelper.get(
        path: '/merchants/sections',
        queryParameters: {'store_id': storeId, 'limit': 50},
        withLoading: false,
      );
      
      if (response != null && response['status'] == true) {
        _notifyControllersAboutSections(response['data'] ?? []);
        print('⚡ [QUICK SYNC] تم تحميل الأقسام بسرعة للمتجر: $storeId');
      }
    } catch (e) {
      print('⚠️ [QUICK SYNC] خطأ في تحميل الأقسام السريع: $e');
    }
  }
}