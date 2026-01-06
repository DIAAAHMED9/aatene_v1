
import '../../../../general_index.dart';

class KeywordController extends GetxController {
  static KeywordController get to => Get.find();

  final MyAppController myAppController = Get.find();
  final ProductCentralController productController = Get.find();

  final RxList<Store> stores = <Store>[].obs;
  final Rx<Store?> selectedStore = Rx<Store?>(null);
  final RxBool isLoadingStores = false.obs;
  final RxString storesError = ''.obs;
  final RxBool hasAttemptedLoad = false.obs;
  final RxBool isInitialized = false.obs;

  final RxList<String> availableKeywords = <String>[].obs;
  final RxList<String> selectedKeywords = <String>[].obs;
  final RxList<String> filteredKeywords = <String>[].obs;

  final TextEditingController searchController = TextEditingController();
  final RxBool isSearchInputEmpty = true.obs;
  final RxBool isLoadingKeywords = false.obs;

  static const int maxKeywords = 15;
  static const List<String> defaultKeywords = [
    'ملابس',
    'أحذية',
    'إلكترونيات',
    'هواتف',
    'لابتوبات',
    'إكسسوارات',
    'منزلية',
    'رياضية',
    'عطور',
    'جمال',
    'أطفال',
    'رجال',
    'نساء',
    'رياضة',
    'موضة',
    'ديكور',
    'مطبخ',
    'أجهزة',
  ];

  @override
  void onInit() {
    super.onInit();
    print('🚀 [KEYWORD CONTROLLER] Initializing...');

    _setupListeners();
    _initializeController();
  }

  void _setupListeners() {
    searchController.addListener(_onSearchChanged);

    ever(myAppController.isLoggedIn, (isLoggedIn) {
      if (isLoggedIn && !isInitialized.value) {
        _initializeController();
      }
    });
  }

  Future<void> _initializeController() async {
    if (isInitialized.value) return;

    try {
      print('🔄 [KEYWORD CONTROLLER] Initializing data...');

      _syncWithProductController();
      _loadDefaultKeywords();

      if (myAppController.isLoggedIn.value) {
        await loadStores();
      }

      isInitialized.value = true;
      print('✅ [KEYWORD CONTROLLER] Initialization completed');
    } catch (e) {
      print('❌ [KEYWORD CONTROLLER] Initialization error: $e');
      storesError('فشل في تهيئة البيانات: $e');
    }
  }

  void _syncWithProductController() {
    selectedKeywords.assignAll(productController.keywords);
    print(
      '🔄 [KEYWORD] Synced with product controller: ${selectedKeywords.length} keywords',
    );
  }

  /// Public helper for edit-mode: re-sync selected keywords from ProductCentralController.
  void syncFromProductController() {
    _syncWithProductController();
    update();
  }

  Future<void> loadStoresOnOpen() async {
    if (!myAppController.isLoggedIn.value) {
      storesError('يجب تسجيل الدخول أولاً');
      return;
    }

    if (hasAttemptedLoad.value && stores.isNotEmpty) return;
    await loadStores();
  }

  Future<void> loadStores() async {
    try {
      if (!myAppController.isLoggedIn.value) {
        storesError('يجب تسجيل الدخول أولاً');
        return;
      }

      hasAttemptedLoad.value = true;
      isLoadingStores.value = true;
      storesError.value = '';

      print('🏪 [KEYWORD] Fetching stores from API...');

      final response = await ApiHelper.get(
        path: '/merchants/stores',
        queryParameters: {'orderDir': 'asc'},
        withLoading: false,
      );

      if (response != null && response['status'] == true) {
        final storesList = List<Map<String, dynamic>>.from(
          response['data'] ?? [],
        );
        final loadedStores = storesList.map(Store.fromJson).toList();

        stores.assignAll(loadedStores);

        if (stores.isNotEmpty) {
          selectedStore.value = stores.first;
          print('✅ [KEYWORD] Auto-selected store: ${stores.first.name}');
        }

        print('✅ [KEYWORD] Loaded ${stores.length} stores');
      } else {
        final errorMessage = response?['message'] ?? 'فشل في تحميل المتاجر';
        storesError.value = errorMessage;
      }
    } catch (e) {
      storesError.value = 'حدث خطأ أثناء تحميل المتاجر: $e';
      print('❌ [KEYWORD] Stores error: $e');
    } finally {
      isLoadingStores.value = false;
      update();
    }
  }

