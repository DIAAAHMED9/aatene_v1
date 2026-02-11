import '../../../../general_index.dart';

enum SearchType { products, services, stores, users }

class SearchController extends GetxController {
  final Rx<SearchType> selectedType = SearchType.products.obs;
  final RxString searchQuery = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxBool hasMore = true.obs;
  String errorMessage = '';

  final RxList<Map<String, dynamic>> products = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> services = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> stores = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> users = <Map<String, dynamic>>[].obs;

  final RxMap<String, dynamic> productFilters = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> serviceFilters = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> storeFilters = <String, dynamic>{}.obs;
  final RxMap<String, dynamic> userFilters = <String, dynamic>{}.obs;

  Timer? _debounce;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadInitialData();
    });
  }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }

  Future<void> loadInitialData() async {
    searchQuery.value = '';
    await resetAndSearch(force: true);
  }

  void changeSearchType(SearchType type) {
    if (selectedType.value == type) return;
    selectedType.value = type;
    if (searchQuery.value.isEmpty) {
      resetAndSearch(force: true);
    } else {
      resetAndSearch();
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query.trim();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      resetAndSearch();
    });
  }

  void clearResults() {
    products.clear();
    services.clear();
    stores.clear();
    users.clear();
    hasMore.value = true;
    currentPage.value = 1;
  }

  Future<void> resetAndSearch({bool force = false}) async {
    clearResults();
    await performSearch(force: force);
  }

  Future<void> performSearch({bool force = false}) async {
    if (!force && searchQuery.value.isEmpty) {
      print('⏸️ [Search] Query empty, skipping search');
      return;
    }

    try {
      isLoading.value = true;
      hasError.value = false;

      final basePath = _getSearchPath(selectedType.value);
      final params = <String, dynamic>{
        'page': currentPage.value,
        'per_page': 10,
        ..._getCurrentFilters(),
      };

      if (searchQuery.value.isNotEmpty) {
        params['search'] = searchQuery.value;
      }

      final queryString = params.entries
          .where((e) => e.value != null && e.value.toString().isNotEmpty)
          .map((e) => '${e.key}=${Uri.encodeComponent(e.value.toString())}')
          .join('&');

      final fullUrl = queryString.isEmpty ? basePath : '$basePath?$queryString';
      print('🌐 [Search] Request: $fullUrl');

      final res = await ApiHelper.get(
        path: fullUrl,
        withLoading: isLoading.value,
      );

      print('📦 [Search] Response: ${res?['status']}');

      if (res != null && res['status'] == true) {
        _handleSearchResponse(res);
      } else {
        hasError.value = true;
        errorMessage = res?['message'] ?? 'فشل في تحميل البيانات';
        print('❌ [Search] Error: $errorMessage');
      }
    } catch (e, stack) {
      hasError.value = true;
      errorMessage = 'خطأ في الشبكة: ${e.toString()}';
      print('🔥 [Search] Exception: $e\n$stack');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMore() async {
    if (!hasMore.value || isLoading.value) return;
    if (searchQuery.value.isEmpty && currentPage.value == 1) {
    }
    currentPage.value++;
    await performSearch(force: searchQuery.value.isNotEmpty);
  }

  void applyFilters(Map<String, dynamic> filters) {
    switch (selectedType.value) {
      case SearchType.products:
        productFilters.assignAll(filters);
        break;
      case SearchType.services:
        serviceFilters.assignAll(filters);
        break;
      case SearchType.stores:
        storeFilters.assignAll(filters);
        break;
      case SearchType.users:
        userFilters.assignAll(filters);
        break;
    }

    if (searchQuery.value.isNotEmpty) {
      resetAndSearch();
    } else {
      resetAndSearch(force: true);
    }
  }

  void clearFilters() {
    switch (selectedType.value) {
      case SearchType.products:
        productFilters.clear();
        break;
      case SearchType.services:
        serviceFilters.clear();
        break;
      case SearchType.stores:
        storeFilters.clear();
        break;
      case SearchType.users:
        userFilters.clear();
        break;
    }
    if (searchQuery.value.isNotEmpty) {
      resetAndSearch();
    } else {
      resetAndSearch(force: true);
    }
  }

  List<Map<String, dynamic>> get currentResults {
    switch (selectedType.value) {
      case SearchType.products:
        return products;
      case SearchType.services:
        return services;
      case SearchType.stores:
        return stores;
      case SearchType.users:
        return users;
    }
  }

  String _getSearchPath(SearchType type) {
    switch (type) {
      case SearchType.products:
        return '/products/search';
      case SearchType.services:
        return '/services/search';
      case SearchType.stores:
        return '/stores/search';
      case SearchType.users:
        return '/users/search';
    }
  }

  Map<String, dynamic> _getCurrentFilters() {
    switch (selectedType.value) {
      case SearchType.products:
        return productFilters;
      case SearchType.services:
        return serviceFilters;
      case SearchType.stores:
        return storeFilters;
      case SearchType.users:
        return userFilters;
    }
  }

  void _handleSearchResponse(Map<String, dynamic> response) {
    final String dataKey = _getDataKey(selectedType.value);
    final List<dynamic> items = response[dataKey] ?? [];
    final pagination = response['pagination'] ?? {};

    final current = pagination['current_page'] ?? 1;
    final last = pagination['last_page'] ?? 1;
    hasMore.value = current < last;

    switch (selectedType.value) {
      case SearchType.products:
        if (currentPage.value == 1) {
          products.assignAll(items.cast<Map<String, dynamic>>());
        } else {
          products.addAll(items.cast<Map<String, dynamic>>());
        }
        break;
      case SearchType.services:
        if (currentPage.value == 1) {
          services.assignAll(items.cast<Map<String, dynamic>>());
        } else {
          services.addAll(items.cast<Map<String, dynamic>>());
        }
        break;
      case SearchType.stores:
        if (currentPage.value == 1) {
          stores.assignAll(items.cast<Map<String, dynamic>>());
        } else {
          stores.addAll(items.cast<Map<String, dynamic>>());
        }
        break;
      case SearchType.users:
        if (currentPage.value == 1) {
          users.assignAll(items.cast<Map<String, dynamic>>());
        } else {
          users.addAll(items.cast<Map<String, dynamic>>());
        }
        break;
    }

    update();
  }

  String _getDataKey(SearchType type) {
    switch (type) {
      case SearchType.products:
        return 'products';
      case SearchType.services:
        return 'services';
      case SearchType.stores:
        return 'stores';
      case SearchType.users:
        return 'users';
    }
  }
}