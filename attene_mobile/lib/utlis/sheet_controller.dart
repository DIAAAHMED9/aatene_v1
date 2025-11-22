import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/view/product_variations/product_variation_model.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/add_product.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum BottomSheetType {
  filter,
  sort,
  multiSelect,
  singleSelect,
  manageSections,
  addNewSection,
  addProduct,
  manageAttributes,      // ✅ إدارة السمات والصفات
  addAttribute,          // ✅ إضافة سمة جديدة
  addAttributeValue,     // ✅ إضافة صفة جديدة
  selectAttributeValue,  // ✅ اختيار قيمة السمة
}

class BottomSheetController extends GetxController {
  final Rx<BottomSheetType> currentType = BottomSheetType.filter.obs;
  final RxList<String> selectedOptions = <String>[].obs;
  final RxString selectedOption = ''.obs;
  final RxString newSectionName = ''.obs;
  final RxString sectionSearchText = ''.obs;
  final RxString selectedSection = ''.obs;
  final isRTL = LanguageUtils.isRTL;

  // === بيانات إدارة السمات والاختلافات === ✅ جديد
  final RxList<ProductAttribute> tempAttributes = <ProductAttribute>[].obs;
  final Rx<ProductAttribute?> currentEditingAttribute = Rx<ProductAttribute?>(null);
  final RxString attributeSearchQuery = ''.obs;
  final TextEditingController attributeSearchController = TextEditingController();
  final TextEditingController newAttributeController = TextEditingController();
  final TextEditingController newAttributeValueController = TextEditingController();
  final RxString newAttributeName = ''.obs;
  final RxString newAttributeValue = ''.obs;
  final RxInt attributeTabIndex = 0.obs;
  final RxList<ProductAttribute> selectedAttributes = <ProductAttribute>[].obs;

  // === بيانات المنتج ===
  final RxInt currentStep = 0.obs;
  final RxString productName = ''.obs;
  final RxString productDescription = ''.obs;
  final RxDouble productPrice = 0.0.obs;
  final RxInt productQuantity = 0.obs;
  final RxList<String> productImages = <String>[].obs;
  final RxString selectedCategory = ''.obs;

  // === بيانات تجريبية ===
  final List<String> filterOptions = ['الفئة 1', 'الفئة 2', 'الفئة 3', 'الفئة 4'];
  final List<String> sortOptions = ['الأحدث', 'الأقدم', 'السعر من الأعلى', 'السعر من الأدنى'];
  final List<String> multiSelectOptions = ['خيار 1', 'خيار 2', 'خيار 3', 'خيار 4'];
  final List<String> singleSelectOptions = ['خيار أ', 'خيار ب', 'خيار ج', 'خيار د'];
  final RxList<String> storeSections = <String>[].obs;
  final List<String> productCategories = ['الكترونيات', 'ملابس', 'أغذية', 'أثاث', 'رياضة'];

  @override
  void onInit() {
    super.onInit();
    _initializeAttributeListeners();
    _initializeSampleAttributes();
  }

  void _initializeAttributeListeners() {
    attributeSearchController.addListener(() {
      attributeSearchQuery.value = attributeSearchController.text;
    });
    
    newAttributeController.addListener(() {
      newAttributeName.value = newAttributeController.text;
    });
    
    newAttributeValueController.addListener(() {
      newAttributeValue.value = newAttributeValueController.text;
    });
  }