  Future<void> reloadStores() async {
    stores.clear();
    selectedStore.value = null;
    await loadStores();
  }

  void setSelectedStore(Store store) {
    selectedStore.value = store;
    print('✅ [KEYWORD] Store selected: ${store.name}');
    update();
  }

  void _loadDefaultKeywords() {
    availableKeywords.assignAll(defaultKeywords);
    filteredKeywords.assignAll(defaultKeywords);
    print('🔤 [KEYWORD] Loaded ${defaultKeywords.length} default keywords');
  }

  void _onSearchChanged() {
    final query = searchController.text.trim();
    isSearchInputEmpty.value = query.isEmpty;

    filteredKeywords.assignAll(
      query.isEmpty
          ? availableKeywords
          : availableKeywords.where((k) => k.contains(query)).toList(),
    );
    update();
  }

  void addCustomKeyword() {
    final text = searchController.text.trim();

    if (text.isEmpty) {
      _showErrorSnackbar('يرجى إدخال كلمة مفتاحية');
      return;
    }

    if (selectedKeywords.contains(text)) {
      _showWarningSnackbar('هذه الكلمة مضافة مسبقاً');
      return;
    }

    if (selectedKeywords.length >= maxKeywords) {
      _showErrorSnackbar('تم الوصول للحد الأقصى ($maxKeywords كلمة)');
      return;
    }

    selectedKeywords.add(text);
    searchController.clear();
    _updateProductControllerKeywords();
    update();

    print('✅ [KEYWORD] Custom keyword added: $text');
  }

  void addKeyword(String keyword) {
    if (selectedKeywords.contains(keyword)) {
      _showWarningSnackbar('هذه الكلمة مضافة مسبقاً');
      return;
    }

    if (selectedKeywords.length >= maxKeywords) {
      _showErrorSnackbar('تم الوصول للحد الأقصى ($maxKeywords كلمة)');
      return;
    }

    selectedKeywords.add(keyword);
    _updateProductControllerKeywords();
    update();

    print('✅ [KEYWORD] Keyword added: $keyword');
  }

  void removeKeyword(String keyword) {
    selectedKeywords.remove(keyword);
    _updateProductControllerKeywords();
    update();

    print('🗑️ [KEYWORD] Keyword removed: $keyword');
  }

  void _updateProductControllerKeywords() {
    productController.addKeywords(selectedKeywords);
    print(
      '🔄 [KEYWORD] Updated product controller with ${selectedKeywords.length} keywords',
    );
  }

  void confirmSelection() {
    if (selectedStore.value == null) {
      _showErrorSnackbar('يرجى اختيار متجر');
      return;
    }

    try {
      productController.updateSelectedStore({
        'id': selectedStore.value!.id,
        'name': selectedStore.value!.name,
        'logo_url': selectedStore.value!.logoUrl,
        'status': selectedStore.value!.status,
      });

      Get.back();
      _showSuccessSnackbar('تم حفظ الكلمات المفتاحية بنجاح');
    } catch (e) {
      _showErrorSnackbar('حدث خطأ أثناء الحفظ: $e');
    }
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'خطأ',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _showWarningSnackbar(String message) {
    Get.snackbar(
      'تنبيه',
      message,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  void _showSuccessSnackbar(String message) {
    Get.snackbar(
      'نجاح',
      message,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
    );
  }

  bool get canAddMoreKeywords => selectedKeywords.length < maxKeywords;

  bool get isFormValid =>
      selectedStore.value != null && selectedKeywords.isNotEmpty;

  bool get hasStoresError => storesError.value.isNotEmpty;

  bool get hasStores => stores.isNotEmpty;

  String getStoreStatusText(String status) {
    switch (status) {
      case 'active':
        return 'نشط';
      case 'not-active':
        return 'غير نشط';
      case 'pending':
        return 'قيد المراجعة';
      default:
        return status;
    }
  }

  Color getStoreStatusColor(String status) {
    switch (status) {
      case 'active':
        return Colors.green;
      case 'not-active':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}