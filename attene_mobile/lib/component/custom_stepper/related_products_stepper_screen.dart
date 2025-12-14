import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/view/related_products/related_products_model.dart';
import 'package:attene_mobile/models/product_model.dart';
import '../../controller/product_controller.dart';
import '../../view/Services/data_lnitializer_service.dart';

class RelatedProductsController extends GetxController {
  final DataInitializerService dataService = Get.find<DataInitializerService>();
  
  final RxList<Product> _allProducts = <Product>[].obs;
  final RxList<Product> _selectedProducts = <Product>[].obs;
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
  bool get hasDiscount => _discountedPrice.value > 0 && _discountedPrice.value < _originalPrice.value;
  int get discountCount => _discounts.length;
  
  late TextEditingController dateController;
  late TextEditingController searchController;
  
  @override
  void onInit() {
    super.onInit();
    initializeControllers();
    loadProducts();
  }
  
  void initializeControllers() {
    dateController = TextEditingController(text: _formatDateTime(DateTime.now()));
    searchController = TextEditingController();
    searchController.addListener(() {
      _searchQuery.value = searchController.text;
    });
  }
  
  String _formatDateTime(DateTime date) {
    final months = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'];
    final hour = date.hour;
    final period = hour < 12 ? 'ص' : 'م';
    final displayHour = hour <= 12 ? hour : hour - 12;
    return '${months[date.month - 1]} ${date.day}, ${date.year} $displayHour:${date.minute.toString().padLeft(2, '0')} $period';
  }
  
  void loadProducts() {
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
  
  void setSearchQuery(String query) {
    _searchQuery.value = query;
    update(['products']);
  }
  
  List<Product> get filteredProducts {
    if (_searchQuery.value.isEmpty) return _allProducts;
    final searchLower = _searchQuery.value.toLowerCase();
    return _allProducts.where((product) {
      final nameMatch = product.name.toLowerCase().contains(searchLower);
      final skuMatch = product.sku?.toLowerCase().contains(searchLower) ?? false;
      return nameMatch || skuMatch;
    }).toList();
  }
  
  void toggleProductSelection(Product product) {
    if (isProductSelected(product)) {
      _selectedProducts.removeWhere((p) => p.id == product.id);
    } else {
      _selectedProducts.add(product);
    }
    _calculateTotalPrice();
    update(['selected', 'summary']);
  }
  
  bool isProductSelected(Product product) {
    return _selectedProducts.any((p) => p.id == product.id);
  }
  
  void removeSelectedProduct(Product product) {
    _selectedProducts.removeWhere((p) => p.id == product.id);
    _calculateTotalPrice();
    update(['selected', 'summary']);
  }
  
  void clearAllSelections() {
    _selectedProducts.clear();
    _originalPrice.value = 0.0;
    _discountedPrice.value = 0.0;
    _discountNote.value = '';
    dateController.text = _formatDateTime(DateTime.now());
    _discountDate.value = DateTime.now();
    update(['selected', 'summary', 'discounts']);
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
      print('🔗 [CROSS SELL] عدد المنتجات المختارة: ${_selectedProducts.length}');
      
      final List<int> productIds = _selectedProducts
          .where((product) => product.id > 0)
          .map((product) => product.id)
          .toList();
      
      double crossSellPrice = _discountedPrice.value > 0
          ? _discountedPrice.value
          : _originalPrice.value;
      
      final DateTime dueDate = _discountDate.value;
      final String formattedDueDate = '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}';
      
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
  
  void _showErrorSnackbar(String message) {
    Get.snackbar('خطأ', message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
  }
  
  void _showSuccessSnackbar(String message) {
    Get.snackbar('نجاح', message,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2));
  }
  
  @override
  void onClose() {
    dateController.dispose();
    searchController.dispose();
    super.onClose();
  }
}