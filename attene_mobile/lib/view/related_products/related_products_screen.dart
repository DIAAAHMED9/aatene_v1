import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/appBar/custom_appbar.dart';
import 'package:attene_mobile/component/appBar/tab_model.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:attene_mobile/view/related_products/related_products_controller.dart';
import 'package:attene_mobile/view/related_products/related_products_model.dart';

import '../../models/product_model.dart';


class RelatedProductsScreen extends StatefulWidget {
  final bool isLinkingMode;
  
  const RelatedProductsScreen({
    super.key,
    this.isLinkingMode = false,
  });

  @override
  State<RelatedProductsScreen> createState() => _RelatedProductsScreenState();
}

class _RelatedProductsScreenState extends State<RelatedProductsScreen> {
  final RelatedProductsController controller = Get.find<RelatedProductsController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.refreshProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
          child: _buildContent(),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return CustomAppBarWithTabs(
      isRTL: LanguageUtils.isRTL,
      config: AppBarConfig(
        title: widget.isLinkingMode ? 'ربط المنتجات' : 'المنتجات المرتبطة',
        actionText: '',
        showSearch: false,
        showTabs: false,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: ResponsiveDimensions.h(24)),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChooseProductsButton(),
                SizedBox(height: ResponsiveDimensions.h(24)),
                _buildSelectedProductsSection(),
                SizedBox(height: ResponsiveDimensions.h(24)),
                _buildDiscountsSection(),
                SizedBox(height: ResponsiveDimensions.h(32)),
                _buildBottomActions(),
                SizedBox(height: ResponsiveDimensions.h(20)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.isLinkingMode 
              ? 'اختر المنتجات المرتبطة لربطها مع المنتج الرئيسي'
              : 'قم باختيار منتجات لترشيحها في قائمة المنتجات',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(16),
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveDimensions.h(8)),
        Text(
          widget.isLinkingMode
              ? 'سيتم ربط المنتجات المختارة مع المنتج الرئيسي وتطبيق التخفيضات عليها'
              : 'اختر مجموعة من المنتجات المرتبطة لعرضها معاً وتطبيق عروض خاصة عليها',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(14),
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  Widget _buildChooseProductsButton() {
    return Center(
      child: AateneButton(
        buttonText: 'اختر المنتجات',
        color: AppColors.primary400,
        textColor: Colors.white,
        onTap: _showProductSelectionSheet,
      ),
    );
  }

  Widget _buildSelectedProductsSection() {
    return Obx(() {
      if (controller.selectedProducts.isEmpty) {
        return _buildNoProductsSelected();
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'المنتجات المختارة (${controller.selectedProductsCount})',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(18),
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (controller.hasSelectedProducts)
                InkWell(
                  onTap: () => controller.clearAllSelections(),
                  child: Row(
                    children: [
                      Icon(Icons.clear_all, color: Colors.red, size: 18),
                      SizedBox(width: ResponsiveDimensions.w(4)),
                      Text(
                        'مسح الكل',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: ResponsiveDimensions.f(14),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          _buildSelectedProductsList(),
        ],
      );
    });
  }

  Widget _buildNoProductsSelected() {
    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.w(24)),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            size: ResponsiveDimensions.w(60),
            color: Colors.grey[400],
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          Text(
            'لم يتم اختيار أي منتجات بعد',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(16),
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(8)),
          Text(
            widget.isLinkingMode
                ? 'انقر على "اختر المنتجات" لبدء ربط المنتجات مع المنتج الرئيسي'
                : 'انقر على "اختر المنتجات" لبدء إضافة المنتجات المرتبطة',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(14),
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedProductsList() {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.selectedProducts.length,
        itemBuilder: (context, index) {
          final product = controller.selectedProducts[index];
          return _buildProductCard(product);
        },
      );
    });
  }

  Widget _buildProductCard(Product product) {
    return Card(
      margin: EdgeInsets.only(bottom: ResponsiveDimensions.h(8)),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary100,
          child: Icon(
            Icons.check,
            color: AppColors.primary400,
            size: ResponsiveDimensions.w(18),
          ),
        ),
        title: Text(
          product.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: ResponsiveDimensions.f(14),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          _formatPrice(product.price ?? '0'),
          style: TextStyle(
            color: Colors.green[600],
            fontWeight: FontWeight.bold,
            fontSize: ResponsiveDimensions.f(13),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.close,
            color: Colors.red,
            size: ResponsiveDimensions.w(20),
          ),
          onPressed: () => controller.removeSelectedProduct(product),
        ),
      ),
    );
  }

  Widget _buildDiscountsSection() {
    return Obx(() {
      if (controller.discounts.isEmpty) return const SizedBox();
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'التخفيضات المضافة (${controller.discountCount})',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          _buildDiscountsList(),
        ],
      );
    });
  }

  Widget _buildDiscountsList() {
    return Obx(() {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.discounts.length,
        itemBuilder: (context, index) {
          final discount = controller.discounts[index];
          return _buildDiscountCard(discount);
        },
      );
    });
  }

  Widget _buildDiscountCard(ProductDiscount discount) {
    return Card(
      margin: EdgeInsets.only(bottom: ResponsiveDimensions.h(12)),
      color: Colors.green[50],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: Colors.green[100]!),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveDimensions.w(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.discount, color: Colors.green[700], size: 20),
                    SizedBox(width: ResponsiveDimensions.w(8)),
                    Text(
                      'خصم ${discount.discountPercentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                        fontSize: ResponsiveDimensions.f(16),
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.visibility, color: AppColors.primary400, size: 20),
                  onPressed: () => _showDiscountDetails(discount),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDimensions.h(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'من ${discount.productCount} منتج',
                  style: TextStyle(
                    color: Colors.grey[700],
                    fontSize: ResponsiveDimensions.f(12),
                  ),
                ),
                Text(
                  '${discount.discountAmount.toStringAsFixed(2)} ريال توفير',
                  style: TextStyle(
                    color: Colors.green[600],
                    fontWeight: FontWeight.bold,
                    fontSize: ResponsiveDimensions.f(12),
                  ),
                ),
              ],
            ),
            if (discount.note.isNotEmpty) ...[
              SizedBox(height: ResponsiveDimensions.h(8)),
              Text(
                'ملاحظة: ${discount.note}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: ResponsiveDimensions.f(11),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            SizedBox(height: ResponsiveDimensions.h(8)),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => _showDeleteDiscountConfirmation(discount),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outline, color: Colors.red, size: 16),
                    SizedBox(width: ResponsiveDimensions.w(4)),
                    Text(
                      'حذف',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: ResponsiveDimensions.f(12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Obx(() {
      if (!controller.hasSelectedProducts) return const SizedBox();
      
      return Container(
        padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'السعر الإجمالي:',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(16),
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '${controller.originalPrice.value.toStringAsFixed(2)} ريال',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(18),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary400,
                  ),
                ),
              ],
            ),
            
            // معلومات التخفيض إذا كان موجود
            if (controller.discounts.isNotEmpty) ...[
              SizedBox(height: ResponsiveDimensions.h(12)),
              Obx(() {
                final discount = controller.discounts.last;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'بعد التخفيض:',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.f(14),
                        color: Colors.green[600],
                      ),
                    ),
                    Text(
                      '${discount.discountedPrice.toStringAsFixed(2)} ريال',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.f(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.green[600],
                      ),
                    ),
                  ],
                );
              }),
            ],
            
            SizedBox(height: ResponsiveDimensions.h(20)),
            Row(
              children: [
                if (widget.isLinkingMode) ...[
                  Expanded(
                    child: AateneButton(
                      buttonText: 'ربط مع المنتج الرئيسي',
                      color: AppColors.primary400,
                      textColor: Colors.white,
                      onTap: _linkToMainProduct,
                    ),
                  ),
                ] else ...[
                  Expanded(
                    child: AateneButton(
                      buttonText: 'تخفيض',
                      color: AppColors.primary300,
                      textColor: Colors.white,
                      onTap: _showAddDiscountSheet,
                    ),
                  ),
                  SizedBox(width: ResponsiveDimensions.w(12)),
                  Expanded(
                    child: AateneButton(
                      buttonText: 'حفظ',
                      color: AppColors.primary400,
                      textColor: Colors.white,
                      onTap: _showSuccessSheet,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      );
    });
  }

  String _formatPrice(String price) {
    try {
      final cleanPrice = price.replaceAll(RegExp(r'[^\d.]'), '');
      final priceDouble = double.tryParse(cleanPrice) ?? 0.0;
      return '${priceDouble.toStringAsFixed(2)} ريال';
    } catch (e) {
      return '0.00 ريال';
    }
  }

  void _showProductSelectionSheet() {
    Get.bottomSheet(
      ProductSelectionBottomSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      enableDrag: true,
    );
  }

  void _showAddDiscountSheet() {
    Get.bottomSheet(
      AddDiscountBottomSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      enableDrag: true,
    );
  }

  void _showSuccessSheet() {
    if (controller.selectedProducts.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى اختيار منتجات أولاً',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }
    
    Get.bottomSheet(
      SuccessBottomSheet(controller: controller),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      enableDrag: true,
    );
  }

  void _showDiscountDetails(ProductDiscount discount) {
    Get.bottomSheet(
      DiscountDetailsBottomSheet(controller: controller, discount: discount),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      enableDrag: true,
    );
  }

  void _showDeleteDiscountConfirmation(ProductDiscount discount) {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber, color: Colors.orange),
            SizedBox(width: ResponsiveDimensions.w(8)),
            Text('تأكيد الحذف'),
          ],
        ),
        content: Text('هل أنت متأكد من حذف هذا التخفيض؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeDiscount(discount);
              Get.back();
              Get.snackbar(
                'تم الحذف',
                'تم حذف التخفيض بنجاح',
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _linkToMainProduct() {
    if (controller.selectedProducts.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار منتجات أولاً',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // ربط المنتجات مع ProductCentralController
    controller.linkToProductCentral();
    
    // إظهار رسالة نجاح
    Get.snackbar(
      'نجاح',
      'تم ربط ${controller.selectedProductsCount} منتج مع المنتج الرئيسي',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    
    // العودة للشاشة السابقة
    Get.back();
  }
}

class ProductSelectionBottomSheet extends StatefulWidget {
  final RelatedProductsController controller;
  
  const ProductSelectionBottomSheet({super.key, required this.controller});

  @override
  State<ProductSelectionBottomSheet> createState() => _ProductSelectionBottomSheetState();
}

class _ProductSelectionBottomSheetState extends State<ProductSelectionBottomSheet> {
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.controller.refreshProducts();
    widget.controller.saveCurrentState();
    
    searchController.addListener(() {
      widget.controller.searchQuery.value = searchController.text;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: ResponsiveDimensions.h(16)),
          _buildSearchBar(),
          SizedBox(height: ResponsiveDimensions.h(16)),
          _buildSelectedCount(),
          SizedBox(height: ResponsiveDimensions.h(16)),
          Expanded(child: _buildProductsList()),
          SizedBox(height: ResponsiveDimensions.h(16)),
          _buildActionButtons(),
          SizedBox(height: ResponsiveDimensions.h(8)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.w(16),
        vertical: ResponsiveDimensions.h(16),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'اختر المنتجات',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              widget.controller.restoreSavedState();
              Get.back();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      )
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.w(16)),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'ابحث عن منتج بالاسم أو الكود...',
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary400),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildSelectedCount() {
    return Obx(() {
      final count = widget.controller.selectedProducts.length;
      if (count == 0) return const SizedBox();
      
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.w(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'المنتجات المختارة:',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(14),
                color: Colors.grey[700],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveDimensions.w(12),
                vertical: ResponsiveDimensions.h(6),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary400,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$count منتج',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: ResponsiveDimensions.f(12),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildProductsList() {
    return Obx(() {
      final products = widget.controller.filteredProducts;
      
      if (products.isEmpty) {
        return _buildEmptyState();
      }

      return ListView.builder(
        padding: EdgeInsets.symmetric(
          horizontal: ResponsiveDimensions.w(16),
          vertical: ResponsiveDimensions.h(8),
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductItem(product);
        },
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: ResponsiveDimensions.w(80),
            color: Colors.grey[300],
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          Text(
            'لا توجد منتجات',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(16),
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(8)),
          Text(
            'لم يتم العثور على منتجات تطابق البحث',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(14),
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItem(Product product) {
    final isSelected = widget.controller.isProductSelected(product);
    
    return Card(
      margin: EdgeInsets.only(bottom: ResponsiveDimensions.h(8)),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isSelected ? AppColors.primary400 : Colors.grey[200]!,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(
          horizontal: ResponsiveDimensions.w(12),
          vertical: ResponsiveDimensions.h(8),
        ),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[100],
          ),
          child: _buildProductImage(product),
        ),
        title: Text(
          product.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: ResponsiveDimensions.f(14),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (product.sku != null && product.sku!.isNotEmpty) ...[
              Text(
                'SKU: ${product.sku}',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(11),
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: ResponsiveDimensions.h(2)),
            ],
            Text(
              _formatPrice(product.price ?? '0'),
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(13),
                color: Colors.green[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (value) {
            widget.controller.toggleProductSelection(product);
          },
          activeColor: AppColors.primary400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        onTap: () {
          widget.controller.toggleProductSelection(product);
        },
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    if (product.coverUrl != null && product.coverUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          product.coverUrl!,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildProductPlaceholder();
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
                strokeWidth: 2,
              ),
            );
          },
        ),
      );
    }
    return _buildProductPlaceholder();
  }

  Widget _buildProductPlaceholder() {
    return Center(
      child: Icon(
        Icons.shopping_bag,
        color: Colors.grey[400],
        size: ResponsiveDimensions.w(24),
      ),
    );
  }

  String _formatPrice(String price) {
    try {
      final cleanPrice = price.replaceAll(RegExp(r'[^\d.]'), '');
      final priceDouble = double.tryParse(cleanPrice) ?? 0.0;
      return '${priceDouble.toStringAsFixed(2)} ريال';
    } catch (e) {
      return '0.00 ريال';
    }
  }

  Widget _buildActionButtons() {
    return Obx(() {
      final hasSelected = widget.controller.hasSelectedProducts;
      final selectedCount = widget.controller.selectedProductsCount;
      
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.w(16)),
        child: Column(
          children: [
            if (hasSelected) ...[
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(ResponsiveDimensions.w(12)),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Column(
                  children: [
                    Text(
                      'تم اختيار $selectedCount منتج',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    SizedBox(height: ResponsiveDimensions.h(4)),
                    Text(
                      'السعر الإجمالي: ${widget.controller.originalPrice.value.toStringAsFixed(2)} ريال',
                      style: TextStyle(
                        color: Colors.green[600],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: ResponsiveDimensions.h(12)),
            ],
            Row(
              children: [
                if (hasSelected) ...[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        widget.controller.clearAllSelections();
                        Get.back();
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'مسح الكل',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  SizedBox(width: ResponsiveDimensions.w(12)),
                ],
                Expanded(
                  child: AateneButton(
                    buttonText: hasSelected ? 'تأكيد' : 'إغلاق',
                    color: hasSelected ? AppColors.primary400 : Colors.grey[400],
                    textColor: Colors.white,
                    onTap: () {
                      if (hasSelected) {
                        widget.controller.calculateTotalPrice();
                        Get.back();
                        Get.snackbar(
                          'تم الإضافة',
                          'تم اختيار $selectedCount منتج بنجاح',
                          backgroundColor: Colors.green,
                          colorText: Colors.white,
                          duration: const Duration(seconds: 2),
                        );
                      } else {
                        widget.controller.restoreSavedState();
                        Get.back();
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}


class AddDiscountBottomSheet extends StatefulWidget {
  final RelatedProductsController controller;
  final bool isEditing;
  
  const AddDiscountBottomSheet({
    super.key,
    required this.controller,
    this.isEditing = false,
  });

  @override
  State<AddDiscountBottomSheet> createState() => _AddDiscountBottomSheetState();
}

class _AddDiscountBottomSheetState extends State<AddDiscountBottomSheet> {
  final TextEditingController discountedPriceController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final FocusNode discountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    
    discountedPriceController.addListener(() {
      final value = double.tryParse(discountedPriceController.text) ?? 0.0;
      widget.controller.discountedPrice.value = value;
    });
    
    noteController.addListener(() {
      widget.controller.discountNote.value = noteController.text;
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      discountFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    discountedPriceController.dispose();
    noteController.dispose();
    discountFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.75,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: ResponsiveDimensions.h(16)),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveDimensions.w(16),
              ),
              child: Column(
                children: [
                  _buildSummaryCard(),
                  SizedBox(height: ResponsiveDimensions.h(20)),
                  _buildPriceField(
                    'السعر الاصلي',
                    widget.controller.originalPrice.value.toStringAsFixed(2),
                    true,
                  ),
                  SizedBox(height: ResponsiveDimensions.h(16)),
                  _buildDiscountPriceField(),
                  SizedBox(height: ResponsiveDimensions.h(16)),
                  _buildDiscountNote(),
                  SizedBox(height: ResponsiveDimensions.h(16)),
                  _buildDateField(),
                  SizedBox(height: ResponsiveDimensions.h(20)),
                ],
              ),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          _buildActionButtons(),
          SizedBox(height: ResponsiveDimensions.h(8)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.w(16),
        vertical: ResponsiveDimensions.h(16),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.isEditing ? 'تعديل التخفيض' : 'إضافة تخفيض',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () {
              widget.controller.clearDiscountFields();
              Get.back();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      )
    );
  }

  Widget _buildSummaryCard() {
    return Obx(() {
      final productCount = widget.controller.selectedProducts.length;
      final originalPrice = widget.controller.originalPrice.value;
      
      return Container(
        padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
        decoration: BoxDecoration(
          color: AppColors.primary50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary200),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'عدد المنتجات:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '$productCount منتج',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary400,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDimensions.h(8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'السعر الإجمالي:',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '${originalPrice.toStringAsFixed(2)} ريال',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPriceField(String label, String value, bool isReadOnly) {
    return TextField(
      readOnly: isReadOnly,
      decoration: InputDecoration(
        labelText: label,
        hintText: value,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixText: 'ريال',
        prefixIcon: Icon(Icons.attach_money, color: Colors.green),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDiscountPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: discountedPriceController,
          focusNode: discountFocusNode,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'السعر بعد التخفيض',
            hintText: 'أدخل السعر المخفض',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixText: 'ريال',
            prefixIcon: Icon(Icons.discount, color: AppColors.primary400),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        SizedBox(height: ResponsiveDimensions.h(8)),
        Obx(() {
          final originalPrice = widget.controller.originalPrice.value;
          final discountedPrice = widget.controller.discountedPrice.value;
          
          if (discountedPrice <= 0) {
            return Padding(
              padding: EdgeInsets.only(left: ResponsiveDimensions.w(4)),
              child: Text(
                'أدخل سعراً صحيحاً أكبر من الصفر',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(12),
                  color: Colors.orange[700],
                ),
              ),
            );
          }
          
          if (discountedPrice >= originalPrice) {
            return Padding(
              padding: EdgeInsets.only(left: ResponsiveDimensions.w(4)),
              child: Text(
                'يجب أن يكون السعر المخفض أقل من السعر الأصلي',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(12),
                  color: Colors.red,
                ),
              ),
            );
          }
          
          final discountAmount = originalPrice - discountedPrice;
          final discountPercentage = (discountAmount / originalPrice) * 100;
          
          return Container(
            padding: EdgeInsets.all(ResponsiveDimensions.w(12)),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green[200]!),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'نسبة التخفيض:',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(13),
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '${discountPercentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(14),
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDiscountNote() {
    return TextField(
      controller: noteController,
      decoration: InputDecoration(
        labelText: 'ملاحظة (اختياري)',
        hintText: 'أضف ملاحظة عن التخفيض',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.note_add, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      maxLines: 3,
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: widget.controller.dateController,
      readOnly: true,
      onTap: () => _showDatePicker(),
      decoration: InputDecoration(
        labelText: 'تاريخ التخفيض',
        hintText: 'اختر التاريخ',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        prefixIcon: Icon(Icons.calendar_today, color: Colors.grey[600]),
        suffixIcon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.controller.discountDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      locale: const Locale('ar', 'SA'),
    );
    
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(widget.controller.discountDate.value),
      );
      
      if (time != null) {
        final selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
        widget.controller.setDiscountDate(selectedDateTime);
      }
    }
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.w(16)),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                widget.controller.clearDiscountFields();
                Get.back();
              },
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'إلغاء',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(16),
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveDimensions.w(12)),
          Expanded(
            child: Obx(() {
              final originalPrice = widget.controller.originalPrice.value;
              final discountedPrice = widget.controller.discountedPrice.value;
              final isValid = discountedPrice > 0 && discountedPrice < originalPrice;
              
              return ElevatedButton(
                onPressed: isValid ? () {
                  if (widget.controller.validateDiscount()) {
                    widget.controller.addDiscount();
                    Get.back();
                    Get.snackbar(
                      'نجاح',
                      'تم إضافة التخفيض بنجاح',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                  }
                } : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: isValid ? AppColors.primary400 : Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.isEditing ? 'تحديث' : 'إضافة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ResponsiveDimensions.f(16),
                  ),
                ),
              );
            }),
          ),
        ],
      )
    );
  }
}

class SuccessBottomSheet extends StatelessWidget {
  final RelatedProductsController controller;
  
  const SuccessBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.4,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: ResponsiveDimensions.w(80),
            height: ResponsiveDimensions.w(80),
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: ResponsiveDimensions.w(50),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(20)),
          Text(
            'تمت العملية بنجاح',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(20),
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(8)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveDimensions.w(40),
            ),
            child: Text(
              'تم حفظ المنتجات المرتبطة بنجاح في النظام',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(14),
                color: Colors.grey[600],
              ),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(32)),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveDimensions.w(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back();
                      controller.clearAllSelections();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'إغلاق',
                      style: TextStyle(
                        color: AppColors.primary400,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveDimensions.w(12)),
                Expanded(
                  child: AateneButton(
                    buttonText: 'متابعة',
                    color: AppColors.primary400,
                    textColor: Colors.white,
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class DiscountDetailsBottomSheet extends StatelessWidget {
  final RelatedProductsController controller;
  final ProductDiscount discount;
  
  const DiscountDetailsBottomSheet({
    super.key,
    required this.controller,
    required this.discount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: ResponsiveDimensions.h(16)),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveDimensions.w(16),
              ),
              child: Column(
                children: [
                  _buildDiscountHeader(),
                  SizedBox(height: ResponsiveDimensions.h(20)),
                  _buildPriceDetails(),
                  SizedBox(height: ResponsiveDimensions.h(20)),
                  _buildAdditionalInfo(),
                  SizedBox(height: ResponsiveDimensions.h(20)),
                ],
              ),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          _buildActionButtons(),
          SizedBox(height: ResponsiveDimensions.h(8)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.w(16),
        vertical: ResponsiveDimensions.h(16),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'تفاصيل التخفيض',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
          ),
        ],
      )
    );
  }

  Widget _buildDiscountHeader() {
    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary100, AppColors.primary50],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'نسبة التخفيض:',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(14),
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '${discount.discountPercentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(20),
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary400,
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveDimensions.h(12)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'عدد المنتجات:',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(14),
                  color: Colors.grey[700],
                ),
              ),
              Text(
                '${discount.productCount} منتج',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(16),
                  fontWeight: FontWeight.bold,
                  color: Colors.green[600],
                ),
              ),
            ],
          ),
        ],
      )
    );
  }

  Widget _buildPriceDetails() {
    return Column(
      children: [
        _buildPriceItem('السعر الأصلي', '${discount.originalPrice.toStringAsFixed(2)} ريال'),
        SizedBox(height: ResponsiveDimensions.h(12)),
        _buildPriceItem('السعر بعد التخفيض', '${discount.discountedPrice.toStringAsFixed(2)} ريال',
            isDiscounted: true),
        SizedBox(height: ResponsiveDimensions.h(12)),
        _buildPriceItem('قيمة التخفيض', '${discount.discountAmount.toStringAsFixed(2)} ريال',
            isSavings: true),
      ],
    );
  }

  Widget _buildPriceItem(String title, String value, {
    bool isDiscounted = false,
    bool isSavings = false,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.w(12)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[100]!,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
              fontSize: ResponsiveDimensions.f(14),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isSavings 
                  ? Colors.green[600]
                  : (isDiscounted ? AppColors.primary400 : Colors.grey[800]),
              fontSize: ResponsiveDimensions.f(16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo() {
    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
              SizedBox(width: ResponsiveDimensions.w(8)),
              Text(
                'معلومات إضافية',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
          SizedBox(height: ResponsiveDimensions.h(12)),
          _buildInfoRow('تاريخ التخفيض', _formatDate(discount.date)),
          if (discount.note.isNotEmpty) ...[
            SizedBox(height: ResponsiveDimensions.h(8)),
            _buildInfoRow('الملاحظات', discount.note),
          ],
          SizedBox(height: ResponsiveDimensions.h(8)),
          _buildInfoRow('تاريخ الإنشاء', _formatDate(discount.date)),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: ResponsiveDimensions.f(13),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: ResponsiveDimensions.f(13),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final months = [
      'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
      'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'
    ];
    
    final hour = date.hour;
    final period = hour < 12 ? 'ص' : 'م';
    final displayHour = hour <= 12 ? hour : hour - 12;
    
    return '${date.day} ${months[date.month - 1]} ${date.year} - $displayHour:${date.minute.toString().padLeft(2, '0')} $period';
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.w(16)),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _showDeleteConfirmation(),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'حذف التخفيض',
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          SizedBox(width: ResponsiveDimensions.w(12)),
          Expanded(
            child: AateneButton(
              buttonText: 'إغلاق',
              color: AppColors.primary400,
              textColor: Colors.white,
              onTap: () => Get.back(),
            ),
          ),
        ],
      )
    );
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا التخفيض؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              controller.removeDiscount(discount);
              Get.back();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}