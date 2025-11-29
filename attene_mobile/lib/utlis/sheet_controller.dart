import 'dart:async';
import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/demo_stepper_screen.dart';
import 'package:attene_mobile/my_app/may_app_controller.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/view/product_variations/product_variation_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/section_model.dart';

enum BottomSheetType {
  filter,
  sort,
  multiSelect,
  singleSelect,
  manageSections,
  addNewSection,
  manageAttributes,
  addAttribute,
  addAttributeValue,
  selectAttributeValue,
}

class BottomSheetController extends GetxController {
  final Rx<BottomSheetType> _currentType = BottomSheetType.filter.obs;
  final RxList<String> _selectedOptions = <String>[].obs;
  final RxString _selectedOption = ''.obs;
  final RxString _newSectionName = ''.obs;
  final RxString _sectionSearchText = ''.obs;
  final RxString _selectedSectionName = ''.obs;
  
  final bool isRTL = LanguageUtils.isRTL;

  // === إدارة السمات ===
  final RxList<ProductAttribute> _tempAttributes = <ProductAttribute>[].obs;
  final Rx<ProductAttribute?> _currentEditingAttribute = Rx<ProductAttribute?>(null);
  final RxString _attributeSearchQuery = ''.obs;
  final TextEditingController _attributeSearchController = TextEditingController();
  final TextEditingController _newAttributeController = TextEditingController();
  final TextEditingController _newAttributeValueController = TextEditingController();
  final RxString _newAttributeName = ''.obs;
  final RxString _newAttributeValue = ''.obs;
  final RxInt _attributeTabIndex = 0.obs;
  final RxList<ProductAttribute> _selectedAttributes = <ProductAttribute>[].obs;

  // === إدارة الأقسام ===
  final RxList<Section> _sections = <Section>[].obs;
  final RxBool _isLoadingSections = false.obs;
  final RxString _sectionsErrorMessage = ''.obs;
  final Rx<Section?> _selectedSection = Rx<Section?>(null);
  final RxList<Section> _filteredSections = <Section>[].obs;

  // === Stream Controllers ===
  final _sectionSearchController = StreamController<String>.broadcast();
  final MyAppController _myAppController = Get.find<MyAppController>();

  // === Getters ===
  BottomSheetType get currentType => _currentType.value;
  List<String> get selectedOptions => _selectedOptions.toList();
  String get selectedOption => _selectedOption.value;
  Section? get selectedSection => _selectedSection.value;
  String get selectedSectionName => _selectedSectionName.value;
  bool get hasSelectedSection => _selectedSection.value != null;
  List<Section> get sections => _sections.toList();
  List<Section> get filteredSections => _filteredSections.toList();
  bool get isLoadingSections => _isLoadingSections.value;
  String get sectionsErrorMessage => _sectionsErrorMessage.value;
  List<ProductAttribute> get tempAttributes => _tempAttributes.toList();
  List<ProductAttribute> get selectedAttributes => _selectedAttributes.toList();

  // ✅ إضافة Getter لـ RxList للاستماع للتغيرات
  RxList<Section> get sectionsRx => _sections;

