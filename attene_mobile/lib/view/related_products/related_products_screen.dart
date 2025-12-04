import 'package:attene_mobile/models/product_model.dart';
import 'package:attene_mobile/view/Services/data_lnitializer_service.dart';
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

class RelatedProductsScreen extends StatefulWidget {
  const RelatedProductsScreen({super.key});

  @override
  State<RelatedProductsScreen> createState() => _RelatedProductsScreenState();
}

class _RelatedProductsScreenState extends State<RelatedProductsScreen> {
  final RelatedProductsController controller = Get.put(RelatedProductsController());

  @override
  void initState() {
    super.initState();
    // تحميل البيانات عند بدء الشاشة
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
        title: 'المنتجات المرتبطة',
        actionText: '',
        showSearch: false,
        showTabs: false,
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      child: Column(
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
      ),
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
            'المنتجات المختارة (${controller.selectedProductsCount})',
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
      child: ListTile(
        leading: Icon(Icons.check_circle, color: AppColors.primary400),
        title: Text(
          product.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Text(
          '${double.tryParse(product.price ?? '0')?.toStringAsFixed(2) ?? '0.00'} ريال',
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
  }

  Widget _buildBottomActions() {
    return Obx(() {
      if (!controller.hasSelectedProducts) return const SizedBox();
      
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveDimensions.h(16),
          horizontal: ResponsiveDimensions.w(8),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[200]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              'السعر الإجمالي: ${controller.originalPrice.value.toStringAsFixed(2)} ريال',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(16),
                fontWeight: FontWeight.bold,
                color: AppColors.primary400,
              ),
            ),
            SizedBox(height: ResponsiveDimensions.h(16)),
            Row(
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
          ],
        ),
      );
    });
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
  }

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
          icon: const Icon(Icons.close),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: searchController,
      onChanged: (value) => widget.controller.searchQuery.value = value,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildProductsList() {
    return Obx(() {
      final products = widget.controller.filteredProducts;
      
      if (products.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
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
    final isSelected = widget.controller.isProductSelected(product);
    
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
          child: product.coverUrl != null && product.coverUrl!.isNotEmpty
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
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'SKU: ${product.sku ?? "غير متوفر"}',
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 4),
            Text(
              '${double.tryParse(product.price ?? '0')?.toStringAsFixed(2) ?? '0.00'} ريال',
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
            widget.controller.toggleProductSelection(product);
          },
          activeColor: AppColors.primary400,
        ),
        onTap: () {
          widget.controller.toggleProductSelection(product);
        },
      ),
    );
  }

  Widget _buildAddButton() {
    return Obx(() {
      final hasSelected = widget.controller.hasSelectedProducts;
      
      return Column(
        children: [
          if (hasSelected) ...[
            Text(
              'تم اختيار ${widget.controller.selectedProductsCount} منتج',
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
                  'تمت إضافة ${widget.controller.selectedProductsCount} منتج',
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

class AddDiscountBottomSheet extends StatefulWidget {
  final RelatedProductsController controller;
  
  const AddDiscountBottomSheet({super.key, required this.controller});

  @override
  State<AddDiscountBottomSheet> createState() => _AddDiscountBottomSheetState();
}

class _AddDiscountBottomSheetState extends State<AddDiscountBottomSheet> {
  final TextEditingController discountedPriceController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

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
  }

  @override
  void dispose() {
    discountedPriceController.dispose();
    noteController.dispose();
    super.dispose();
  }

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
                    widget.controller.originalPrice.value.toStringAsFixed(2),
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
          icon: const Icon(Icons.close),
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
        border: const OutlineInputBorder(),
        suffixText: 'ريال',
        prefixIcon: const Icon(Icons.attach_money),
      ),
    );
  }

  Widget _buildDiscountPriceField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: discountedPriceController,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            labelText: 'السعر المخفض',
            hintText: 'أدخل السعر المخفض',
            border: OutlineInputBorder(),
            suffixText: 'ريال',
            prefixIcon: Icon(Icons.discount),
          ),
        ),
        SizedBox(height: ResponsiveDimensions.h(8)),
        const Text(
          'يجب أن يكون أقل من السعر الاصلي',
          style: TextStyle(
            fontSize: 12,
            color: Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _buildDiscountNote() {
    return TextField(
      controller: noteController,
      decoration: const InputDecoration(
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
      controller: widget.controller.dateController,
      readOnly: true,
      onTap: () => _showDatePicker(),
      decoration: const InputDecoration(
        labelText: 'التاريخ',
        hintText: 'اختر التاريخ',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.calendar_today),
        suffixIcon: Icon(Icons.arrow_drop_down),
      ),
    );
  }

  Future<void> _showDatePicker() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: widget.controller.discountDate.value,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
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
          'الخصم على ${widget.controller.selectedProducts.length} من عدد المنتجات',
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
            child: const Text('إلغاء'),
          ),
        ),
        SizedBox(width: ResponsiveDimensions.w(12)),
        Expanded(
          child: Obx(() => ElevatedButton(
            onPressed: widget.controller.discountedPrice.value > 0 ?
                () {
                  if (widget.controller.validateDiscount()) {
                    widget.controller.addDiscount();
                    Get.back();
                    Get.bottomSheet(
                      SuccessBottomSheet(controller: widget.controller),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                    );
                  }
                } : null,
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 12),
              backgroundColor: AppColors.primary400,
            ),
            child: const Text('تأكيد', style: TextStyle(color: Colors.white)),
          )),
        ),
      ],
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
          const Text(
            'تم الإضافة بنجاح',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(8)),
          const Text(
            'تم حفظ المنتجات المرتبطة والتخفيض بنجاح',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(24)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    Get.back();
                    controller.clearAllSelections();
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('قائمة المنتجات المرتبطة'),
                ),
              ),
              SizedBox(width: ResponsiveDimensions.w(12)),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.bottomSheet(
                      DiscountDetailsBottomSheet(controller: controller),
                      isScrollControlled: true,
                      backgroundColor: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: AppColors.primary400,
                  ),
                  child: const Text('عرض التخفيض', style: TextStyle(color: Colors.white)),
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
  final RelatedProductsController controller;
  
  const DiscountDetailsBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final discount = controller.discounts.isNotEmpty ? controller.discounts.last : null;
      
      if (discount == null) {
        return Container(
          height: Get.height * 0.3,
          child: const Center(child: Text('لا توجد تفاصيل تخفيض')),
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
    });
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
          icon: const Icon(Icons.close),
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
        border: const OutlineInputBorder(),
        suffixText: 'ريال',
        prefixIcon: const Icon(Icons.attach_money),
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
          const Text(
            'معلومات التخفيض',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Text('قيمة التخفيض: ${discount.discountAmount.toStringAsFixed(2)} ريال'),
          Text('نسبة التخفيض: ${discount.discountPercentage.toStringAsFixed(1)}%'),
          if (discount.note.isNotEmpty) ...[
            const SizedBox(height: 8),
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
              padding: const EdgeInsets.symmetric(vertical: 12),
              side: const BorderSide(color: Colors.red),
            ),
            child: const Text(
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
                AddDiscountBottomSheet(controller: controller),
                isScrollControlled: true,
                backgroundColor: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: AppColors.primary400,
            ),
            child: const Text('تعديل الخصم', style: TextStyle(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(ProductDiscount discount) {
    Get.dialog(
      AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا الخصم؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              controller.removeDiscount(discount);
              Get.back();
              Get.back();
            },
            child: const Text(
              'حذف',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}