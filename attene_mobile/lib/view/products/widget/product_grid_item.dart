

import '../../../general_index.dart';
import '../../add_product/stepper/screen/edit_product_stepper_screen.dart';

class ProductGridItem extends StatelessWidget {
  final Product product;
  final ProductController controller;
  final bool isSelected;
  final ValueChanged<bool>? onSelectionChanged;

  const ProductGridItem({
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
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: isSelected
              ? BorderSide(color: AppColors.primary400, width: 2)
              : BorderSide(color: Colors.grey[200]!, width: 1),
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 120,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                    color: Colors.grey[200],
                  ),
                  child: Stack(
                    children: [
                      product.coverUrl != null
                          ? ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              child: Image.network(
                                product.coverUrl!,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
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
                                Icons.image,
                                color: Colors.grey[400],
                                size: 40,
                              ),
                            ),

                      if (isSelectionMode)
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Checkbox(
                              value: isSelected,
                              onChanged: (value) {
                                onSelectionChanged?.call(value ?? false);
                              },
                              activeColor: AppColors.primary400,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: getMedium(fontSize: 14, color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 8),

                      if (product.sectionId != null && product.sectionId != '0')
                        Row(
                          children: [
                            Icon(
                              Icons.local_offer_outlined,
                              color: Colors.grey[600],
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                controller.getSectionName(product.sectionId!),
                                style: getRegular(
                                  fontSize: 11,
                                  color: Colors.grey,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 8),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${product.price ?? '0.0'} ر.س',
                            style: getBold(
                              fontSize: 14,
                              color: AppColors.primary400,
                            ),
                          ),

                          if (!isSelectionMode)
                            IconButton(
                              onPressed: _showProductOptions,
                              icon: const Icon(Icons.more_horiz, size: 18),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
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
        child: SafeArea(
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
            ],
          ),
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
}