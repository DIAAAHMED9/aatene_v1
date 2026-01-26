
import '../../../general_index.dart';
import '../model/account_model.dart';

class DrawerControllerX extends GetxController {
  final GetStorage _storage = GetStorage();

  final RxList<DrawerAccount> accounts = <DrawerAccount>[].obs;
  final RxInt selectedAccountId = 0.obs;

  // Key must match DataInitializerService
  static const String _storesKey = '_stores_cache_v1';

  @override
  void onInit() {
    super.onInit();
    _loadFromCache();
    refreshStores(); // حاول التحديث من السيرفر
  }

  DrawerAccount? get selectedAccount {
    final id = selectedAccountId.value;
    if (id <= 0) return accounts.isNotEmpty ? accounts.first : null;
    for (final a in accounts) {
      if (a.id == id) return a;
    }
    return accounts.isNotEmpty ? accounts.first : null;
  }

  Future<void> _loadFromCache() async {
    try {
      final cached = _storage.read(_storesKey);
      if (cached is List && cached.isNotEmpty) {
        final list = cached
            .whereType<Map>()
            .map((m) => DrawerAccount.fromStoreJson(Map<String, dynamic>.from(m)))
            .where((e) => e.id > 0)
            .toList();
        if (list.isNotEmpty) {
          accounts.assignAll(list);
          _syncSelectedFromUserData();
        }
      }
    } catch (_) {}
  }

  void _syncSelectedFromUserData() {
    try {
      final userData = (_storage.read('user_data') is Map)
          ? Map<String, dynamic>.from(_storage.read('user_data'))
          : <String, dynamic>{};

      final activeId = int.tryParse('${userData['active_store_id'] ?? userData['store_id'] ?? ''}') ?? 0;

      if (activeId > 0) {
        selectedAccountId.value = activeId;
      } else if (accounts.isNotEmpty) {
        // Default to first store
        selectAccount(accounts.first, initializeData: false);
      }
    } catch (_) {}
  }

  Future<void> refreshStores() async {
    try {
      final isMerchant = ApiHelper.isMerchantUser;
      if (!isMerchant) return;

      final response = await ApiHelper.get(path:'/merchants/stores');
      if (response != null && response['status'] == true) {
        final data = response['data'];
        final List<dynamic> stores = (data is List) ? data : <dynamic>[];

        final list = stores
            .whereType<Map>()
            .map((m) => DrawerAccount.fromStoreJson(Map<String, dynamic>.from(m)))
            .where((e) => e.id > 0)
            .toList();

        if (list.isNotEmpty) {
          accounts.assignAll(list);
          await _storage.write(_storesKey, stores);
          _syncSelectedFromUserData();
        }
      }
    } catch (e) {
      // ignore refresh failure
    }
  }

  Future<void> selectAccount(DrawerAccount account, {bool initializeData = true}) async {
    if (account.id <= 0) return;

    selectedAccountId.value = account.id;

    // Persist as active store
    final userData = (_storage.read('user_data') is Map)
        ? Map<String, dynamic>.from(_storage.read('user_data'))
        : <String, dynamic>{};

    userData['active_store_id'] = account.id;
    userData['store_id'] = account.id;

    await _storage.write('user_data', userData);
    await _storage.write('store_id', account.id);

    if (initializeData) {
      try {
        await Get.find<DataInitializerService>().initializeStoreData(storeId: account.id, silent: true);
      } catch (_) {}
    }

    update();
  }
}