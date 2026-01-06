
import '../../../../general_index.dart';

class RelatedProductsController extends GetxController {
  final DataInitializerService dataService = Get.find<DataInitializerService>();

  final RxList<Product> _allProducts = <Product>[].obs;
  final RxList<Product> _selectedProducts = <Product>[].obs;
  /// Holds selected cross-sell product ids (from API) so we can apply them
  /// after we load products (cache or API).
  final RxList<int> _selectedIds = <int>[].obs;
  final RxList<ProductDiscount> _discounts = <ProductDiscount>[].obs;
  final RxString _searchQuery = ''.obs;
  final RxDouble _originalPrice = 0.0.obs;
  final RxDouble _discountedPrice = 0.0.obs;
  final RxString _discountNote = ''.obs;
  final Rx<DateTime> _discountDate = DateTime.now().obs;

  List<Product> get allProducts => _allProducts;

  List<Product> get selectedProducts => _selectedProducts;

  List<ProductDiscount> get discounts => _discounts;

  String get searchQuery => _searchQuery.value;

  double get originalPrice => _originalPrice.value;

  double get discountedPrice => _discountedPrice.value;

  String get discountNote => _discountNote.value;

  DateTime get discountDate => _discountDate.value;

  int get selectedProductsCount => _selectedProducts.length;

  bool get hasSelectedProducts => _selectedProducts.isNotEmpty;

  bool get hasDiscount =>
      _discountedPrice.value > 0 &&
      _discountedPrice.value < _originalPrice.value;

  int get discountCount => _discounts.length;

  late TextEditingController dateController;
  late TextEditingController searchController;

  final RxBool _isSearching = false.obs;

  bool get isSearching => _isSearching.value;

  @override
  void onInit() {
    super.onInit();
    initializeControllers();
    // Try to load cached products first. If cache is empty we will fetch
    // from API on-demand (especially in edit flows).
    loadProductsFromCache();
  }

  /// Reset all related-products selections and discount info.
  /// This is important when user navigates from Edit -> Add to avoid
  /// leaking the previous product's cross-sells into the new product flow.
  void resetAll() {
    _selectedProducts.clear();
    _selectedIds.clear();
    _discounts.clear();
    _searchQuery.value = '';
    _originalPrice.value = 0.0;
    _discountedPrice.value = 0.0;
    _discountNote.value = '';
    _discountDate.value = DateTime.now();
    try {
      searchController.clear();
      dateController.text = _formatDateTime(DateTime.now());
    } catch (_) {}
    update(['products', 'search', 'discount']);
  }

  void initializeControllers() {
    dateController = TextEditingController(
      text: _formatDateTime(DateTime.now()),
    );
    searchController = TextEditingController();
    searchController.addListener(() {
      _searchQuery.value = searchController.text;
      _isSearching.value = searchController.text.isNotEmpty;
      update(['products', 'search']);
    });
  }

  String _formatDateTime(DateTime date) {
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    final hour = date.hour;
    final period = hour < 12 ? 'ص' : 'م';
    final displayHour = hour <= 12 ? hour : hour - 12;
    return '${months[date.month - 1]} ${date.day}, ${date.year} $displayHour:${date.minute.toString().padLeft(2, '0')} $period';
  }

  void loadProductsFromCache() {
    try {
      final productsData = dataService.getProducts();
      final loadedProducts = productsData
          .map((productData) => Product.fromJson(productData))
          .where((product) => product.id > 0)
          .toList();
      _allProducts.assignAll(loadedProducts);
      update(['products']);
    } catch (e) {
      _showErrorSnackbar('خطأ في تحميل المنتجات');
    }
  }

  /// Ensures the products list is available for selection.
  /// - Uses cached products if present.
  /// - Falls back to API if cache is empty.
  Future<void> ensureProductsLoaded() async {
    if (_allProducts.isNotEmpty) {
      _applySelectedIdsToProducts();
      return;
    }

    // Try cache again (in case it was refreshed elsewhere)
    loadProductsFromCache();
    if (_allProducts.isNotEmpty) {
      _applySelectedIdsToProducts();
      return;
    }

    await _loadProductsFromApi();
    _applySelectedIdsToProducts();
  }

  Future<void> _loadProductsFromApi() async {
    try {
      final response = await ApiHelper.get(
        path: '/merchants/products',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final raw = response['data'];
        final List<dynamic> list = raw is List ? raw : const [];
        final loadedProducts = list
            .whereType<Map>()
            .map((m) => Product.fromJson(Map<String, dynamic>.from(m)))
            .where((p) => p.id > 0)
            .toList();

        _allProducts.assignAll(loadedProducts);
        update(['products']);
      }
    } catch (e) {
      print('⚠️ [CROSS SELL] Error loading products from API: $e');
    }
  }

