import '../../../general_index.dart';

class ProductService extends GetxController {
  static ProductService get to => Get.find();
  final GetStorage _storage = GetStorage();

  static const String _productsCacheKey = 'cached_products';
  static const String _productsTimestampKey = 'products_timestamp';

  static const Duration _cacheDuration = Duration(hours: 1);
  final RxBool _productsUpdated = false.obs;

  bool get productsUpdated => _productsUpdated.value;
  Map<String, dynamic> productData = {};

  void notifyProductsUpdated() {
    print('📢 [PRODUCT SERVICE] Notifying products update');
    _productsUpdated.value = !_productsUpdated.value;
  }

  Future<Product?> createProduct(Map<String, dynamic> productData) async {
    try {
      final response = await ApiHelper.post(
        path: '/merchants/products',
        body: productData,
      );

      if (response != null && response['status'] == true) {
        final product = Product.fromJson(response['data']);

        _addProductToCache(product);

        notifyProductsUpdated();

        return product;
      }
      return null;
    } catch (e) {
      print('❌ [PRODUCT SERVICE] Error creating product: $e');
      return null;
    }
  }

  Future<List<Product>> fetchProducts({bool forceRefresh = false}) async {
    try {
      if (!forceRefresh) {
        final cachedProducts = _getCachedProducts();
        if (cachedProducts.isNotEmpty && !_isCacheExpired()) {
          print('📂 [PRODUCT SERVICE] Using cached products');
          return cachedProducts;
        }
      }

      print('📡 [PRODUCT SERVICE] Fetching products from API');

      final response = await ApiHelper.get(
        path: '/merchants/products',
        withLoading: false,
      );

      if (response != null && response['status'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        final products = data
            .map((product) => Product.fromJson(product))
            .toList();

        _cacheProducts(products);

        return products;
      }

      return [];
    } catch (e) {
      print('❌ [PRODUCT SERVICE] Error fetching products: $e');

      final cachedProducts = _getCachedProducts();
      if (cachedProducts.isNotEmpty) {
        print('📂 [PRODUCT SERVICE] Using cached products as fallback');
        return cachedProducts;
      }

      rethrow;
    }
  }

  fetchProductById({required int productId, bool withLoading = false}) async {
    try {
      final response = await ApiHelper.get(
        path: '/merchants/products/$productId',
        withLoading: withLoading,
      );

      if (response != null && response['status'] == true) {
        productData = response['data'];
        update();
      }
      return null;
    } catch (e) {
      print('❌ [PRODUCT SERVICE] Error fetching product by ID: $e');
      return null;
    }
  }

  fetchProductBySlug({required String slug, bool withLoading = false}) async {
    try {
      final response = await ApiHelper.get(
        path: '/products/search/$slug',
        withLoading: withLoading,
      );

      if (response != null && response['status'] == true) {
        final Map<String, dynamic> p =
            (response['product'] is Map)
                ? Map<String, dynamic>.from(response['product'])
                : (response['data'] is Map)
                    ? Map<String, dynamic>.from(response['data'])
                    : <String, dynamic>{};

        if (response['store'] is Map) {
          p['store'] = Map<String, dynamic>.from(response['store']);
        }
        if (response['attributes'] is List) {
          p['attributes'] = List<dynamic>.from(response['attributes']);
        }

        productData = p;
        update();
      }
      return null;
    } catch (e) {
      print('❌ [PRODUCT SERVICE] Error fetching product by slug: $e');
      return null;
    }
  }

  @Deprecated('Use fetchProductBySlug')
  fetchProductBySlag({required String slag, bool withLoading = false}) async {
    return fetchProductBySlug(slug: slag, withLoading: withLoading);
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      final response = await ApiHelper.delete(
        path: '/merchants/products/$productId',
      );

      if (response != null && response['status'] == true) {
        _removeProductFromCache(productId);

        notifyProductsUpdated();

        return true;
      }
      return false;
    } catch (e) {
      print('❌ [PRODUCT SERVICE] Error deleting product: $e');
      return false;
    }
  }

  Future<Product?> testproduct(Map<String, dynamic> productData) async {
    try {
      final response = await ApiHelper.post(
        path: '/merchants/products',
        body: productData,
        withLoading: true,
      );
      print(response);
    } catch (e) {
      print('❌ [PRODUCT SERVICE] Error creating product: $e');
      return null;
    }
  }

  Future<Product?> updateProduct(
    String productId,
    Map<String, dynamic> productData,
  ) async {
    try {
      final response = await ApiHelper.post(
        path: '/merchants/products/$productId',
        body: productData,
      );

      if (response != null && response['status'] == true) {
        final product = Product.fromJson(response['data']);

        _updateProductInCache(product);

        notifyProductsUpdated();

        return product;
      }
      return null;
    } catch (e) {
      print('❌ [PRODUCT SERVICE] Error updating product: $e');
      return null;
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await ApiHelper.get(
        path: '/merchants/products/search',
        withLoading: false,
      );

      if (response != null && response['status'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        return data.map((product) => Product.fromJson(product)).toList();
      }
      return [];
    } catch (e) {
      print('❌ [PRODUCT SERVICE] Error searching products: $e');
      return [];
    }
  }

  List<Product> _getCachedProducts() {
    try {
      final cachedData = _storage.read(_productsCacheKey);
      if (cachedData != null) {
        final List<dynamic> data = json.decode(cachedData);
        return data.map((product) => Product.fromJson(product)).toList();
      }
    } catch (e) {
      print('⚠️ [PRODUCT SERVICE] Error reading cached products: $e');
    }
    return [];
  }

  void _cacheProducts(List<Product> products) {
    try {
      final productsJson = products.map((p) => p.toJson()).toList();
      _storage.write(_productsCacheKey, json.encode(productsJson));
      _storage.write(_productsTimestampKey, DateTime.now().toIso8601String());
      print('💾 [PRODUCT SERVICE] Products cached successfully');
    } catch (e) {
      print('⚠️ [PRODUCT SERVICE] Error caching products: $e');
    }
  }

  void _addProductToCache(Product product) {
    final cachedProducts = _getCachedProducts();
    cachedProducts.add(product);
    _cacheProducts(cachedProducts);
  }

  void _updateProductInCache(Product updatedProduct) {
    final cachedProducts = _getCachedProducts();
    final index = cachedProducts.indexWhere((p) => p.id == updatedProduct.id);

    if (index != -1) {
      cachedProducts[index] = updatedProduct;
      _cacheProducts(cachedProducts);
    }
  }

  void _removeProductFromCache(String productId) {
    final cachedProducts = _getCachedProducts();
    cachedProducts.removeWhere((p) => p.id == productId);
    _cacheProducts(cachedProducts);
  }

  bool _isCacheExpired() {
    final timestamp = _storage.read(_productsTimestampKey);
    if (timestamp == null) return true;

    try {
      final lastUpdate = DateTime.parse(timestamp);
      return DateTime.now().difference(lastUpdate) > _cacheDuration;
    } catch (e) {
      return true;
    }
  }

  void clearCache() {
    _storage.remove(_productsCacheKey);
    _storage.remove(_productsTimestampKey);
    print('🗑️ [PRODUCT SERVICE] Cache cleared');
  }

  @override
  void onClose() {
    clearCache();
    super.onClose();
  }
}