  void _initializeSampleAttributes() {
    tempAttributes.assignAll([
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

  // === دوال فتح الـ Bottom Sheets === ✅ محدث
  void showBottomSheet(BottomSheetType type, {List<ProductAttribute>? attributes, ProductAttribute? attribute}) {
    currentType.value = type;
    
    if (attributes != null && type == BottomSheetType.manageAttributes) {
      tempAttributes.assignAll(attributes);
      selectedAttributes.clear();
      // نختار السمات المحددة مسبقاً
      for (final attr in attributes) {
        if (attr.values.any((value) => value.isSelected.value)) {
          selectedAttributes.add(attr);
        }
      }
      if (selectedAttributes.isNotEmpty && currentEditingAttribute.value == null) {
        currentEditingAttribute.value = selectedAttributes.first;
      }
    }
    
    if (attribute != null && type == BottomSheetType.addAttributeValue) {
      currentEditingAttribute.value = attribute;
    }
    
    // إعادة تعيين الحقول
    selectedOptions.clear();
    selectedOption.value = '';
    newSectionName.value = '';
    sectionSearchText.value = '';
    selectedSection.value = '';
    attributeSearchQuery.value = '';
    attributeSearchController.clear();
    newAttributeName.value = '';
    newAttributeController.clear();
    newAttributeValue.value = '';
    newAttributeValueController.clear();
    attributeTabIndex.value = 0;
    
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
    );
  }

  // === دوال فتح النوافذ المنبثقة === ✅ محدث
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
    currentEditingAttribute.value = attribute;
    showBottomSheet(BottomSheetType.selectAttributeValue);
  }

  void openManageSections() {
    showBottomSheet(BottomSheetType.manageSections);
  }

  void openAddNewSection() {
    showBottomSheet(BottomSheetType.addNewSection);
  }

  void openAddProduct() {
    showBottomSheet(BottomSheetType.addProduct);
  }

  void openFilter() {
    showBottomSheet(BottomSheetType.filter);
  }

  void openSort() {
    showBottomSheet(BottomSheetType.sort);
  }

  void openMultiSelect() {
    showBottomSheet(BottomSheetType.multiSelect);
  }

  void openSingleSelect() {
    showBottomSheet(BottomSheetType.singleSelect);
  }

  // === بناء واجهة الـ Bottom Sheet === ✅ محدث
  Widget _buildBottomSheetContent() {
    return Container(
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.9,
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          Expanded(
            child: _buildContent(),
          ),
          if (_shouldShowActions) const SizedBox(height: 20),
          if (_shouldShowActions) _buildActions(),
        ],
      ),
    );
  }

  bool get _shouldShowActions {
    return currentType.value != BottomSheetType.manageSections && 
           currentType.value != BottomSheetType.addNewSection &&
           currentType.value != BottomSheetType.manageAttributes &&
           currentType.value != BottomSheetType.addAttribute &&
           currentType.value != BottomSheetType.addAttributeValue &&
           currentType.value != BottomSheetType.selectAttributeValue &&
           currentType.value != BottomSheetType.addProduct;
  }

  Widget _buildHeader() {
    String title = '';
    switch (currentType.value) {
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
      case BottomSheetType.addProduct:
        title = 'إضافة منتج جديد';
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
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Obx(() {
      switch (currentType.value) {
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
        case BottomSheetType.addProduct:
          return _buildAddProductContent();
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

  // === واجهات إدارة السمات === ✅ جديد
  Widget _buildManageAttributesContent() {
    return Column(
      children: [
        _buildAttributeTabs(),
        const SizedBox(height: 16),
        Expanded(
          child: IndexedStack(
            index: attributeTabIndex.value,
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
              isActive: attributeTabIndex.value == 0,
              onTap: () => attributeTabIndex.value = 0,
            ),
          ),
          Expanded(
            child: _buildAttributeTabButton(
              text: 'الصفات',
              isActive: attributeTabIndex.value == 1,
              onTap: () {
                if (selectedAttributes.isNotEmpty && currentEditingAttribute.value == null) {
                  currentEditingAttribute.value = selectedAttributes.first;
                }
                attributeTabIndex.value = 1;
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
        controller: attributeSearchController,
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
                      controller: newAttributeController,
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
                      onTap: newAttributeName.value.trim().isNotEmpty 
                          ? _addNewAttribute
                          : null,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: newAttributeName.value.trim().isNotEmpty 
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
    final filteredAttributes = attributeSearchQuery.isEmpty 
        ? tempAttributes 
        : tempAttributes.where((attribute) => 
            attribute.name.toLowerCase().contains(attributeSearchQuery.value.toLowerCase())
          ).toList();

    if (filteredAttributes.isEmpty && attributeSearchQuery.isNotEmpty) {
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
    final isSelected = selectedAttributes.any((attr) => attr.id == attribute.id);
    
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
    final hasSelectedAttributes = selectedAttributes.isNotEmpty;
    
    if (hasSelectedAttributes) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: ElevatedButton(
          onPressed: () {
            if (currentEditingAttribute.value == null) {
              currentEditingAttribute.value = selectedAttributes.first;
            }
            attributeTabIndex.value = 1;
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
    if (selectedAttributes.isEmpty) {
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
          children: selectedAttributes.map((attribute) {
            final isActive = currentEditingAttribute.value?.id == attribute.id;
            return ChoiceChip(
              label: Text(attribute.name),
              selected: isActive,
              onSelected: (selected) => currentEditingAttribute.value = attribute,
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
    final currentAttribute = currentEditingAttribute.value;
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
                      controller: newAttributeValueController,
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
                      onTap: newAttributeValue.value.trim().isNotEmpty 
                          ? _addNewAttributeValue
                          : null,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: newAttributeValue.value.trim().isNotEmpty 
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
    final currentAttribute = currentEditingAttribute.value;
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
                attributeTabIndex.value = 0;
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
          controller: newAttributeController,
          onChanged: (value) => newAttributeName.value = value,
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
    final currentAttribute = currentEditingAttribute.value;
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
          controller: newAttributeValueController,
          onChanged: (value) => newAttributeValue.value = value,
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
    final currentAttribute = currentEditingAttribute.value;
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

  // === دوال إدارة السمات === ✅ جديد
  void _toggleAttributeSelection(ProductAttribute attribute) {
    final isCurrentlySelected = selectedAttributes.any((attr) => attr.id == attribute.id);
    
    if (isCurrentlySelected) {
      selectedAttributes.removeWhere((attr) => attr.id == attribute.id);
      if (currentEditingAttribute.value?.id == attribute.id) {
        currentEditingAttribute.value = selectedAttributes.isNotEmpty ? selectedAttributes.first : null;
      }
    } else {
      final newAttribute = attribute.copyWith(
        values: attribute.values.map((value) => value.copyWith(isSelected: true)).toList()
      );
      selectedAttributes.add(newAttribute);
      
      if (currentEditingAttribute.value == null) {
        currentEditingAttribute.value = newAttribute;
      }
    }
  }

  void _addNewAttribute() {
    final name = newAttributeName.value.trim();
    if (name.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى إدخال اسم السمة');
      return;
    }

    if (tempAttributes.any((attr) => attr.name.toLowerCase() == name.toLowerCase())) {
      Get.snackbar('تنبيه', 'اسم السمة موجود مسبقاً');
      return;
    }

    final newAttribute = ProductAttribute(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      values: [],
    );

    tempAttributes.add(newAttribute);
    newAttributeController.clear();
    newAttributeName.value = '';
    
    Get.snackbar('نجاح', 'تم إضافة السمة "$name" بنجاح');
  }

  void _addNewAttributeValue() {
    final valueText = newAttributeValue.value.trim();
    final attribute = currentEditingAttribute.value;
    
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
    newAttributeValueController.clear();
    newAttributeValue.value = '';
    
    Get.snackbar('نجاح', 'تم إضافة الصفة "$valueText" بنجاح');
  }

  void _toggleAttributeValueSelection(AttributeValue value) {
    value.isSelected.toggle();
  }

  void _saveAttributesAndClose() {
    // هنا يمكنك إرجاع البيانات إلى ProductVariationController
    Get.back();
    Get.snackbar('نجاح', 'تم حفظ السمات والصفات بنجاح');
  }

  // === دوال إدارة الأقسام والمنتجات === ✅ محفوظة
  List<String> get filteredSections {
    if (sectionSearchText.isEmpty) return storeSections;
    return storeSections.where((section) => 
      section.toLowerCase().contains(sectionSearchText.toLowerCase())
    ).toList();
  }
  
  bool get isTextSimilarToExisting {
    if (sectionSearchText.isEmpty) return false;
    return storeSections.any((section) => 
      section.toLowerCase() == sectionSearchText.toLowerCase()
    );
  }

  void _addSectionFromSearch() {
    if (sectionSearchText.isNotEmpty && !isTextSimilarToExisting) {
      storeSections.add(sectionSearchText.value);
      sectionSearchText.value = '';
      Get.snackbar(
        'تمت الإضافة',
        'تم إضافة القسم الجديد بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  bool _isSectionNameExists(String name) {
    return storeSections.any((section) => 
      section.toLowerCase() == name.toLowerCase()
    );
  }

  void _addNewSection() {
    if (newSectionName.isNotEmpty && !_isSectionNameExists(newSectionName.value)) {
      storeSections.add(newSectionName.value);
      newSectionName.value = '';
      Get.back();
      Get.snackbar(
        'تمت الإضافة',
        'تم إضافة القسم الجديد بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  // === دوال إدارة المنتج === ✅ محفوظة
  void _addProductImage() {
    if (productImages.length < 5) {
      productImages.add('https://via.placeholder.com/150');
      Get.snackbar(
        'تمت الإضافة',
        'تم إضافة صورة المنتج',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void _nextStep() {
    if (currentStep.value < 2) {
      currentStep.value++;
    } else {
      _submitProduct();
    }
  }

  void _previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void _submitProduct() {
    if (productName.isEmpty || selectedCategory.isEmpty || productPrice.value <= 0) {
      Get.snackbar(
        'خطأ',
        'يرجى ملء جميع الحقول المطلوبة',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    print('''
    تم إضافة المنتج:
    - القسم: ${selectedSection.value}
    - الاسم: ${productName.value}
    - الوصف: ${productDescription.value}
    - الفئة: ${selectedCategory.value}
    - السعر: ${productPrice.value}
    - الكمية: ${productQuantity.value}
    - عدد الصور: ${productImages.length}
    ''');

    Get.back();
    _resetProductData();
    
    Get.snackbar(
      'نجح',
      'تم إضافة المنتج بنجاح إلى قسم ${selectedSection.value}',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  void _resetProductData() {
    currentStep.value = 0;
    productName.value = '';
    productDescription.value = '';
    productPrice.value = 0.0;
    productQuantity.value = 0;
    productImages.clear();
    selectedCategory.value = '';
  }

  // === واجهات إدارة الأقسام والمنتجات === ✅ محفوظة
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
        
        Obx(() {
          if (storeSections.isEmpty) {
            return AateneButton(
              color: AppColors.primary300.withAlpha(50),
              textColor: AppColors.primary400,
              borderColor: Colors.transparent,
              buttonText: isRTL ? 'إضافة قسم جديد' : 'Add a new section',
              onTap: () {
                openAddNewSection(); 
                Get.back(); 
              },
            );
          } else {
            return Column(
              children: [
                TextFiledAatene(
                  heightTextFiled: 50,
                  onChanged: (value) => sectionSearchText.value = value,
                  prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
                  isRTL: isRTL, 
                  hintText: isRTL ? 'ابحث في الأقسام' : 'Search sections',
                ),
                const SizedBox(height: 20),
                
                Container(
                  constraints: const BoxConstraints(
                    maxHeight: 200,
                  ),
                  child: Obx(() {
                    if (filteredSections.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'لا توجد أقسام تطابق البحث',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    }
                    
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredSections.length,
                      itemBuilder: (context, index) {
                        final section = filteredSections[index];
                        return Obx(() => RadioListTile<String>(
                          title: Text(section),
                          value: section,
                          groupValue: selectedSection.value,
                          onChanged: (value) {
                            selectedSection.value = value!;
                          },
                        ));
                      },
                    );
                  }),
                ),
                const SizedBox(height: 20),
                
                AateneButton(
                  color: AppColors.primary400,
                  textColor: Colors.white,
                  borderColor: Colors.transparent,
                  buttonText: isRTL ? 'التالي' : 'Next',
                 onTap: selectedSection.isNotEmpty ? () {
                    Get.back();
                    Get.toNamed('/stepper-screen');
                 } : null,
                ),
                const SizedBox(height: 10),
                
                AateneButton(
                  color: AppColors.primary300.withAlpha(50),
                  textColor: AppColors.primary400,
                  borderColor: Colors.transparent,
                  buttonText: isRTL ? 'إضافة قسم جديد' : 'Add a new section',
                  onTap: () {
                    if (sectionSearchText.isNotEmpty && !isTextSimilarToExisting) {
                      _addSectionFromSearch();
                    } else {
                      openAddNewSection(); 
                      Get.back(); 
                    }
                  },
                ),
                
                Obx(() {
                  if (sectionSearchText.isNotEmpty && isTextSimilarToExisting) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'هذا الاسم مشابه لقسم موجود مسبقاً',
                        style: TextStyle(
                          color: Colors.orange,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            );
          }
        }),
      ],
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
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 20),
        TextFiledAatene(
          heightTextFiled: 50,
          onChanged: (value) => newSectionName.value = value,
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          isRTL: isRTL, 
          hintText: isRTL ? 'أضف اسم القسم' : 'Add department name',
        ),
        const SizedBox(height: 20),
        
        Obx(() {
          if (newSectionName.isNotEmpty && _isSectionNameExists(newSectionName.value)) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'هذا الاسم مشابه لقسم موجود مسبقاً',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                ),
                textAlign: TextAlign.right,
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
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('إلغاء'),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Obx(() => ElevatedButton(
                onPressed: newSectionName.isNotEmpty && !_isSectionNameExists(newSectionName.value) 
                    ? _addNewSection 
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('إضافة'),
              )),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddProductContent() {
    return Container(
      height: Get.height * 0.8,
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 10),
          _buildSelectedSectionCard(),
          const SizedBox(height: 20),
          Expanded(
            child: _buildProductStepper(),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedSectionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'سيتم إضافة المنتج إلى:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.primary500,
            ),
          ),
          Row(
            children: [
              Text(
                selectedSection.value,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary400,
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () {
                  Get.back();
                  openManageSections();
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.edit,
                    size: 16,
                    color: AppColors.primary400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProductStepper() {
    return Obx(() => Stepper(
      type: StepperType.horizontal,
      currentStep: currentStep.value,
      onStepContinue: _nextStep,
      onStepCancel: _previousStep,
      onStepTapped: (step) => currentStep.value = step,
      elevation: 0,
      controlsBuilder: (context, details) {
        return Row(
          children: [
            if (currentStep.value > 0)
              OutlinedButton(
                onPressed: details.onStepCancel,
                child: const Text('السابق'),
              ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: details.onStepContinue,
              child: Text(currentStep.value == 2 ? 'إنهاء' : 'التالي'),
            ),
          ],
        );
      },
      steps: [
        Step(
          title: const SizedBox(),
          content: _buildBasicInfoStep(),
          isActive: currentStep.value >= 0,
          state: currentStep.value > 0 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const SizedBox(),
          content: _buildImagesAndPriceStep(),
          isActive: currentStep.value >= 1,
          state: currentStep.value > 1 ? StepState.complete : StepState.indexed,
        ),
        Step(
          title: const SizedBox(),
          content: _buildReviewStep(),
          isActive: currentStep.value >= 2,
        ),
      ],
    ));
  }

  Widget _buildBasicInfoStep() {
    return Column(
      children: [
        TextFiledAatene(
          heightTextFiled: 50,
          onChanged: (value) => productName.value = value,
          hintText: 'اسم المنتج',
          isRTL: isRTL,
        ),
        const SizedBox(height: 16),
        TextFiledAatene(
          heightTextFiled: 80,
          onChanged: (value) => productDescription.value = value,
          hintText: 'وصف المنتج',
          isRTL: isRTL,
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          value: selectedCategory.value.isEmpty ? null : selectedCategory.value,
          items: productCategories.map((category) {
            return DropdownMenuItem(
              value: category,
              child: Text(category),
            );
          }).toList(),
          onChanged: (value) => selectedCategory.value = value!,
          decoration: const InputDecoration(
            labelText: 'الفئة',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildImagesAndPriceStep() {
    return Column(
      children: [
        const Text(
          'صور المنتج',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Obx(() => Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            ...productImages.map((image) => Stack(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(image),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: -5,
                  right: -5,
                  child: IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () => productImages.remove(image),
                  ),
                ),
              ],
            )).toList(),
            
            if (productImages.length < 5)
              GestureDetector(
                onTap: _addProductImage,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate, color: Colors.grey),
                      const Text('إضافة', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
          ],
        )),
        const SizedBox(height: 20),
        
        Row(
          children: [
            Expanded(
              child: TextFiledAatene(
                heightTextFiled: 50,
                onChanged: (value) => productPrice.value = double.tryParse(value) ?? 0.0,
                hintText: 'السعر',
                isRTL: isRTL,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextFiledAatene(
                heightTextFiled: 50,
                onChanged: (value) => productQuantity.value = int.tryParse(value) ?? 0,
                hintText: 'الكمية',
                isRTL: isRTL,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('مراجعة المعلومات:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildReviewItem('القسم', selectedSection.value),
        _buildReviewItem('اسم المنتج', productName.value),
        _buildReviewItem('الوصف', productDescription.value),
        _buildReviewItem('الفئة', selectedCategory.value),
        _buildReviewItem('السعر', '${productPrice.value} ريال'),
        _buildReviewItem('الكمية', productQuantity.value.toString()),
        _buildReviewItem('عدد الصور', productImages.length.toString()),
      ],
    );
  }

  Widget _buildReviewItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value.isEmpty ? 'غير محدد' : value)),
        ],
      ),
    );
  }

  // === واجهات الفلترة والترتيب === ✅ محفوظة
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
        // يمكنك فتح نافذة منبثقة فرعية هنا
        print('فتح $title');
      },
    );
  }
  
  Widget _buildSortContent() {
    return Column(
      children: sortOptions.map((option) {
        return Obx(() => RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: selectedOption.value,
          onChanged: (value) {
            selectedOption.value = value!;
          },
        ));
      }).toList(),
    );
  }
  
  Widget _buildMultiSelectContent() {
    return Column(
      children: multiSelectOptions.map((option) {
        return Obx(() => CheckboxListTile(
          title: Text(option),
          value: selectedOptions.contains(option),
          onChanged: (value) {
            if (value == true) {
              selectedOptions.add(option);
            } else {
              selectedOptions.remove(option);
            }
          },
        ));
      }).toList(),
    );
  }
  
  Widget _buildSingleSelectContent() {
    return Column(
      children: singleSelectOptions.map((option) {
        return Obx(() => RadioListTile<String>(
          title: Text(option),
          value: option,
          groupValue: selectedOption.value,
          onChanged: (value) {
            selectedOption.value = value!;
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
              selectedOptions.clear();
              selectedOption.value = '';
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
    switch (currentType.value) {
      case BottomSheetType.filter:
        print('تطبيق الفلاتر: ${selectedOptions.join(', ')}');
        break;
      case BottomSheetType.sort:
        print('تم الترتيب حسب: ${selectedOption.value}');
        break;
      case BottomSheetType.multiSelect:
        print('الخيارات المحددة: ${selectedOptions.join(', ')}');
        break;
      case BottomSheetType.singleSelect:
        print('الخيار المحدد: ${selectedOption.value}');
        break;
      default:
        break;
    }
    Get.back();
  }

  // === دوال الحصول على البيانات === ✅ جديد
  List<ProductAttribute> getSelectedAttributes() {
    return selectedAttributes.toList();
  }

  List<ProductAttribute> getAllAttributes() {
    return tempAttributes.toList();
  }

  void updateAttributes(List<ProductAttribute> attributes) {
    tempAttributes.assignAll(attributes);
  }

  @override
  void onClose() {
    attributeSearchController.dispose();
    newAttributeController.dispose();
    newAttributeValueController.dispose();
    super.onClose();
  }
}