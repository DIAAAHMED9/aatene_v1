import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/models/section_model.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/utlis/responsive/responsive_dimensions.dart';
import '../../../media_library/media_model.dart';
import '../add_product_controller.dart';

class SectionTitleWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;
  
  const SectionTitleWidget({
    super.key,
    required this.title,
    this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Text(
        title,
        style: TextStyle(
          fontSize: ResponsiveDimensions.f(18),
          fontWeight: FontWeight.bold,
          color: AppColors.primary400,
        ),
      ),
    );
  }
}

class CategorySectionWidget extends StatelessWidget {
  final Section selectedSection;
  
  const CategorySectionWidget({
    super.key,
    required this.selectedSection,
  });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(ResponsiveDimensions.f(16)),
      decoration: BoxDecoration(
        color: AppColors.primary300Alpha10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedSection.name,
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(16),
              fontWeight: FontWeight.bold,
              color: AppColors.primary400,
            ),
          ),
          SizedBox(height: ResponsiveDimensions.f(8)),
          Text(
            'منتجات خاصة بالملابس و متعلقاتها',
            style: TextStyle(
              fontSize: ResponsiveDimensions.f(14),
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
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
            Row(
              children: [
                Text(
                  'الصوز',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                   Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: ResponsiveDimensions.f(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDimensions.f(5)),
            Text(
              'يمكنك إضافة حتى (10) صور و (1) فيديو',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(12),
                color: Colors.black,
              ),
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
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(12),
                  color: AppColors.primary400,
                ),
              ),
            ),
            SizedBox(height: ResponsiveDimensions.f(16)),
            
            if (controller.selectedMedia.isNotEmpty)
              _buildSelectedMediaPreview(context),
            
            InkWell(
              onTap: controller.openMediaLibrary,
              child: Container(
                height: ResponsiveDimensions.f(120),
                padding: EdgeInsets.symmetric(horizontal: ResponsiveDimensions.f(15)),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F8F8),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.all(ResponsiveDimensions.f(7)),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Icon(
                        Icons.add,
                        size: ResponsiveDimensions.f(25),
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: ResponsiveDimensions.f(8)),
                    Text(
                      'اضف او اسحب صورة او فيديو',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.f(14),
                        color: Colors.grey[600],
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
      height: ResponsiveDimensions.f(100),
      margin: EdgeInsets.only(bottom: ResponsiveDimensions.f(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الصور المختارة (${controller.selectedMedia.length})',
            style: TextStyle(
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
      width: ResponsiveDimensions.f(80),
      height: ResponsiveDimensions.f(80),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: ResponsiveDimensions.f(8),
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
  
  const ProductNameSectionWidget({
    super.key,
    required this.isRTL,
  });
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'اسم المنتج',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: ResponsiveDimensions.f(4)),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red[400],
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.f(8)),
        GetBuilder<AddProductController>(
          builder: (_) {
            return TextFiledAatene(
              fillColor: Colors.transparent,
              heightTextFiled: ResponsiveDimensions.f(50),
              controller: controller.productNameController,
              isRTL: isRTL,
              hintText: 'أدخل اسم المنتج',
              onChanged: (value) {},
            );
          },
        ),
        SizedBox(height: ResponsiveDimensions.f(8)),
        Text(
          'قم بتضمين الكلمات الرئيسية التي يستخدمها المشترون للبحث عن هذا العنصر.',
          style: TextStyle(
            fontSize: ResponsiveDimensions.f(12),
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class PriceSectionWidget extends StatelessWidget {
  final bool isRTL;
  
  const PriceSectionWidget({
    super.key,
    required this.isRTL,
  });
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AddProductController>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'السعر',
              style: TextStyle(
                fontSize: ResponsiveDimensions.f(16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: ResponsiveDimensions.f(4)),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red[400],
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.f(8)),
        GetBuilder<AddProductController>(
          builder: (_) {
            return TextFiledAatene(
              heightTextFiled: ResponsiveDimensions.f(50),
              controller: controller.priceController,
              isRTL: isRTL,
              hintText: 'السعر',
              onChanged: (value) {},
              suffixIcon: Padding(
                padding: EdgeInsets.only(top: ResponsiveDimensions.f(12)),
                child: Text(
                  '₪',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              fillColor: Colors.transparent,
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
            Row(
              children: [
                Text(
                  'الفئات',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: ResponsiveDimensions.f(4)),
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red[400],
                  ),
                ),
                const Spacer(),
                if (hasError || (categories.isEmpty && !isLoading))
                  IconButton(
                    icon: Icon(
                      Icons.refresh,
                      size: ResponsiveDimensions.f(20),
                    ),
                    onPressed: controller.reloadCategories,
                    tooltip: 'إعادة تحميل الفئات',
                  ),
              ],
            ),
            SizedBox(height: ResponsiveDimensions.f(8)),
            
            if (isLoading)
              _buildLoadingDropdown('جاري تحميل الفئات...'),
            
            if (!isLoading && hasError)
              _buildErrorDropdown(controller.categoriesError),
            
            if (!isLoading && !hasError && categories.isEmpty)
              _buildEmptyDropdown('لا توجد فئات متاحة'),
            
            if (!isLoading && !hasError && categories.isNotEmpty)
              _buildCategoriesDropdown(controller),
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
            style: TextStyle(
              color: Colors.grey[600],
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
                  style: TextStyle(
                    color: Colors.red[600],
                    fontSize: ResponsiveDimensions.f(14),
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
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: ResponsiveDimensions.f(14),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildCategoriesDropdown(AddProductController controller) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(25),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<String>(
          isExpanded: true,
          value: controller.selectedCategoryName.isEmpty
              ? null
              : controller.selectedCategoryName,
          decoration: InputDecoration(
            hintText: 'اختر فئة المنتج',
            hintStyle: TextStyle(
              fontSize: ResponsiveDimensions.f(14),
              color: Colors.grey[600],
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(
              horizontal: ResponsiveDimensions.f(16),
              vertical: ResponsiveDimensions.f(16),
            ),
            isCollapsed: true,
          ),
          items: controller.categories.map((category) {
            final categoryName = category['name'] as String? ?? 'غير معروف';
            final categoryId = category['id'] as int? ?? 0;
            return DropdownMenuItem(
              value: categoryName,
              child: Text(
                categoryName,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: ResponsiveDimensions.f(14),
                  color: categoryId == controller.productCentralController.selectedCategoryId.value
                      ? AppColors.primary400
                      : Colors.black,
                  fontWeight: categoryId == controller.productCentralController.selectedCategoryId.value
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              final foundCategory = controller.categories.firstWhere(
                (cat) => cat['name'] == value,
                orElse: () => {},
              );
              if (foundCategory.isNotEmpty) {
                final categoryId = foundCategory['id'] as int;
                controller.updateCategory(categoryId);
              }
            }
          },
        ),
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
            Row(
              children: [
                Text(
                  'حالة المنتج',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: ResponsiveDimensions.f(4)),
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red[400],
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDimensions.f(8)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(25),
              ),
              child: DropdownButtonFormField<String>(
                value: controller.selectedCondition.isEmpty
                    ? null
                    : controller.selectedCondition,
                decoration: InputDecoration(
                  hintText: 'اختر حالة المنتج',
                  hintStyle: TextStyle(
                    fontSize: ResponsiveDimensions.f(14),
                    color: Colors.grey[600],
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
                        fontSize: ResponsiveDimensions.f(14),
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
                onChanged: controller.updateCondition,
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
            Row(
              children: [
                Text(
                  'وصف المنتج',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.f(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: ResponsiveDimensions.f(4)),
                Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red[400],
                  ),
                ),
              ],
            ),
            SizedBox(height: ResponsiveDimensions.f(8)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: controller.productDescriptionController,
                maxLines: 4,
                maxLength: AddProductController.maxDescriptionLength,
                onChanged: (value) {},
                decoration: InputDecoration(
                  hintText: 'وصف المنتج',
                  hintStyle: TextStyle(
                    fontSize: ResponsiveDimensions.f(14),
                    color: Colors.grey[600],
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(ResponsiveDimensions.f(12)),
                  counterText: '${controller.characterCount}/${AddProductController.maxDescriptionLength}',
                  counterStyle: TextStyle(
                    color: controller.characterCount > AddProductController.maxDescriptionLength
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
              ),
            ),
            if (controller.characterCount > AddProductController.maxDescriptionLength)
              Padding(
                padding: EdgeInsets.only(top: ResponsiveDimensions.f(4)),
                child: Text(
                  'تجاوزت الحد الأقصى للحروف',
                  style: TextStyle(
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

class NextButtonWidget extends StatelessWidget {
  final Section selectedSection;
  
  const NextButtonWidget({
    super.key,
    required this.selectedSection,
  });
  
  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    final controller = Get.find<AddProductController>();
    
    return GetBuilder<AddProductController>(
      builder: (_) {
        return Center(
          child: AateneButton(
            color: controller.isFormValid ? AppColors.primary400 : Colors.grey[400]!,
            textColor: Colors.white,
            borderColor: Colors.transparent,
            buttonText: isRTL ? 'التالي' : 'Next',
            onTap: controller.isFormValid
                ? () => controller.saveBasicInfo(selectedSection)
                : null,
          ),
        );
      },
    );
  }
}