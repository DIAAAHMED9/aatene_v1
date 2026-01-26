import '../../../../general_index.dart';
import '../../../../utils/responsive/index.dart';

class ProductSelectionBottomSheet extends StatefulWidget {
  final RelatedProductsController controller;

  const ProductSelectionBottomSheet({super.key, required this.controller});

  @override
  State<ProductSelectionBottomSheet> createState() =>
      _ProductSelectionBottomSheetState();
}

class _ProductSelectionBottomSheetState
    extends State<ProductSelectionBottomSheet> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_refreshUI);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_refreshUI);
    super.dispose();
  }

  void _refreshUI() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.85,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          // _buildSelectedCount(),
          Expanded(child: _buildProductsList()),
          _buildActionButtons(),
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
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'اختر المنتجات',
            style: getBold(fontSize: ResponsiveDimensions.f(18)),
          ),
          Row(
            children: [
              GetBuilder<RelatedProductsController>(
                id: 'search',
                builder: (controller) {
                  if (!controller.isSearching) return const SizedBox();
                  return IconButton(
                    onPressed: controller.clearSearch,
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  );
                },
              ),
              IconButton(onPressed: Get.back, icon: const Icon(Icons.close)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.w(16),
        vertical: ResponsiveDimensions.h(12),
      ),
      child: TextField(
        controller: widget.controller.searchController,
        decoration: InputDecoration(
          hintText: 'بحث',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: GetBuilder<RelatedProductsController>(
            id: 'search',
            builder: (controller) {
              if (!controller.isSearching) return SizedBox();
              return IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: controller.clearSearch,
              );
            },
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onChanged: (value) {
          widget.controller.setSearchQuery(value);
        },
      ),
    );
  }

  Widget _buildSelectedCount() {
    return GetBuilder<RelatedProductsController>(
      id: 'selected',
      builder: (controller) {
        if (!controller.hasSelectedProducts) return const SizedBox();
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.w(16),
            vertical: ResponsiveDimensions.h(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('المنتجات المختارة:'),
              Chip(
                label: Text('${controller.selectedProductsCount} منتج'),
                backgroundColor: AppColors.primary400.withOpacity(0.2),
                labelStyle: getRegular(color: AppColors.primary400),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductsList() {
    return GetBuilder<RelatedProductsController>(
      id: 'products',
      builder: (controller) {
        final products = controller.filteredProducts;

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  controller.isSearching ? Icons.search_off : Icons.inventory_2,
                  size: 60,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  controller.isSearching
                      ? 'لم يتم العثور على منتجات'
                      : 'لا توجد منتجات',
                  style: getRegular(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.w(16),
            vertical: ResponsiveDimensions.h(8),
          ),
          itemCount: products.length,
          itemBuilder: (context, index) => _buildProductItem(products[index]),
        );
      },
    );
  }

  Widget _buildProductItem(Product product) {
    return GetBuilder<RelatedProductsController>(
      id: 'products',
      builder: (controller) {
        final isSelected = controller.isProductSelected(product);

        return Card(
          margin: EdgeInsets.only(bottom: ResponsiveDimensions.h(8)),
          color: isSelected ? AppColors.primary50 : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: isSelected ? AppColors.primary200 : Colors.grey[200]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: InkWell(
            onTap: () {
              controller.toggleProductSelection(product);
              controller.refreshProducts();
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: EdgeInsets.all(ResponsiveDimensions.w(12)),
              child: Row(
                children: [
                  Checkbox(
                    value: isSelected,
                    onChanged: (_) {
                      controller.toggleProductSelection(product);
                      controller.refreshProducts();
                    },
                    activeColor: AppColors.primary400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),

                  const SizedBox(width: 12),

                  _buildProductImage(product),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: getMedium(
                            fontSize: ResponsiveDimensions.f(14),
                          ),
                        ),

                        const SizedBox(height: 4),

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
                                  fontSize: ResponsiveDimensions.f(10),
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _formatPrice(product.price ?? '0'),
                        style: getBold(
                          fontSize: ResponsiveDimensions.f(14),
                          color: AppColors.primary400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductImage(Product product) {
    final imageSize = ResponsiveDimensions.getProductImageSize(Get.context!);

    if (product.coverUrl != null && product.coverUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.network(
          product.coverUrl!,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(),
          loadingBuilder: (_, child, progress) {
            if (progress == null) return child;
            return Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                            progress.expectedTotalBytes!
                      : null,
                ),
              ),
            );
          },
        ),
      );
    }
    return _buildPlaceholder();
  }

  Widget _buildPlaceholder() {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(Icons.image, color: Colors.grey[400], size: 24),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
        color: Colors.white,
      ),
      child: GetBuilder<RelatedProductsController>(
        id: 'selected',
        builder: (controller) {
          return Column(
            children: [
              // if (controller.hasSelectedProducts)
              //   Padding(
              //     padding: EdgeInsets.only(bottom: ResponsiveDimensions.h(12)),
              //     child: Column(
              //       children: [
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text('المنتجات المختارة:', style: getMedium()),
              //             Text(
              //               '${controller.selectedProductsCount} منتج',
              //               style: getBold(),
              //             ),
              //           ],
              //         ),
              //         const SizedBox(height: 8),
              //         Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Text('السعر الإجمالي:', style: getMedium()),
              //             Text(
              //               '${controller.originalPrice.toStringAsFixed(2)} ₪',
              //               style: getBold(color: AppColors.primary400),
              //             ),
              //           ],
              //         ),
              //       ],
              //     ),
              //   ),
                   AateneButton(
                     color: AppColors.primary400,
                     textColor: AppColors.light1000,
                     borderColor: AppColors.primary400,
                     buttonText: controller.hasSelectedProducts
                         ? 'اضافة'
                         : 'إغلاق',
                     onTap: () {
                       if (controller.hasSelectedProducts) {
                         controller.calculateTotalPrice();
                       }
                       Get.back();
                     },
                   ),
              // Row(
              //   children: [
              //     if (controller.hasSelectedProducts)
              //       Expanded(
              //         child: AateneButton(
              //           color: AppColors.light1000,
              //           textColor: Colors.red,
              //           borderColor: Colors.red.shade400,
              //           buttonText: 'مسح الكل',
              //           onTap: () {
              //             controller.clearAllSelections();
              //             controller.refreshProducts();
              //           },
              //         ),
              //       ),
              //     if (controller.hasSelectedProducts)
              //       SizedBox(width: ResponsiveDimensions.w(8)),
              //     Expanded(
              //       child: AateneButton(
              //         color: AppColors.primary400,
              //         textColor: AppColors.light1000,
              //         borderColor: AppColors.primary400,
              //         buttonText: controller.hasSelectedProducts
              //             ? 'تأكيد'
              //             : 'إغلاق',
              //         onTap: () {
              //           if (controller.hasSelectedProducts) {
              //             controller.calculateTotalPrice();
              //           }
              //           Get.back();
              //         },
              //       ),
              //     ),
              //   ],
              // ),
            ],
          );
        },
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
