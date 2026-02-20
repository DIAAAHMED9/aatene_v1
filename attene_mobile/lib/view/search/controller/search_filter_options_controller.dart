import '../../../../general_index.dart';
import 'search_controller.dart';

class SearchFilterOptionsController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> sections = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> tags = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> cities = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> variationOptions = <Map<String, dynamic>>[].obs;

  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 300.0.obs;

  bool _loadedForProducts = false;
  bool _loadedForServices = false;
  bool _loadedForStores = false;
  bool _loadedForUsers = false;

  Future<void> ensureLoaded(SearchType type) async {
    if (_isLoaded(type)) return;
    await _load(type);
  }

  bool _isLoaded(SearchType type) {
    switch (type) {
      case SearchType.products:
        return _loadedForProducts;
      case SearchType.services:
        return _loadedForServices;
      case SearchType.stores:
        return _loadedForStores;
      case SearchType.users:
        return _loadedForUsers;
    }
  }

  void _markLoaded(SearchType type) {
    switch (type) {
      case SearchType.products:
        _loadedForProducts = true;
        break;
      case SearchType.services:
        _loadedForServices = true;
        break;
      case SearchType.stores:
        _loadedForStores = true;
        break;
      case SearchType.users:
        _loadedForUsers = true;
        break;
    }
  }

  String _path(SearchType type) {
    switch (type) {
      case SearchType.products:
        return '/products/search-page';
      case SearchType.services:
        return '/services/search-page';
      case SearchType.stores:
        return '/stores/search-page';
      case SearchType.users:
        return '/users/search-page';
    }
  }

  Future<void> _load(SearchType type) async {
    try {
      isLoading.value = true;
      error.value = '';

      categories.clear();
      sections.clear();
      tags.clear();
      cities.clear();
      variationOptions.clear();

      final res = await ApiHelper.get(path: _path(type), withLoading: false);

      if (res == null || res['status'] != true) {
        error.value = res?['message'] ?? 'فشل تحميل خيارات الفلاتر';
        return;
      }

      final root = (res['data'] is Map) ? (res['data'] as Map).cast<String, dynamic>() : res;

      categories.assignAll(_asListOfMap(root['categories'] ?? root['category'] ?? root['product_categories']));
      sections.assignAll(_asListOfMap(root['sections'] ?? root['sub_categories'] ?? root['product_sections']));
      tags.assignAll(_asListOfMap(root['tags'] ?? root['skills']));
      cities.assignAll(_asListOfMap(root['cities'] ?? root['locations']));

      final variations = root['variation_options'] ?? root['variations'] ?? root['options'] ?? root['sizes'] ?? root['colors'];
      variationOptions.assignAll(_asListOfMap(variations));

      final minP = root['min_price'] ?? root['price_min'] ?? root['minPrice'];
      final maxP = root['max_price'] ?? root['price_max'] ?? root['maxPrice'];
      if (minP != null) minPrice.value = double.tryParse(minP.toString()) ?? minPrice.value;
      if (maxP != null) maxPrice.value = double.tryParse(maxP.toString()) ?? maxPrice.value;

      _markLoaded(type);
    } catch (e) {
      error.value = 'خطأ أثناء تحميل خيارات الفلاتر';
      debugPrint('🔥 [SearchFilterOptions] $e');
    } finally {
      isLoading.value = false;
    }
  }

  List<Map<String, dynamic>> _asListOfMap(dynamic v) {
    if (v == null) return const [];
    if (v is List) {
      return v.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
    }
    if (v is Map) {
      final data = v['data'];
      if (data is List) {
        return data.whereType<Map>().map((e) => e.cast<String, dynamic>()).toList();
      }
    }
    return const [];
  }
}