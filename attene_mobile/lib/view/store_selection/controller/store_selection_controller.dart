import '../../../general_index.dart';

class StoreSelectionController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<dynamic> stores = <dynamic>[].obs;
  final RxString searchQuery = ''.obs;
  final Rxn<dynamic> selectedStore = Rxn<dynamic>();

  @override
  void onInit() {
    super.onInit();
    loadStores();
  }

  List<dynamic> get filteredStores {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return stores;
    return stores.where((s) {
      final name = (s['name'] ?? s['title'] ?? '').toString().toLowerCase();
      final code = (s['code'] ?? s['slug'] ?? '').toString().toLowerCase();
      return name.contains(q) || code.contains(q);
    }).toList();
  }

  Future<void> loadStores({bool force = false}) async {
    try {
      isLoading.value = true;

      final storage = Get.find<GetStorage>();
      if (!force) {
        final cached = storage.read('app_stores');
        if (cached is List && cached.isNotEmpty) {
          stores.assignAll(cached);
        }
      }

      final response = await ApiHelper.get(
        path: '/merchants/stores',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final data = (response['data'] ?? []) as List;
        stores.assignAll(data);
        await storage.write('app_stores', data);
      }
    } catch (e) {
      print('❌ [STORE SELECT] loadStores error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void selectStore(dynamic store) {
    selectedStore.value = store;
  }

  Future<void> confirmSelection() async {
    final store = selectedStore.value;
    if (store == null) return;

    final storeIdRaw = store['id'];
    if (storeIdRaw == null) return;

    final storeId = int.tryParse(storeIdRaw.toString());
    if (storeId == null) return;

    // حفظ المتجر بالطريقة الصحيحة داخل user_data
    await DataInitializerService.to.updateUserData({
      'store_id': storeId,
      'active_store_id': storeId,
      'store': store,
    });

    // ✅ Phase 2: تهيئة عامة للجميع + تهيئة بيانات المتجر للتاجر
    await DataInitializerService.to.initializeCoreData(silent: true);
    await DataInitializerService.to.initializeStoreData(storeId: storeId, silent: true);

    Get.offAllNamed('/mainScreen');
  }

  Future<void> resetStoreSelection() async {
    // زر مؤقت: إزالة المتجر الحالي ثم الذهاب للاختيار
    await DataInitializerService.to.updateUserData({
      'store_id': null,
      'active_store_id': null,
      'store': null,
    });
  }
}
