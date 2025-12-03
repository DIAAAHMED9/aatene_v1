import 'package:attene_mobile/models/product_model.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/product_controller.dart';
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

class RelatedProductsScreen extends StatelessWidget {
  final RelatedProductsController controller = Get.put(RelatedProductsController());

  RelatedProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  _buildContent();
    
  }

  Widget _buildAppBar() {
    return CustomAppBarWithTabs(
      isRTL: LanguageUtils.isRTL,
      config: AppBarConfig(
        title: 'المنتجات المرتبطة',
        actionText: '',
        showSearch: false,
        showTabs: false,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        SizedBox(height: ResponsiveDimensions.h(32)),
        _buildChooseProductsButton(),
        SizedBox(height: ResponsiveDimensions.h(24)),
        _buildSelectedProductsSection(),
        SizedBox(height: ResponsiveDimensions.h(32)),
        _buildBottomActions(),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'قم باختيار منتجات لترشيحها في قائمة المنتجات',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(16),
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: ResponsiveDimensions.h(8)),
        Text(
          'اختر مجموعة من المنتجات المرتبطة لعرضها معاً وتطبيق عروض خاصة عليها',
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
          Text(
            'المنتجات المختارة',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(18),
              fontWeight: FontWeight.bold,
            ),
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
            'انقر على "اختر المنتجات" لبدء إضافة المنتجات المرتبطة',
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
      return Column(
        children: controller.selectedProducts.map((product) {
          return Card(
            margin: EdgeInsets.only(bottom: ResponsiveDimensions.h(8)),
            child: ListTile(
              leading: Icon(Icons.check_circle, color: AppColors.primary400),
              title: Text(
                product.name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: Text(
                '${double.parse(product.price??'0.0').toStringAsFixed(2)} ريال',
                style: TextStyle(
                  color: Colors.green[600],
                  fontWeight: FontWeight.bold,
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
        }).toList(),
      );
    });
  }

  Widget _buildBottomActions() {
    return Obx(() {
      if (!controller.hasSelectedProducts) return SizedBox();
      
      return Container(
        padding: EdgeInsets.symmetric(vertical: ResponsiveDimensions.h(16)),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: AateneButton(
                buttonText: 'تخفيض على المنتجات المختارة',
                color: AppColors.primary300,
                textColor: Colors.white,
                onTap: _showAddDiscountSheet,
              ),
            ),
            SizedBox(width: ResponsiveDimensions.w(12)),
            Expanded(
              child: AateneButton(
                buttonText: 'التالي',
                color: AppColors.primary400,
                textColor: Colors.white,
                onTap: _showSuccessSheet,
              ),
            ),
          ],
        ),
      );
    });
  }

  void _showProductSelectionSheet() {
    Get.bottomSheet(
      ProductSelectionBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      enableDrag: true,
    );
  }

  void _showAddDiscountSheet() {
    Get.bottomSheet(
      AddDiscountBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
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
      SuccessBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      enableDrag: true,
    );
  }
}

class ProductSelectionBottomSheet extends StatelessWidget {
  final RelatedProductsController controller = Get.find<RelatedProductsController>();
  final ProductController productController = Get.find<ProductController>();
  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.8,
      padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
      child: Column(
        children: [
          _buildHeader('إضافة منتجات مترابطة'),
          SizedBox(height: ResponsiveDimensions.h(16)),
          _buildSearchBar(),
          SizedBox(height: ResponsiveDimensions.h(16)),
          Expanded(
            child: _buildProductsList(),
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      onChanged: (value) => controller.searchQuery.value = value,
      decoration: InputDecoration(
        hintText: 'ابحث عن المنتجات...',
        prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide(color: AppColors.primary400),
        ),
        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildProductsList() {
    return Obx(() {
      final products = controller.filteredProducts;
      
      if (products.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
              SizedBox(height: 16),
              Text(
                'لا توجد منتجات تطابق البحث',
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildProductItem(product);
        },
      );
    });
  }

  Widget _buildProductItem(Product product) {
    final isSelected = controller.isProductSelected(product);
    
    return Card(
      margin: EdgeInsets.only(bottom: ResponsiveDimensions.h(8)),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey[200],
          ),
          child: product.coverUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    product.coverUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.image, color: Colors.grey[400]);
                    },
                  ),
                )
              : Icon(Icons.image, color: Colors.grey[400]),
        ),
        title: Text(
          product.name,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SKU: ${product.sku ?? "غير متوفر"}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              '${product.price ?? "0.0"} ريال',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green[600],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Checkbox(
          value: isSelected,
          onChanged: (value) {
            controller.toggleProductSelection(product);
          },
          activeColor: AppColors.primary400,
        ),
        onTap: () {
          controller.toggleProductSelection(product);
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return Obx(() {
      final hasSelected = controller.hasSelectedProducts;
      
      return Column(
        children: [
          if (hasSelected) ...[
            Text(
              'تم اختيار ${controller.selectedProductsCount} منتج',
              style: TextStyle(
                color: AppColors.primary400,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveDimensions.h(8)),
          ],
          AateneButton(
            buttonText: hasSelected ? 'تأكيد الإضافة' : 'إغلاق',
            color: hasSelected ? AppColors.primary400 : Colors.grey[400],
            textColor: Colors.white,
            onTap: () {
              if (hasSelected) {
                Get.back();
                Get.snackbar(
                  'تم الإضافة',
                  'تمت إضافة ${controller.selectedProductsCount} منتج',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                );
              } else {
                Get.back();
              }
            },
          ),
        ],
      );
    });
  }
}
class AddDiscountBottomSheet extends StatelessWidget {
  final RelatedProductsController controller = Get.find<RelatedProductsController>();
  final TextEditingController discountedPriceController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.7,
      padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
      child: Column(
        children: [
          _buildHeader('إضافة خصم على الكولكشن'),
          SizedBox(height: ResponsiveDimensions.h(16)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildPriceField(
                    'السعر الاصلي',
                    controller.originalPrice.value.toStringAsFixed(2),
                    true,
                  ),
                  SizedBox(height: ResponsiveDimensions.h(16)),
                  _buildDiscountPriceField(),
                  SizedBox(height: ResponsiveDimensions.h(8)),
                  _buildDiscountNote(),
                  SizedBox(height: ResponsiveDimensions.h(16)),
                  _buildDateField(),
                  SizedBox(height: ResponsiveDimensions.h(16)),
                  _buildProductCount(),
                ],
              ),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          _buildDiscountActions(),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildPriceField(String label, String value, bool isReadOnly) {
    return TextField(
      readOnly: isReadOnly,
      decoration: InputDecoration(
        labelText: label,
        hintText: value,
        border: OutlineInputBorder(),
        suffixText: 'ريال',
        prefixIcon: Icon(Icons.attach_money),
      ),
    );
  }

  Widget _buildDiscountPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: discountedPriceController,
          onChanged: (value) {
            final parsed = double.tryParse(value) ?? 0.0;
            controller.discountedPrice.value = parsed;
          },
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: 'السعر المخفض',
            hintText: 'أدخل السعر المخفض',
            border: OutlineInputBorder(),
            suffixText: 'ريال',
            prefixIcon: Icon(Icons.discount),
          ),
        ),
        SizedBox(height: ResponsiveDimensions.h(8)),
        Text(
          'يجب أن يكون أقل من السعر الاصلي',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(12),
            color: Colors.orange[700],
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountNote() {
    return TextField(
      controller: noteController,
      onChanged: (value) => controller.discountNote.value = value,
      decoration: InputDecoration(
        labelText: 'ملاحظة',
        hintText: 'أضف ملاحظة عن التخفيض',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.note),
      ),
      maxLines: 2,
    );
  }

  Widget _buildDateField() {
    return TextField(
      controller: controller.dateController,
      readOnly: true,
      onTap: () => _showDatePicker(),
      decoration: InputDecoration(
        labelText: 'التاريخ',
        hintText: 'مايو 25, 2025 12:00 م',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.calendar_today),
        suffixIcon: Icon(Icons.arrow_drop_down),
      ),
    );
  }

  void _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: controller.discountDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    
    if (picked != null) {
      final TimeOfDay? time = await showTimePicker(
        context: Get.context!,
        initialTime: TimeOfDay.fromDateTime(controller.discountDate.value),
      );
      
      if (time != null) {
        final selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          time.hour,
          time.minute,
        );
        controller.setDiscountDate(selectedDateTime);
      }
    }
  }

  Widget _buildProductCount() {
    return Obx(() => Container(
      padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Center(
        child: Text(
          'الخصم على ${controller.selectedProducts.length} من عدد المنتجات',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(16),
            fontWeight: FontWeight.bold,
            color: AppColors.primary400,
          ),
        ),
      ),
    ));
  }

  Widget _buildDiscountActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Get.back(),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text('إلغاء'),
          ),
        ),
        SizedBox(width: ResponsiveDimensions.w(12)),
        Expanded(
          child: Obx(() => ElevatedButton(
            onPressed: controller.discountedPrice.value > 0 ?
                () {
                  if (controller.validateDiscount()) {
                    controller.addDiscount();
                    Get.back();
                    Get.bottomSheet(
                      SuccessBottomSheet(),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                    );
                  }
                } : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              backgroundColor: AppColors.primary400,
            ),
            child: Text('تأكيد', style: TextStyle(color: Colors.white)),
          )),
        ),
      ],
    );
  }
}

class SuccessBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.4,
      padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.green,
            size: ResponsiveDimensions.w(60),
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          Text(
            'تم الإضافة بنجاح',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(18),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(8)),
          Text(
            'تم حفظ المنتجات المرتبطة والتخفيض بنجاح',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(14),
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(24)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Get.back(),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text('قائمة المنتجات المرتبطة'),
                ),
              ),
              SizedBox(width: ResponsiveDimensions.w(12)),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.bottomSheet(
                      DiscountDetailsBottomSheet(),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppColors.primary400,
                  ),
                  child: Text('عرض التخفيض', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class DiscountDetailsBottomSheet extends StatelessWidget {
  final RelatedProductsController controller = Get.find<RelatedProductsController>();

  @override
  Widget build(BuildContext context) {
    final discount = controller.discounts.isNotEmpty ? controller.discounts.last : null;
    
    if (discount == null) {
      return Container(
        height: Get.height * 0.3,
        child: Center(child: Text('لا توجد تفاصيل تخفيض')),
      );
    }

    return Container(
      height: Get.height * 0.7,
      padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
      child: Column(
        children: [
          _buildHeader('تفاصيل التخفيض'),
          SizedBox(height: ResponsiveDimensions.h(16)),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildPriceField(
                    'السعر الاصلي',
                    discount.originalPrice.toStringAsFixed(2),
                    true,
                  ),
                  SizedBox(height: ResponsiveDimensions.h(16)),
                  _buildPriceField(
                    'السعر المخفض',
                    discount.discountedPrice.toStringAsFixed(2),
                    true,
                  ),
                  SizedBox(height: ResponsiveDimensions.h(16)),
                  _buildDiscountInfo(discount),
                  SizedBox(height: ResponsiveDimensions.h(16)),
                  _buildProductCountInfo(discount),
                ],
              ),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(16)),
          _buildDetailActions(discount),
        ],
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(18),
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildPriceField(String label, String value, bool isReadOnly) {
    return TextField(
      readOnly: isReadOnly,
      decoration: InputDecoration(
        labelText: label,
        hintText: value,
        border: OutlineInputBorder(),
        suffixText: 'ريال',
        prefixIcon: Icon(Icons.attach_money),
      ),
    );
  }

  Widget _buildDiscountInfo(ProductDiscount discount) {
    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        children: [
          Text(
            'معلومات التخفيض',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green[800],
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(8)),
          Text('قيمة التخفيض: ${discount.discountAmount.toStringAsFixed(2)} ريال'),
          Text('نسبة التخفيض: ${discount.discountPercentage.toStringAsFixed(1)}%'),
          if (discount.note.isNotEmpty) ...[
            SizedBox(height: ResponsiveDimensions.h(8)),
            Text('ملاحظة: ${discount.note}'),
          ],
        ],
      ),
    );
  }

  Widget _buildProductCountInfo(ProductDiscount discount) {
    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Center(
        child: Text(
          'الخصم على ${discount.productCount} من عدد المنتجات',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primary400,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailActions(ProductDiscount discount) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _showDeleteConfirmation(discount),
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              side: BorderSide(color: Colors.red),
            ),
            child: Text(
              'حذف الخصم',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ),
        SizedBox(width: ResponsiveDimensions.w(12)),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Get.back();
              Get.bottomSheet(
                AddDiscountBottomSheet(),
                isScrollControlled: true,
                backgroundColor: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              backgroundColor: AppColors.primary400,
            ),
            child: Text('تعديل الخصم', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(ProductDiscount discount) {
    Get.dialog(
      AlertDialog(
        title: Text('تأكيد الحذف'),
        content: Text('هل أنت متأكد من حذف هذا الخصم؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              controller.removeDiscount(discount);
              Get.back();
              Get.back();
            },
            child: Text(
              'حذف',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}