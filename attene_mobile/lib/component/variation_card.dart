import 'package:attene_mobile/component/media_selector.dart';
import 'package:attene_mobile/utlis/sheet_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import 'package:attene_mobile/view/product_variations/product_variation_controller.dart';
import 'package:attene_mobile/view/product_variations/product_variation_model.dart';
import 'package:attene_mobile/view/Services/data_lnitializer_service.dart';

class VariationCard extends StatefulWidget {
  final ProductVariation variation;
  final VoidCallback? onUpdate;
  final VoidCallback? onRemove;

  const VariationCard({
    super.key,
    required this.variation,
    this.onUpdate,
    this.onRemove,
  });

  @override
  State<VariationCard> createState() => _VariationCardState();
}

class _VariationCardState extends State<VariationCard> {
  final ProductVariationController _variationController = Get.find<ProductVariationController>();
  final BottomSheetController _bottomSheetController = Get.find<BottomSheetController>();
  final DataInitializerService _dataService = Get.find<DataInitializerService>();
  
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  
  final FocusNode _priceFocusNode = FocusNode();
  final FocusNode _stockFocusNode = FocusNode();
  final FocusNode _skuFocusNode = FocusNode();
  
  bool _isExpanded = true;
  bool _isUpdating = false;
  
  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupFocusListeners();
  }
  
  @override
  void didUpdateWidget(covariant VariationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.variation.id != widget.variation.id) {
      _initializeControllers();
    }
  }
  
  void _initializeControllers() {
    _priceController.text = widget.variation.price.value > 0 
        ? widget.variation.price.value.toStringAsFixed(2) 
        : '';
    
    _stockController.text = widget.variation.stock.value > 0 
        ? widget.variation.stock.value.toString() 
        : '';
    
    _skuController.text = widget.variation.sku.value;
  }
  
  void _setupFocusListeners() {
    _priceFocusNode.addListener(() {
      if (!_priceFocusNode.hasFocus && _priceController.text.isNotEmpty) {
        _onPriceChanged(_priceController.text);
      }
    });
    
    _stockFocusNode.addListener(() {
      if (!_stockFocusNode.hasFocus && _stockController.text.isNotEmpty) {
        _onStockChanged(_stockController.text);
      }
    });
    
    _skuFocusNode.addListener(() {
      if (!_skuFocusNode.hasFocus && _skuController.text.isNotEmpty) {
        _onSkuChanged(_skuController.text);
      }
    });
  }
  
  void _onPriceChanged(String value) {
    if (_isUpdating) return;
    
    _isUpdating = true;
    try {
      _variationController.updateVariationPrice(widget.variation, value);
      widget.onUpdate?.call();
    } catch (e) {
      print('❌ [VARIATION CARD] خطأ في تحديث السعر: $e');
    } finally {
      _isUpdating = false;
    }
  }
  
  void _onStockChanged(String value) {
    if (_isUpdating) return;
    
    _isUpdating = true;
    try {
      _variationController.updateVariationStock(widget.variation, value);
      widget.onUpdate?.call();
    } catch (e) {
      print('❌ [VARIATION CARD] خطأ في تحديث المخزون: $e');
    } finally {
      _isUpdating = false;
    }
  }
  
  void _onSkuChanged(String value) {
    if (_isUpdating) return;
    
    _isUpdating = true;
    try {
      _variationController.updateVariationSku(widget.variation, value);
      widget.onUpdate?.call();
    } catch (e) {
      print('❌ [VARIATION CARD] خطأ في تحديث SKU: $e');
    } finally {
      _isUpdating = false;
    }
  }
  
  Future<void> _toggleVariationActive() async {
    try {
      _variationController.toggleVariationActive(widget.variation);
      widget.onUpdate?.call();
      
      Get.snackbar(
        widget.variation.isActive.value ? 'تم التفعيل' : 'تم التعطيل',
        widget.variation.isActive.value 
            ? 'الاختلاف مفعل الآن' 
            : 'الاختلاف معطل الآن',
        backgroundColor: widget.variation.isActive.value ? Colors.green : Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ [VARIATION CARD] خطأ في تغيير حالة الاختلاف: $e');
    }
  }
  
  void _onAddImages(List<String> imageUrls) {
    try {
      for (final imageUrl in imageUrls) {
        if (widget.variation.images.length < 5) {
          _variationController.addImageToVariation(widget.variation, imageUrl);
        } else {
          Get.snackbar(
            'تنبيه',
            'لا يمكن إضافة أكثر من 5 صور لكل اختلاف',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
          break;
        }
      }
      widget.onUpdate?.call();
      
      Get.snackbar(
        'تم الإضافة',
        'تم إضافة ${imageUrls.length} صورة',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ [VARIATION CARD] خطأ في إضافة الصور: $e');
    }
  }
  
  void _onRemoveImage(String imageUrl) {
    try {
      _variationController.removeImageFromVariation(widget.variation, imageUrl);
      widget.onUpdate?.call();
      
      Get.snackbar(
        'تم الحذف',
        'تم حذف الصورة',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      print('❌ [VARIATION CARD] خطأ في حذف الصورة: $e');
    }
  }
  
  void _onRemoveVariation() {
    try {
      _variationController.removeVariation(widget.variation);
      widget.onRemove?.call();
      
      Get.snackbar(
        'تم الحذف',
        'تم حذف الاختلاف',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('❌ [VARIATION CARD] خطأ في حذف الاختلاف: $e');
    }
  }
  
  Future<void> _onAttributeChanged(String attributeName, String attributeValue) async {
    try {
      _variationController.updateVariationAttribute(
        widget.variation, 
        attributeName, 
        attributeValue
      );
      widget.onUpdate?.call();
      
      Get.snackbar(
        'تم التحديث',
        'تم تعيين $attributeValue لـ $attributeName',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 1),
      );
    } catch (e) {
      print('❌ [VARIATION CARD] خطأ في تحديث السمة: $e');
    }
  }
  
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
            if (_isExpanded) ...[
              SizedBox(height: ResponsiveDimensions.h(16)),
              _buildVariationAttributes(),
              SizedBox(height: ResponsiveDimensions.h(16)),
              _buildPriceSection(),
              SizedBox(height: ResponsiveDimensions.h(16)),
              _buildStockAndSkuSection(),
              SizedBox(height: ResponsiveDimensions.h(16)),
              _buildVariationImages(),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildVariationHeader() {
    return Obx(() => Row(
      children: [
        // زر التوسيع/الطي
        IconButton(
          icon: Icon(
            _isExpanded ? Icons.expand_less : Icons.expand_more,
            size: ResponsiveDimensions.w(20),
            color: Colors.grey[600],
          ),
          onPressed: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          tooltip: _isExpanded ? 'طي التفاصيل' : 'عرض التفاصيل',
        ),
        
        SizedBox(width: ResponsiveDimensions.w(8)),
        
        // حالة الاختلاف
        GestureDetector(
          onTap: _toggleVariationActive,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveDimensions.w(12),
              vertical: ResponsiveDimensions.h(6),
            ),
            decoration: BoxDecoration(
              color: widget.variation.isActive.value ? Colors.green[50] : Colors.red[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.variation.isActive.value ? Colors.green : Colors.red,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.variation.isActive.value ? Icons.check_circle : Icons.cancel,
                  size: ResponsiveDimensions.w(14),
                  color: widget.variation.isActive.value ? Colors.green : Colors.red,
                ),
                SizedBox(width: ResponsiveDimensions.w(4)),
                Text(
                  widget.variation.isActive.value ? 'مفعل' : 'معطل',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(12),
                    color: widget.variation.isActive.value ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        SizedBox(width: ResponsiveDimensions.w(8)),
        
        // زر التبديل
        Transform.scale(
          scale: 0.8,
          child: Switch(
            value: widget.variation.isActive.value,
            onChanged: (value) => _toggleVariationActive(),
            activeColor: AppColors.primary400,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        
        Spacer(),
        
        // معلومات الاختلاف
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.w(8),
            vertical: ResponsiveDimensions.h(4),
          ),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.blue[200]!),
          ),
          child: Text(
            'ID: ${widget.variation.id.substring(0, 8)}',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(10),
              color: Colors.blue[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        SizedBox(width: ResponsiveDimensions.w(8)),
        
        // زر الحذف
        IconButton(
          icon: Icon(
            Icons.delete_outline,
            color: Colors.red,
            size: ResponsiveDimensions.w(24)
          ),
          onPressed: () => _showDeleteConfirmation(),
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
            
            // عرض السمات بطريقة ذكية حسب الشاشة
            LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = constraints.maxWidth > 600;
                final crossAxisCount = isWideScreen ? 3 : 2;
                
                return GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: ResponsiveDimensions.w(12),
                    mainAxisSpacing: ResponsiveDimensions.h(12),
                    childAspectRatio: 2.5,
                  ),
                  itemCount: controller.selectedAttributes.length,
                  itemBuilder: (context, index) {
                    final attribute = controller.selectedAttributes[index];
                    return _buildAttributeField(attribute);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildAttributeField(ProductAttribute attribute) {
    final currentValue = widget.variation.attributes[attribute.name] ?? '';
    final hasValue = currentValue.isNotEmpty;
    
    // الحصول على قيم السمة من التخزين المحلي أولاً
    final cachedAttributes = _dataService.getAttributesForVariations();
    ProductAttribute? fullAttribute;
    
    for (final attr in cachedAttributes) {
      if (attr.id == attribute.id) {
        fullAttribute = attr;
        break;
      }
    }
    
    final availableValues = fullAttribute?.values ?? attribute.values;
    
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
        
        // حقل اختيار قيمة السمة
        GestureDetector(
          onTap: () => _showAttributeValueSelection(attribute, availableValues),
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
              color: hasValue ? AppColors.primary50 : Colors.grey[50],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? currentValue : 'اختر ${attribute.name}',
                    style: TextStyle(
                      color: hasValue ? AppColors.primary500 : Colors.grey[600],
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
        Row(
          children: [
            Text(
              'السعر',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(16),
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(width: ResponsiveDimensions.w(8)),
            if (widget.variation.price.value > 0)
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveDimensions.w(8),
                  vertical: ResponsiveDimensions.h(2),
                ),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Text(
                  '${widget.variation.price.value.toStringAsFixed(2)} ريال',
                  style: TextStyle(
                    color: Colors.green[700],
                    fontSize: ResponsiveDimensions.f(12),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.h(8)),
        TextFormField(
          controller: _priceController,
          focusNode: _priceFocusNode,
          onChanged: (value) {
            // تحديث في الوقت الحقيقي
          },
          onFieldSubmitted: (value) {
            _onPriceChanged(value);
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
            suffixStyle: TextStyle(
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
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
              vertical: ResponsiveDimensions.h(14),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.red, width: 1),
            ),
          ),
          validator: (value) {
            if (value != null && value.isNotEmpty) {
              final price = double.tryParse(value);
              if (price == null || price < 0) {
                return 'يرجى إدخال سعر صحيح';
              }
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildStockAndSkuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        'المخزون',
                        style: TextStyle(
                          fontSize: ResponsiveDimensions.f(14),
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[700],
                        ),
                      ),
                      SizedBox(width: ResponsiveDimensions.w(4)),
                      if (widget.variation.stock.value > 0)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveDimensions.w(6),
                            vertical: ResponsiveDimensions.h(1),
                          ),
                          decoration: BoxDecoration(
                            color: widget.variation.stock.value > 10 
                                ? Colors.green[50] 
                                : Colors.orange[50],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: widget.variation.stock.value > 10 
                                  ? Colors.green[200]! 
                                  : Colors.orange[200]!,
                            ),
                          ),
                          child: Text(
                            widget.variation.stock.value.toString(),
                            style: TextStyle(
                              fontSize: ResponsiveDimensions.f(10),
                              color: widget.variation.stock.value > 10 
                                  ? Colors.green[700] 
                                  : Colors.orange[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  SizedBox(height: ResponsiveDimensions.h(6)),
                  TextFormField(
                    controller: _stockController,
                    focusNode: _stockFocusNode,
                    onChanged: (value) {
                      // تحديث في الوقت الحقيقي
                    },
                    onFieldSubmitted: (value) {
                      _onStockChanged(value);
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
                    controller: _skuController,
                    focusNode: _skuFocusNode,
                    onChanged: (value) {
                      // تحديث في الوقت الحقيقي
                    },
                    onFieldSubmitted: (value) {
                      _onSkuChanged(value);
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
                color: widget.variation.images.isEmpty 
                    ? Colors.grey[100] 
                    : AppColors.primary100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: widget.variation.images.isEmpty 
                      ? Colors.grey[300]! 
                      : AppColors.primary200,
                ),
              ),
              child: Text(
                '${widget.variation.images.length} / 5',
                style: TextStyle(
                  color: widget.variation.images.isEmpty 
                      ? Colors.grey[600] 
                      : AppColors.primary400,
                  fontSize: ResponsiveDimensions.f(12),
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
            Spacer(),
            if (widget.variation.images.isNotEmpty)
              Text(
                'انقر على الصورة للحذف',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(10),
                  color: Colors.grey[500],
                ),
              ),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.h(8)),
        
        Obx(() {
          if (widget.variation.images.isEmpty) {
            return _buildNoImagesPlaceholder();
          }
          
          return Wrap(
            spacing: ResponsiveDimensions.w(8),
            runSpacing: ResponsiveDimensions.h(8),
            children: [
              ...widget.variation.images.map((imageUrl) => _buildImageThumbnail(imageUrl)),
              if (widget.variation.images.length < 5) _buildAddImageButton(),
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
        border: Border.all(
          color: Colors.grey[300]!,
          style: BorderStyle.solid,
        ),
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
                offset: const Offset(0, 2),
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
                    offset: const Offset(0, 2),
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
      onMediaSelected: _onAddImages,
      // maxSelection: 5 - widget.variation.images.length,
    );
  }

  Future<void> _showAttributeValueSelection(
    ProductAttribute attribute,
    List<AttributeValue> values
  ) async {
    if (values.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'لا توجد قيم متاحة لـ ${attribute.name}',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final currentValue = widget.variation.attributes[attribute.name] ?? '';
    
    await Get.bottomSheet(
      Container(
        height: Get.height * 0.6,
        padding: EdgeInsets.all(ResponsiveDimensions.w(16)),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
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
                  icon: Icon(
                    Icons.close,
                    size: ResponsiveDimensions.w(24),
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDimensions.h(16)),
            
            Expanded(
              child: ListView.builder(
                itemCount: values.length,
                itemBuilder: (context, index) {
                  final value = values[index];
                  final isSelected = currentValue == value.value;
                  
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
                      _onAttributeChanged(attribute.name, value.value);
                      Get.back();
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: ResponsiveDimensions.w(100),
              height: ResponsiveDimensions.h(100),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: ResponsiveDimensions.h(12)),
            Text(
              'هل أنت متأكد من حذف هذه الصورة؟',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(14),
              ),
            ),
          ],
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
              _onRemoveImage(imageUrl);
              Get.back();
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
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber,
              size: ResponsiveDimensions.w(48),
              color: Colors.red,
            ),
            SizedBox(height: ResponsiveDimensions.h(16)),
            Text(
              'هل أنت متأكد من حذف هذا الاختلاف؟',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(14),
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: ResponsiveDimensions.h(8)),
            Text(
              'لا يمكن التراجع عن هذا الإجراء بعد الحذف.',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(12),
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
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
          ElevatedButton(
            onPressed: () {
              Get.back();
              _onRemoveVariation();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('حذف الاختلاف'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _priceController.dispose();
    _stockController.dispose();
    _skuController.dispose();
    _priceFocusNode.dispose();
    _stockFocusNode.dispose();
    _skuFocusNode.dispose();
    super.dispose();
  }
}