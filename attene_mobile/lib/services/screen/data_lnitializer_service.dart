


import '../../general_index.dart';
enum StoreMode { products, services, mixed }

class DataInitializerService extends GetxService {
  final RxBool _isInitializing = false.obs;
  final RxDouble _progress = 0.0.obs;
  final RxString _currentStep = ''.obs;
  final RxBool _isOnline = true.obs;
  final RxBool _isDataLoaded = false.obs;

  RxBool get isInitializingRx => _isInitializing;

  RxString get currentStepRx => _currentStep;

  RxDouble get progressRx => _progress;

  RxBool get isOnlineRx => _isOnline;

  RxBool get isDataLoadedRx => _isDataLoaded;

// ========= Phase 2: Role & TTL helpers =========
bool get isMerchantUser {
  final ud = getUserData();
  final user = ud['user'];
  if (user is Map) {
    final t = (user['user_type'] ?? '').toString().toLowerCase();
    return t == 'merchant';
  }
  final t2 = (ud['user_type'] ?? ud['role'] ?? ud['type'] ?? '').toString().toLowerCase();
  return t2 == 'merchant';
}


StoreMode get currentStoreMode {
  if (!isMerchantUser) return StoreMode.products;

  final ud = getUserData();
  final store = ud['store'];
  if (store is! Map) return StoreMode.products;

  final t = (store['type'] ?? store['store_type'] ?? '').toString().toLowerCase().trim();
  if (t == 'services' || t.contains('service') || t.contains('خدمات')) {
    return StoreMode.services;
  }
  if (t == 'mixed' || t == 'both') {
    return StoreMode.mixed;
  }
  return StoreMode.products;
}

bool _isFresh(String key, {required int maxAgeHours}) {
  try {
    final v = _storage.read<String>(key);
    if (v == null) return false;
    final last = DateTime.tryParse(v);
    if (last == null) return false;
    return DateTime.now().difference(last).inHours <= maxAgeHours;
  } catch (_) {
    return false;
  }
}

Future<void> _touch(String key) async {
  await _storage.write(key, DateTime.now().toIso8601String());
}


  final RxBool _productsUpdated = false.obs;

  RxBool get productsUpdated => _productsUpdated;

  void notifyProductsUpdated() {
    print('📢 [DATA SERVICE] Notifying products update');
    _productsUpdated.value = !_productsUpdated.value;
  }

  Future<void> refreshProducts() async {
    try {
      print('🔄 [DATA SERVICE] Refreshing products...');

      final storeId = _getActiveStoreId();
      if (storeId == null) {
        print('⚠️ [DATA SERVICE] No active storeId. Skip refreshProducts.');
        return;
      }

      final response = await ApiHelper.get(
        path: '/merchants/products',
        withLoading: false,
      );

      if (response != null && response['status'] == true) {
        final products = response['data'] ?? [];

        // ✅ store-scoped + unified type (List)
        await _storage.write(_kProducts(storeId), products);
        await _storage.write(
          _kLastUpdateProducts(storeId),
          DateTime.now().toIso8601String(),
        );

        // ✅ rebuild enhanced sections after products update
        await _rebuildEnhancedSections(storeId);

        notifyProductsUpdated();

        print(
          '✅ [DATA SERVICE] Products refreshed successfully (storeId=$storeId)',
        );
      }
    } catch (e) {
      print('❌ [DATA SERVICE] Error refreshing products: $e');
    }
  }

  static const String _STORES_KEY = 'app_stores';
  static const String _CITIES_KEY = 'app_cities';
  static const String _DISTRICTS_KEY = 'app_districts';
  static const String _CURRENCIES_KEY = 'app_currencies';
  static const String _SECTIONS_KEY = 'app_sections';
  static const String _ATTRIBUTES_KEY = 'app_attributes';
  static const String _CATEGORIES_KEY = 'app_categories';
  static const String _MEDIA_KEY = 'app_media';
  static const String _PRODUCTS_KEY = 'app_products';
  static const String _SETTINGS_KEY = 'app_settings';
  static const String _USER_DATA_KEY = 'user_data';
  static const String _LAST_UPDATE_KEY = 'last_update_time';
  static const String _APP_CONFIG_KEY = 'app_config';
  static const String _VARIATIONS_DATA_KEY = 'product_variations_data';
  static const String _PRODUCT_DRAFT_KEY = 'product_draft';
  static const String _ATTRIBUTES_VARIATIONS_KEY =
      'cached_attributes_variations';
  static const String _CACHED_SECTIONS_KEY = 'cached_sections_enhanced';
  static const String _SYNC_QUEUE_KEY = 'sync_queue';
  static const String _OFFLINE_DATA_KEY = 'offline_data';
  static const String _APP_STATISTICS_KEY = 'app_statistics';

  static DataInitializerService get to => Get.find();

  bool get isInitializing => _isInitializing.value;

  double get progress => _progress.value;

  String get currentStep => _currentStep.value;

  bool get isOnline => _isOnline.value;

  bool get isDataLoaded => _isDataLoaded.value;

  GetStorage get _storage => Get.find<GetStorage>();

  MyAppController get _myAppController => Get.find<MyAppController>();

  // ========= STORE SCOPE HELPERS (Phase 1) =========
  int? _getActiveStoreId() {
    try {
      final userData = getUserData();
      final dynamic s1 = userData['active_store_id'] ?? userData['store_id'];

      if (s1 != null) {
        final parsed = int.tryParse(s1.toString());
        if (parsed != null) return parsed;
      }

      return null;
    } catch (_) {
      return null;
    }
  }

  Future<void> _ensureDefaultStoreIfNeeded(List<dynamic> stores) async {
    try {
      if (stores.isEmpty) return;

      final current = _getActiveStoreId();
      if (current != null && current > 0) return;

      final first = stores.first;
      if (first is! Map) return;

      final firstId = int.tryParse('${first['id'] ?? ''}');
      if (firstId == null || firstId <= 0) return;

      // Update user_data + store_id so ApiHelper picks it up immediately
      final userData = (_storage.read('user_data') is Map)
          ? Map<String, dynamic>.from(_storage.read('user_data'))
          : <String, dynamic>{};

      userData['active_store_id'] = firstId;
      userData['store_id'] = firstId;
      await _storage.write('user_data', userData);
      await _storage.write('store_id', firstId);

      print('🏪 [STORES] تم تعيين المتجر الافتراضي: $firstId');
    } catch (e) {
      print('⚠️ [STORES] فشل تعيين المتجر الافتراضي: $e');
    }
  }


  String _kProducts(int storeId) => '${_PRODUCTS_KEY}_store_$storeId';
  String _kSections(int storeId) => '${_SECTIONS_KEY}_store_$storeId';
  String _kMedia(int storeId) => '${_MEDIA_KEY}_store_$storeId';
  String _kEnhancedSections(int storeId) =>
      '${_CACHED_SECTIONS_KEY}_store_$storeId';

