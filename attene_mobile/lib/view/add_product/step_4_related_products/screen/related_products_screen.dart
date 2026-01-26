import '../../../../general_index.dart';
import '../../../../utils/responsive/index.dart';

class RelatedProductsScreen extends StatelessWidget {
  final bool isLinkingMode;

  const RelatedProductsScreen({super.key, this.isLinkingMode = false});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<RelatedProductsController>();

    return Scaffold(
      backgroundColor: Colors.white,

      body: GetBuilder<RelatedProductsController>(
        init: controller,
        builder: (controller) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  SizedBox(height: ResponsiveDimensions.h(24)),
                  _buildChooseProductsButton(),
                  SizedBox(height: ResponsiveDimensions.h(24)),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildSelectedProductsSection(),
                          SizedBox(height: ResponsiveDimensions.h(24)),
                          _buildDiscountsSection(),
                          SizedBox(height: ResponsiveDimensions.h(32)),
                          _buildBottomActions(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isLinkingMode
              ? 'اختر المنتجات المرتبطة لربطها مع المنتج الرئيسي'
              : 'قم باختيار منتجات لترشيحها في قائمة المنتجات',
          style: getRegular(color: AppColors.colorRelatedProductsScreen),
        ),
      ],
    );
  }

  Widget _buildChooseProductsButton() {
    return Center(
      child: AateneButton(
        borderColor: AppColors.primary400,
        textColor: AppColors.primary400,
        color: AppColors.primary50,
        buttonText: 'اختر المنتجات',
        onTap: () => Get.bottomSheet(
          ProductSelectionBottomSheet(
            controller: Get.find<RelatedProductsController>(),
          ),
          isScrollControlled: true,
          backgroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedProductsSection() {
    return GetBuilder<RelatedProductsController>(
      id: 'selected',
      builder: (controller) {
        if (!controller.hasSelectedProducts) {
          return _buildEmptyState();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'المنتجات المختارة (${controller.selectedProductsCount})',
                  style: getBold(fontSize: ResponsiveDimensions.f(14)),
                ),
                if (controller.hasSelectedProducts)
                  TextButton(
                    onPressed: controller.clearAllSelections,
                    child: Row(
                      children: [
                        Icon(Icons.clear_all, color: Colors.red, size: 16),
                        const SizedBox(width: 4),
                        Text('مسح الكل', style: getRegular(color: Colors.red)),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: ResponsiveDimensions.h(5)),
            _buildSelectedProductsList(),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        spacing: 15,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/svg_images/background_change.svg',
            semanticsLabel: 'My SVG Image',
            height: 160,
            width: 160,
          ),

          Text(
            'لم يتم اختيار أي منتجات بعد',
            style: getRegular(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedProductsList() {
    return GetBuilder<RelatedProductsController>(
      id: 'selected',
      builder: (controller) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.selectedProducts.length,
          itemBuilder: (context, index) {
            final product = controller.selectedProducts[index];
            return _buildProductCard(product);
          },
        );
      },
    );
  }

  Widget _buildProductCard(Product product) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildProductImage(product),

          const SizedBox(width: 12),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: getMedium(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),
                  if (product.sectionName != null &&
                      product.sectionName!.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.local_offer_outlined,
                          size: 12,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Text(
                          product.sectionName!,
                          style: getRegular(
                            fontSize: ResponsiveDimensions.f(14),
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Column(
              spacing: 4,
              children: [
                Text(
                  _formatPrice(product.price ?? '0'),
                  style: getBold(fontSize: 14),
                ),
                IconButton(
                  onPressed: () => Get.find<RelatedProductsController>()
                      .removeSelectedProduct(product),
                  icon: Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductImage(Product product) {
    final imageSize = ResponsiveDimensions.getProductImageSize(Get.context!);

    return Container(
      width: imageSize,
      height: imageSize,
      margin: const EdgeInsets.all(12),
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
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[200],
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey[400],
                      size: 40,
                    ),
                  );
                },
              ),
            )
          : Container(
              color: Colors.grey[200],
              child: Icon(
                Icons.shopping_bag,
                color: Colors.grey[400],
                size: 40,
              ),
            ),
    );
  }

  Widget _buildDiscountsSection() {
    return GetBuilder<RelatedProductsController>(
      id: 'discounts',
      builder: (controller) {
        if (controller.discounts.isEmpty) return const SizedBox();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التخفيضات المضافة (${controller.discountCount})',
              style: getBold(fontSize: ResponsiveDimensions.f(18)),
            ),
            SizedBox(height: ResponsiveDimensions.h(16)),
            _buildDiscountsList(),
          ],
        );
      },
    );
  }

  Widget _buildDiscountsList() {
    return GetBuilder<RelatedProductsController>(
      id: 'discounts',
      builder: (controller) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.discounts.length,
          itemBuilder: (context, index) {
            final discount = controller.discounts[index];
            return _buildDiscountCard(discount);
          },
        );
      },
    );
  }

  Widget _buildDiscountCard(ProductDiscount discount) {
    return Card(
      color: Colors.white,
      margin: EdgeInsets.only(bottom: ResponsiveDimensions.h(12)),
      child: ListTile(
        leading: const Icon(Icons.discount, color: Colors.green),
        title: Text('خصم ${discount.discountPercentage.toStringAsFixed(1)}%'),
        subtitle: Text('${discount.productCount} منتج'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.visibility),
              onPressed: () => Get.bottomSheet(
                DiscountDetailsBottomSheet(
                  controller: Get.find<RelatedProductsController>(),
                  discount: discount,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => _showDeleteConfirmation(discount),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return GetBuilder<RelatedProductsController>(
      id: 'summary',
      builder: (controller) {
        if (!controller.hasSelectedProducts) return const SizedBox();

        return Container(
          padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 8),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('السعر الإجمالي:', style: getMedium()),
                  Text(
                    '${controller.originalPrice.toStringAsFixed(2)} ₪',
                    style: getBold(color: AppColors.primary400),
                  ),
                ],
              ),
              SizedBox(height: ResponsiveDimensions.h(20)),
              Column(
                children: [
                  if (isLinkingMode) ...[
                    AateneButton(
                      buttonText: 'ربط مع المنتج الرئيسي',
                      onTap: () {
                        controller.linkToProductCentral();
                        Get.back();
                      },
                    ),
                  ] else ...[
                       AateneButton(
                      borderColor: AppColors.primary400,
                      textColor: AppColors.light1000,
                      color: AppColors.primary400,
                      buttonText: 'التالي',
                      onTap: () => _showSuccessMessage(),
                    ),
                                        SizedBox(height: ResponsiveDimensions.w(12)),

                    AateneButton(
                      borderColor: AppColors.primary400,
                      textColor: AppColors.primary400,
                      color: AppColors.light1000,
                      buttonText: 'تخفيض علي المنتجات المختارة',
                      onTap: () => Get.bottomSheet(
                        AddDiscountBottomSheet(
                          controller: Get.find<RelatedProductsController>(),
                        ),
                      ),
                    ),
                 
                  ],
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSuccessMessage() {
    Get.snackbar(
      'نجاح',
      'تم حفظ المنتجات المرتبطة بنجاح',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _showDeleteConfirmation(ProductDiscount discount) {
    Get.dialog(
      AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا التخفيض؟'),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              Get.find<RelatedProductsController>().removeDiscount(discount);
              Get.back();
            },
            child: Text('حذف', style: getRegular(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  String _formatPrice(String price) {
    try {
      final cleanPrice = price.replaceAll(RegExp(r'[^\d.]'), '');
      final priceDouble = double.tryParse(cleanPrice) ?? 0.0;
      return '${priceDouble.toStringAsFixed(2)} ₪';
    } catch (e) {
      return '0.00 ₪';
    }
  }
}
