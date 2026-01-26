import '../../../../general_index.dart';
import '../../../../utils/responsive/index.dart';
import '../index.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  const SectionTitleWidget({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: getBold(
          fontSize: ResponsiveDimensions.f(18),
          color: AppColors.primary400,
        ),
      ),
    );
  }
}

class CategorySectionWidget extends StatelessWidget {
  final Section selectedSection;

  const CategorySectionWidget({super.key, required this.selectedSection});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();

    return GetBuilder<AddProductController>(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(ResponsiveDimensions.f(16)),
              decoration: BoxDecoration(
                color: AppColors.primary300Alpha10,
                borderRadius: BorderRadius.circular(12),
                border: controller.fieldErrors.containsKey('section')
                    ? Border.all(color: Colors.red, width: 1)
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedSection.name,
                    style: getBold(
                      fontSize: ResponsiveDimensions.f(16),
                      color: AppColors.primary400,
                    ),
                  ),
                  SizedBox(height: ResponsiveDimensions.f(8)),
                  Text(
                    'منتجات خاصة بالملابس و متعلقاتها',
                    style: getRegular(
                      fontSize: ResponsiveDimensions.f(14),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (controller.fieldErrors.containsKey('section'))
              Padding(
                padding: EdgeInsets.only(
                  top: ResponsiveDimensions.f(4),
                  left: ResponsiveDimensions.f(12),
                ),
                child: Text(
                  controller.fieldErrors['section']!,
                  style: getRegular(
                    color: Colors.red,
                    fontSize: ResponsiveDimensions.f(12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class ImageUploadSectionWidget extends StatelessWidget {
  const ImageUploadSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();

    return GetBuilder<AddProductController>(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWithStar(text: "الصور"),
            SizedBox(height: ResponsiveDimensions.f(5)),
            Text(
              'يمكنك إضافة حتى (10) صور و (1) فيديو',
              style: getRegular(fontSize: ResponsiveDimensions.f(12)),
            ),
            SizedBox(height: ResponsiveDimensions.f(8)),
            Container(
              height: ResponsiveDimensions.f(22),
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: ResponsiveDimensions.f(1),
                horizontal: ResponsiveDimensions.f(10),
              ),
              decoration: BoxDecoration(
                color: AppColors.primary300Alpha10,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'يمكنك سحب وافلات الصورة لاعادة ترتيب الصور',
                style: getRegular(
                  fontSize: ResponsiveDimensions.f(12),
                  color: AppColors.primary400,
                ),
              ),
            ),
            SizedBox(height: ResponsiveDimensions.f(16)),

            if (controller.fieldErrors.containsKey('media'))
              Padding(
                padding: EdgeInsets.only(bottom: ResponsiveDimensions.f(8)),
                child: Text(
                  controller.fieldErrors['media']!,
                  style: getRegular(
                    color: Colors.red,
                    fontSize: ResponsiveDimensions.f(12),
                  ),
                ),
              ),

            if (controller.selectedMedia.isNotEmpty)
              _buildSelectedMediaPreview(context),

            InkWell(
              onTap: controller.openMediaLibrary,
              child: Container(
                height: ResponsiveDimensions.f(120),
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveDimensions.f(15),
                ),
                decoration: BoxDecoration(
                  color: AppColors.customAddProductWidgets,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: controller.fieldErrors.containsKey('media')
                        ? Colors.red
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(ResponsiveDimensions.f(7)),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(
                          color: controller.fieldErrors.containsKey('media')
                              ? Colors.red
                              : Colors.black,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.add,
                        size: ResponsiveDimensions.f(25),
                        color: controller.fieldErrors.containsKey('media')
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                    SizedBox(height: ResponsiveDimensions.f(8)),
                    Text(
                      'اضف او اسحب صورة او فيديو',
                      style: getRegular(
                        fontSize: ResponsiveDimensions.f(14),
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: ResponsiveDimensions.f(4)),
                    Text(
                      'png , jpg , svg',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.f(12),
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSelectedMediaPreview(BuildContext context) {
    final controller = Get.find<AddProductController>();

    return Container(
      height: ResponsiveDimensions.f(150),
      margin: EdgeInsets.only(bottom: ResponsiveDimensions.f(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الصور المختارة (${controller.selectedMedia.length})',
            style: getMedium(
              fontSize: ResponsiveDimensions.f(14),
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: ResponsiveDimensions.f(8)),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.selectedMedia.length,
              itemBuilder: (context, index) {
                final media = controller.selectedMedia[index];
                return _buildSelectedMediaItem(media, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedMediaItem(MediaItem media, int index) {
    final controller = Get.find<AddProductController>();

    return Container(
      width: ResponsiveDimensions.f(150),
      height: ResponsiveDimensions.f(150),
      margin: EdgeInsets.only(left: ResponsiveDimensions.f(8)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              media.path ?? 'https://via.placeholder.com/150',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[200],
                  child: Icon(
                    Icons.image,
                    size: ResponsiveDimensions.f(30),
                    color: Colors.grey[400],
                  ),
                );
              },
            ),
          ),

          Positioned(
            top: ResponsiveDimensions.f(4),
            left: ResponsiveDimensions.f(4),
            child: GestureDetector(
              onTap: () => controller.removeMedia(index),
              child: Container(
                width: ResponsiveDimensions.f(20),
                height: ResponsiveDimensions.f(20),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: ResponsiveDimensions.f(14),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(ResponsiveDimensions.f(4)),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
              child: Text(
                media.name.length > 12
                    ? '${media.name.substring(0, 12)}...'
                    : media.name,
                style: getRegular(
                  color: Colors.white,
                  fontSize: ResponsiveDimensions.f(10),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductNameSectionWidget extends StatelessWidget {
  final bool isRTL;

  const ProductNameSectionWidget({super.key, required this.isRTL});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWithStar(text: "اسم المنتج"),
        SizedBox(height: ResponsiveDimensions.f(8)),
        GetBuilder<AddProductController>(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFiledAatene(
                  fillColor: Colors.transparent,
                  heightTextFiled: ResponsiveDimensions.f(50),
                  controller: controller.productNameController,
                  isRTL: isRTL,
                  hintText: 'أدخل اسم المنتج',
                  errorText: controller.fieldErrors.containsKey('productName')
                      ? controller.fieldErrors['productName']
                      : null,
                  onChanged: (value) {
                    if (controller.fieldErrors.containsKey('productName')) {
                      controller.fieldErrors.remove('productName');
                      controller.productCentralController.validationErrors
                          .remove('productName');
                      controller.update();
                    }
                  },
                  textInputAction: TextInputAction.next, textInputType: TextInputType.name,
                ),
                if (controller.fieldErrors.containsKey('productName'))
                  Padding(
                    padding: EdgeInsets.only(
                      top: ResponsiveDimensions.f(4),
                      left: ResponsiveDimensions.f(12),
                    ),
                    child: Text(
                      controller.fieldErrors['productName']!,
                      style: getRegular(
                        color: Colors.red,
                        fontSize: ResponsiveDimensions.f(12),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
        SizedBox(height: ResponsiveDimensions.f(8)),
        Text(
          'قم بتضمين الكلمات الرئيسية التي يستخدمها المشترون للبحث عن هذا العنصر.',
          style: getRegular(
            fontSize: ResponsiveDimensions.f(12),
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

class PriceSectionWidget extends StatelessWidget {
  final bool isRTL;

  const PriceSectionWidget({super.key, required this.isRTL});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWithStar(text: "السعر"),
        SizedBox(height: ResponsiveDimensions.f(8)),
        GetBuilder<AddProductController>(
          builder: (_) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFiledAatene(
                  heightTextFiled: ResponsiveDimensions.f(50),
                  controller: controller.priceController,
                  textInputType: TextInputType.number,
                  isRTL: isRTL,
                  hintText: 'السعر',
                  errorText: controller.fieldErrors.containsKey('price')
                      ? controller.fieldErrors['price']
                      : null,
                  onChanged: (value) {
                    if (controller.fieldErrors.containsKey('price')) {
                      controller.fieldErrors.remove('price');
                      controller.productCentralController.validationErrors
                          .remove('price');
                      controller.update();
                    }
                  },
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(top: 7),
                    child: Text(
                      '₪',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.f(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  fillColor: Colors.transparent,
                  textInputAction: TextInputAction.next,
                ),
                if (controller.fieldErrors.containsKey('price'))
                  Padding(
                    padding: EdgeInsets.only(
                      top: ResponsiveDimensions.f(4),
                      left: ResponsiveDimensions.f(12),
                    ),
                    child: Text(
                      controller.fieldErrors['price']!,
                      style: getRegular(
                        color: Colors.red,
                        fontSize: ResponsiveDimensions.f(12),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class CategoriesSectionWidget extends StatelessWidget {
  const CategoriesSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();

    return GetBuilder<AddProductController>(
      builder: (_) {
        final isLoading = controller.isLoadingCategories;
        final hasError = controller.categoriesError.isNotEmpty;
        final categories = controller.categories;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWithStar(text: "الفئات"),
            SizedBox(height: ResponsiveDimensions.f(8)),

            if (isLoading) _buildLoadingDropdown('جاري تحميل الفئات...'),

            if (!isLoading && hasError)
              _buildErrorDropdown(controller.categoriesError),

            if (!isLoading && !hasError && categories.isEmpty)
              _buildEmptyDropdown('لا توجد فئات متاحة'),

            if (!isLoading && !hasError && categories.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.fieldErrors.containsKey('category')
                            ? Colors.red
                            : Colors.grey[300]!,
                        width: 1.5,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: controller.selectedCategoryName.isEmpty
                            ? null
                            : controller.selectedCategoryName,
                        decoration: InputDecoration(
                          hintText: 'اختر فئة المنتج',
                          hintStyle: getRegular(
                            fontSize: ResponsiveDimensions.f(12),
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: ResponsiveDimensions.f(16),
                            vertical: ResponsiveDimensions.f(16),
                          ),
                          isCollapsed: true,
                        ),
                        items: categories.map((category) {
                          final categoryName =
                              category['name'] as String? ?? 'غير معروف';
                          final categoryId = category['id'] as int? ?? 0;
                          return DropdownMenuItem(
                            value: categoryName,
                            child: Text(
                              categoryName,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                fontFamily: "PingAR",
                                fontSize: ResponsiveDimensions.f(12),
                                color:
                                    categoryId ==
                                        controller
                                            .productCentralController
                                            .selectedCategoryId
                                            .value
                                    ? AppColors.primary400
                                    : Colors.black,
                                fontWeight:
                                    categoryId ==
                                        controller
                                            .productCentralController
                                            .selectedCategoryId
                                            .value
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            final foundCategory = categories.firstWhere(
                              (cat) => cat['name'] == value,
                              orElse: () => {},
                            );
                            if (foundCategory.isNotEmpty) {
                              final categoryId = foundCategory['id'] as int;
                              controller.updateCategory(categoryId);

                              if (controller.fieldErrors.containsKey(
                                'category',
                              )) {
                                controller.fieldErrors.remove('category');
                                controller
                                    .productCentralController
                                    .validationErrors
                                    .remove('category');
                                controller.update();
                              }
                            }
                          }
                        },
                      ),
                    ),
                  ),
                  if (controller.fieldErrors.containsKey('category'))
                    Padding(
                      padding: EdgeInsets.only(
                        top: ResponsiveDimensions.f(4),
                        left: ResponsiveDimensions.f(12),
                      ),
                      child: Text(
                        controller.fieldErrors['category']!,
                        style: getRegular(
                          color: Colors.red,
                          fontSize: ResponsiveDimensions.f(12),
                        ),
                      ),
                    ),
                ],
              ),
          ],
        );
      },
    );
  }

  Widget _buildLoadingDropdown(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.f(16),
        vertical: ResponsiveDimensions.f(16),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          SizedBox(
            width: ResponsiveDimensions.f(20),
            height: ResponsiveDimensions.f(20),
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: ResponsiveDimensions.f(12)),
          Text(
            text,
            style: getRegular(
              color: Colors.grey,
              fontSize: ResponsiveDimensions.f(14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorDropdown(String error) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.f(16),
            vertical: ResponsiveDimensions.f(16),
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red[300]!),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red,
                size: ResponsiveDimensions.f(20),
              ),
              SizedBox(width: ResponsiveDimensions.f(12)),
              Expanded(
                child: Text(
                  error,
                  style: getRegular(
                    color: Colors.red,
                    fontSize: ResponsiveDimensions.f(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: ResponsiveDimensions.f(8)),
        ElevatedButton.icon(
          onPressed: () => Get.find<AddProductController>().reloadCategories(),
          icon: Icon(Icons.refresh),
          label: Text('إعادة المحاولة'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyDropdown(String text) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.f(16),
        vertical: ResponsiveDimensions.f(16),
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(
            Icons.category_outlined,
            color: Colors.grey[500],
            size: ResponsiveDimensions.f(20),
          ),
          SizedBox(width: ResponsiveDimensions.f(12)),
          Text(
            text,
            style: getRegular(
              color: Colors.grey,
              fontSize: ResponsiveDimensions.f(12),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductConditionSectionWidget extends StatelessWidget {
  const ProductConditionSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();

    return GetBuilder<AddProductController>(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWithStar(text: "حالة المنتج"),
            SizedBox(height: ResponsiveDimensions.f(8)),
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: controller.fieldErrors.containsKey('condition')
                      ? Colors.red
                      : Colors.grey[300]!,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(100),
              ),
              child: DropdownButtonFormField<String>(
                value: controller.selectedCondition.isEmpty
                    ? null
                    : controller.selectedCondition,
                decoration: InputDecoration(
                  hintText: 'اختر حالة المنتج',
                  hintStyle: getRegular(
                    fontSize: ResponsiveDimensions.f(12),
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: ResponsiveDimensions.f(16),
                    vertical: ResponsiveDimensions.f(16),
                  ),
                  isCollapsed: true,
                ),
                items: controller.conditions.map((condition) {
                  return DropdownMenuItem(
                    value: condition,
                    child: Text(
                      condition,
                      style: TextStyle(
                        fontFamily: "PingAR",
                        fontSize: ResponsiveDimensions.f(12),
                        color: condition == controller.selectedCondition
                            ? AppColors.primary400
                            : Colors.black,
                        fontWeight: condition == controller.selectedCondition
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.updateCondition(value);

                  if (controller.fieldErrors.containsKey('condition')) {
                    controller.fieldErrors.remove('condition');
                    controller.productCentralController.validationErrors.remove(
                      'condition',
                    );
                    controller.update();
                  }
                },
              ),
            ),
            if (controller.fieldErrors.containsKey('condition'))
              Padding(
                padding: EdgeInsets.only(
                  top: ResponsiveDimensions.f(4),
                  left: ResponsiveDimensions.f(12),
                ),
                child: Text(
                  controller.fieldErrors['condition']!,
                  style: getRegular(
                    color: Colors.red,
                    fontSize: ResponsiveDimensions.f(12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class ProductDescriptionSectionWidget extends StatelessWidget {
  const ProductDescriptionSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();

    return GetBuilder<AddProductController>(
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWithStar(text: 'وصف المنتج'),
            SizedBox(height: ResponsiveDimensions.f(8)),
            TextField(
              controller: controller.productDescriptionController,
              maxLines: 4,
              maxLength: AddProductController.maxDescriptionLength,
              onChanged: (value) {
                if (controller.fieldErrors.containsKey('productDescription')) {
                  controller.fieldErrors.remove('productDescription');
                  controller.productCentralController.validationErrors.remove(
                    'productDescription',
                  );
                  controller.update();
                }
              },
              decoration: InputDecoration(
                hintText: 'وصف المنتج',
                hintStyle: getRegular(
                  fontSize: ResponsiveDimensions.f(12),
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(ResponsiveDimensions.f(12)),
                counterText:
                    '${controller.characterCount}/${AddProductController.maxDescriptionLength}',
                counterStyle: TextStyle(
                  fontFamily: "PingAR",
                  color:
                      controller.characterCount >
                          AddProductController.maxDescriptionLength
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
            ),
            if (controller.fieldErrors.containsKey('productDescription'))
              Padding(
                padding: EdgeInsets.only(
                  top: ResponsiveDimensions.f(4),
                  left: ResponsiveDimensions.f(12),
                ),
                child: Text(
                  controller.fieldErrors['productDescription']!,
                  style: getRegular(
                    color: Colors.red,
                    fontSize: ResponsiveDimensions.f(12),
                  ),
                ),
              ),
            if (controller.characterCount >
                AddProductController.maxDescriptionLength)
              Padding(
                padding: EdgeInsets.only(top: ResponsiveDimensions.f(4)),
                child: Text(
                  'تجاوزت الحد الأقصى للحروف',
                  style: getRegular(
                    fontSize: ResponsiveDimensions.f(12),
                    color: Colors.red,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
