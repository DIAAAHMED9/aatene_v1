import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/controller/product_controller.dart';
import 'package:attene_mobile/view/advance_info/keyword_management_screen.dart';
import 'package:attene_mobile/view/media_library/media_library_controller.dart';
import 'package:attene_mobile/view/media_library/media_library_screen.dart';
import 'package:attene_mobile/view/media_library/media_model.dart';
import 'package:attene_mobile/view/product_variations/product_variations_screen.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/add_product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';

import '../../../models/section_model.dart';
import '../../../utlis/sheet_controller.dart';
import 'product_controller.dart';

class AddProductContent extends StatefulWidget {
  const AddProductContent({super.key});

  @override
  _AddProductContentState createState() => _AddProductContentState();
}

class _AddProductContentState extends State<AddProductContent> {
  final isRTL = LanguageUtils.isRTL;
  final AddProductController addProductController = Get.find<AddProductController>();
  final ProductCentralController productController = Get.find<ProductCentralController>();
  final ProductController productMainController = Get.find<ProductController>();
  final MediaLibraryController mediaController = Get.find<MediaLibraryController>();
  final BottomSheetController bottomSheetController = Get.find<BottomSheetController>();
  
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  
  String _selectedCategory = '';
  int _selectedCategoryId = 0;
  String _selectedCondition = '';
  
  List<String> _productConditions = ['جديد', 'مستعمل', 'مجدول'];
  
  int _characterCount = 0;
  final int _maxDescriptionLength = 140;
  
  // متغيرات لتتبع القسم المختار
  Section? _selectedSection;
  String _selectedSectionName = '';
  String _selectedSectionDescription = '';