  /// Prefill cross-sells selection and discount fields from API product response.
  /// Expected keys: crossSells (List<int>) / cross_sells_price / cross_sells_due_date
  Future<void> loadFromProductApi(Map<String, dynamic> productData) async {
    try {
      final dynamic rawCrossSells =
          productData['crossSells'] ??
          productData['cross_sells'] ??
          productData['cross_sells_products'];

      final List<int> ids = <int>[];
      if (rawCrossSells is List) {
        for (final item in rawCrossSells) {
          if (item is int) {
            if (item > 0) ids.add(item);
          } else if (item is String) {
            final v = int.tryParse(item);
            if (v != null && v > 0) ids.add(v);
          } else if (item is Map) {
            final dynamic idVal = item['id'];
            final v = int.tryParse(idVal?.toString() ?? '');
            if (v != null && v > 0) ids.add(v);
          } else {
            final v = int.tryParse(item.toString());
            if (v != null && v > 0) ids.add(v);
          }
        }
      }


      _selectedIds.assignAll(ids);

      // Ensure products are available, then apply selected ids.
      await ensureProductsLoaded();

      // Prices
      _originalPrice.value = 0.0;
      calculateTotalPrice();
      final csPriceRaw = productData['cross_sells_price'] ?? productData['crossSells_price'];
      final csPrice = (csPriceRaw is num)
          ? csPriceRaw.toDouble()
          : double.tryParse(csPriceRaw?.toString() ?? '') ?? 0.0;
      if (csPrice > 0) {
        _discountedPrice.value = csPrice;
      }

      // Due date
      final dueRaw = (productData['cross_sells_due_date'] ?? productData['crossSells_due_date'])?.toString();
      if (dueRaw != null && dueRaw.trim().isNotEmpty) {
        final parsed = DateTime.tryParse(dueRaw);
        if (parsed != null) {
          setDiscountDate(parsed);
        }
      }

      update(['selected', 'summary', 'discount', 'products']);
    } catch (e) {
      print('❌ [CROSS SELL] Error loading from API: $e');
    }
  }

  void _applySelectedIdsToProducts() {
    if (_selectedIds.isEmpty) {
      _selectedProducts.clear();
      update(['selected', 'summary', 'products']);
      return;
    }

    _selectedProducts.clear();
    for (final id in _selectedIds) {
      final p = _allProducts.firstWhereOrNull((x) => x.id == id);
      if (p != null) _selectedProducts.add(p);
    }

    _calculateTotalPrice();
    update(['selected', 'summary', 'products']);
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
    _isSearching.value = query.isNotEmpty;
    update(['products', 'search']);
  }

  List<Product> get filteredProducts {
    if (_searchQuery.value.isEmpty) return _allProducts;
    final searchLower = _searchQuery.value.toLowerCase();
    return _allProducts.where((product) {
      final nameMatch = product.name.toLowerCase().contains(searchLower);
      final skuMatch =
          product.sku?.toLowerCase().contains(searchLower) ?? false;
      final sectionMatch =
          product.sectionName?.toLowerCase().contains(searchLower) ?? false;
      return nameMatch || skuMatch || sectionMatch;
    }).toList();
  }

  void toggleProductSelection(Product product) {
    if (isProductSelected(product)) {
      _selectedProducts.removeWhere((p) => p.id == product.id);
      _selectedIds.removeWhere((id) => id == product.id);
    } else {
      _selectedProducts.add(product);
      if (product.id > 0 && !_selectedIds.contains(product.id)) {
        _selectedIds.add(product.id);
      }
    }
    _calculateTotalPrice();
    update(['selected', 'summary', 'products']);
  }

  bool isProductSelected(Product product) {
    return _selectedProducts.any((p) => p.id == product.id);
  }

  void removeSelectedProduct(Product product) {
    _selectedProducts.removeWhere((p) => p.id == product.id);
    _selectedIds.removeWhere((id) => id == product.id);
    _calculateTotalPrice();
    update(['selected', 'summary', 'products']);
  }

  void clearAllSelections() {
    _selectedProducts.clear();
    _selectedIds.clear();
    _originalPrice.value = 0.0;
    _discountedPrice.value = 0.0;
    _discountNote.value = '';
    dateController.text = _formatDateTime(DateTime.now());
    _discountDate.value = DateTime.now();
    update(['selected', 'summary', 'discounts', 'products']);
  }