  @override
  void onInit() {
    super.onInit();
    _initializeAttributeListeners();
    _initializeSampleAttributes();
    _initializeSectionSearch();
    _loadSections();
  }
  // === دوال إدارة الأقسام مع API ===
  Future<void> _loadSections() async {
    try {
      if (!_isUserAuthenticated()) {
        print('⚠️ المستخدم غير مسجل دخول');
        return;
      }

      _isLoadingSections.value = true;
      _sectionsErrorMessage.value = '';
      
      final response = await ApiHelper.get(
        path: '/merchants/sections',
        withLoading: false,
      );
      
      if (response != null && response['status'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        _sections.assignAll(data.map((section) => Section.fromJson(section)).toList());
        _filteredSections.assignAll(_sections);
      } else {
        _sectionsErrorMessage.value = response?['message'] ?? 'فشل في تحميل الأقسام';
      }
    } catch (e) {
      _sectionsErrorMessage.value = 'خطأ في تحميل الأقسام: ${e.toString()}';
    } finally {
      _isLoadingSections.value = false;
    }
  }



  // === دوال التهيئة ===
  void _initializeAttributeListeners() {
    _attributeSearchController.addListener(() {
      _attributeSearchQuery.value = _attributeSearchController.text;
    });
    
    _newAttributeController.addListener(() {
      _newAttributeName.value = _newAttributeController.text;
    });
    
    _newAttributeValueController.addListener(() {
      _newAttributeValue.value = _newAttributeValueController.text;
    });
  }

  void _initializeSectionSearch() {
    _sectionSearchController.stream.listen((searchText) {
      _filterSections(searchText);
    });
  }

  void _initializeSampleAttributes() {
    _tempAttributes.assignAll([
      ProductAttribute(
        id: '1',
        name: 'اللون',
        values: [
          AttributeValue(id: '1-1', value: 'أحمر', isSelected: true),
          AttributeValue(id: '1-2', value: 'أزرق', isSelected: true),
          AttributeValue(id: '1-3', value: 'أخضر', isSelected: true),
        ],
      ),
      ProductAttribute(
        id: '2', 
        name: 'المقاس',
        values: [
          AttributeValue(id: '2-1', value: 'صغير', isSelected: true),
          AttributeValue(id: '2-2', value: 'متوسط', isSelected: true),
          AttributeValue(id: '2-3', value: 'كبير', isSelected: true),
        ],
      ),
      ProductAttribute(
        id: '3',
        name: 'المادة',
        values: [
          AttributeValue(id: '3-1', value: 'قطن', isSelected: true),
          AttributeValue(id: '3-2', value: 'حرير', isSelected: true),
          AttributeValue(id: '3-3', value: 'صوف', isSelected: true),
        ],
      ),
    ]);
  }

  void _filterSections(String searchText) {
    if (searchText.isEmpty) {
      _filteredSections.assignAll(_sections);
    } else {
      final filtered = _sections.where((section) => 
        section.name.toLowerCase().contains(searchText.toLowerCase())
      ).toList();
      _filteredSections.assignAll(filtered);
    }
  }

  // === دوال إدارة الأقسام مع API ===
  Future<void> loadSections() async {
    try {
      if (!_isUserAuthenticated()) {
        print('⚠️ المستخدم غير مسجل دخول');
        return;
      }

      _isLoadingSections.value = true;
      _sectionsErrorMessage.value = '';
      
      final response = await ApiHelper.get(
        path: '/merchants/sections',
        withLoading: false,
      );
      
      if (response != null && response['status'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        _sections.assignAll(data.map((section) => Section.fromJson(section)).toList());
        _filteredSections.assignAll(_sections);
      } else {
        _sectionsErrorMessage.value = response?['message'] ?? 'فشل في تحميل الأقسام';
      }
    } catch (e) {
      _sectionsErrorMessage.value = 'خطأ في تحميل الأقسام: ${e.toString()}';
    } finally {
      _isLoadingSections.value = false;
    }
  }

  // ✅ إضافة دالة getSections المطلوبة
  List<Section> getSections() {
    return _sections.toList();
  }

  Future<bool> addSection(String name) async {
    try {
      _isLoadingSections.value = true;
      
      final response = await ApiHelper.post(
        path: '/merchants/sections',
        body: {'name': name, 'status': 'active'},
        withLoading: true,
      );
      
      if (response != null && response['status'] == true) {
        await loadSections();
        return true;
      } else {
        _sectionsErrorMessage.value = response?['message'] ?? 'فشل في إضافة القسم';
        return false;
      }
    } catch (e) {
      _sectionsErrorMessage.value = 'خطأ في إضافة القسم: ${e.toString()}';
      return false;
    } finally {
      _isLoadingSections.value = false;
    }
  }

  Future<bool> deleteSection(int sectionId) async {
    try {
      _isLoadingSections.value = true;
      
      final response = await ApiHelper.delete(
        path: '/merchants/sections/$sectionId',
        withLoading: true,
      );
      
      if (response != null && response['status'] == true) {
        await loadSections();
        if (_selectedSection.value?.id == sectionId) {
          _selectedSection.value = null;
          _selectedSectionName.value = '';
        }
        return true;
      } else {
        _sectionsErrorMessage.value = response?['message'] ?? 'فشل في حذف القسم';
        return false;
      }
    } catch (e) {
      _sectionsErrorMessage.value = 'خطأ في حذف القسم: ${e.toString()}';
      return false;
    } finally {
      _isLoadingSections.value = false;
    }
  }

  void selectSection(Section section) {
    _selectedSection.value = section;
    _selectedSectionName.value = section.name;
  }

  void clearSectionSelection() {
    _selectedSection.value = null;
    _selectedSectionName.value = '';
  }

  bool get isSectionNameExists {
    if (_newSectionName.value.isEmpty) return false;
    return _sections.any((section) => 
      section.name.toLowerCase() == _newSectionName.value.trim().toLowerCase()
    );
  }

  bool _isUserAuthenticated() {
    final userData = _myAppController.userData;
    return userData.isNotEmpty && userData['token'] != null;
  }

  void _showLoginRequiredMessage() {
    Get.snackbar(
      'يجب تسجيل الدخول',
      'يرجى تسجيل الدخول للوصول إلى هذه الميزة',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // === دوال فتح الـ Bottom Sheets ===
  void showBottomSheet(BottomSheetType type, {List<ProductAttribute>? attributes, ProductAttribute? attribute}) {
    _currentType.value = type;
    
    if (attributes != null && type == BottomSheetType.manageAttributes) {
      _tempAttributes.assignAll(attributes);
      _selectedAttributes.clear();
      for (final attr in attributes) {
        if (attr.values.any((value) => value.isSelected.value)) {
          _selectedAttributes.add(attr);
        }
      }
      if (_selectedAttributes.isNotEmpty && _currentEditingAttribute.value == null) {
        _currentEditingAttribute.value = _selectedAttributes.first;
      }
    }
    
    if (attribute != null && type == BottomSheetType.addAttributeValue) {
      _currentEditingAttribute.value = attribute;
    }
    
    if (type == BottomSheetType.manageSections) {
      loadSections();
    }
    
    _resetFields();
    
    Get.bottomSheet(
      _buildBottomSheetContent(),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      enableDrag: true,
    ).then((_) {
      _resetFields();
    });
  }

  void _resetFields() {
    _selectedOptions.clear();
    _selectedOption.value = '';
    _newSectionName.value = '';
    _sectionSearchText.value = '';
    _attributeSearchQuery.value = '';
    _attributeSearchController.clear();
    _newAttributeName.value = '';
    _newAttributeController.clear();
    _newAttributeValue.value = '';
    _newAttributeValueController.clear();
    _attributeTabIndex.value = 0;
  }

  // === دوال فتح النوافذ المنبثقة ===
  void openManageAttributes(List<ProductAttribute> attributes) {
    showBottomSheet(BottomSheetType.manageAttributes, attributes: attributes);
  }

  void openAddAttribute() {
    showBottomSheet(BottomSheetType.addAttribute);
  }

  void openAddAttributeValue(ProductAttribute attribute) {
    showBottomSheet(BottomSheetType.addAttributeValue, attribute: attribute);
  }

  void openSelectAttributeValue(ProductAttribute attribute, Function(String) onValueSelected) {
    _currentEditingAttribute.value = attribute;
    showBottomSheet(BottomSheetType.selectAttributeValue);
  }

  void openManageSections() {
    if (!_isUserAuthenticated()) {
      _showLoginRequiredMessage();
      return;
    }
    showBottomSheet(BottomSheetType.manageSections);
  }

  void openAddNewSection() {
    if (!_isUserAuthenticated()) {
      _showLoginRequiredMessage();
      return;
    }
    showBottomSheet(BottomSheetType.addNewSection);
  }

  // ✅ دالة الانتقال إلى شاشة إضافة المنتج الجديدة
  void openAddProductScreen() {
    if (!_isUserAuthenticated()) {
      _showLoginRequiredMessage();
      return;
    }

    if (!hasSelectedSection) {
      Get.snackbar(
        'قسم مطلوب',
        'يجب اختيار قسم أولاً قبل إضافة المنتج',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      
      // فتح إدارة الأقسام مباشرة
      openManageSections();
      return;
    }

    _navigateToAddProductStepper();
  }

  void _navigateToAddProductStepper() {
    Get.back(); // إغلاق أي BottomSheet مفتوح
    Get.to(
      () => DemoStepperScreen(),
      transition: Transition.cupertino,
      duration: const Duration(milliseconds: 300),
    );
  }

  void openFilter() => showBottomSheet(BottomSheetType.filter);
  void openSort() => showBottomSheet(BottomSheetType.sort);
  void openMultiSelect() => showBottomSheet(BottomSheetType.multiSelect);
  void openSingleSelect() => showBottomSheet(BottomSheetType.singleSelect);

  // === بناء واجهة الـ Bottom Sheet ===
  Widget _buildBottomSheetContent() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      constraints: BoxConstraints(maxHeight: Get.height * 0.9),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Expanded(child: _buildContent()),
          if (_shouldShowActions) const SizedBox(height: 20),
          if (_shouldShowActions) _buildActions(),
        ],
      ),
    );
  }

  bool get _shouldShowActions {
    return _currentType.value != BottomSheetType.manageSections && 
           _currentType.value != BottomSheetType.addNewSection &&
           _currentType.value != BottomSheetType.manageAttributes &&
           _currentType.value != BottomSheetType.addAttribute &&
           _currentType.value != BottomSheetType.addAttributeValue &&
           _currentType.value != BottomSheetType.selectAttributeValue;
  }

  Widget _buildHeader() {
    String title = '';
    switch (_currentType.value) {
      case BottomSheetType.filter:
        title = 'الفلاتر';
        break;
      case BottomSheetType.sort:
        title = 'ترتيب المنتجات';
        break;
      case BottomSheetType.multiSelect:
        title = 'اختيار متعدد';
        break;
      case BottomSheetType.singleSelect:
        title = 'اختيار واحد';
        break;
      case BottomSheetType.manageSections:
        title = 'إدارة أقسام المتجر';
        break;
      case BottomSheetType.addNewSection:
        title = 'إضافة قسم جديد';
        break;
      case BottomSheetType.manageAttributes:
        title = 'إدارة السمات والصفات';
        break;
      case BottomSheetType.addAttribute:
        title = 'إضافة سمة جديدة';
        break;
      case BottomSheetType.addAttributeValue:
        title = 'إضافة صفة جديدة';
        break;
      case BottomSheetType.selectAttributeValue:
        title = 'اختيار الصفة';
        break;
    }
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.close),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Obx(() {
      switch (_currentType.value) {
        case BottomSheetType.filter:
          return _buildFilterContent();
        case BottomSheetType.sort:
          return _buildSortContent();
        case BottomSheetType.multiSelect:
          return _buildMultiSelectContent();
        case BottomSheetType.singleSelect:
          return _buildSingleSelectContent();
        case BottomSheetType.manageSections:
          return _buildManageSectionsContent();
        case BottomSheetType.addNewSection:
          return _buildAddNewSectionContent();
        case BottomSheetType.manageAttributes:
          return _buildManageAttributesContent();
        case BottomSheetType.addAttribute:
          return _buildAddAttributeContent();
        case BottomSheetType.addAttributeValue:
          return _buildAddAttributeValueContent();
        case BottomSheetType.selectAttributeValue:
          return _buildSelectAttributeValueContent();
      }
    });
  }

