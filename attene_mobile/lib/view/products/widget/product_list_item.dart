import '../../../general_index.dart';

class ProductListItem extends StatelessWidget {
  final Product product;
  final ProductController controller;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;

  const ProductListItem({
    Key? key,
    required this.product,
    required this.controller,
    this.isSelected = false,
    this.onSelectionChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isSelectionMode = controller.isSelectionMode;

    return GestureDetector(
      onLongPress: () {
        if (!isSelectionMode) {
          controller.toggleProductSelection('${product.id}');
        }
      },
      onTap: () {
        if (isSelectionMode) {
          controller.toggleProductSelection('${product.id}');
        } else {
          _showProductOptions();
        }
      },
      child: Column(
        children: [
          Row(
            children: [
              if (isSelectionMode)
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (value) {
                      onSelectionChanged?.call(value ?? false);
                    },
                    activeColor: AppColors.primary400,
                  ),
                ),

              _buildProductImage(context),

              const SizedBox(width: 16),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: getMedium(
                          fontSize: ResponsiveWidgets.getFontSize(
                            context,
                            baseSize: 16,
                          ),
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 6),

                      if (product.sectionId != null && product.sectionId != '0')
                        Row(
                          children: [
                            Icon(
                              Icons.local_offer_outlined,
                              color: Colors.grey[600],
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              controller.getSectionName(product.sectionId!),
                              style: getMedium(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),

              if ((product.status ?? '').toString().trim().isNotEmpty)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.light1000,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.neutral900),
                    ),
                    child: Text(
                      'الحالة: ${product.status}',
                      style: getMedium(fontSize: 12),
                    ),
                  ),
                ),
              const SizedBox(height: 8),

              Text('${product.price ?? '0.0'} ₪', style: getBold()),

              if (!isSelectionMode)
                IconButton(
                  onPressed: _showProductOptions,
                  icon: const Icon(Icons.more_horiz, color: Colors.grey),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),
          Divider(height: 3),
        ],
      ),
    );
  }

  Widget _buildProductImage(BuildContext context) {
    final imageSize = ResponsiveWidgets.getProductImageSize(context);
    return Container(
      width: imageSize,
      height: imageSize,
      margin: const EdgeInsets.all(12),
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
              child: Icon(Icons.image, color: Colors.grey[400], size: 40),
            ),
    );
  }

  void _showProductOptions() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.visibility, color: Colors.blue),
              title: const Text('عرض التفاصيل'),
              onTap: () {
                Get.back();
                _viewProductDetails();
              },
            ),
            ListTile(
              leading: const Icon(Icons.content_copy, color: Colors.orange),
              title: const Text('نسخ المنتج'),
              onTap: () {
                Get.back();
                _copyProduct();
              },
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                spacing: 10,
                children: [
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.primary500.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            SizedBox(height: 15),
                            Icon(
                              Icons.edit,
                              size: ResponsiveDimensions.responsiveFontSize(32),
                              color: AppColors.primary500,
                            ),
                            Text(
                              'تعديل الخدمة',
                              style: getMedium(
                                fontSize: 14,
                                color: AppColors.primary500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.back();
                        _editProduct();
                      },
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.error300.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          spacing: 10,
                          children: [
                            SizedBox(height: 15),
                            Icon(
                              Icons.delete_outline,
                              size: ResponsiveDimensions.responsiveFontSize(32),
                              color: AppColors.error300,
                            ),
                            Text(
                              'حذف الخدمة',
                              style: getMedium(
                                fontSize: 14,
                                color: AppColors.error300,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        Get.back();
                        _confirmDeleteProduct();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _editProduct() {
    if (product.id <= 0) {
      Get.snackbar(
        'تنبيه',
        'معرف المنتج غير صالح',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.to(() => EditProductStepperScreen(productId: product.id));
  }

  void _confirmDeleteProduct() {
    Get.dialog(
      AlertDialog(
        title: const Text('حذف المنتج'),
        content: Text('هل أنت متأكد من حذف المنتج "${product.name}"؟'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteProduct(product);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  void _viewProductDetails() {
    Get.toNamed('/product-details', arguments: product.toJson());
  }

  void _copyProduct() {
    Get.snackbar(
      'نسخ المنتج',
      'تم نسخ المنتج ${product.name}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}