  void calculateTotalPrice() {
    double total = 0.0;
    for (final product in _selectedProducts) {
      try {
        final priceStr = product.price ?? '0';
        final cleanPrice = priceStr.replaceAll(RegExp(r'[^\d.]'), '');
        final price = double.tryParse(cleanPrice) ?? 0.0;
        total += price;
      } catch (e) {
        print('⚠️ خطأ في حساب سعر المنتج: $e');
      }
    }
    _originalPrice.value = total;
    if (_discountedPrice.value > _originalPrice.value) {
      _discountedPrice.value = _originalPrice.value;
    }
    update(['summary']);
  }

  void _calculateTotalPrice() {
    calculateTotalPrice();
  }

  void setDiscountDate(DateTime date) {
    _discountDate.value = date;
    dateController.text = _formatDateTime(date);
    update(['discount']);
  }

  void setDiscountedPrice(double price) {
    _discountedPrice.value = price;
    update(['discount']);
  }

  void setDiscountNote(String note) {
    _discountNote.value = note;
  }

  bool _validateDiscount() {
    if (_selectedProducts.isEmpty) {
      _showErrorSnackbar('يرجى اختيار منتجات أولاً');
      return false;
    }
    if (_discountedPrice.value <= 0) {
      _showErrorSnackbar('يرجى إدخال سعر مخفض صحيح');
      return false;
    }
    if (_discountedPrice.value >= _originalPrice.value) {
      _showErrorSnackbar('السعر المخفض يجب أن يكون أقل من السعر الأصلي');
      return false;
    }
    return true;
  }

  void addDiscount() {
    if (!_validateDiscount()) return;

    final newDiscount = ProductDiscount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      originalPrice: _originalPrice.value,
      discountedPrice: _discountedPrice.value,
      note: _discountNote.value,
      date: _discountDate.value,
      productCount: _selectedProducts.length,
      products: _selectedProducts.toList(),
    );

    _discounts.add(newDiscount);
    clearDiscountFields();
    _showSuccessSnackbar('تم إضافة التخفيض بنجاح');
    update(['discounts', 'summary']);
  }

  void removeDiscount(ProductDiscount discount) {
    _discounts.removeWhere((d) => d.id == discount.id);
    _showSuccessSnackbar('تم حذف التخفيض بنجاح');
    update(['discounts', 'summary']);
  }

  void clearDiscountFields() {
    _discountedPrice.value = 0.0;
    _discountNote.value = '';
    update(['discount']);
  }

  void linkToProductCentral() {
    try {
      if (Get.isRegistered<ProductCentralController>()) {
        final productCentralController = Get.find<ProductCentralController>();
        productCentralController.updateRelatedProductsFromRelatedController();
        _showSuccessSnackbar('تم الربط بنجاح');
      }
    } catch (e) {
      _showErrorSnackbar('خطأ في الربط');
    }
  }

  Map<String, dynamic> getCrossSellData() {
    try {
      print('🔗 [CROSS SELL] جلب بيانات المنتجات المختارة للتسويق المتقاطع');
      print(
        '🔗 [CROSS SELL] عدد المنتجات المختارة: ${_selectedProducts.length}',
      );

      // Prefer selected products (when list is loaded), otherwise fallback to selected ids.
      final List<int> productIds = _selectedProducts.isNotEmpty
          ? _selectedProducts
              .where((product) => product.id > 0)
              .map((product) => product.id)
              .toList()
          : _selectedIds.where((id) => id > 0).toList();

      double crossSellPrice = _discountedPrice.value > 0
          ? _discountedPrice.value
          : _originalPrice.value;

      final DateTime dueDate = _discountDate.value;
      final String formattedDueDate =
          '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}';

      final data = {
        'crossSells': productIds,
        'cross_sells_price': crossSellPrice,
        'cross_sells_due_date': formattedDueDate,
      };

      print('📊 [CROSS SELL] بيانات التسويق المتقاطع:');
      print('   - Product IDs: $productIds');
      print('   - Price: $crossSellPrice');
      print('   - Due Date: $formattedDueDate');

      return data;
    } catch (e) {
      print('⚠️ [CROSS SELL] خطأ في جلب بيانات التسويق المتقاطع: $e');
      return {
        'crossSells': [],
        'cross_sells_price': 0.0,
        'cross_sells_due_date': '',
      };
    }
  }

  void refreshProducts() {
    update(['products', 'selected', 'summary']);
  }

  void clearSearch() {
    searchController.clear();
    _searchQuery.value = '';
    _isSearching.value = false;
    update(['products', 'search']);
  }

  void _showErrorSnackbar(String message) {
    Get.snackbar(
      'خطأ',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 2),
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

  @override
  void onClose() {
    dateController.dispose();
    searchController.dispose();
    super.onClose();
  }
}