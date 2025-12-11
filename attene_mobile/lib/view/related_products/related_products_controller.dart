import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/view/related_products/related_products_model.dart';
import 'package:attene_mobile/models/product_model.dart';
import 'package:attene_mobile/view/Services/data_lnitializer_service.dart';

import '../../controller/product_controller.dart';

class RelatedProductsController extends GetxController {
  final DataInitializerService dataService = Get.find<DataInitializerService>();

  // القوائم القابلة للملاحظة
  final RxList<Product> allProducts = <Product>[].obs;
  final RxList<Product> selectedProducts = <Product>[].obs;
  final RxList<ProductDiscount> discounts = <ProductDiscount>[].obs;
  final RxString searchQuery = ''.obs;

  // المتغيرات القابلة للملاحظة
  final RxDouble originalPrice = 0.0.obs;
  final RxDouble discountedPrice = 0.0.obs;
  final RxString discountNote = ''.obs;
  final Rx<DateTime> discountDate = DateTime.now().obs;

  // أدوات التحكم
  final TextEditingController dateController = TextEditingController();

  // الحالة المحفوظة
  final RxList<Product> savedSelectedProducts = <Product>[].obs;
  final RxDouble savedOriginalPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    initializeDateController();
    loadProducts();
  }

  void initializeDateController() {
    dateController.text = formatDateTime(DateTime.now());
  }

  String formatDateTime(DateTime date) {
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

  void loadProducts() {
    try {
      final productsData = dataService.getProducts();
      print('📦 [RELATED] جاري تحميل المنتجات: ${productsData.length} منتج');

      final loadedProducts = productsData
          .map((productData) {
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
          })
          .where((product) => product.id > 0)
          .toList();

      allProducts.assignAll(loadedProducts);
      print('✅ [RELATED] تم تحميل ${allProducts.length} منتج');
    } catch (e) {
      print('❌ [RELATED] خطأ في تحميل المنتجات: $e');
      Get.snackbar(
        'خطأ',
        'فشل في تحميل المنتجات',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void refreshProducts() {
    loadProducts();
  }

  List<Product> get filteredProducts {
    if (searchQuery.isEmpty) return allProducts;

    final searchLower = searchQuery.value.toLowerCase();
    return allProducts.where((product) {
      final nameMatch = product.name.toLowerCase().contains(searchLower);
      final skuMatch =
          product.sku?.toLowerCase().contains(searchLower) ?? false;
      return nameMatch || skuMatch;
    }).toList();
  }

  void toggleProductSelection(Product product) {
    if (!isProductSelected(product)) {
      selectedProducts.add(product);
      print('✅ [RELATED] تم إضافة المنتج: ${product.name}');
    } else {
      selectedProducts.removeWhere((p) => p.id == product.id);
      print('🗑️ [RELATED] تم إزالة المنتج: ${product.name}');
    }

    calculateTotalPrice();
  }

  bool isProductSelected(Product product) {
    return selectedProducts.any((p) => p.id == product.id);
  }

  void removeSelectedProduct(Product product) {
    selectedProducts.removeWhere((p) => p.id == product.id);
    calculateTotalPrice();
    print('🗑️ [RELATED] تم حذف المنتج المختار: ${product.name}');
  }

  void clearAllSelections() {
    selectedProducts.clear();
    originalPrice.value = 0.0;
    discountedPrice.value = 0.0;
    discountNote.value = '';
    dateController.text = formatDateTime(DateTime.now());
    discountDate.value = DateTime.now();
    print('🔄 [RELATED] تم مسح جميع الاختيارات');
  }

  void calculateTotalPrice() {
    double total = 0.0;

    for (final product in selectedProducts) {
      try {
        final priceStr = product.price ?? '0';
        final cleanPrice = priceStr.replaceAll(RegExp(r'[^\d.]'), '');
        final price = double.tryParse(cleanPrice) ?? 0.0;
        total += price;
      } catch (e) {
        print('⚠️ [RELATED] خطأ في حساب سعر المنتج: $e');
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
    dateController.text = formatDateTime(date);
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

  void saveCurrentState() {
    savedSelectedProducts.assignAll(selectedProducts);
    savedOriginalPrice.value = originalPrice.value;
    print('💾 [RELATED] تم حفظ حالة المنتجات المختارة');
  }

  void restoreSavedState() {
    selectedProducts.assignAll(savedSelectedProducts);
    originalPrice.value = savedOriginalPrice.value;
    print('↩️ [RELATED] تم استعادة حالة المنتجات المختارة');
  }

  void addDiscount() {
    if (!validateDiscount()) return;

    // حفظ نسخة من المنتجات المختارة
    final productCopy = selectedProducts
        .map(
          (p) => Product(
            id: p.id,
            sku: p.sku,
            name: p.name,
            price: p.price,
            shown: p.shown,
            favoritesCount: p.favoritesCount,
            messagesCount: p.messagesCount,
            coverUrl: p.coverUrl,
            // productCount: p.productCount,
          ),
        )
        .toList();

    final newDiscount = ProductDiscount(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      originalPrice: originalPrice.value,
      discountedPrice: discountedPrice.value,
      note: discountNote.value,
      date: discountDate.value,
      productCount: selectedProducts.length,
      products: productCopy,
    );

    discounts.add(newDiscount);

    clearDiscountFields();

    print('✅ [RELATED] تم إضافة تخفيض جديد');
    print('📊 [RELATED] المنتجات المرفقة: ${selectedProducts.length} منتج');

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

  List<Product> getDiscountProducts(ProductDiscount discount) {
    if (discount.products != null && discount.products!.isNotEmpty) {
      return discount.products!;
    }
    return selectedProducts.toList();
  }

  double get totalSelectedPrice {
    return selectedProducts.fold(0.0, (sum, product) {
      final priceStr = product.price ?? '0';
      final cleanPrice = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
      return sum + (double.tryParse(cleanPrice) ?? 0.0);
    });
  }

  int get selectedProductsCount => selectedProducts.length;

  bool get hasSelectedProducts => selectedProducts.isNotEmpty;

  bool get hasDiscount =>
      discountedPrice.value > 0 && discountedPrice.value < originalPrice.value;

  int get discountCount => discounts.length;

  void clearDiscountFields() {
    discountedPrice.value = 0.0;
    discountNote.value = '';
  }

  // **الدوال الجديدة للربط مع ProductCentralController**

  // الحصول على بيانات cross sell للمنتجات المختارة
  Map<String, dynamic> getCrossSellData() {
    if (selectedProducts.isEmpty) {
      return {
        'crossSells': [],
        'cross_sells_price': 0.0,
        'cross_sells_due_date': '',
      };
    }

    // إذا كان هناك تخفيضات مضافة
    if (discounts.isNotEmpty) {
      final latestDiscount = discounts.last;
      return {
        'crossSells': selectedProducts.map((p) => p.id).toList(),
        'cross_sells_price': latestDiscount.discountedPrice,
        'cross_sells_due_date': latestDiscount.date.toIso8601String().split(
          'T',
        )[0], // YYYY-MM-DD
      };
    }

    // إذا لم يكن هناك تخفيضات، ارسل السعر الأصلي
    return {
      'crossSells': selectedProducts.map((p) => p.id).toList(),
      'cross_sells_price': originalPrice.value,
      'cross_sells_due_date': DateTime.now()
          .add(const Duration(days: 30))
          .toIso8601String()
          .split('T')[0],
    };
  }

  // الحصول على المنتجات المختارة كقائمة معرفات
  List<int> getSelectedProductIds() {
    return selectedProducts.map((product) => product.id).toList();
  }

  // الحصول على بيانات التخفيض النشط
  Map<String, dynamic>? getActiveDiscountData() {
    if (discounts.isEmpty) return null;
    final discount = discounts.last;
    return {'discountedPrice': discount.discountedPrice, 'date': discount.date};
  }

  // الحصول على المنتجات المختارة بالتنسيق المناسب لـ ProductCentralController
  List<Map<String, dynamic>> getFormattedSelectedProducts() {
    return selectedProducts.map((product) {
      return {
        'id': product.id,
        'name': product.name,
        'price': product.price ?? '0',
        'sku': product.sku,
      };
    }).toList();
  }

  // رابط مع ProductCentralController
  void linkToProductCentral() {
    try {
      if (Get.isRegistered<ProductCentralController>()) {
        final productCentralController = Get.find<ProductCentralController>();
        productCentralController.updateRelatedProductsFromRelatedController();

        print(
          '🔗 [RELATED] تم ربط ${selectedProducts.length} منتج مع ProductCentralController',
        );
      } else {
        print('⚠️ [RELATED] ProductCentralController غير مسجل');
      }
    } catch (e) {
      print('❌ [RELATED] خطأ في الربط مع ProductCentralController: $e');
    }
  }

  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }
}
