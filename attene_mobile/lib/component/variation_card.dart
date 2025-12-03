import 'package:attene_mobile/component/media_selector.dart';
import 'package:attene_mobile/utlis/sheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:attene_mobile/view/product_variations/product_variation_controller.dart';
import 'package:attene_mobile/view/product_variations/product_variation_model.dart';

class VariationCard extends StatelessWidget {
  final ProductVariation variation;
  final ProductVariationController controller = Get.find<ProductVariationController>();
  final BottomSheetController bottomSheetController = Get.find<BottomSheetController>();

  VariationCard({super.key, required this.variation});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: ResponsiveDimensions.h(16)),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildVariationHeader(),
            SizedBox(height: ResponsiveDimensions.h(16)),
            _buildVariationAttributes(),
            SizedBox(height: ResponsiveDimensions.h(16)),
            _buildPriceSection(),
            SizedBox(height: ResponsiveDimensions.h(16)),
            _buildStockAndSkuSection(),
            SizedBox(height: ResponsiveDimensions.h(16)),
            _buildVariationImages(),
          ],
        ),
      ),
    );
  }

  Widget _buildVariationHeader() {
    return Obx(() => Row(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.w(12),
            vertical: ResponsiveDimensions.h(6),
          ),
          decoration: BoxDecoration(
            color: variation.isActive.value ? Colors.green[50] : Colors.red[50],
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: variation.isActive.value ? Colors.green : Colors.red,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                variation.isActive.value ? Icons.check_circle : Icons.cancel,
                size: ResponsiveDimensions.w(14),
                color: variation.isActive.value ? Colors.green : Colors.red,
              ),
              SizedBox(width: ResponsiveDimensions.w(4)),
              Text(
                variation.isActive.value ? 'مفعل' : 'معطل',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(12),
                  color: variation.isActive.value ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(width: ResponsiveDimensions.w(8)),
        
        Switch(
          value: variation.isActive.value,
          onChanged: (value) => controller.toggleVariationActive(variation),
          activeColor: AppColors.primary400,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        
        Spacer(),
        
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Colors.red,
            size: ResponsiveDimensions.w(24)
          ),
          onPressed: _showDeleteConfirmation,
          tooltip: 'حذف الاختلاف',
        ),
      ],
    ));
  }

