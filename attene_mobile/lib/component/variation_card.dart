import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:attene_mobile/view/product_variations/product_variation_model.dart';

class VariationCard extends StatelessWidget {
  final ProductVariation variation;
  final Function(ProductVariation)? onEdit;
  final Function(ProductVariation)? onDelete;

  const VariationCard({
    Key? key,
    required this.variation,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(
        vertical: isSmallScreen ? ResponsiveDimensions.f(8) : ResponsiveDimensions.f(12),
        horizontal: isSmallScreen ? ResponsiveDimensions.f(4) : ResponsiveDimensions.f(8),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveDimensions.f(12)),
        side: BorderSide(
          color: variation.isActive.value
              ? AppColors.primary300
              : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? ResponsiveDimensions.f(12) : ResponsiveDimensions.f(16)),
        decoration: BoxDecoration(
          color: variation.isActive.value
              ? AppColors.primary50.withOpacity(0.3)
              : Colors.grey[50],
          borderRadius: BorderRadius.circular(ResponsiveDimensions.f(12)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    variation.displayName,
                    style: TextStyle(
                      fontSize: isSmallScreen
                          ? ResponsiveDimensions.f(14)
                          : ResponsiveDimensions.f(16),
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        variation.toggleActive();
                        if (onEdit != null) onEdit!(variation);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveDimensions.f(8),
                          vertical: ResponsiveDimensions.f(4),
                        ),
                        decoration: BoxDecoration(
                          color: variation.isActive.value
                              ? AppColors.primary400
                              : Colors.grey[400],
                          borderRadius: BorderRadius.circular(ResponsiveDimensions.f(20)),
                        ),
                        child: Text(
                          variation.isActive.value ? 'نشط' : 'غير نشط',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: ResponsiveDimensions.f(12),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: ResponsiveDimensions.f(8)),
                    if (onDelete != null)
                      IconButton(
                        icon: Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                          size: ResponsiveDimensions.f(20),
                        ),
                        onPressed: () => onDelete!(variation),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
              ],
            ),
            
            SizedBox(height: ResponsiveDimensions.f(12)),
            
            if (isSmallScreen)
              _buildSmallDetails(variation, context)
            else
              _buildLargeDetails(variation, context),
            
            SizedBox(height: ResponsiveDimensions.f(12)),
            Container(
              padding: EdgeInsets.all(ResponsiveDimensions.f(8)),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(ResponsiveDimensions.f(8)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.qr_code,
                    size: ResponsiveDimensions.f(16),
                    color: Colors.grey[600],
                  ),
                  SizedBox(width: ResponsiveDimensions.f(8)),
                  Expanded(
                    child: Text(
                      'SKU: ${variation.sku.value}',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.f(12),
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w500,
                      ),
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

  Widget _buildSmallDetails(ProductVariation variation, BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                icon: Icons.attach_money,
                label: 'السعر',
                value: '${variation.price.value} ر.س',
                color: AppColors.primary400,
              ),
            ),
            SizedBox(width: ResponsiveDimensions.f(12)),
            Expanded(
              child: _buildDetailItem(
                icon: Icons.inventory_2,
                label: 'المخزون',
                value: variation.stock.value.toString(),
                color: variation.stock.value > 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.f(12)),
        if (variation.attributes.isNotEmpty)
          Wrap(
            spacing: ResponsiveDimensions.f(8),
            runSpacing: ResponsiveDimensions.f(8),
            children: variation.attributes.entries.map((entry) {
              return Chip(
                label: Text(
                  '${entry.key}: ${entry.value}',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(10),
                  ),
                ),
                backgroundColor: AppColors.primary100,
                labelStyle: TextStyle(
                  color: AppColors.primary500,
                ),
                visualDensity: VisualDensity.compact,
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildLargeDetails(ProductVariation variation, BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildDetailItem(
                icon: Icons.attach_money,
                label: 'السعر',
                value: '${variation.price.value} ر.س',
                color: AppColors.primary400,
              ),
            ),
            SizedBox(width: ResponsiveDimensions.f(16)),
            Expanded(
              child: _buildDetailItem(
                icon: Icons.inventory_2,
                label: 'المخزون',
                value: variation.stock.value.toString(),
                color: variation.stock.value > 0
                    ? Colors.green
                    : Colors.red,
              ),
            ),
            SizedBox(width: ResponsiveDimensions.f(16)),
            Expanded(
              child: _buildDetailItem(
                icon: Icons.tag,
                label: 'الحالة',
                value: variation.stockStatus,
                color: variation.stock.value > 0
                    ? Colors.green
                    : Colors.grey,
              ),
            ),
          ],
        ),
        
        SizedBox(height: ResponsiveDimensions.f(16)),
        
        if (variation.attributes.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'السمات:',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(14),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: ResponsiveDimensions.f(8)),
              Wrap(
                spacing: ResponsiveDimensions.f(12),
                runSpacing: ResponsiveDimensions.f(8),
                children: variation.attributes.entries.map((entry) {
                  return Chip(
                    label: Text(
                      '${entry.key}: ${entry.value}',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.f(12),
                      ),
                    ),
                    backgroundColor: AppColors.primary100,
                    labelStyle: TextStyle(
                      color: AppColors.primary500,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.f(12)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ResponsiveDimensions.f(8)),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: ResponsiveDimensions.f(20),
            color: color,
          ),
          SizedBox(width: ResponsiveDimensions.f(8)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(12),
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.f(4)),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(14),
                    color: color,
                    fontWeight: FontWeight.w700,
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