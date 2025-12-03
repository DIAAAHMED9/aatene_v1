import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/view/related_products/related_products_model.dart';
import 'package:attene_mobile/models/product_model.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/product_controller.dart';

class RelatedProductsController extends GetxController {
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> selectedProducts = <Product>[].obs;
  final RxList<ProductDiscount> discounts = <ProductDiscount>[].obs;
  final RxString searchQuery = ''.obs;

  final RxDouble originalPrice = 0.0.obs;
  final RxDouble discountedPrice = 0.0.obs;
  final RxString discountNote = ''.obs;
  final Rx<DateTime> discountDate = DateTime.now().obs;
  final TextEditingController dateController = TextEditingController();
  late ProductController productController;
  late Worker _productsWorker;

  @override
  void onInit() {
    super.onInit();
    _initializeDateController();
    
    // انتظر حتى يتم تهيئة ProductController
    if (Get.isRegistered<ProductController>()) {
      _setupProductController();
    } else {
      // إذا لم يتم تسجيله بعد، انتظر قليلاً
      Future.delayed(const Duration(milliseconds: 500), () {
        if (Get.isRegistered<ProductController>()) {
          _setupProductController();
        }
      });
    }
  }

  void _setupProductController() {
    productController = Get.find<ProductController>();
    
    // تحميل المنتجات أول مرة
    _loadProductsFromProductController();
    
    // الاستماع لتغيرات المنتجات في ProductController
    _productsWorker = ever(productController.productsRx, (List<Product> products) {
      print('🔄 [RELATED PRODUCTS] Products changed, reloading...');
      _loadProductsFromProductController();
    });
  }

  void _loadProductsFromProductController() {
    try {
      // جلب المنتجات الحقيقية من ProductController
      final realProducts = productController.allProducts;
      
      allProducts.assignAll(realProducts);
      
      print('✅ [RELATED PRODUCTS] Loaded ${realProducts.length} real products');
    } catch (e) {
      print('❌ [RELATED PRODUCTS] Error loading products: $e');
    }
  }

  void _initializeDateController() {
    dateController.text = _formatDateTime(DateTime.now());
  }

  String _formatDateTime(DateTime date) {
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    final hour = date.hour;
    final period = hour < 12 ? 'ص' : 'م';
    final displayHour = hour <= 12 ? hour : hour - 12;
    
    return '${months[date.month - 1]} ${date.day}, ${date.year} $displayHour:${date.minute.toString().padLeft(2, '0')} $period';
  }

  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) return allProducts;
    return allProducts.where((product) {
      return product.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
             (product.sku?.toLowerCase().contains(searchQuery.value.toLowerCase()) ?? false);
    }).toList();
  }

  void toggleProductSelection(Product product) {
    // البحث عن المنتج في القائمة
    if (!selectedProducts.any((p) => p.id == product.id)) {
      selectedProducts.add(product);
    } else {
      selectedProducts.removeWhere((p) => p.id == product.id);
    }
    
    _calculateTotalPrice();
  }

  bool isProductSelected(Product product) {
    return selectedProducts.any((p) => p.id == product.id);
  }

  void removeSelectedProduct(Product product) {
    selectedProducts.removeWhere((p) => p.id == product.id);
    _calculateTotalPrice();
  }

  void clearAllSelections() {
    selectedProducts.clear();
    originalPrice.value = 0.0;
    discountedPrice.value = 0.0;
    discountNote.value = '';
  }

  void _calculateTotalPrice() {
    // حساب السعر الإجمالي للمنتجات المختارة
    originalPrice.value = selectedProducts.fold(0.0, (sum, product) {
      final price = double.tryParse(product.price?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0') ?? 0.0;
      return sum + price;
    });
    
    if (discountedPrice.value > originalPrice.value) {
      discountedPrice.value = originalPrice.value;
    }
  }

  void setDiscountDate(DateTime date) {
    discountDate.value = date;
    dateController.text = _formatDateTime(date);
  }

  bool validateDiscount() {
    if (selectedProducts.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار منتجات أولاً',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (discountedPrice.value >= originalPrice.value) {
      Get.snackbar(
        'خطأ',
        'السعر المخفض يجب أن يكون أقل من السعر الأصلي',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    if (discountedPrice.value <= 0) {
      Get.snackbar(
        'خطأ',
        'يرجى إدخال سعر مخفض صحيح',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    return true;
  }

  void addDiscount() {
    if (!validateDiscount()) return;

    final newDiscount = ProductDiscount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      originalPrice: originalPrice.value,
      discountedPrice: discountedPrice.value,
      note: discountNote.value,
      date: discountDate.value,
      productCount: selectedProducts.length,
    );

    discounts.add(newDiscount);
    
    // إعادة تعيين
    discountedPrice.value = 0.0;
    discountNote.value = '';
    
    Get.snackbar(
      'نجاح',
      'تم إضافة التخفيض بنجاح',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void removeDiscount(ProductDiscount discount) {
    discounts.removeWhere((d) => d.id == discount.id);
    Get.snackbar(
      'نجاح',
      'تم حذف التخفيض بنجاح',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  double get totalSelectedPrice {
    return selectedProducts.fold(0.0, (sum, product) {
      final price = double.tryParse(product.price?.replaceAll(RegExp(r'[^0-9.]'), '') ?? '0') ?? 0.0;
      return sum + price;
    });
  }

  int get selectedProductsCount => selectedProducts.length;

  bool get hasSelectedProducts => selectedProducts.isNotEmpty;

  bool get hasDiscount => discountedPrice.value > 0 && discountedPrice.value < originalPrice.value;

  @override
  void onClose() {
    dateController.dispose();
    _productsWorker.dispose();
    super.onClose();
  }
}