  String _kLastUpdateProducts(int storeId) =>
      'last_update_products_store_$storeId';
  String _kLastUpdateSections(int storeId) =>
      'last_update_sections_store_$storeId';
  String _kLastUpdateMedia(int storeId) => 'last_update_media_store_$storeId';

  // Legacy key (كان يتم تخزين المنتجات فيه بشكل String JSON)
  static const String _LEGACY_PRODUCTS_KEY = 'products';

  Future<void> _migrateLegacyProductsIfNeeded() async {
    try {
      final storeId = _getActiveStoreId();
      if (storeId == null) return;

      // legacy: app_products العام
      if (_storage.hasData(_PRODUCTS_KEY) &&
          !_storage.hasData(_kProducts(storeId))) {
        final legacy = _storage.read(_PRODUCTS_KEY);
        if (legacy is List) {
          await _storage.write(_kProducts(storeId), legacy);
          print('🧭 [MIGRATION] Moved app_products -> ${_kProducts(storeId)}');
        }
      }

      // legacy: key 'products' قد يكون String JSON أو List
      if (_storage.hasData(_LEGACY_PRODUCTS_KEY)) {
        final v = _storage.read(_LEGACY_PRODUCTS_KEY);
        if (v is String && v.isNotEmpty) {
          try {
            final decoded = json.decode(v);
            if (decoded is List) {
              await _storage.write(_kProducts(storeId), decoded);
              print(
                '🧭 [MIGRATION] Moved products(String) -> ${_kProducts(storeId)}',
              );
            }
          } catch (_) {
            // ignore
          }
        } else if (v is List) {
          await _storage.write(_kProducts(storeId), v);
          print('🧭 [MIGRATION] Moved products(List) -> ${_kProducts(storeId)}');
        }

        await _storage.remove(_LEGACY_PRODUCTS_KEY);
        print('🧹 [MIGRATION] Removed legacy key: $_LEGACY_PRODUCTS_KEY');
      }
    } catch (e) {
      print('⚠️ [MIGRATION] Legacy products migration failed: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    print('🔄 [DATA SERVICE] تهيئة خدمة البيانات');

    Future.delayed(const Duration(milliseconds: 500), () {
      _initializeService();
    });
  }

  void _initializeService() {
    ever(_myAppController.isInternetConnect, (bool isConnected) {
      _isOnline.value = isConnected;
      print(
        '📶 [DATA] تغيير حالة الانترنت: ${isConnected ? 'متصل' : 'غير متصل'}',
      );

      if (isConnected && !_isDataLoaded.value) {
        _tryReloadOnConnection();
      }
    });

    _initializeStorage();
  }

  Future<void> _initializeStorage() async {
    try {
      await GetStorage.init();
      print('✅ [STORAGE] تم تهيئة GetStorage بنجاح');

      await _loadInitialStatistics();

      // Phase 1: migrate legacy products keys to store-scoped storage
      await _migrateLegacyProductsIfNeeded();

      if (_hasCachedData()) {
        print('📂 [DATA] تم العثور على بيانات مخزنة مسبقاً');
        _isDataLoaded.value = true;

        _processSyncQueue();
      }
    } catch (e) {
      print('❌ [STORAGE] خطأ في تهيئة GetStorage: $e');
    }
  }

  
// ========= Phase 2: Split initialization (Core vs Store) =========

/// تهيئة بيانات عامة (تعمل للمستخدم والتاجر)
Future<void> initializeCoreData({bool forceRefresh = false, bool silent = false}) async {
  if (_isInitializing.value) return;

  Future<void> run() async {
    _isInitializing.value = true;
    _progress.value = 0.0;
    _currentStep.value = 'تهيئة البيانات العامة...';

    try {
      // إذا لم يكن المستخدم مسجل دخول، لا نحمّل من الشبكة
      if (!_isUserAuthenticated()) {
        _isDataLoaded.value = true;
        _progress.value = 1.0;
        _currentStep.value = 'جاهز';
        return;
      }

      if (!_isOnline.value && forceRefresh) {
        throw Exception('لا يوجد اتصال بالإنترنت');
      }

      // SETTINGS (24h)
      _currentStep.value = 'جاري تحميل الإعدادات...';
      if (forceRefresh || !_isFresh('last_update_settings', maxAgeHours: 24)) {
        await _loadSettings();
        await _touch('last_update_settings');
      }

      // STORES (24h) - للتاجر مهم لاختيار المتجر
      _currentStep.value = 'جاري تحميل المتاجر...';
      if (forceRefresh || !_isFresh('last_update_stores', maxAgeHours: 24)) {
        await _loadStores();
        await _touch('last_update_stores');
      }

      // CITIES (72h)
      _currentStep.value = 'جاري تحميل المدن...';
      if (forceRefresh || !_isFresh('last_update_cities', maxAgeHours: 72)) {
        await _loadCities();
        await _touch('last_update_cities');
      }

      // DISTRICTS (72h)
      _currentStep.value = 'جاري تحميل المناطق...';
      if (forceRefresh || !_isFresh('last_update_districts', maxAgeHours: 72)) {
        await _loadDistricts();
        await _touch('last_update_districts');
      }

      // CURRENCIES (72h)
      _currentStep.value = 'جاري تحميل العملات...';
      if (forceRefresh || !_isFresh('last_update_currencies', maxAgeHours: 72)) {
        await _loadCurrencies();
        await _touch('last_update_currencies');
      }

      _progress.value = 1.0;
      _currentStep.value = 'تمت تهيئة البيانات العامة';
      _isDataLoaded.value = true;
    } finally {
      _isInitializing.value = false;
    }
  }

  if (!silent) {
    return UnifiedLoadingScreen.showWithFuture<void>(
      run(),
      message: 'جاري تهيئة البيانات...',
      dialogId: 'core_initialization',
    );
  }
  return run();
}

/// تهيئة بيانات المتجر (تعمل للتاجر فقط بعد اختيار المتجر)
Future<void> initializeStoreData({
  required int storeId,
  bool forceRefresh = false,
  bool silent = false,
}) async {
  if (_isInitializing.value) return;

  Future<void> run() async {
    _isInitializing.value = true;
    _progress.value = 0.0;
    _currentStep.value = 'تهيئة بيانات المتجر...';

    try {
      if (!_isUserAuthenticated()) return;

      if (!_isOnline.value && forceRefresh) {
        throw Exception('لا يوجد اتصال بالإنترنت');
      }

      // SECTIONS (12h)
      _currentStep.value = 'جاري تحميل الأقسام...';
      if (forceRefresh || !_isFresh(_kLastUpdateSections(storeId), maxAgeHours: 12)) {
        await _loadSections();
        await _touch(_kLastUpdateSections(storeId));
      }

      // ATTRIBUTES (24h)
      _currentStep.value = 'جاري تحميل السمات...';
      if (forceRefresh || !_isFresh('last_update_attributes', maxAgeHours: 24)) {
        await _loadAttributes();
        await _touch('last_update_attributes');
      }

      // CATEGORIES (24h)
      _currentStep.value = 'جاري تحميل الفئات...';
      if (forceRefresh || !_isFresh('last_update_categories', maxAgeHours: 24)) {
        await _loadCategories();
        await _touch('last_update_categories');
      }

      // PRODUCTS (6h)
      _currentStep.value = 'جاري تحميل المنتجات...';
      if (forceRefresh || !_isFresh(_kLastUpdateProducts(storeId), maxAgeHours: 6)) {
        await _loadProducts();
        await _touch(_kLastUpdateProducts(storeId));
      }

      // ✅ rebuild enhanced sections AFTER products
      await _rebuildEnhancedSections(storeId);

      // MEDIA (12h)
      _currentStep.value = 'جاري تحميل الوسائط...';
      if (forceRefresh || !_isFresh(_kLastUpdateMedia(storeId), maxAgeHours: 12)) {
        await _loadMedia();
        await _touch(_kLastUpdateMedia(storeId));
      }

      _progress.value = 1.0;
      _currentStep.value = 'تمت تهيئة بيانات المتجر';
      _isDataLoaded.value = true;
    } finally {
      _isInitializing.value = false;
    }
  }

  if (!silent) {
    return UnifiedLoadingScreen.showWithFuture<void>(
      run(),
      message: 'جاري تهيئة بيانات المتجر...',
      dialogId: 'store_initialization',
    );
  }
  return run();
}

/// Wrapper: تهيئة مناسبة حسب نوع المستخدم
Future<void> initializeData({bool forceRefresh = false, bool silent = false}) async {
  await initializeCoreData(forceRefresh: forceRefresh, silent: true);

  if (isMerchantUser) {
    final sid = _getActiveStoreId();
    if (sid != null) {
      await initializeStoreData(storeId: sid, forceRefresh: forceRefresh, silent: true);
    }
  }

  if (!silent) {
    // لو استدعيت هذه الدالة بدون silent نعرض رسالة بسيطة بعد إنتهاء العمل
    // (بدون فتح لودينج ثاني حتى لا نكرر الـ UI)
    print('✅ [DATA] initializeData complete');
  }
}

Future<void> initializeAppData({
    bool forceRefresh = false,
    bool silent = false,
  }) async {
    if (_isInitializing.value) {
      print('⚠️ [DATA] التهيئة قيد التنفيذ بالفعل');
      return;
    }

    if (!silent) {
      return UnifiedLoadingScreen.showWithFuture<void>(
        _performInitialization(forceRefresh: forceRefresh),
        message: 'جاري تهيئة البيانات...',
        dialogId: 'data_initialization',
      );
    } else {
      return _performInitialization(forceRefresh: forceRefresh);
    }
  }

  bool _isUserAuthenticated() {
    try {
      if (Get.isRegistered<MyAppController>()) {
        final myAppController = Get.find<MyAppController>();
        return myAppController.isLoggedIn.value;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<void> _loadAttributes() async {
    try {
      if (!_isUserAuthenticated()) {
        print('⚠️ [ATTRIBUTES] المستخدم غير مسجل دخول، تخطي تحميل السمات');
        return;
      }

      if (!_isOnline.value) {
        print('⚠️ [ATTRIBUTES] استخدام السمات المخزنة (غير متصل)');
        return;
      }

      final response = await ApiHelper.get(
        path: '/merchants/attributes',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final attributes = response['data'] ?? [];
        await _storage.write(_ATTRIBUTES_KEY, attributes);
        print('✅ [ATTRIBUTES] تم تحميل ${attributes.length} سمة');

        await saveAttributesForVariations(attributes);
      }
    } catch (e) {
      print('⚠️ [ATTRIBUTES] فشل في تحميل السمات: $e');
    }
  }

  Future<void> _performInitialization({bool forceRefresh = false}) async {
    _isInitializing.value = true;
    _progress.value = 0.0;
    _currentStep.value = 'جاري التحضير...';

    try {
      final totalSteps = 11;
      int currentStep = 0;

      if (!_isUserAuthenticated()) {
        print('👤 [DATA] المستخدم غير مسجل دخول، استخدام البيانات المخزنة فقط');
        _isDataLoaded.value = true;
        _progress.value = 1.0;
        _currentStep.value = 'جاهز';
        return;
      }

      if (!_isOnline.value && forceRefresh) {
        throw Exception('لا يوجد اتصال بالإنترنت');
      }

      if (!forceRefresh && _isDataLoaded.value && _hasCachedData()) {
        print('📂 [DATA] استخدام البيانات المخزنة مؤقتًا');
        _progress.value = 1.0;
        _currentStep.value = 'جاهز';
        return;
      }

      currentStep++;
      _progress.value = currentStep / totalSteps;
      _currentStep.value = 'جاري التحقق من الاتصال...';

      currentStep++;
      _progress.value = currentStep / totalSteps;
      _currentStep.value = 'جاري تحميل الإعدادات...';
      await _loadSettings();

      currentStep++;
      _progress.value = currentStep / totalSteps;
      _currentStep.value = 'جاري تحميل المتاجر...';
      await _loadStores();

      currentStep++;
      _progress.value = currentStep / totalSteps;
      _currentStep.value = 'جاري تحميل المدن...';
      await _loadCities();

      currentStep++;
      _progress.value = currentStep / totalSteps;
      _currentStep.value = 'جاري تحميل المناطق...';
      await _loadDistricts();

      currentStep++;
      _progress.value = currentStep / totalSteps;
      _currentStep.value = 'جاري تحميل العملات...';
      await _loadCurrencies();

      currentStep++;
      _progress.value = currentStep / totalSteps;
      _currentStep.value = 'جاري تحميل الأقسام...';
      await _loadSections();

      currentStep++;
      _progress.value = currentStep / totalSteps;
      _currentStep.value = 'جاري تحميل السمات...';
      await _loadAttributes();

      currentStep++;
      _progress.value = currentStep / totalSteps;
      _currentStep.value = 'جاري تحميل الفئات...';
      await _loadCategories();

      currentStep++;
      _progress.value = currentStep / totalSteps;
      _currentStep.value = 'جاري تحميل المنتجات...';
      await _loadProducts();

      // Phase 1: build enhanced sections after products are available
      final storeId = _getActiveStoreId();
      if (storeId != null) {
        await _rebuildEnhancedSections(storeId);
      }

      currentStep++;
      _progress.value = currentStep / totalSteps;
      _currentStep.value = 'جاري تحميل الوسائط...';
      await _loadMedia();

      currentStep++;
      _progress.value = currentStep / totalSteps;
      _currentStep.value = 'جاري تحديث الإحصائيات...';
      await _updateStatistics();

      _progress.value = 1.0;
      _currentStep.value = 'تم تهيئة البيانات بنجاح';
      _isDataLoaded.value = true;

      print('✅ [DATA] تم تهيئة بيانات التطبيق بنجاح');

      await _storage.write(_LAST_UPDATE_KEY, DateTime.now().toIso8601String());

      await _cleanupOldData();
    } catch (e) {
      print('❌ [DATA] خطأ في تهيئة بيانات التطبيق: $e');
      _currentStep.value = 'فشل في تهيئة البيانات';

      if (_hasCachedData() && !_isDataLoaded.value) {
        print('🔄 [DATA] استخدام البيانات المخزنة كنسخة احتياطية');
        _isDataLoaded.value = true;
      }

      rethrow;
    } finally {
      _isInitializing.value = false;
    }
  }

  bool _hasCachedData() {
    final storeId = _getActiveStoreId();
    if (storeId == null) return false;

    // الحد الأدنى للمرحلة 1
    return _storage.hasData(_STORES_KEY) &&
        _storage.hasData(_SETTINGS_KEY) &&
        _storage.hasData(_kSections(storeId)) &&
        _storage.hasData(_kProducts(storeId));
  }

  bool _hasOfflineData() {
    return _storage.hasData(_SYNC_QUEUE_KEY);
  }

  Future<void> _loadSettings() async {
    try {
      if (!_isOnline.value) {
        print('⚠️ [SETTINGS] استخدام الإعدادات المخزنة (غير متصل)');
        return;
      }

      final response = await ApiHelper.get(
        path: '/settings',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final settings = response['data'] ?? {};
        await _storage.write(_SETTINGS_KEY, settings);
        print('✅ [SETTINGS] تم تحميل الإعدادات');
      }
    } catch (e) {
      print('⚠️ [SETTINGS] فشل في تحميل الإعدادات: $e');
    }
  }

  Future<void> _loadStores() async {
    try {
      if (!_isOnline.value) {
        print('⚠️ [STORES] استخدام المتاجر المخزنة (غير متصل)');
        return;
      }

      final response = await ApiHelper.get(
        path: '/merchants/stores',
        queryParameters: {'orderDir': 'asc'},
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final stores = response['data'] ?? [];
        await _storage.write(_STORES_KEY, stores);
        await _ensureDefaultStoreIfNeeded(stores);
        print('✅ [STORES] تم تحميل ${stores.length} متجر');
      }
    } catch (e) {
      print('⚠️ [STORES] فشل في تحميل المتاجر: $e');
    }
  }

  Future<void> _loadCities() async {
    try {
      if (!_isOnline.value) {
        print('⚠️ [CITIES] استخدام المدن المخزنة (غير متصل)');
        return;
      }

      final response = await ApiHelper.get(
        path: '/merchants/cities',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final cities = response['data'] ?? [];
        await _storage.write(_CITIES_KEY, cities);
        print('✅ [CITIES] تم تحميل ${cities.length} مدينة');
      }
    } catch (e) {
      print('⚠️ [CITIES] فشل في تحميل المدن: $e');
    }
  }

  Future<void> _loadDistricts() async {
    try {
      if (!_isOnline.value) {
        print('⚠️ [DISTRICTS] استخدام المناطق المخزنة (غير متصل)');
        return;
      }

      final response = await ApiHelper.get(
        path: '/merchants/districts',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final districts = response['data'] ?? [];
        await _storage.write(_DISTRICTS_KEY, districts);
        print('✅ [DISTRICTS] تم تحميل ${districts.length} منطقة');
      }
    } catch (e) {
      print('⚠️ [DISTRICTS] فشل في تحميل المناطق: $e');
    }
  }

  Future<void> _loadCurrencies() async {
    try {
      if (!_isOnline.value) {
        print('⚠️ [CURRENCIES] استخدام العملات المخزنة (غير متصل)');
        return;
      }

      final response = await ApiHelper.get(
        path: '/merchants/currencies',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final currencies = response['data'] ?? [];
        await _storage.write(_CURRENCIES_KEY, currencies);
        print('✅ [CURRENCIES] تم تحميل ${currencies.length} عملة');
      }
    } catch (e) {
      print('⚠️ [CURRENCIES] فشل في تحميل العملات: $e');
    }
  }

  Future<void> _loadSections() async {
    try {
      final storeId = _getActiveStoreId();
      if (storeId == null) {
        print('⚠️ [SECTIONS] لا يوجد متجر محدد، تخطي تحميل الأقسام');
        return;
      }

      if (!_isOnline.value) {
        print('⚠️ [SECTIONS] استخدام الأقسام المخزنة (غير متصل)');
        return;
      }

      final response = await ApiHelper.get(
        path: '/merchants/sections',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final sections = response['data'] ?? [];

        await _storage.write(_kSections(storeId), sections);
        await _storage.write(
          _kLastUpdateSections(storeId),
          DateTime.now().toIso8601String(),
        );

        print('✅ [SECTIONS] تم تحميل ${sections.length} قسم (storeId=$storeId)');
      }
    } catch (e) {
      print('⚠️ [SECTIONS] فشل في تحميل الأقسام: $e');
    }
  }

  Future<void> _rebuildEnhancedSections(int storeId) async {
    try {
      final sections = _storage.read<List<dynamic>>(_kSections(storeId)) ?? [];
      if (sections.isEmpty) return;

      final enhancedSections = sections.map((section) {
        return {
          ...Map<String, dynamic>.from(section),
          'store_name': _getStoreName(section['store_id']),
          'product_count': _countProductsInSection(section['id'], storeId),
          'is_active': section['status'] == 'active',
        };
      }).toList();

      await _storage.write(_kEnhancedSections(storeId), enhancedSections);
      print(
        '✅ [SECTIONS] Enhanced sections rebuilt (${enhancedSections.length}) for storeId=$storeId',
      );
    } catch (e) {
      print('⚠️ [SECTIONS] Failed to rebuild enhanced sections: $e');
    }
  }

  Future<void> saveAttributesForVariations(List<dynamic> attributes) async {
    try {
      final processedAttributes = attributes.map((attr) {
        return {
          'id': attr['id']?.toString() ?? '',
          'title': attr['title'] ?? 'بدون اسم',
          'type': attr['type'] ?? 'text',
          'is_required': attr['is_required'] ?? false,
          'options': (attr['options'] ?? []).map((option) {
            return {
              'id': option['id']?.toString() ?? '',
              'title': option['title'] ?? 'بدون قيمة',
              'color_code': option['color_code'],
              'image_url': option['image_url'],
            };
          }).toList(),
          'created_at': attr['created_at'],
          'updated_at': attr['updated_at'],
        };
      }).toList();

      await _storage.write(_ATTRIBUTES_VARIATIONS_KEY, processedAttributes);
      print(
        '✅ [ATTRIBUTES] تم حفظ ${processedAttributes.length} سمة للاستخدام في الاختلافات',
      );
    } catch (e) {
      print('⚠️ [ATTRIBUTES] خطأ في حفظ السمات: $e');
    }
  }

  Future<void> _loadCategories() async {
    try {
      if (!_isOnline.value) {
        print('⚠️ [CATEGORIES] استخدام الفئات المخزنة (غير متصل)');
        return;
      }

      final response = await ApiHelper.get(
        path: '/merchants/categories/select',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final categories = response['categories'] ?? [];
        await _storage.write(_CATEGORIES_KEY, categories);
        print('✅ [CATEGORIES] تم تحميل ${categories.length} فئة');
      }
    } catch (e) {
      print('⚠️ [CATEGORIES] فشل في تحميل الفئات: $e');
    }
  }

  Future<void> _loadProducts() async {
    try {
      final storeId = _getActiveStoreId();
      if (storeId == null) {
        print('⚠️ [PRODUCTS] لا يوجد متجر محدد، تخطي تحميل المنتجات');
        return;
      }

      if (!_isOnline.value) {
        print('⚠️ [PRODUCTS] استخدام المنتجات المخزنة (غير متصل)');
        return;
      }

      final response = await ApiHelper.get(
        path: '/merchants/products',
        queryParameters: {
          'limit': 100,
          'orderBy': 'created_at',
          'orderDir': 'desc',
        },
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final products = response['data'] ?? [];
        await _storage.write(_kProducts(storeId), products);
        await _storage.write(
          _kLastUpdateProducts(storeId),
          DateTime.now().toIso8601String(),
        );

        print('✅ [PRODUCTS] تم تحميل ${products.length} منتج (storeId=$storeId)');
      }
    } catch (e) {
      print('⚠️ [PRODUCTS] فشل في تحميل المنتجات: $e');
    }
  }

  Future<void> _loadMedia() async {
    try {
      final storeId = _getActiveStoreId();
      if (storeId == null) {
        print('⚠️ [MEDIA] لا يوجد متجر محدد، تخطي تحميل الوسائط');
        return;
      }

      if (!_isOnline.value) {
        print('⚠️ [MEDIA] استخدام الوسائط المخزنة (غير متصل)');
        return;
      }

      final List<String> mediaTypes = [
        'gallery',
        'image',
        'media',
        'avatar',
        'thumbnail',
      ];
      final List<Map<String, dynamic>> allMedia = [];

      for (String mediaType in mediaTypes) {
        try {
          final response = await ApiHelper.get(
            path: '/media-center/list',
            queryParameters: {'type': mediaType, 'limit': 50},
            withLoading: false,
            shouldShowMessage: false,
          );

          if (response != null &&
              response['status'] == true &&
              response['data'] != null) {
            final data = response['data'];
            if (data is List) {
              final typedMedia = List<Map<String, dynamic>>.from(data).map((
                item,
              ) {
                return {...item, 'type': mediaType, 'selected': false};
              }).toList();

              allMedia.addAll(typedMedia);
            }
          }
        } catch (e) {
          print('⚠️ [MEDIA] فشل في تحميل نوع الوسائط $mediaType: $e');
        }
      }

      allMedia.sort((a, b) {
        final dateA =
            DateTime.tryParse(a['created_at'] ?? '') ?? DateTime(2000);
        final dateB =
            DateTime.tryParse(b['created_at'] ?? '') ?? DateTime(2000);
        return dateB.compareTo(dateA);
      });

      await _storage.write(_kMedia(storeId), allMedia);
      await _storage.write(
        _kLastUpdateMedia(storeId),
        DateTime.now().toIso8601String(),
      );
      print('✅ [MEDIA] تم تحميل ${allMedia.length} وسائط (storeId=$storeId)');
    } catch (e) {
      print('⚠️ [MEDIA] فشل في تحميل الوسائط: $e');
    }
  }

  Future<void> _tryReloadOnConnection() async {
    try {
      if (_isDataLoaded.value && _isOnline.value) {
        if (isDataStale()) {
          print('🔄 [DATA] البيانات قديمة، جاري التحديث...');
          await initializeAppData(forceRefresh: true, silent: true);
        }

        await _processSyncQueue();
      }
    } catch (e) {
      print('⚠️ [DATA] خطأ في إعادة التحميل: $e');
    }
  }

  Future<void> _processSyncQueue() async {
    try {
      final queue = _storage.read<List<dynamic>>(_SYNC_QUEUE_KEY) ?? [];
      if (queue.isEmpty) return;

      print('🔄 [SYNC] معالجة ${queue.length} مهمة متأخرة');

      for (final task in queue) {
        try {
          await _processSyncTask(task);
        } catch (e) {
          print('⚠️ [SYNC] فشل في معالجة المهمة: $e');
        }
      }

      await _storage.remove(_SYNC_QUEUE_KEY);
      print('✅ [SYNC] تمت مزامنة جميع المهام');
    } catch (e) {
      print('❌ [SYNC] خطأ في معالجة قائمة المزامنة: $e');
    }
  }

  Future<void> _processSyncTask(Map<String, dynamic> task) async {
    final String type = task['type'] ?? '';
    final dynamic data = task['data'];

    switch (type) {
      case 'add_product':
        await _syncAddProduct(data);
        break;
      case 'update_product':
        await _syncUpdateProduct(data);
        break;
      case 'add_section':
        await _syncAddSection(data);
        break;
      default:
        print('⚠️ [SYNC] نوع مهمة غير معروف: $type');
    }
  }

  Future<void> _syncAddProduct(Map<String, dynamic> productData) async {
    print('🔄 [SYNC] مزامنة إضافة منتج');
  }

  Future<void> _syncUpdateProduct(Map<String, dynamic> productData) async {
    print('🔄 [SYNC] مزامنة تحديث منتج');
  }

  Future<void> _syncAddSection(Map<String, dynamic> sectionData) async {
    print('🔄 [SYNC] مزامنة إضافة قسم');
  }

  Future<void> _loadInitialStatistics() async {
    try {
      final stats = await getStatistics();
      await _storage.write(_APP_STATISTICS_KEY, stats);
      print('📊 [STATS] تم تحميل الإحصائيات الأولية');
    } catch (e) {
      print('⚠️ [STATS] خطأ في تحميل الإحصائيات: $e');
    }
  }

  Future<void> _updateStatistics() async {
    try {
      final stats = await getStatistics();
      await _storage.write(_APP_STATISTICS_KEY, stats);
      print('📊 [STATS] تم تحديث الإحصائيات');
    } catch (e) {
      print('⚠️ [STATS] خطأ في تحديث الإحصائيات: $e');
    }
  }

  Future<void> _cleanupOldData() async {
    try {
      final now = DateTime.now();
      final cutoffDate = now.subtract(const Duration(days: 30));

      final media = getMedia();
      final recentMedia = media.where((item) {
        try {
          final dateString =
              item['created_at'] ?? item['updated_at'] ?? item['date'] ?? '';
          if (dateString.isEmpty) return true;

          final date = DateTime.tryParse(dateString);
          return date == null || date.isAfter(cutoffDate);
        } catch (e) {
          return true;
        }
      }).toList();

      if (recentMedia.length < media.length) {
        final storeId = _getActiveStoreId();
        if (storeId != null) {
          await _storage.write(_kMedia(storeId), recentMedia);
        }
        print(
          '🧹 [CLEANUP] تم تنظيف الوسائط القديمة: ${media.length - recentMedia.length} عنصر',
        );
      }

      final products = getProducts();
      final activeProducts = products.where((product) {
        try {
          final status = product['status']?.toString() ?? '';
          return status == 'active' || status == 'published';
        } catch (e) {
          return true;
        }
      }).toList();

      if (activeProducts.length < products.length) {
        final storeId = _getActiveStoreId();
        if (storeId != null) {
          await _storage.write(_kProducts(storeId), activeProducts);
        }
        print(
          '🧹 [CLEANUP] تم تنظيف المنتجات غير النشطة: ${products.length - activeProducts.length} منتج',
        );
      }

      print('✅ [CLEANUP] اكتمل تنظيف البيانات القديمة');
    } catch (e) {
      print('⚠️ [CLEANUP] خطأ في تنظيف البيانات القديمة: $e');
    }
  }

  List<dynamic> getStores() => _storage.read(_STORES_KEY) ?? [];

  List<dynamic> getCities() => _storage.read(_CITIES_KEY) ?? [];

  List<dynamic> getDistricts() => _storage.read(_DISTRICTS_KEY) ?? [];

  List<dynamic> getCurrencies() => _storage.read(_CURRENCIES_KEY) ?? [];

  List<dynamic> getSections() {
    final storeId = _getActiveStoreId();
    if (storeId == null) return [];
    return _storage.read(_kSections(storeId)) ?? [];
  }

  List<dynamic> getAttributes() => _storage.read(_ATTRIBUTES_KEY) ?? [];

  List<dynamic> getCategories() => _storage.read(_CATEGORIES_KEY) ?? [];

  List<dynamic> getMedia() {
    final storeId = _getActiveStoreId();
    if (storeId == null) return [];
    return _storage.read(_kMedia(storeId)) ?? [];
  }

  List<dynamic> getProducts() {
    final storeId = _getActiveStoreId();
    if (storeId == null) return [];
    return _storage.read(_kProducts(storeId)) ?? [];
  }

  Map<String, dynamic> getSettings() => _storage.read(_SETTINGS_KEY) ?? {};

  Map<String, dynamic> getUserData() => _storage.read(_USER_DATA_KEY) ?? {};

  Map<String, dynamic> getAppConfig() => _storage.read(_APP_CONFIG_KEY) ?? {};

  List<Map<String, dynamic>> getEnhancedSections() {
    final storeId = _getActiveStoreId();
    if (storeId == null) return [];

    final sections =
        _storage.read<List<dynamic>>(_kEnhancedSections(storeId)) ?? [];
    return sections.map((s) => Map<String, dynamic>.from(s)).toList();
  }

  List<ProductAttribute> getAttributesForVariations() {
    try {
      final cachedAttributes =
          _storage.read<List<dynamic>>(_ATTRIBUTES_VARIATIONS_KEY) ?? [];
      if (cachedAttributes.isEmpty) return [];

      return cachedAttributes.map((attr) {
        return ProductAttribute.fromApiJson(Map<String, dynamic>.from(attr));
      }).toList();
    } catch (e) {
      print('⚠️ [DATA] خطأ في تحويل السمات: $e');
      return [];
    }
  }

  List<ProductAttribute> getAttributesByType(String type) {
    final allAttributes = getAttributesForVariations();
    return allAttributes.where((attr) => attr.type == type).toList();
  }

  Map<String, dynamic>? getStoreById(dynamic id) {
    try {
      final stores = getStores();
      for (var store in stores) {
        if (store['id'].toString() == id.toString()) {
          return Map<String, dynamic>.from(store);
        }
      }
    } catch (e) {
      print('⚠️ [DATA] خطأ في البحث عن المتجر: $e');
    }
    return null;
  }

  String _getStoreName(dynamic storeId) {
    final store = getStoreById(storeId);
    return store?['name']?.toString() ?? 'غير معروف';
  }

  int _countProductsInSection(dynamic sectionId, int storeId) {
    try {
      final products = _storage.read<List<dynamic>>(_kProducts(storeId)) ?? [];
      return products.where((product) {
        final productSectionId = product['section_id']?.toString();
        return productSectionId == sectionId.toString();
      }).length;
    } catch (e) {
      return 0;
    }
  }

  Map<String, dynamic>? getCityById(dynamic id) {
    try {
      final cities = getCities();
      for (var city in cities) {
        if (city['id'].toString() == id.toString()) {
          return Map<String, dynamic>.from(city);
        }
      }
    } catch (e) {
      print('⚠️ [DATA] خطأ في البحث عن المدينة: $e');
    }
    return null;
  }

  Map<String, dynamic>? getDistrictById(dynamic id) {
    try {
      final districts = getDistricts();
      for (var district in districts) {
        if (district['id'].toString() == id.toString()) {
          return Map<String, dynamic>.from(district);
        }
      }
    } catch (e) {
      print('⚠️ [DATA] خطأ في البحث عن المنطقة: $e');
    }
    return null;
  }

  Map<String, dynamic>? getSectionById(dynamic id) {
    try {
      final sections = getSections();
      for (var section in sections) {
        if (section['id'].toString() == id.toString()) {
          return Map<String, dynamic>.from(section);
        }
      }
    } catch (e) {
      print('⚠️ [DATA] خطأ في البحث عن القسم: $e');
    }
    return null;
  }

  Map<String, dynamic>? getProductById(dynamic id) {
    try {
      final products = getProducts();
      for (var product in products) {
        if (product['id'].toString() == id.toString()) {
          return Map<String, dynamic>.from(product);
        }
      }
    } catch (e) {
      print('⚠️ [DATA] خطأ في البحث عن المنتج: $e');
    }
    return null;
  }

  Future<void> refreshCities() async => await _loadCities();

  Future<void> refreshDistricts() async => await _loadDistricts();

  Future<void> refreshCurrencies() async => await _loadCurrencies();

  Future<void> refreshSections() async => await _loadSections();

  Future<void> refreshAttributes() async => await _loadAttributes();

  Future<void> refreshCategories() async => await _loadCategories();

  Future<void> refreshMedia() async => await _loadMedia();

  Future<void> refreshAllData() async =>
      await initializeAppData(forceRefresh: true);

  Future<void> saveUserData(Map<String, dynamic> userData) async {
    try {
      await _storage.write(_USER_DATA_KEY, userData);
      print('✅ [DATA] تم حفظ بيانات المستخدم');
    } catch (e) {
      print('❌ [DATA] خطأ في حفظ بيانات المستخدم: $e');
      throw e;
    }
  }

  Future<void> updateUserData(Map<String, dynamic> updates) async {
    try {
      final currentData = getUserData();
      final newData = {...currentData, ...updates};
      await saveUserData(newData);
      print('✅ [DATA] تم تحديث بيانات المستخدم');
    } catch (e) {
      print('❌ [DATA] خطأ في تحديث بيانات المستخدم: $e');
      throw e;
    }
  }

  Future<void> clearUserData() async {
    try {
      await _storage.remove(_USER_DATA_KEY);
      print('✅ [DATA] تم مسح بيانات المستخدم');
    } catch (e) {
      print('❌ [DATA] خطأ في مسح بيانات المستخدم: $e');
      throw e;
    }
  }

  Future<void> saveAppConfig(Map<String, dynamic> config) async {
    try {
      await _storage.write(_APP_CONFIG_KEY, config);
      print('✅ [DATA] تم حفظ إعدادات التطبيق');
    } catch (e) {
      print('❌ [DATA] خطأ في حفظ إعدادات التطبيق: $e');
      throw e;
    }
  }

  Future<void> addStore(Map<String, dynamic> store) async {
    try {
      final stores = getStores();
      stores.add(store);
      await _storage.write(_STORES_KEY, stores);
      print('✅ [DATA] تم إضافة متجر جديد');
    } catch (e) {
      print('❌ [DATA] خطأ في إضافة متجر: $e');
      throw e;
    }
  }

  Future<void> updateStore(
    dynamic id,
    Map<String, dynamic> updatedStore,
  ) async {
    try {
      final stores = getStores();
      final index = stores.indexWhere(
        (store) => store['id'].toString() == id.toString(),
      );
      if (index != -1) {
        stores[index] = {...stores[index], ...updatedStore};
        await _storage.write(_STORES_KEY, stores);
        print('✅ [DATA] تم تحديث المتجر: $id');
      }
    } catch (e) {
      print('❌ [DATA] خطأ في تحديث المتجر: $e');
      throw e;
    }
  }

  Future<void> deleteStore(dynamic id) async {
    try {
      final stores = getStores();
      stores.removeWhere((store) => store['id'].toString() == id.toString());
      await _storage.write(_STORES_KEY, stores);
      print('✅ [DATA] تم حذف المتجر: $id');
    } catch (e) {
      print('❌ [DATA] خطأ في حذف المتجر: $e');
      throw e;
    }
  }

  Future<void> saveVariationsData(Map<String, dynamic> variationsData) async {
    try {
      await _storage.write(_VARIATIONS_DATA_KEY, variationsData);
      print('✅ [DATA] تم حفظ بيانات الاختلافات');
    } catch (e) {
      print('❌ [DATA] خطأ في حفظ بيانات الاختلافات: $e');
      throw e;
    }
  }

  Map<String, dynamic> getVariationsData() {
    return _storage.read(_VARIATIONS_DATA_KEY) ?? {};
  }

  Future<void> saveProductDraft(Map<String, dynamic> productData) async {
    try {
      await _storage.write(_PRODUCT_DRAFT_KEY, {
        ...productData,
        'saved_at': DateTime.now().toIso8601String(),
        'version': '1.0',
      });
      print('✅ [DATA] تم حفظ مسودة المنتج');
    } catch (e) {
      print('❌ [DATA] خطأ في حفظ مسودة المنتج: $e');
      throw e;
    }
  }

  Map<String, dynamic> getProductDraft() {
    return _storage.read(_PRODUCT_DRAFT_KEY) ?? {};
  }

  Future<void> clearProductDraft() async {
    try {
      await _storage.remove(_PRODUCT_DRAFT_KEY);
      print('✅ [DATA] تم مسح مسودة المنتج');
    } catch (e) {
      print('❌ [DATA] خطأ في مسح مسودة المنتج: $e');
      throw e;
    }
  }

  Future<void> addToSyncQueue(String type, Map<String, dynamic> data) async {
    try {
      final queue = _storage.read<List<dynamic>>(_SYNC_QUEUE_KEY) ?? [];
      queue.add({
        'type': type,
        'data': data,
        'created_at': DateTime.now().toIso8601String(),
        'attempts': 0,
      });

      await _storage.write(_SYNC_QUEUE_KEY, queue);
      print('📝 [SYNC] تم إضافة مهمة للمزامنة: $type');
    } catch (e) {
      print('❌ [SYNC] خطأ في إضافة مهمة للمزامنة: $e');
      throw e;
    }
  }

  Future<void> clearAllData() async {
    try {
      await _storage.erase();
      _isDataLoaded.value = false;
      print('🗑️ [STORAGE] تم مسح جميع بيانات التطبيق من التخزين');
    } catch (e) {
      print('❌ [STORAGE] خطأ في مسح البيانات: $e');
      throw e;
    }
  }

  bool isDataStale({int maxAgeHours = 24}) {
    try {
      final lastUpdate = _storage.read<String>(_LAST_UPDATE_KEY);
      if (lastUpdate == null) return true;

      final lastUpdateTime = DateTime.parse(lastUpdate);
      final now = DateTime.now();
      final difference = now.difference(lastUpdateTime);

      return difference.inHours > maxAgeHours;
    } catch (e) {
      print('⚠️ [DATA] خطأ في التحقق من عمر البيانات: $e');
      return true;
    }
  }

  Future<Map<String, dynamic>> getStorageInfo() async {
    try {
      final keys = _storage.getKeys();
      final info = <String, dynamic>{
        'total_keys': keys.length,
        'keys': keys.toList(),
        'details': {},
      };

      int estimatedSize = 0;
      for (var key in keys) {
        final value = _storage.read(key);
        if (value != null) {
          final jsonString = jsonEncode(value);
          final keySize = jsonString.length * 2;
          estimatedSize += keySize;

          info['details'][key] = {
            'type': value.runtimeType.toString(),
            'size_bytes': keySize,
            'size_kb': (keySize / 1024).toStringAsFixed(2),
          };
        }
      }

      info['estimated_size_bytes'] = estimatedSize;
      info['estimated_size_kb'] = (estimatedSize / 1024).toStringAsFixed(2);
      info['estimated_size_mb'] = (estimatedSize / (1024 * 1024))
          .toStringAsFixed(2);

      return info;
    } catch (e) {
      print('⚠️ [DATA] خطأ في الحصول على معلومات التخزين: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> getStatistics() async {
    try {
      final now = DateTime.now();
      final storageInfo = await getStorageInfo();

      return {
        'general': {
          'stores_count': getStores().length,
          'cities_count': getCities().length,
          'districts_count': getDistricts().length,
          'currencies_count': getCurrencies().length,
          'sections_count': getSections().length,
          'attributes_count': getAttributes().length,
          'categories_count': getCategories().length,
          'products_count': getProducts().length,
          'media_count': getMedia().length,
          'is_online': _isOnline.value,
          'is_data_loaded': _isDataLoaded.value,
          'last_update': _storage.read<String>(_LAST_UPDATE_KEY),
          'is_data_stale': isDataStale(),
        },
        'storage': storageInfo,
        'user': {
          'is_logged_in': _myAppController.isLoggedIn.value,
          'user_data_exists': getUserData().isNotEmpty,
        },
        'sync': {
          'pending_tasks':
              (_storage.read<List<dynamic>>(_SYNC_QUEUE_KEY) ?? []).length,
          'has_offline_data': _hasOfflineData(),
        },
        'timestamp': now.toIso8601String(),
        'app_version': '1.0.0',
      };
    } catch (e) {
      print('⚠️ [DATA] خطأ في الحصول على الإحصائيات: $e');
      return {'error': e.toString()};
    }
  }

  Future<Map<String, dynamic>> exportData() async {
    try {
      final stats = await getStatistics();

      return {
        'metadata': {
          'export_date': DateTime.now().toIso8601String(),
          'app_version': '1.0.0',
          'export_format': 'v1',
          'statistics': stats,
        },
        'data': {
          'stores': getStores(),
          'cities': getCities(),
          'districts': getDistricts(),
          'currencies': getCurrencies(),
          'sections': getSections(),
          'attributes': getAttributes(),
          'categories': getCategories(),
          'products': getProducts(),
          'media': getMedia(),
          'settings': getSettings(),
          'user_data': getUserData(),
          'app_config': getAppConfig(),
          'variations_data': getVariationsData(),
          'product_draft': getProductDraft(),
          'sync_queue': _storage.read(_SYNC_QUEUE_KEY) ?? [],
        },
      };
    } catch (e) {
      print('❌ [DATA] خطأ في تصدير البيانات: $e');
      return {'error': e.toString()};
    }
  }

  Future<bool> importData(Map<String, dynamic> data) async {
    try {
      if (data['metadata'] == null || data['data'] == null) {
        throw Exception('بيانات غير صالحة');
      }

      final metadata = Map<String, dynamic>.from(data['metadata']);
      final importData = Map<String, dynamic>.from(data['data']);

      print('📥 [IMPORT] استيراد بيانات من: ${metadata['export_date']}');

      if (importData['stores'] != null)
        await _storage.write(_STORES_KEY, importData['stores']);
      if (importData['cities'] != null)
        await _storage.write(_CITIES_KEY, importData['cities']);
      if (importData['districts'] != null)
        await _storage.write(_DISTRICTS_KEY, importData['districts']);
      if (importData['currencies'] != null)
        await _storage.write(_CURRENCIES_KEY, importData['currencies']);
      final storeId = _getActiveStoreId();
      if (importData['sections'] != null) {
        if (storeId != null) {
          await _storage.write(_kSections(storeId), importData['sections']);
        } else {
          await _storage.write(_SECTIONS_KEY, importData['sections']);
        }
      }
      if (importData['attributes'] != null)
        await _storage.write(_ATTRIBUTES_KEY, importData['attributes']);
      if (importData['categories'] != null)
        await _storage.write(_CATEGORIES_KEY, importData['categories']);
      if (importData['products'] != null) {
        if (storeId != null) {
          await _storage.write(_kProducts(storeId), importData['products']);
        } else {
          await _storage.write(_PRODUCTS_KEY, importData['products']);
        }
      }
      if (importData['media'] != null) {
        if (storeId != null) {
          await _storage.write(_kMedia(storeId), importData['media']);
        } else {
          await _storage.write(_MEDIA_KEY, importData['media']);
        }
      }
      if (importData['settings'] != null)
        await _storage.write(_SETTINGS_KEY, importData['settings']);
      if (importData['user_data'] != null)
        await _storage.write(_USER_DATA_KEY, importData['user_data']);
      if (importData['app_config'] != null)
        await _storage.write(_APP_CONFIG_KEY, importData['app_config']);
      if (importData['variations_data'] != null)
        await _storage.write(
          _VARIATIONS_DATA_KEY,
          importData['variations_data'],
        );
      if (importData['product_draft'] != null)
        await _storage.write(_PRODUCT_DRAFT_KEY, importData['product_draft']);
      if (importData['sync_queue'] != null)
        await _storage.write(_SYNC_QUEUE_KEY, importData['sync_queue']);

      await saveAttributesForVariations(getAttributes());

      await _storage.write(_LAST_UPDATE_KEY, DateTime.now().toIso8601String());

      _isDataLoaded.value = true;

      print('✅ [DATA] تم استيراد البيانات بنجاح');
      return true;
    } catch (e) {
      print('❌ [DATA] خطأ في استيراد البيانات: $e');
      return false;
    }
  }

  Future<void> backupData() async {
    try {
      final exportedData = await exportData();
      final backupKey = 'backup_${DateTime.now().millisecondsSinceEpoch}';
      await _storage.write(backupKey, exportedData);

      print('💾 [BACKUP] تم إنشاء نسخة احتياطية: $backupKey');
    } catch (e) {
      print('❌ [BACKUP] خطأ في إنشاء نسخة احتياطية: $e');
    }
  }

  Future<bool> restoreFromBackup(String backupKey) async {
    try {
      final backupData = _storage.read(backupKey);
      if (backupData == null) {
        throw Exception('النسخة الاحتياطية غير موجودة');
      }

      return await importData(Map<String, dynamic>.from(backupData));
    } catch (e) {
      print('❌ [BACKUP] خطأ في استعادة النسخة الاحتياطية: $e');
      return false;
    }
  }

  List<String> getAvailableBackups() {
    return _storage
        .getKeys()
        .where((key) => key.startsWith('backup_'))
        .toList();
  }

  Future<void> clearOldBackups({int keepLast = 5}) async {
    try {
      final backups = getAvailableBackups();
      if (backups.length <= keepLast) return;

      backups.sort();

      for (int i = 0; i < backups.length - keepLast; i++) {
        await _storage.remove(backups[i]);
        print('🗑️ [BACKUP] تم حذف النسخة الاحتياطية: ${backups[i]}');
      }

      print('✅ [BACKUP] تم تنظيف النسخ الاحتياطية القديمة');
    } catch (e) {
      print('⚠️ [BACKUP] خطأ في تنظيف النسخ الاحتياطية: $e');
    }
  }

  @override
  void onClose() {
    print('🔚 [DATA SERVICE] إغلاق خدمة البيانات');
    _updateStatistics().catchError((e) {
      print('⚠️ [DATA] خطأ في حفظ الإحصائيات النهائية: $e');
    });
    super.onClose();
  }

  void printDebugInfo() {
    print('''
📊 [DATA DEBUG INFO]:
   حالة التحميل: ${isInitializing ? 'قيد التحميل' : 'جاهز'}
   التقدم: ${(progress * 100).toStringAsFixed(1)}%
   الخطوة الحالية: $currentStep
   اتصال بالإنترنت: ${isOnline ? 'نعم' : 'لا'}
   بيانات محملة: ${isDataLoaded ? 'نعم' : 'لا'}
   عدد المتاجر: ${getStores().length}
   عدد المدن: ${getCities().length}
   عدد الأقسام: ${getSections().length}
   عدد الفئات: ${getCategories().length}
   عدد المنتجات: ${getProducts().length}
   عدد الوسائط: ${getMedia().length}
''');
  }

  Future<void> refreshStores() async {
    try {
      if (!_isOnline.value) {
        print('⚠️ [STORES] لا يمكن التحديث (غير متصل)');
        return;
      }

      final response = await ApiHelper.get(
        path: '/merchants/stores',
        queryParameters: {'orderDir': 'asc'},
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final stores = response['data'] ?? [];
        await _storage.write(_STORES_KEY, stores);
        print('✅ [STORES] تم تحديث المتاجر: ${stores.length} متجر');
      }
    } catch (e) {
      print('⚠️ [STORES] فشل في تحديث المتاجر: $e');
    }
  }

  Stream<bool> get isInitializingStream => _isInitializing.stream;

  Stream<String> get currentStepStream => _currentStep.stream;

  Stream<double> get progressStream => _progress.stream;
}