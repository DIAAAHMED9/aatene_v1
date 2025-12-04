import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/view/related_products/related_products_model.dart';
import 'package:attene_mobile/models/product_model.dart';
import 'package:attene_mobile/view/Services/data_lnitializer_service.dart';

class RelatedProductsController extends GetxController {
  final DataInitializerService dataService = Get.find<DataInitializerService>();
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> selectedProducts = <Product>[].obs;
  final RxList<ProductDiscount> discounts = <ProductDiscount>[].obs;
  final RxString searchQuery = ''.obs;

  final RxDouble originalPrice = 0.0.obs;
  final RxDouble discountedPrice = 0.0.obs;
  final RxString discountNote = ''.obs;
  final Rx<DateTime> discountDate = DateTime.now().obs;
  final TextEditingController dateController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    _initializeDateController();
    _loadProducts();
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

  void _loadProducts() {
    try {
      // جلب المنتجات من DataInitializerService
      final productsData = dataService.getProducts();
      print('📦 [RELATED] جاري تحميل المنتجات: ${productsData.length} منتج');
      
      // تحويل البيانات إلى نموذج Product
      final loadedProducts = productsData.map((productData) {
        try {
          return Product.fromJson(productData);
        } catch (e) {
          print('⚠️ [RELATED] خطأ في تحويل المنتج: $e');
          return Product(
            id: 0,
            sku: '',
            name: 'منتج غير معروف',
            shown: false,
            favoritesCount: '0',
            messagesCount: '0',
          );
        }
      }).where((product) => product.id > 0).toList();
      
      allProducts.assignAll(loadedProducts);
      print('✅ [RELATED] تم تحميل ${allProducts.length} منتج');
    } catch (e) {
      print('❌ [RELATED] خطأ في تحميل المنتجات: $e');
    }
  }

  void refreshProducts() {
    _loadProducts();
  }

  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) return allProducts;
    
    return allProducts.where((product) {
      final searchLower = searchQuery.value.toLowerCase();
      final nameMatch = product.name.toLowerCase().contains(searchLower);
      final skuMatch = product.sku?.toLowerCase().contains(searchLower) ?? false;
      
      return nameMatch || skuMatch;
    }).toList();
  }

  void toggleProductSelection(Product product) {
    if (!selectedProducts.any((p) => p.id == product.id)) {
      selectedProducts.add(product);
      print('✅ [RELATED] تم إضافة المنتج: ${product.name}');
    } else {
      selectedProducts.removeWhere((p) => p.id == product.id);
      print('🗑️ [RELATED] تم إزالة المنتج: ${product.name}');
    }
    
    _calculateTotalPrice();
  }

  bool isProductSelected(Product product) {
    return selectedProducts.any((p) => p.id == product.id);
  }

  void removeSelectedProduct(Product product) {
    selectedProducts.removeWhere((p) => p.id == product.id);
    _calculateTotalPrice();
    print('🗑️ [RELATED] تم حذف المنتج المختار: ${product.name}');
  }

  void clearAllSelections() {
    selectedProducts.clear();
    originalPrice.value = 0.0;
    discountedPrice.value = 0.0;
    discountNote.value = '';
    print('🔄 [RELATED] تم مسح جميع الاختيارات');
  }

  void _calculateTotalPrice() {
    double total = 0.0;
    
    for (final product in selectedProducts) {
      try {
        final priceStr = product.price ?? '0';
        final cleanPrice = priceStr.replaceAll(RegExp(r'[^\d.]'), '');
        final price = double.tryParse(cleanPrice) ?? 0.0;
        total += price;
      } catch (e) {
        print('⚠️ [RELATED] خطأ في حساب سعر المنتج: ${e}');
      }
    }
    
    originalPrice.value = total;
    
    if (discountedPrice.value > originalPrice.value) {
      discountedPrice.value = originalPrice.value;
    }
    
    print('💰 [RELATED] السعر الإجمالي: ${originalPrice.value}');
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
    
    if (discountedPrice.value <= 0) {
      Get.snackbar(
        'خطأ',
        'يرجى إدخال سعر مخفض صحيح',
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
    
    print('✅ [RELATED] تم إضافة تخفيض جديد');
    
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
    super.onClose();
  }
}