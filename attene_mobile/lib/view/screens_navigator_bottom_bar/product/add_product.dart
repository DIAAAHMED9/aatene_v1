import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/aatene_button.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final isRTL = LanguageUtils.isRTL;
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productDescriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _productConditionController = TextEditingController();
  
  String _selectedCategory = '';
  String _selectedCondition = '';
  String _selectedSubCategory = '';
  
  List<String> _productConditions = ['جديد', 'مستعمل', 'مجدول'];
  List<String> _categories = ['ملابس', 'أحذية', 'إلكترونيات', 'منزلية'];
  List<String> _subCategories = ['ملابس نساء', 'ملابس رجال', 'ملابس أطفال'];
  
  int _characterCount = 0;
  final int _maxDescriptionLength = 140;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('إضافة منتج جديد'),
        backgroundColor: AppColors.primary400,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان الرئيسي
            _buildSectionTitle('المعلومات الأساسية'),
            SizedBox(height: 20),
            
            // قسم الملابس والأحذية
            _buildCategorySection(),
            SizedBox(height: 20),
            
            // نصائح للصور
            // _buildImageTipsSection(),
            // SizedBox(height: 20),
            
            // قسم تحميل الصور
            _buildImageUploadSection(),
            SizedBox(height: 20),
            
            // اسم المنتج
            _buildProductNameSection(),
            SizedBox(height: 20),
            
            // وصف المنتج
            _buildProductDescriptionSection(),
            SizedBox(height: 20),
            
            // السعر
            _buildPriceSection(),
            SizedBox(height: 20),
            
            // الفئات
            _buildCategoriesSection(),
            SizedBox(height: 20),
            
            // حالة المنتج
            _buildProductConditionSection(),
            SizedBox(height: 20),
            
            // الأقسام الفرعية
            _buildSubCategoriesSection(),
            SizedBox(height: 30),
            
            // زر التالي
            _buildNextButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppColors.primary400,
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary300Alpha10,
        borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: AppColors.primary100),
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
          SizedBox(height: 8),
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

  Widget _buildImageTipsSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.orange[700], size: 20),
              SizedBox(width: 8),
              Text(
                'نصائح لإلتقاط صور جيدة',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            '• استخدم إضاءة جيدة وطبيعية\n• التقط الصور من زوايا متعددة\n• تأكد من وضوح المنتج في الصورة\n• استخدم خلفية بسيطة',
            style: TextStyle(
              fontSize: 12,
              color: Colors.orange[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageUploadSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الصور *',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'يمكنك إضافة حتى (10) صور و (1) فيديو',
          style: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Container(
         height: 22,
         width: double.infinity,
         padding: EdgeInsets.symmetric(vertical: 1,horizontal: 10),
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
        SizedBox(height: 16),
        
        // منطقة سحب وإفلات الصور
        Container(
          height: 120,
          padding: EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Color(0xFFF8F8F8),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  border: BoxBorder.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Icon(Icons.add, size: 25, color: Colors.black)),
              SizedBox(height: 8),
              Text(
                'اضف او اسحب صورة او فيديو',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4),
              Text(
                'png , jpg , svg',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'اسم المنتج',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        TextFiledAatene(
          heightTextFiled: 50,
          controller: _productNameController,
          isRTL: isRTL,
          hintText: 'أدخل اسم المنتج',
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
            Text(
              'وصف المنتج',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              TextField(
                controller: _productDescriptionController,
                maxLines: 4,
                maxLength: _maxDescriptionLength,
                onChanged: (value) {
                  setState(() {
                    _characterCount = value.length;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'قم بتضمين الكلمات الرئيسية التي يستخدمها المشترون للبحث عن هذا العنصر.',
                  hintStyle: TextStyle(fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(12),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '$_characterCount/$_maxDescriptionLength',
                      style: TextStyle(
                        fontSize: 12,
                        color: _characterCount > _maxDescriptionLength 
                            ? Colors.red 
                            : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
            Text(
              'السعر',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                '₪',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: TextFiledAatene(
                heightTextFiled: 50,
                controller: _priceController,
                isRTL: isRTL,
                hintText: 'السعر',
                // contentPadding: EdgeInsets.only(left: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'الفئات',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'ابحث عن اسم الفئة التي ترغب بإضافة منتجك إليها',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedCategory.isEmpty ? null : _selectedCategory,
            decoration: InputDecoration(
              hintText: 'ابحث عن تصنيف',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
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
            Text(
              'حالة المنتج',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 4),
            Text(
              '*',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedCondition.isEmpty ? null : _selectedCondition,
            decoration: InputDecoration(
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

  Widget _buildSubCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ملابس',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 12),
        
        // وصف المنتج
        _buildSubCategoryField(
          title: 'وصف المنتج',
          hint: 'ملابس نساء',
        ),
        SizedBox(height: 12),
        
        // ماهو وصف المنتج
        _buildSubCategoryField(
          title: 'ماهو وصف المنتج',
          hint: 'جاكت',
        ),
        SizedBox(height: 12),
        
        // اخري
        _buildSubCategoryField(
          title: 'اخري',
          hint: 'وصف المنتج',
        ),
      ],
    );
  }

  Widget _buildSubCategoryField({required String title, required String hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonFormField<String>(
            value: _selectedSubCategory.isEmpty ? null : _selectedSubCategory,
            decoration: InputDecoration(
              hintText: hint,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
            items: _subCategories.map((subCategory) {
              return DropdownMenuItem(
                value: subCategory,
                child: Text(subCategory),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedSubCategory = value!;
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
          // التحقق من الحقول المطلوبة قبل المتابعة
          if (_validateForm()) {
            // الانتقال للخطوة التالية
            _goToNextStep();
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
    
    return true;
  }

  void _goToNextStep() {
    // هنا يمكنك الانتقال للخطوة التالية
    Get.snackbar(
      'نجاح',
      'تم حفظ المعلومات الأساسية بنجاح',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
    
    // مثال للانتقال للخطوة التالية:
    // Get.to(() => NextStepScreen());
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