Widget _buildVariationAttributes() {
  return GetBuilder<ProductVariationController>(
    id: ProductVariationController.attributesUpdateId,
    builder: (controller) {
      if (controller.selectedAttributes.isEmpty) {
        return _buildNoAttributes();
      }
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Text(
                'السمات',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(16),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              SizedBox(width: ResponsiveDimensions.w(8)),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveDimensions.w(8),
                  vertical: ResponsiveDimensions.h(2),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${controller.selectedAttributes.length}',
                  style: TextStyle(
                    color: AppColors.primary400,
                    fontSize: ResponsiveDimensions.f(12),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              IconButton(
                icon: Icon(
                  Icons.settings,
                  size: ResponsiveDimensions.w(18),
                  color: AppColors.primary400,
                ),
                onPressed: () => controller.openAttributesManagement(),
                tooltip: 'إدارة السمات',
              ),
            ],
          ),
          SizedBox(height: ResponsiveDimensions.h(12)),
          
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _getGridCrossAxisCount(),
              crossAxisSpacing: ResponsiveDimensions.w(12),
              mainAxisSpacing: ResponsiveDimensions.h(12),
              childAspectRatio: _getChildAspectRatio(),
            ),
            itemCount: controller.selectedAttributes.length,
            itemBuilder: (context, index) {
              final attribute = controller.selectedAttributes[index];
              return _buildAttributeField(attribute);
            },
          ),
        ],
      );
    },
  );
}

  Widget _buildAttributeField(ProductAttribute attribute) {
    return Obx(() {
      final currentValue = variation.attributes[attribute.name] ?? 'اختر ${attribute.name}';
      final hasValue = variation.attributes.containsKey(attribute.name);
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  attribute.name,
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(14),
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (hasValue)
                Container(
                  margin: EdgeInsets.only(left: ResponsiveDimensions.w(4)),
                  width: ResponsiveDimensions.w(8),
                  height: ResponsiveDimensions.w(8),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          SizedBox(height: ResponsiveDimensions.h(6)),
          
          GestureDetector(
            onTap: () => _showAttributeSelectionSheet(attribute),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveDimensions.w(12),
                vertical: ResponsiveDimensions.h(12),
              ),
              decoration: BoxDecoration(
                border: Border.all(
                  color: hasValue ? AppColors.primary300 : Colors.grey[300]!,
                  width: hasValue ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
                color: hasValue ? AppColors.primary100 : Colors.grey[50],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      currentValue,
                      style: TextStyle(
                        color: hasValue ? AppColors.primary400 : Colors.grey[600],
                        fontSize: ResponsiveDimensions.f(14),
                        fontWeight: hasValue ? FontWeight.w500 : FontWeight.normal,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: hasValue ? AppColors.primary400 : Colors.grey[500],
                    size: ResponsiveDimensions.w(20),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildNoAttributes() {
    return Container(
      padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber_outlined,
            color: Colors.orange[600],
            size: ResponsiveDimensions.w(20),
          ),
          SizedBox(width: ResponsiveDimensions.w(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'لا توجد سمات محددة',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(14),
                    color: Colors.orange[800],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.h(4)),
                Text(
                  'قم بإدارة السمات أولاً لتعيين القيم',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(12),
                    color: Colors.orange[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'السعر',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(16),
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        SizedBox(height: ResponsiveDimensions.h(8)),
        TextFormField(
          initialValue: variation.price.value > 0 ? variation.price.value.toStringAsFixed(2) : '',
          onChanged: (value) {
            if (value.isNotEmpty) {
              controller.updateVariationPrice(variation, value);
            }
          },
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: '0.00',
            prefixIcon: Icon(
              Icons.attach_money,
              size: ResponsiveDimensions.w(20),
              color: Colors.grey[600],
            ),
            suffixText: 'ريال',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary400, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveDimensions.w(12),
              vertical: ResponsiveDimensions.h(14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStockAndSkuSection() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'المخزون',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(14),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: ResponsiveDimensions.h(6)),
              TextFormField(
                initialValue: variation.stock.value > 0 ? variation.stock.value.toString() : '',
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    controller.updateVariationStock(variation, value);
                  }
                },
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: '0',
                  prefixIcon: Icon(
                    Icons.inventory_2_outlined,
                    size: ResponsiveDimensions.w(18),
                    color: Colors.grey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primary400, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveDimensions.w(12),
                    vertical: ResponsiveDimensions.h(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(width: ResponsiveDimensions.w(12)),
        
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'SKU',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(14),
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: ResponsiveDimensions.h(6)),
              TextFormField(
                initialValue: variation.sku.value.isNotEmpty ? variation.sku.value : '',
                onChanged: (value) {
                  controller.updateVariationSku(variation, value);
                },
                decoration: InputDecoration(
                  hintText: 'SKU_001',
                  prefixIcon: Icon(
                    Icons.code,
                    size: ResponsiveDimensions.w(18),
                    color: Colors.grey[600],
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: AppColors.primary400, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveDimensions.w(12),
                    vertical: ResponsiveDimensions.h(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVariationImages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              'الصور',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(16),
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(width: ResponsiveDimensions.w(8)),
            Obx(() => Container(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveDimensions.w(8),
                vertical: ResponsiveDimensions.h(2),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${variation.images.length}',
                style: TextStyle(
                  color: AppColors.primary400,
                  fontSize: ResponsiveDimensions.f(12),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.h(8)),
        
        Obx(() {
          if (variation.images.isEmpty) {
            return _buildNoImagesPlaceholder();
          }
          
          return Wrap(
            spacing: ResponsiveDimensions.w(8),
            runSpacing: ResponsiveDimensions.h(8),
            children: [
              ...variation.images.map((imageUrl) => _buildImageThumbnail(imageUrl)),
              if (variation.images.length < 5) _buildAddImageButton(),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildNoImagesPlaceholder() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveDimensions.w(20)),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[50],
      ),
      child: Column(
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: ResponsiveDimensions.w(40),
            color: Colors.grey[400],
          ),
          SizedBox(height: ResponsiveDimensions.h(8)),
          Text(
            'لا توجد صور',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(14),
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: ResponsiveDimensions.h(4)),
          Text(
            'انقر على زر الإضافة لرفع الصور',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(12),
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildImageThumbnail(String imageUrl) {
    return Stack(
      children: [
        Container(
          width: ResponsiveDimensions.w(80),
          height: ResponsiveDimensions.h(80),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.cover,
            ),
            border: Border.all(color: Colors.grey[300]!),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
        Positioned(
          top: ResponsiveDimensions.h(2),
          right: ResponsiveDimensions.w(2),
          child: GestureDetector(
            onTap: () => _showImageDeleteConfirmation(imageUrl),
            child: Container(
              width: ResponsiveDimensions.w(20),
              height: ResponsiveDimensions.h(20),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: ResponsiveDimensions.w(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAddImageButton() {
    return MediaSelector(
      onMediaSelected: (List<String> imageUrls) {
        for (final imageUrl in imageUrls) {
          if (variation.images.length < 5) {
            controller.addImageToVariation(variation, imageUrl);
          } else {
            Get.snackbar(
              'تنبيه',
              'لا يمكن إضافة أكثر من 5 صور',
              backgroundColor: Colors.orange,
              colorText: Colors.white,
              duration: Duration(seconds: 2),
            );
            break;
          }
        }
      },
    );
  }

  void _showAttributeSelectionSheet(ProductAttribute attribute) {
    final selectedValues = attribute.values.where((v) => v.isSelected.value).toList();
    
    if (selectedValues.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'لا توجد قيم متاحة لـ ${attribute.name}',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    Get.bottomSheet(
      Container(
        height: Get.height * 0.6,
        padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'اختر ${attribute.name}',
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
            ),
            SizedBox(height: ResponsiveDimensions.h(16)),
            
            Expanded(
              child: ListView.builder(
                itemCount: selectedValues.length,
                itemBuilder: (context, index) {
                  final value = selectedValues[index];
                  final isSelected = variation.attributes[attribute.name] == value.value;
                  
                  return ListTile(
                    leading: Container(
                      width: ResponsiveDimensions.w(24),
                      height: ResponsiveDimensions.h(24),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primary400 : Colors.grey[400]!,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: ResponsiveDimensions.w(12),
                          height: ResponsiveDimensions.h(12),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected ? AppColors.primary400 : Colors.transparent,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      value.value,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primary400 : Colors.black87,
                      ),
                    ),
                    onTap: () {
                      controller.updateVariationAttribute(variation, attribute.name, value.value);
                      Get.back();
                      Get.snackbar(
                        'تم التحديث',
                        'تم تعيين $value لـ ${attribute.name}',
                        backgroundColor: Colors.green,
                        colorText: Colors.white,
                        duration: Duration(seconds: 2),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      enableDrag: true,
    );
  }

  void _showImageDeleteConfirmation(String imageUrl) {
    Get.dialog(
      AlertDialog(
        title: Text(
          'تأكيد الحذف',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'هل أنت متأكد من حذف هذه الصورة؟',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.removeImageFromVariation(variation, imageUrl);
              Get.back();
              Get.snackbar(
                'تم الحذف',
                'تم حذف الصورة بنجاح',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: Duration(seconds: 2),
              );
            },
            child: Text(
              'حذف',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'تأكيد الحذف',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'هل أنت متأكد من حذف هذا الاختلاف؟ لا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(14),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'إلغاء',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.removeVariation(variation);
              Get.back();
              Get.snackbar(
                'تم الحذف',
                'تم حذف الاختلاف بنجاح',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: Duration(seconds: 2),
              );
            },
            child: Text(
              'حذف',
              style: TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  int _getGridCrossAxisCount() {
    final screenWidth = Get.width;
    if (screenWidth > 600) return 3;
    if (screenWidth > 400) return 2;
    return 1;
  }

  double _getChildAspectRatio() {
    final screenWidth = Get.width;
    if (screenWidth > 600) {
      return (screenWidth / 3 - ResponsiveDimensions.w(24)) / ResponsiveDimensions.h(100);
    } else if (screenWidth > 400) {
      return (screenWidth / 2 - ResponsiveDimensions.w(24)) / ResponsiveDimensions.h(100);
    } else {
      return (screenWidth - ResponsiveDimensions.w(32)) / ResponsiveDimensions.h(80);
    }
  }
}