  @override
  void initState() {
    super.initState();
    _loadStoredData();
    _loadSelectedSection();
    print('🔴 [ADD PRODUCT CONTENT INITIALIZED]');
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      productController.loadCategoriesIfNeeded();
    });
  }

  void _loadStoredData() {
    if (productController.productName.isNotEmpty) {
      _productNameController.text = productController.productName.value;
    }
    if (productController.productDescription.isNotEmpty) {
      _productDescriptionController.text = productController.productDescription.value;
      _characterCount = productController.productDescription.value.length;
    }
    if (productController.price.isNotEmpty) {
      _priceController.text = productController.price.value;
    }
    if (productController.selectedCondition.isNotEmpty) {
      _selectedCondition = productController.selectedCondition.value;
    }
    if (productController.selectedCategoryId > 0) {
      final category = productController.categories.firstWhere(
        (cat) => cat['id'] == productController.selectedCategoryId.value,
        orElse: () => {},
      );
      if (category.isNotEmpty) {
        _selectedCategory = category['name'];
        _selectedCategoryId = category['id'];
      }
    }

    print('''
📥 [DATA LOADED FROM CONTROLLER]:
   الاسم: ${_productNameController.text}
   الفئة: $_selectedCategory ($_selectedCategoryId)
   السعر: ${_priceController.text}
   الحالة: $_selectedCondition
''');
  }

  void _loadSelectedSection() {
    // محاولة الحصول على القسم المختار من عدة مصادر
    try {
      // 1. من BottomSheetController
      if (bottomSheetController.selectedSection != null) {
        _selectedSection = bottomSheetController.selectedSection;
        _selectedSectionName = _selectedSection!.name;
        _selectedSectionDescription = 'منتجات خاصة بـ ${_selectedSection!.name}';
        
        print('✅ [SECTION] تم تحميل القسم من BottomSheet: $_selectedSectionName');
      }
      // 2. من ProductController
      else if (productMainController.selectedSection != null) {
        _selectedSection = productMainController.selectedSection;
        _selectedSectionName = _selectedSection!.name;
        _selectedSectionDescription = 'منتجات خاصة بـ ${_selectedSection!.name}';
        
        print('✅ [SECTION] تم تحميل القسم من ProductController: $_selectedSectionName');
      }
      // 3. من ProductCentralController
      else if (productController.selectedSection.value != null) {
        _selectedSection = productController.selectedSection.value;
        _selectedSectionName = _selectedSection!.name;
        _selectedSectionDescription = 'منتجات خاصة بـ ${_selectedSection!.name}';
        
        print('✅ [SECTION] تم تحميل القسم من ProductCentralController: $_selectedSectionName');
      }
      // 4. الافتراضي
      else {
        _selectedSectionName = 'الملابس والأحذية';
        _selectedSectionDescription = 'منتجات خاصة بالملابس و متعلقاتها';
        
        print('⚠️ [SECTION] استخدام القسم الافتراضي: $_selectedSectionName');
      }
      
      // تحديث ProductCentralController بالقسم المختار
      if (_selectedSection != null) {
        productController.updateSelectedSection(_selectedSection!);
      }
    } catch (e) {
      print('❌ [SECTION] خطأ في تحميل القسم: $e');
      _selectedSectionName = 'الملابس والأحذية';
      _selectedSectionDescription = 'منتجات خاصة بالملابس و متعلقاتها';
    }
  }

  @override
  Widget build(BuildContext context) {
    print('🔴 [ADD PRODUCT CONTENT BUILT]');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              Get.to(() => KeywordManagementScreen());
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

  void _openMediaLibrary() async {
    print('🖼️ [OPENING MEDIA LIBRARY]');
    
    final List<MediaItem>? result = await Get.to(
      () => MediaLibraryScreen(
        isSelectionMode: true,
        onMediaSelected: (selectedMedia) {
          addProductController.updateSelectedMedia(selectedMedia);
          productController.selectedMedia.assignAll(selectedMedia);
          
          print('✅ [MEDIA SELECTED]: ${selectedMedia.length} عنصر');
          productController.printDataSummary();
        },
      ),
    );

    if (result != null) {
      addProductController.updateSelectedMedia(result);
      productController.selectedMedia.assignAll(result);
      print('✅ [MEDIA UPDATED]: ${result.length} عنصر');
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
    return InkWell(
      onTap: () {
        // فتح شاشة اختيار الأقسام
        _openSectionSelection();
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.primary300Alpha10,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _selectedSection != null ? AppColors.primary400 : Colors.grey[300]!,
            width: _selectedSection != null ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    _selectedSectionName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: _selectedSection != null ? AppColors.primary400 : Colors.black87,
                    ),
                  ),
                ),
                if (_selectedSection != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary400.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.primary400,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'محدد',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              _selectedSectionDescription,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            
            if (_selectedSection != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.blue,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'سيتم إضافة المنتج إلى هذا القسم',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
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

  void _openSectionSelection() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'تغيير قسم المنتج',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            if (_selectedSection != null)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'القسم الحالي:',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            _selectedSectionName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Get.back();
                bottomSheetController.openManageSections();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary400,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'اختيار قسم آخر',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Get.back();
                bottomSheetController.openAddNewSection();
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('إنشاء قسم جديد'),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildImageUploadSection() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الصور *',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        
        if (productController.selectedMedia.isNotEmpty)
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
            'الصور المختارة (${productController.selectedMedia.length})',
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
              itemCount: productController.selectedMedia.length,
              itemBuilder: (context, index) {
                final media = productController.selectedMedia[index];
                return _buildSelectedMediaItem(media, index);
              },
            ),
          ),
        ],
      )
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
                  child: Image.network(
                    media.path ?? '',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image,
                        size: 30,
                        color: Colors.grey[400],
                      );
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
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
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
                productController.selectedMedia.removeAt(index);
                print('🗑️ [MEDIA REMOVED]: index $index');
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          onChanged: (value) {
            productController.productName(value);
          },
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              productController.productDescription(value);
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          onChanged: (value) {
            productController.price(value);
          },
          suffixIcon: const Padding(
            padding: EdgeInsets.only(top: 12),
            child: Text(
              '₪',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          fillColor: Colors.transparent,
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Obx(() {
      final isLoading = productController.isLoadingCategories.value;
      final hasError = productController.categoriesError.value.isNotEmpty;
      final categories = productController.categories;
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'الفئات',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Text(
                '*',
                style: TextStyle(
                  color: Colors.red[400],
                ),
              ),
              Spacer(),
              if (hasError || (categories.isEmpty && !isLoading))
                IconButton(
                  icon: Icon(Icons.refresh, size: 20),
                  onPressed: () => productController.reloadCategories(),
                  tooltip: 'إعادة تحميل الفئات',
                ),
            ],
          ),
          const SizedBox(height: 8),
          
          if (isLoading)
            _buildLoadingDropdown('جاري تحميل الفئات...'),
          
          if (!isLoading && hasError)
            _buildErrorDropdown(productController.categoriesError.value),
          
          if (!isLoading && !hasError && categories.isEmpty)
            _buildEmptyDropdown('لا توجد فئات متاحة'),
          
          if (!isLoading && !hasError && categories.isNotEmpty)
            _buildCategoriesDropdown(),
        ],
      );
    });
  }

  Widget _buildLoadingDropdown(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorDropdown(String error) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red[300]!),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 20),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  error,
                  style: TextStyle(color: Colors.red[600]),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () => productController.reloadCategories(),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          Icon(Icons.category_outlined, color: Colors.grey[500]),
          SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      )
    );
  }

  Widget _buildCategoriesDropdown() {
    return Obx(() {
      final categories = productController.categories;
      
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(25),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            value: _selectedCategory.isEmpty ? null : _selectedCategory,
            decoration: InputDecoration(
              hintText: 'ابحث عن اسم الفئة',
              hintStyle: const TextStyle(fontSize: 12),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              isCollapsed: true,
            ),
            items: categories.map((category) {
              final categoryName = category['name'] as String? ?? 'غير معروف';
              return DropdownMenuItem(
                value: categoryName,
                child: Text(
                  categoryName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 14),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCategory = value;
                  final foundCategory = categories.firstWhere(
                    (cat) => cat['name'] == value,
                    orElse: () => {},
                  );
                  if (foundCategory.isNotEmpty) {
                    _selectedCategoryId = foundCategory['id'] as int;
                    productController.selectedCategoryId(_selectedCategoryId);
                  }
                });
                print('✅ [CATEGORY SELECTED]: $value (ID: $_selectedCategoryId)');
              }
            },
          ),
        ),
      );
    });
  }

  Widget _buildProductConditionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'حالة المنتج',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
              return DropdownMenuItem(value: condition, child: Text(condition));
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedCondition = value;
                });
                productController.selectedCondition(value);
                print('✅ [CONDITION SELECTED]: $value');
              }
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
            _saveBasicInfo();
            Get.to(() => ProductVariationsScreen());
          }
        },
      ),
    );
  }

  bool _validateForm() {
    if (_productNameController.text.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى إدخال اسم المنتج',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if (_productDescriptionController.text.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى إدخال وصف المنتج',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if (_priceController.text.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى إدخال سعر المنتج',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if (_selectedCategory.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار الفئة',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    if (_selectedCondition.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار حالة المنتج',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
    // التحقق من وجود قسم محدد
    if (_selectedSection == null) {
      Get.snackbar(
        'تنبيه',
        'يرجى اختيار قسم للمنتج',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      _openSectionSelection();
      return false;
    }
    
    return true;
  }

  void _saveBasicInfo() {
    productController.updateBasicInfo(
      name: _productNameController.text,
      description: _productDescriptionController.text,
      productPrice: _priceController.text,
      categoryId: _selectedCategoryId,
      condition: _selectedCondition,
      media: productController.selectedMedia,
      section: _selectedSection,
    );
    
    print('💾 [BASIC INFO SAVED TO CONTROLLER]');
    print('📂 [SECTION] قسم المنتج: $_selectedSectionName (ID: ${_selectedSection?.id})');
    productController.printDataSummary();
    
    Get.snackbar(
      'نجاح', 
      'تم حفظ المعلومات الأساسية بنجاح\nالقسم: $_selectedSectionName',
      backgroundColor: Colors.green, 
      colorText: Colors.white,
      duration: Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _productNameController.dispose();
    _productDescriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}