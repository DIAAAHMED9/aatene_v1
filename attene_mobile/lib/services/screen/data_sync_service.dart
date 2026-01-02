

import '../../general_index.dart';

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

  void _notifyControllersAboutSections(List<dynamic> sectionsData) {
    try {
      final sections = sectionsData
          .map((section) => Section.fromJson(section))
          .toList();

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