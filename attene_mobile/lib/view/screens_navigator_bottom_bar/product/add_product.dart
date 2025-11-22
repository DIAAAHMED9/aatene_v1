// lib/view/screens_navigator_bottom_bar/product/add_product_content.dart
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/view/advance_info/keyword_management_screen.dart';
import 'package:attene_mobile/view/media_library/media_library_controller.dart';
import 'package:attene_mobile/view/media_library/media_model.dart';
import 'package:attene_mobile/view/product_variations/product_variations_screen.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/add_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/view/media_library/media_library_screen.dart';

class AddProductContent extends StatefulWidget {
  const AddProductContent({super.key});

  @override
  _AddProductContentState createState() => _AddProductContentState();
}

class _AddProductContentState extends State<AddProductContent> {
  final isRTL = LanguageUtils.isRTL;
  final AddProductController addProductController = Get.find<AddProductController>();
  final MediaLibraryController mediaController = Get.find<MediaLibraryController>();
  
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _productConditionController = TextEditingController();
  
  String _selectedCategory = '';
  String _selectedCondition = '';
  
  List<String> _productConditions = ['جديد', 'مستعمل', 'مجدول'];
  List<String> _categories = ['ملابس', 'أحذية', 'إلكترونيات', 'منزلية'];
  
  int _characterCount = 0;
  final int _maxDescriptionLength = 140;

  @override
  Widget build(BuildContext context) {
        print('🔴 AddProductContent built'); // 🔴 راقب في الكونسول

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              Get.to(KeywordManagementScreen());
            },
            child: _buildSectionTitle('المعلومات الأساسية')),
          const SizedBox(height: 20),
          
          _buildCategorySection(),
          const SizedBox(height: 20),
          
          InkWell(
            onTap: _openMediaLibrary,
            child: _buildImageUploadSection(),
          ),
          const SizedBox(height: 20),
          
          _buildProductNameSection(),
          const SizedBox(height: 20),
          
          _buildPriceSection(),
          const SizedBox(height: 20),
        
          _buildProductConditionSection(),
          const SizedBox(height: 20),

          _buildCategoriesSection(),
          const SizedBox(height: 20),
          
          _buildProductDescriptionSection(),
          const SizedBox(height: 20),
          
          _buildNextButton(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ... باقي الدوال تبقى كما هي بدون أي تغيير ...
  void _openMediaLibrary() async {
    final List<MediaItem>? result = await Get.to(
      () => MediaLibraryScreen(
        isSelectionMode: true,
        onMediaSelected: (selectedMedia) {
          addProductController.updateSelectedMedia(selectedMedia);
        },
      ),
    );
    
    if (result != null) {
      addProductController.updateSelectedMedia(result);
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary400,
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary300Alpha10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الملابس والأحذية',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'منتجات خاصة بالملابس و متعلقاتها',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الصور *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'يمكنك إضافة حتى (10) صور و (1) فيديو',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 22,
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 1,horizontal: 10),
          decoration: BoxDecoration(
            color: AppColors.primary300Alpha10,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'يمكنك سحب وافلات الصورة لاعادة ترتيب الصور',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.primary400,
            ),
          ),
        ),
        const SizedBox(height: 16),
        
        if (addProductController.selectedMediaList.isNotEmpty) 
          _buildSelectedMediaPreview(),
        
        Container(
          height: 120,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: const Icon(Icons.add, size: 25, color: Colors.black)),
              const SizedBox(height: 8),
              Text(
                'اضف او اسحب صورة او فيديو',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'png , jpg , svg',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }

  Widget _buildSelectedMediaPreview() {
    return Container(
      height: 100,
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الصور المختارة (${addProductController.selectedMediaList.length})',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: addProductController.selectedMediaList.length,
              itemBuilder: (context, index) {
                final media = addProductController.selectedMediaList[index];
                return _buildSelectedMediaItem(media, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedMediaItem(MediaItem media, int index) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Stack(
        children: [
          media.type == MediaType.image
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/placeholder.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(Icons.image, size: 30, color: Colors.grey[400]);
                    },
                  ),
                )
              : Container(
                  color: Colors.grey[200],
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.videocam, color: Colors.grey[500]),
                        Text(
                          'فيديو',
                          style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ),
        
          Positioned(
            top: 4,
            left: 4,
            child: GestureDetector(
              onTap: () {
                addProductController.removeMedia(index);
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(4),
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
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 8,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'اسم المنتج',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red[400],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFiledAatene(
          fillColor: Colors.transparent,
          heightTextFiled: 50,
          controller: _productNameController,
          isRTL: isRTL,
          hintText: 'أدخل اسم المنتج',
        ),
        const SizedBox(height: 8),
        Text(
          'قم بتضمين الكلمات الرئيسية التي يستخدمها المشترون للبحث عن هذا العنصر.',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildProductDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'وصف المنتج',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red[400],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _productDescriptionController,
            maxLines: 4,
            maxLength: _maxDescriptionLength,
            onChanged: (value) {
              setState(() {
                _characterCount = value.length;
              });
            },
            decoration: InputDecoration(
              hintText: 'وصف المنتج',
              hintStyle: const TextStyle(fontSize: 14),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(12),
              counterText: '$_characterCount/$_maxDescriptionLength',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'السعر',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red[400],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextFiledAatene(
          heightTextFiled: 50,
          controller: _priceController,
          isRTL: isRTL,
          hintText: 'السعر',
          suffixIcon: const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              '₪',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          fillColor: Colors.transparent,
        ),
      ]
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'الفئات',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red[400],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(25),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedCategory.isEmpty ? null : _selectedCategory,
            decoration: InputDecoration(
              hintText: 'ابحث عن اسم الفئة التي ترغب بإضافة منتجك إليها',
              hintStyle: const TextStyle(fontSize: 12),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            items: _categories.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCategory = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductConditionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'حالة المنتج',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red[400],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(25),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedCondition.isEmpty ? null : _selectedCondition,
            decoration: const InputDecoration(
              hintText: 'اختر حالة المنتج',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
            items: _productConditions.map((condition) {
              return DropdownMenuItem(
                value: condition,
                child: Text(condition),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCondition = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNextButton() {
    return Center(
      child: AateneButton(
        color: AppColors.primary400,
        textColor: Colors.white,
        borderColor: Colors.transparent,
        buttonText: isRTL ? 'التالي' : 'Next',
        onTap: () {
          if (_validateForm()) {
            Get.to( ProductVariationsScreen());
            _goToNextStep();
          }
        },
      ),
    );
  }

  bool _validateForm() {
    if (_productNameController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال اسم المنتج', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (_productDescriptionController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال وصف المنتج', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (_priceController.text.isEmpty) {
      Get.snackbar('خطأ', 'يرجى إدخال سعر المنتج', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (_selectedCategory.isEmpty) {
      Get.snackbar('خطأ', 'يرجى اختيار الفئة', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    if (_selectedCondition.isEmpty) {
      Get.snackbar('خطأ', 'يرجى اختيار حالة المنتج', backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
    return true;
  }

  void _goToNextStep() {
    Get.snackbar('نجاح', 'تم حفظ المعلومات الأساسية بنجاح', backgroundColor: Colors.green, colorText: Colors.white);
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productDescriptionController.dispose();
    _priceController.dispose();
    _categoryController.dispose();
    _productConditionController.dispose();
    super.dispose();
  }
}