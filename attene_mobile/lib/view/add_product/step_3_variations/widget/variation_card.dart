import '../../../../general_index.dart';
import '../../../../utils/responsive/index.dart';

class VariationCard extends StatefulWidget {
  final dynamic variation;
  final ProductVariationController controller;

  const VariationCard({
    super.key,
    required this.variation,
    required this.controller,
  });

  @override
  State<VariationCard> createState() => _VariationCardState();
}

class _VariationCardState extends State<VariationCard> {
  final Map<String, String?> _selectedValues = {};
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  final Map<String, TextEditingController> _attributeControllers = {};
  late final MediaLibraryController _mediaController;

  @override
  void initState() {
    super.initState();
    _mediaController = Get.find<MediaLibraryController>();
    _initializeData();
  }

  void _initializeData() {
    for (final entry in widget.variation.attributes.entries) {
      _selectedValues[entry.key] = entry.value;
      _attributeControllers[entry.key] = TextEditingController(
        text: entry.value,
      );
    }

    _priceController.text = widget.variation.price.value.toString();
    _skuController.text = widget.variation.sku.value;
    _stockController.text = widget.variation.stock.value.toString();
  }

  @override
  void dispose() {
    _priceController.dispose();
    _skuController.dispose();
    _stockController.dispose();
    for (final controller in _attributeControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    return Card(
      color: Colors.white,
      elevation: 2,
      margin: EdgeInsets.symmetric(
        vertical: ResponsiveDimensions.f(8),
        horizontal: ResponsiveDimensions.f(4),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveDimensions.f(12)),
        side: BorderSide(
          color: widget.variation.isActive.value
              ? AppColors.primary300
              : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(ResponsiveDimensions.f(16)),
        decoration: BoxDecoration(
          color: widget.variation.isActive.value
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
                Row(
                  children: [
                    Text(
                      widget.variation.isActive.value ? 'تفعيل السمة' : 'غير مفعل',
                      style: getRegular(
                        fontSize: ResponsiveDimensions.f(14),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(width: ResponsiveDimensions.f(8)),

                    Switch(
                      value: widget.variation.isActive.value,
                      onChanged: (value) {
                        controller.toggleVariationActive(widget.variation);
                      },
                      activeColor: Colors.green,
                      activeTrackColor: Colors.green[300],
                      inactiveThumbColor: Colors.grey[400],
                      inactiveTrackColor: Colors.grey[300],
                    ),
                  ],
                ),

                Container(
                  width: 40,
                  height: 40,
                  // padding: EdgeInsets.all(ResponsiveDimensions.f(8)),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                        size: ResponsiveDimensions.f(20),
                      ),
                      onPressed: () => _showDeleteConfirmation(),
                    ),
                  ),
                ),
              ],
            ),

            if (controller.selectedAttributes.isNotEmpty)
              _buildAttributesSection(controller, isSmallScreen),

            SizedBox(height: ResponsiveDimensions.f(16)),

            _buildPriceSection(),

            SizedBox(height: ResponsiveDimensions.f(16)),

            _buildImagesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributesSection(
    ProductVariationController controller,
    bool isSmallScreen,
  ) {
    if (isSmallScreen) {
      return _buildSmallScreenAttributes(controller);
    }

    return _buildLargeScreenAttributes(controller);
  }

  Widget _buildSmallScreenAttributes(ProductVariationController controller) {
    List<List<ProductAttribute>> attributePairs = [];

    for (int i = 0; i < controller.selectedAttributes.length; i += 2) {
      if (i + 1 < controller.selectedAttributes.length) {
        attributePairs.add([
          controller.selectedAttributes[i],
          controller.selectedAttributes[i + 1],
        ]);
      } else {
        attributePairs.add([controller.selectedAttributes[i]]);
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('السمات', style: getMedium()),
        SizedBox(height: ResponsiveDimensions.f(12)),

        ...attributePairs.map((pair) {
          return Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildAttributeField(
                      pair[0],
                      _selectedValues[pair[0].name] ??
                          (pair[0].values.isNotEmpty
                              ? pair[0].values.first.value
                              : ''),
                    ),
                  ),

                  if (pair.length > 1) ...[
                    SizedBox(width: ResponsiveDimensions.f(12)),
                    Expanded(
                      child: _buildAttributeField(
                        pair[1],
                        _selectedValues[pair[1].name] ??
                            (pair[1].values.isNotEmpty
                                ? pair[1].values.first.value
                                : ''),
                      ),
                    ),
                  ],
                ],
              ),
              if (pair != attributePairs.last)
                SizedBox(height: ResponsiveDimensions.f(12)),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _buildLargeScreenAttributes(ProductVariationController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('السمات', style: getMedium()),
        SizedBox(height: ResponsiveDimensions.f(12)),

        Wrap(
          spacing: ResponsiveDimensions.f(12),
          runSpacing: ResponsiveDimensions.f(12),
          children: controller.selectedAttributes.map((attribute) {
            final selectedValue =
                _selectedValues[attribute.name] ??
                (attribute.values.isNotEmpty
                    ? attribute.values.first.value
                    : '');

            final attributeCount = controller.selectedAttributes.length;
            double itemWidth;

            if (attributeCount == 1) {
              itemWidth = double.infinity;
            } else if (attributeCount == 2) {
              itemWidth = (MediaQuery.of(context).size.width - 48) / 2;
            } else {
              itemWidth = (MediaQuery.of(context).size.width - 60) / 3;
            }

            return SizedBox(
              width: itemWidth,
              child: _buildAttributeField(attribute, selectedValue),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAttributeField(
    ProductAttribute attribute,
    String selectedValue,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          attribute.name,
          style: getRegular(fontSize: ResponsiveDimensions.f(14)),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: ResponsiveDimensions.f(8)),
        DropdownButtonFormField<String>(
          value: selectedValue,
          items: attribute.values.map((value) {
            return DropdownMenuItem<String>(
              value: value.value,
              child: Row(
                children: [
                  if (value.colorCode != null)
                    Container(
                      width: 16,
                      height: 16,
                      margin: EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: _parseColor(value.colorCode!),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                    ),
                  Expanded(
                    child: Text(
                      value.value,
                      style: getRegular(fontSize: ResponsiveDimensions.f(13)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedValues[attribute.name] = newValue;
              widget.variation.attributes[attribute.name] = newValue!;
              widget.controller.saveCurrentState();
            });
          },
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveDimensions.f(10),
              vertical: ResponsiveDimensions.f(8),
            ),
            border: InputBorder.none,
            hintText: 'اختر ${attribute.name}',
            hintStyle: getRegular(fontSize: ResponsiveDimensions.f(13)),
          ),
          icon: Icon(
            Icons.arrow_drop_down,
            color: Colors.grey[600],
            size: ResponsiveDimensions.f(15),
          ),
          isExpanded: true,
          style: getRegular(fontSize: ResponsiveDimensions.f(13)),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'السعر',
          style: getMedium(
            fontSize: ResponsiveDimensions.f(16),
            color: Colors.black87,
          ),
        ),
        SizedBox(height: ResponsiveDimensions.f(3)),
        SizedBox(
          height: 50,
          child: TextField(

            controller: _priceController,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: '0.0',
              hintStyle: getMedium(fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(ResponsiveDimensions.w(100)),
                borderSide: BorderSide(color: AppColors.primary300, width: 1.0),
              ),
              suffixText: '₪',
            ),

            onChanged: (value) {
              final price = double.tryParse(value) ?? 0.0;
              widget.variation.price.value = price;
              widget.controller.saveCurrentState();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStockSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المخزون',
          style: getMedium(
            fontSize: ResponsiveDimensions.f(16),
            color: Colors.black87,
          ),
        ),
        SizedBox(height: ResponsiveDimensions.f(8)),
        TextField(
          controller: _stockController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'أدخل كمية المخزون',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            prefixIcon: Icon(Icons.inventory_2_outlined, color: Colors.blue),
          ),
          onChanged: (value) {
            final stock = int.tryParse(value) ?? 0;
            widget.variation.stock.value = stock;
            widget.controller.saveCurrentState();
          },
        ),
      ],
    );
  }

  Widget _buildSkuSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('SKU (الرمز التعريفي)', style: getMedium()),
        SizedBox(height: ResponsiveDimensions.f(8)),
        TextField(
          controller: _skuController,
          decoration: InputDecoration(
            hintText: 'أدخل الرمز التعريفي',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            prefixIcon: Icon(Icons.qr_code, color: Colors.orange),
          ),
          onChanged: (value) {
            widget.variation.sku.value = value;
            widget.controller.saveCurrentState();
          },
        ),
      ],
    );
  }

  Widget _buildImagesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'الصور',
              style: getMedium(
                fontSize: ResponsiveDimensions.f(16),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            if (widget.variation.images.isNotEmpty)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${widget.variation.images.length}',
                  style: getBold(fontSize: 12, color: AppColors.primary500),
                ),
              ),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.f(8)),

        if (widget.variation.images.isNotEmpty)
          Column(
            children: [
              SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.variation.images.length,
                  itemBuilder: (context, index) {
                    final imageUrl = widget.variation.images[index];
                    final displayUrl = _mediaController
                        .getDisplayUrlFromStoredValue(imageUrl);
                    return _buildImageItem(imageUrl, index);
                  },
                ),
              ),
              SizedBox(height: ResponsiveDimensions.f(12)),
            ],
          ),
        OutlinedButton.icon(
          onPressed: () => _addImageFromMediaLibrary(),
          style: OutlinedButton.styleFrom(
            backgroundColor: AppColors.primary50,
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveDimensions.f(12),
              vertical: ResponsiveDimensions.f(10),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            side: BorderSide(color: Colors.transparent, width: 1.5),
          ),
          icon: Icon(
            Icons.image_outlined,
            color: AppColors.primary400,
            size: ResponsiveDimensions.f(18),
          ),
          label: Text(
            'قم برفع الصور',
            style: getMedium(
              color: AppColors.primary400,
              fontSize: ResponsiveDimensions.f(13),
            ),
          ),
        ),

        if (widget.variation.images.isEmpty)
          Padding(
            padding: EdgeInsets.only(top: ResponsiveDimensions.f(8)),
            child: Text(
              'لم يتم إضافة أي صور لهذا الاختلاف',
              style: getRegular(
                fontSize: ResponsiveDimensions.f(12),
                color: Colors.grey,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildImageItem(String imageUrl, int index) {
    return Padding(
      padding: EdgeInsets.only(right: index == 0 ? 0 : 8),
      child: Stack(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl,
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
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: -5,
            right: -5,
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 14, color: Colors.white),
              ),
              onPressed: () {
                setState(() {
                  widget.variation.images.remove(imageUrl);
                  widget.controller.saveCurrentState();
                });

                Get.snackbar(
                  'تم الحذف',
                  'تم حذف الصورة',
                  backgroundColor: Colors.green,
                  colorText: Colors.white,
                  duration: Duration(seconds: 2),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _addImageFromMediaLibrary() async {
    try {
      _mediaController.clearSelection();

      final List<MediaItem>? selectedMedia = await Get.to<List<MediaItem>>(
        () => MediaLibraryScreen(isSelectionMode: true),
        arguments: {'maxSelection': 10 - widget.variation.images.length},
      );

      if (selectedMedia != null && selectedMedia.isNotEmpty) {
        final remainingSlots = 10 - widget.variation.images.length;
        if (selectedMedia.length > remainingSlots) {
          Get.snackbar(
            'تنبيه',
            'يمكنك إضافة ${remainingSlots} صور كحد أقصى',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }

        for (var media in selectedMedia) {
          final apiValue = _mediaController.getMediaApiValue(media);
          if (apiValue.isNotEmpty) {
            if (!widget.variation.images.contains(apiValue)) {
              widget.variation.images.add(apiValue);
            }
          } else if (media.isLocal == true && media.path.isNotEmpty) {
            await _uploadLocalImage(media);
          }
        }

        widget.controller.saveCurrentState();
        setState(() {});

        Get.snackbar(
          'نجاح',
          'تم إضافة ${selectedMedia.length} صورة',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      print('خطأ في اختيار الصور: $e');
      Get.snackbar(
        'خطأ',
        'فشل في اختيار الصور',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _takePhotoFromCamera() async {
    try {
      _mediaController.clearSelection();

      if (widget.variation.images.length >= 10) {
        Get.snackbar(
          'تنبيه',
          'يمكنك إضافة 10 صور كحد أقصى',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      await _mediaController.takePhoto();

      await Future.delayed(Duration(seconds: 2));

      if (_mediaController.uploadedMediaItems.isNotEmpty) {
        final uploadedItems = _mediaController.uploadedMediaItems
            .where((item) => item.type == MediaType.image)
            .toList();

        if (uploadedItems.isNotEmpty) {
          final latestMedia = uploadedItems.last;
          final mediaUrl = _mediaController.getMediaDisplayUrl(latestMedia);

          if (mediaUrl.isNotEmpty && mediaUrl.startsWith('http')) {
            if (!widget.variation.images.contains(mediaUrl)) {
              widget.variation.images.add(mediaUrl);
              widget.controller.saveCurrentState();
              setState(() {});

              Get.snackbar(
                'نجاح',
                'تم إضافة الصورة الملتقطة',
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: Duration(seconds: 2),
              );
            }
          }
        }
      }
    } catch (e) {
      print('خطأ في التقاط الصورة: $e');
      Get.snackbar(
        'خطأ',
        'فشل في التقاط الصورة',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _uploadLocalImage(MediaItem media) async {
    try {
      Get.dialog(
        Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      await Future.delayed(Duration(seconds: 3));

      Get.back();

      Get.snackbar(
        'ملاحظة',
        'يجب رفع الصور المحلية أولاً من خلال مكتبة الوسائط',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.back();
      print('خطأ في رفع الصورة المحلية: $e');
    }
  }

  Color _parseColor(String colorCode) {
    try {
      return Color(int.parse(colorCode.replaceAll('#', '0xff')));
    } catch (e) {
      return Colors.grey;
    }
  }

  void _showDeleteConfirmation() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'تأكيد الحذف',
          style: getBold(fontWeight: FontWeight.bold, color: Colors.red),
        ),
        content: Text(
          'هل أنت متأكد من حذف هذا الاختلاف؟',
          style: getRegular(fontSize: ResponsiveDimensions.f(14)),
        ),
        actions: [
          AateneButton(
            onTap: () {
              Get.back();
              widget.controller.removeVariation(widget.variation);
            },

            buttonText: "حدف",
            color: AppColors.error200,
            textColor: AppColors.light1000,
            borderColor: AppColors.error200,
          ),

          SizedBox(
            height: 10,
          ),
          AateneButton(
            onTap: () => Get.back(),
            buttonText: "إلغاء",
            color: AppColors.light1000,
            textColor: AppColors.primary400,
            borderColor: AppColors.primary400,
          ),
        ],
      ),
    );
  }
}
