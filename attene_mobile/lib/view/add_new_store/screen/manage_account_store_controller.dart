import '../../../general_index.dart';
import '../../../services/api/api_guard.dart';
import '../../../services/api/stores_service.dart';

class ManageAccountStoreController extends GetxController
    with GetTickerProviderStateMixin {
  final MyAppController myAppController = Get.find<MyAppController>();
  final DataInitializerService dataService = Get.find<DataInitializerService>();
  final RxBool isLoading = false.obs;
  final RxBool isFetching = false.obs;
  final RxBool hasFetchedOnce = false.obs;
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

  Future<void> loadStores({bool force = false}) async {
    if (isFetching.value) return;
    if (hasFetchedOnce.value && !force) return;

    isFetching.value = true;
    await ApiGuard.run<void>(
      () async => _performLoadStores(),
      showLoading: true,
      loadingText: 'جاري تحميل المتاجر...',
    );
    isFetching.value = false;
  }

Future<void> _performLoadStores() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final cachedStores = dataService.getStores();
      if (cachedStores.isNotEmpty) {
        stores.assignAll(
          cachedStores.map((storeData) => Store.fromJson(storeData)).toList(),
        );
      }

      final response = await ApiHelper.get(
        path: '/merchants/stores',
        queryParameters: {'orderDir': 'asc'},
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final List<dynamic> data = response['data'];
        stores.assignAll(
          data.map((storeData) => Store.fromJson(storeData)).toList(),
        );

        await dataService.refreshStores();
        hasFetchedOnce.value = true;
      } else {
        errorMessage.value = response?['message'] ?? 'فشل تحميل المتاجر';
      }
      update();
    } catch (e) {
      errorMessage.value = 'حدث خطأ في تحميل المتاجر: $e';
    } finally {
      isLoading.value = false;
    }
  }

  void addNewStore() {
    Get.to(() => TypeStore());
    update();
  }

  void editStore(Store store) {
    Get.to(() => AddNewStore(), arguments: {'storeId': int.parse(store.id)});
    update();
  }

  void deleteStore(Store store) {
    Get.dialog(
      StoreDeleteDialog(
        store: store,
        onConfirm: () async => _performDeleteStore(store),
      ),
    );
    update();
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
      update();
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في حذف المتجر: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void navigateBack() => Get.back();

  void onSearchChanged(String value) {
    searchQuery.value = value;
    update();
  }

  void onFilterPressed() {
    Get.snackbar(
      'تصفية',
      'سيتم فتح شاشة التصفية',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
    update();
  }

  void onSortPressed() {
    Get.snackbar(
      'ترتيب',
      'سيتم فتح شاشة الترتيب',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
    update();
  }
}