  // === واجهات إدارة الأقسام ===
  Widget _buildManageSectionsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أضف وعدّل الأقسام الخاصة بمتجرك لترتيب منتجاتك بالطريقة التي تناسبك، هذه الأقسام لا تؤثر على التصنيفات الرئيسية للمنصة، بل تسهل على عملائك تصفح متجرك',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 20),
        
        AateneButton(
          color: AppColors.primary400,
          textColor: Colors.white,
          borderColor: Colors.transparent,
          buttonText: 'إضافة قسم جديد',
          onTap: () {
            Get.back();
            openAddNewSection();
          },
        ),
        const SizedBox(height: 20),

        TextFiledAatene(
          heightTextFiled: 50,
          onChanged: (value) {
            _sectionSearchText.value = value;
            _sectionSearchController.add(value);
          },
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          isRTL: isRTL,
          hintText: 'ابحث في الأقسام',
        ),
        const SizedBox(height: 20),

        Expanded(
          child: _buildSectionsList(),
        ),

        Obx(() {
          if (hasSelectedSection) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: AateneButton(
                color: AppColors.primary400,
                textColor: Colors.white,
                borderColor: Colors.transparent,
                buttonText: 'متابعة لإضافة المنتج',
                onTap: () {
                  Get.back();
                  _navigateToAddProductStepper();
                },
              ),
            );
          }
          return const SizedBox();
        }),
      ],
    );
  }

  Widget _buildSectionsList() {
    return Obx(() {
      if (_isLoadingSections.value) {
        return const Center(child: CircularProgressIndicator());
      }
      
      if (_sectionsErrorMessage.value.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 60, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                _sectionsErrorMessage.value,
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: loadSections,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        );
      }
      
      if (_filteredSections.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.folder_open_rounded, size: 60, color: Colors.grey),
              SizedBox(height: 16),
              Text('لا توجد أقسام'),
            ],
          ),
        );
      }
      
      return ListView.builder(
        itemCount: _filteredSections.length,
        itemBuilder: (context, index) {
          final section = _filteredSections[index];
          return _buildSectionRadioItem(section);
        },
      );
    });
  }

