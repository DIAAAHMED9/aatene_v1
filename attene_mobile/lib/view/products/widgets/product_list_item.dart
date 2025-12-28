import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/models/product_model.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import '../product_controller.dart';
import 'responsive_widgets.dart';

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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary400.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppColors.primary400, width: 2)
              : Border.all(color: Colors.grey[200]!),
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
                            style: getRegular(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                  ],
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
              leading: const Icon(Icons.edit, color: AppColors.primary400),
              title: const Text('تعديل المنتج'),
              onTap: () {
                Get.back();
                _editProduct();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text('حذف المنتج'),
              onTap: () {
                Get.back();
                _confirmDeleteProduct();
              },
            ),
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
          ],
        ),
      ),
    );
  }

  void _editProduct() {
    Get.snackbar(
      'تحرير المنتج',
      'سيتم فتح شاشة تحرير ${product.name}',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
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
    Get.toNamed('/product-details', arguments: product);
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
