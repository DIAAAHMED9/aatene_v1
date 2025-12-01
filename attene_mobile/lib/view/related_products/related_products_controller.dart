// lib/view/related_products/related_products_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/view/related_products/related_products_model.dart';

class RelatedProductsController extends GetxController {
  // === الحالة الأساسية ===
  final RxList<RelatedProduct> allProducts = <RelatedProduct>[].obs;
  final RxList<RelatedProduct> selectedProducts = <RelatedProduct>[].obs;
  final RxList<ProductDiscount> discounts = <ProductDiscount>[].obs;
  final RxString searchQuery = ''.obs;

  // === بيانات التخفيض الحالي ===
  final RxDouble originalPrice = 0.0.obs;
  final RxDouble discountedPrice = 0.0.obs;
  final RxString discountNote = ''.obs;
  final Rx<DateTime> discountDate = DateTime.now().obs;
  final TextEditingController dateController = TextEditingController();



  @override
  void onInit() {
    super.onInit();
    _initializeSampleProducts();
    _initializeDateController();
  }

  void _initializeSampleProducts() {
    allProducts.assignAll([
      RelatedProduct(
        id: '1',
        name: 'قميص رجالي قطني',
        image: 'https://via.placeholder.com/150',
        price: 120.0,
      ),
      RelatedProduct(
        id: '2', 
        name: 'بنطال جينز',
        image: 'https://via.placeholder.com/150',
        price: 180.0,
      ),
      RelatedProduct(
        id: '3',
        name: 'جاكيت شتوي',
        image: 'https://via.placeholder.com/150',
        price: 250.0,
      ),
      RelatedProduct(
        id: '4',
        name: 'حذاء رياضي',
        image: 'https://via.placeholder.com/150',
        price: 200.0,
      ),
      RelatedProduct(
        id: '5',
        name: 'قبعة صيفية',
        image: 'https://via.placeholder.com/150',
        price: 50.0,
      ),
    ]);
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

  // === دوال إدارة المنتجات ===
  List<RelatedProduct> get filteredProducts {
    if (searchQuery.isEmpty) return allProducts;
    return allProducts.where((product) {
      return product.name.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();
  }

  void toggleProductSelection(RelatedProduct product) {
    final index = allProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      allProducts[index].isSelected.toggle();
      
      if (allProducts[index].isSelected.value) {
        selectedProducts.add(allProducts[index]);
      } else {
        selectedProducts.removeWhere((p) => p.id == product.id);
      }
      
      _calculateTotalPrice();
    }
  }

  void removeSelectedProduct(RelatedProduct product) {
    final index = allProducts.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      allProducts[index].isSelected.value = false;
    }
    selectedProducts.removeWhere((p) => p.id == product.id);
    _calculateTotalPrice();
  }

  void clearAllSelections() {
    for (final product in allProducts) {
      product.isSelected.value = false;
    }
    selectedProducts.clear();
    originalPrice.value = 0.0;
    discountedPrice.value = 0.0;
    discountNote.value = '';

  }

  void _calculateTotalPrice() {
    originalPrice.value = selectedProducts.fold(0.0, (sum, product) => sum + product.price);
    if (discountedPrice.value > originalPrice.value) {
      discountedPrice.value = originalPrice.value;
    }
  }

  // === دوال إدارة التخفيضات ===
  void setDiscountDate(DateTime date) {
    discountDate.value = date;
    dateController.text = _formatDateTime(date);
  }

  bool validateDiscount() {
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

  // === دوال الحصول على البيانات ===
  double get totalSelectedPrice {
    return selectedProducts.fold(0.0, (sum, product) => sum + product.price);
  }

// دالة للحصول على عدد المنتجات المختارة
int get selectedProductsCount => selectedProducts.length;

// دالة للتحقق من وجود منتجات مختارة
bool get hasSelectedProducts => selectedProducts.isNotEmpty;

// دالة للتحقق من وجود تخفيض
bool get hasDiscount => discountedPrice.value > 0 && discountedPrice.value < originalPrice.value;
  @override
  void onClose() {
    dateController.dispose();
    super.onClose();
  }
}