Widget _buildSectionRadioItem(Section section) {
  return Obx(() {
    final isSelected = _selectedSection.value?.id == section.id;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          border: isSelected 
              ? Border.all(color: AppColors.primary400, width: 2)
              : null,
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? AppColors.primary100 : Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            children: [
              // ✅ إصلاح: جعل الـ Radio يستمع للتغييرات
              Obx(() => Radio<Section>(
                value: section,
                groupValue: _selectedSection.value,
                onChanged: (Section? value) {
                  if (value != null) {
                    selectSection(value);
                    // _showSelectionConfirmation(value.name);
                  }
                },
                activeColor: AppColors.primary400,
              )),
              
              Icon(
                Icons.folder_rounded,
                color: isSelected ? AppColors.primary400 : Colors.blue,
                size: 24,
              ),
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      section.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: isSelected ? AppColors.primary400 : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'ID: ${section.id}',
                      style: TextStyle(
                        color: isSelected ? AppColors.primary500 : Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red[400],
                  size: 20,
                ),
                onPressed: () => _showDeleteSectionConfirmation(section),
              ),
            ],
          ),
        ),
      ),
    );
  });
}

  void _showDeleteSectionConfirmation(Section section) {
    Get.dialog(
      AlertDialog(
        title: const Text('حذف القسم'),
        content: Text('هل أنت متأكد من حذف قسم "${section.name}"؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back();
              final success = await deleteSection(section.id);
              if (success) {
                Get.snackbar('نجاح', 'تم حذف القسم بنجاح');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }

  Widget _buildAddNewSectionContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'أضف قسماً جديداً ليسهُل على عملائك تصفح منتجاتك بترتيب أوضح.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.5,
          ),
        ),
        const SizedBox(height: 20),
        TextFiledAatene(
          heightTextFiled: 50,
          onChanged: (value) => _newSectionName.value = value,
          prefixIcon: Icon(Icons.create_new_folder_rounded, color: Colors.grey[600]),
          isRTL: isRTL,
          hintText: 'أدخل اسم القسم الجديد',
        ),
        const SizedBox(height: 20),
        
        Obx(() {
          if (_newSectionName.isNotEmpty && isSectionNameExists) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'هذا الاسم مشابه لقسم موجود مسبقاً',
                style: TextStyle(color: Colors.orange, fontSize: 12),
              ),
            );
          }
          return const SizedBox.shrink();
        }),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Get.back(),
                style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                child: const Text('إلغاء'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(() => ElevatedButton(
                onPressed: _newSectionName.isNotEmpty && !isSectionNameExists 
                    ? _addNewSection 
                    : null,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
                child: const Text('إضافة'),
              )),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _addNewSection() async {
    final success = await addSection(_newSectionName.value.trim());
    if (success) {
      _newSectionName.value = '';
      Get.back();
      Get.snackbar('تمت الإضافة', 'تم إضافة القسم الجديد بنجاح');
    }
  }

  // ... (بقية دوال إدارة السمات والواجهات تبقى كما هي بدون تغيير)
  // === واجهات إدارة السمات ===
  Widget _buildManageAttributesContent() {
    return Column(
      children: [
        _buildAttributeTabs(),
        const SizedBox(height: 16),
        Expanded(
          child: IndexedStack(
            index: _attributeTabIndex.value,
            children: [
              _buildAttributesTab(),
              _buildValuesTab(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttributeTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildAttributeTabButton(
              text: 'السمات',
              isActive: _attributeTabIndex.value == 0,
              onTap: () => _attributeTabIndex.value = 0,
            ),
          ),
          Expanded(
            child: _buildAttributeTabButton(
              text: 'الصفات',
              isActive: _attributeTabIndex.value == 1,
              onTap: () {
                if (_selectedAttributes.isNotEmpty && _currentEditingAttribute.value == null) {
                  _currentEditingAttribute.value = _selectedAttributes.first;
                }
                _attributeTabIndex.value = 1;
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAttributeTabButton({
    required String text,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary400 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[700],
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAttributesTab() {
    return Column(
      children: [
        _buildAttributeSearchBar(),
        const SizedBox(height: 16),
        _buildAddAttributeSection(),
        const SizedBox(height: 16),
        Expanded(
          child: _buildAttributesList(),
        ),
        _buildAttributesTabButton(),
      ],
    );
  }

  Widget _buildAttributeSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _attributeSearchController,
        decoration: InputDecoration(
          hintText: 'بحث في السمات...',
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: const BorderSide(color: AppColors.primary400),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildAddAttributeSection() {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'إضافة سمة جديدة',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newAttributeController,
                      decoration: const InputDecoration(
                        hintText: 'أدخل اسم السمة الجديدة...',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: _newAttributeName.value.trim().isNotEmpty 
                          ? _addNewAttribute
                          : null,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _newAttributeName.value.trim().isNotEmpty 
                              ? AppColors.primary400 
                              : Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
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

  Widget _buildAttributesList() {
    final filteredAttributes = _attributeSearchQuery.isEmpty 
        ? _tempAttributes 
        : _tempAttributes.where((attribute) => 
            attribute.name.toLowerCase().contains(_attributeSearchQuery.value.toLowerCase())
          ).toList();

    if (filteredAttributes.isEmpty && _attributeSearchQuery.isNotEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text('لا توجد نتائج للبحث'),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: filteredAttributes.length,
      itemBuilder: (context, index) {
        final attribute = filteredAttributes[index];
        return _buildAttributeListItem(attribute);
      },
    );
  }

  Widget _buildAttributeListItem(ProductAttribute attribute) {
    final isSelected = _selectedAttributes.any((attr) => attr.id == attribute.id);
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Checkbox(
          value: isSelected,
          onChanged: (value) => _toggleAttributeSelection(attribute),
          activeColor: AppColors.primary400,
        ),
        title: Text(
          attribute.name,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.primary400 : Colors.black87,
          ),
        ),
        subtitle: Text('${attribute.values.where((v) => v.isSelected.value).length}/${attribute.values.length} صفة'),
        trailing: const Icon(Icons.category),
      ),
    );
  }

  Widget _buildAttributesTabButton() {
    final hasSelectedAttributes = _selectedAttributes.isNotEmpty;
    
    if (hasSelectedAttributes) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ElevatedButton(
          onPressed: () {
            if (_currentEditingAttribute.value == null) {
              _currentEditingAttribute.value = _selectedAttributes.first;
            }
            _attributeTabIndex.value = 1;
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary400,
            minimumSize: const Size(double.infinity, 50),
          ),
          child: const Text(
            'الانتقال إلى إضافة الصفات',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }
    return const SizedBox();
  }

  Widget _buildValuesTab() {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildAttributeSelector(),
        const SizedBox(height: 16),
        _buildAddValueSection(),
        const SizedBox(height: 16),
        Expanded(
          child: _buildAttributeValuesContent(),
        ),
        _buildValuesTabButtons(),
      ],
    );
  }

  Widget _buildAttributeSelector() {
    if (_selectedAttributes.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('لم يتم اختيار أي سمات بعد'),
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'اختر سمة لإضافة الصفات:',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: _selectedAttributes.map((attribute) {
            final isActive = _currentEditingAttribute.value?.id == attribute.id;
            return ChoiceChip(
              label: Text(attribute.name),
              selected: isActive,
              onSelected: (selected) => _currentEditingAttribute.value = attribute,
              selectedColor: AppColors.primary400,
              labelStyle: TextStyle(
                color: isActive ? Colors.white : Colors.black87,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAddValueSection() {
    final currentAttribute = _currentEditingAttribute.value;
    if (currentAttribute == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text('اختر سمة لإضافة الصفات'),
          ],
        ),
      );
    }
    
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'إضافة صفة لـ ${currentAttribute.name}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newAttributeValueController,
                      decoration: InputDecoration(
                        hintText: 'أدخل ${currentAttribute.name} جديد...',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: _newAttributeValue.value.trim().isNotEmpty 
                          ? _addNewAttributeValue
                          : null,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: _newAttributeValue.value.trim().isNotEmpty 
                              ? AppColors.primary400 
                              : Colors.grey[400],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 20,
                        ),
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

  Widget _buildAttributeValuesContent() {
    final currentAttribute = _currentEditingAttribute.value;
    if (currentAttribute == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: 60, color: Colors.grey),
            SizedBox(height: 16),
            Text('اختر سمة لإضافة الصفات'),
          ],
        ),
      );
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'صفات ${currentAttribute.name}',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            Obx(() {
              final selectedCount = currentAttribute.values.where((v) => v.isSelected.value).length;
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primary100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$selectedCount/${currentAttribute.values.length}',
                  style: TextStyle(
                    color: AppColors.primary400,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            }),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _buildAttributeValuesList(currentAttribute),
        ),
      ],
    );
  }

  Widget _buildAttributeValuesList(ProductAttribute attribute) {
    if (attribute.values.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.list_alt_outlined, size: 60, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text('لا توجد صفات لـ ${attribute.name} بعد'),
            const SizedBox(height: 8),
            const Text('استخدم الحقل أعلاه لإضافة الصفات الأولى'),
          ],
        ),
      );
    }
    
    return ListView.builder(
      itemCount: attribute.values.length,
      itemBuilder: (context, index) {
        final value = attribute.values[index];
        return _buildValueListItem(value);
      },
    );
  }

  Widget _buildValueListItem(AttributeValue value) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Obx(() => ListTile(
        leading: Checkbox(
          value: value.isSelected.value,
          onChanged: (val) => _toggleAttributeValueSelection(value),
          activeColor: AppColors.primary400,
        ),
        title: Text(
          value.value,
          style: TextStyle(
            fontWeight: value.isSelected.value ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: Icon(
          value.isSelected.value ? Icons.check_circle : Icons.radio_button_unchecked,
          color: value.isSelected.value ? AppColors.primary400 : Colors.grey,
        ),
      )),
    );
  }

  Widget _buildValuesTabButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () {
                _attributeTabIndex.value = 0;
              },
              child: const Text('رجوع إلى السمات'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton(
              onPressed: _saveAttributesAndClose,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary400,
              ),
              child: const Text(
                'حفظ والتطبيق',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddAttributeContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إضافة سمة جديدة',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextFiledAatene(
          heightTextFiled: 50,
          controller: _newAttributeController,
          onChanged: (value) => _newAttributeName.value = value,
          isRTL: isRTL,
          hintText: 'اسم السمة',
        ),
        const SizedBox(height: 20),
        AateneButton(
          buttonText: 'إضافة السمة',
          color: AppColors.primary400,
          textColor: Colors.white,
          onTap: _addNewAttribute,
        ),
      ],
    );
  }

  Widget _buildAddAttributeValueContent() {
    final currentAttribute = _currentEditingAttribute.value;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إضافة صفة جديدة لـ ${currentAttribute?.name ?? ""}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        TextFiledAatene(
          heightTextFiled: 50,
          controller: _newAttributeValueController,
          onChanged: (value) => _newAttributeValue.value = value,
          isRTL: isRTL,
          hintText: 'قيمة الصفة',
        ),
        const SizedBox(height: 20),
        AateneButton(
          buttonText: 'إضافة الصفة',
          color: AppColors.primary400,
          textColor: Colors.white,
          onTap: _addNewAttributeValue,
        ),
      ],
    );
  }

  Widget _buildSelectAttributeValueContent() {
    final currentAttribute = _currentEditingAttribute.value;
    if (currentAttribute == null) {
      return const Center(child: Text('لا توجد سمة محددة'));
    }

    final selectedValues = currentAttribute.values.where((v) => v.isSelected.value).toList();
    
    return Column(
      children: [
        Text(
          'اختر قيمة لـ ${currentAttribute.name}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: selectedValues.isEmpty
              ? const Center(child: Text('لا توجد قيم متاحة'))
              : ListView.builder(
                  itemCount: selectedValues.length,
                  itemBuilder: (context, index) {
                    final value = selectedValues[index];
                    return ListTile(
                      title: Text(value.value),
                      leading: const Icon(Icons.check_circle_outline),
                      onTap: () {
                        Get.back(result: value.value);
                      },
                    );
                  },
                ),
        ),
      ],
    );
  }

  // === دوال إدارة السمات ===
  void _toggleAttributeSelection(ProductAttribute attribute) {
    final isCurrentlySelected = _selectedAttributes.any((attr) => attr.id == attribute.id);
    
    if (isCurrentlySelected) {
      _selectedAttributes.removeWhere((attr) => attr.id == attribute.id);
      if (_currentEditingAttribute.value?.id == attribute.id) {
        _currentEditingAttribute.value = _selectedAttributes.isNotEmpty ? _selectedAttributes.first : null;
      }
    } else {
      final newAttribute = attribute.copyWith(
        values: attribute.values.map((value) => value.copyWith(isSelected: true)).toList()
      );
      _selectedAttributes.add(newAttribute);
      
      if (_currentEditingAttribute.value == null) {
        _currentEditingAttribute.value = newAttribute;
      }
    }
  }

  void _addNewAttribute() {
    final name = _newAttributeName.value.trim();
    if (name.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى إدخال اسم السمة');
      return;
    }

    if (_tempAttributes.any((attr) => attr.name.toLowerCase() == name.toLowerCase())) {
      Get.snackbar('تنبيه', 'اسم السمة موجود مسبقاً');
      return;
    }

    final newAttribute = ProductAttribute(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      values: [],
    );

    _tempAttributes.add(newAttribute);
    _newAttributeController.clear();
    _newAttributeName.value = '';
    
    Get.snackbar('نجاح', 'تم إضافة السمة "$name" بنجاح');
  }

  void _addNewAttributeValue() {
    final valueText = _newAttributeValue.value.trim();
    final attribute = _currentEditingAttribute.value;
    
    if (attribute == null) {
      Get.snackbar('تنبيه', 'يرجى اختيار سمة أولاً');
      return;
    }

    if (valueText.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى إدخال قيمة السمة');
      return;
    }

    if (attribute.values.any((v) => v.value.toLowerCase() == valueText.toLowerCase())) {
      Get.snackbar('تنبيه', 'قيمة السمة موجودة مسبقاً');
      return;
    }

    final newValue = AttributeValue(
      id: '${attribute.id}-${DateTime.now().millisecondsSinceEpoch}',
      value: valueText,
      isSelected: true,
    );

    attribute.values.add(newValue);
    _newAttributeValueController.clear();
    _newAttributeValue.value = '';
    
    Get.snackbar('نجاح', 'تم إضافة الصفة "$valueText" بنجاح');
  }

  void _toggleAttributeValueSelection(AttributeValue value) {
    value.isSelected.toggle();
  }

  void _saveAttributesAndClose() {
    Get.back();
    Get.snackbar('نجاح', 'تم حفظ السمات والصفات بنجاح');
  }

  // === واجهات الفلترة والترتيب ===
  Widget _buildFilterContent() {
    return Column(
      children: [
        _buildFilterOption('نطاق السعر', Icons.attach_money),
        _buildFilterOption('الفئة', Icons.category),
        _buildFilterOption('الماركة', Icons.branding_watermark),
        _buildFilterOption('التقييم', Icons.star),
      ],
    );
  }
  
  Widget _buildFilterOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        print('فتح $title');
      },
    );
  }
  
  Widget _buildSortContent() {
    final List<String> sortOptions = ['الأحدث', 'الأقدم', 'السعر من الأعلى', 'السعر من الأدنى'];
    return Column(
      children: sortOptions.map((option) {
        return Obx(() => RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: _selectedOption.value,
          onChanged: (value) {
            _selectedOption.value = value!;
          },
        ));
      }).toList(),
    );
  }
  
  Widget _buildMultiSelectContent() {
    final List<String> multiSelectOptions = ['خيار 1', 'خيار 2', 'خيار 3', 'خيار 4'];
    return Column(
      children: multiSelectOptions.map((option) {
        return Obx(() => CheckboxListTile(
          title: Text(option),
          value: _selectedOptions.contains(option),
          onChanged: (value) {
            if (value == true) {
              _selectedOptions.add(option);
            } else {
              _selectedOptions.remove(option);
            }
          },
        ));
      }).toList(),
    );
  }
  
  Widget _buildSingleSelectContent() {
    final List<String> singleSelectOptions = ['خيار أ', 'خيار ب', 'خيار ج', 'خيار د'];
    return Column(
      children: singleSelectOptions.map((option) {
        return Obx(() => RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: _selectedOption.value,
          onChanged: (value) {
            _selectedOption.value = value!;
          },
        ));
      }).toList(),
    );
  }
  
  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              _selectedOptions.clear();
              _selectedOption.value = '';
              Get.back();
            },
            child: const Text('إلغاء'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: _applySelection,
            child: const Text('تطبيق'),
          ),
        ),
      ],
    );
  }
  
  void _applySelection() {
    switch (_currentType.value) {
      case BottomSheetType.filter:
        print('تطبيق الفلاتر: ${_selectedOptions.join(', ')}');
        break;
      case BottomSheetType.sort:
        print('تم الترتيب حسب: ${_selectedOption.value}');
        break;
      case BottomSheetType.multiSelect:
        print('الخيارات المحددة: ${_selectedOptions.join(', ')}');
        break;
      case BottomSheetType.singleSelect:
        print('الخيار المحدد: ${_selectedOption.value}');
        break;
      default:
        break;
    }
    Get.back();
  }

  // === دوال الحصول على البيانات ===
  List<ProductAttribute> getSelectedAttributes() {
    return _selectedAttributes.toList();
  }

  List<ProductAttribute> getAllAttributes() {
    return _tempAttributes.toList();
  }

  void updateAttributes(List<ProductAttribute> attributes) {
    _tempAttributes.assignAll(attributes);
  }

  @override
  void onClose() {
    _sectionSearchController.close();
    _attributeSearchController.dispose();
    _newAttributeController.dispose();
    _newAttributeValueController.dispose();
    super.onClose();
  }
}