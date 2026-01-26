import '../../../../general_index.dart';
import '../../../../utils/responsive/index.dart';

class AttributesBottomSheet extends StatefulWidget {
  final List<ProductAttribute> allAttributes;
  final List<ProductAttribute> selectedAttributes;
  final Function(List<ProductAttribute>) onAttributesSelected;
  final bool isMultiSelectAttributes;
  final bool isMultiSelectValues;

  const AttributesBottomSheet({
    super.key,
    required this.allAttributes,
    required this.selectedAttributes,
    required this.onAttributesSelected,
    this.isMultiSelectAttributes = true,
    this.isMultiSelectValues = true,
  });

  @override
  State<AttributesBottomSheet> createState() => _AttributesBottomSheetState();
}

class _AttributesBottomSheetState extends State<AttributesBottomSheet> {
  final List<ProductAttribute> _tempSelectedAttributes = [];
  int _currentStep = 0;
  int _currentValueTabIndex = 0;
  final Map<String, bool> _attributeSelectionState = {};

  String _attributeSearchQuery = '';
  String _valueSearchQuery = '';

  @override
  void initState() {
    super.initState();

    for (var attr in widget.allAttributes) {
      _attributeSelectionState[attr.id] = widget.selectedAttributes.any(
        (selected) => selected.id == attr.id,
      );
    }

    _tempSelectedAttributes.addAll(
      widget.selectedAttributes.map((attr) {
        return attr.copyWith(
          values: attr.values.map((value) {
            return AttributeValue(
              id: value.id,
              value: value.value,
              colorCode: value.colorCode,
              isSelected: false.obs,
            );
          }).toList(),
        );
      }).toList(),
    );

    if (_tempSelectedAttributes.isNotEmpty) {
      _currentStep = 1;
    }
  }

  List<ProductAttribute> _getFilteredAttributes() {
    if (_attributeSearchQuery.isEmpty) {
      return widget.allAttributes;
    }
    return widget.allAttributes.where((attribute) {
      return attribute.name.toLowerCase().contains(
        _attributeSearchQuery.toLowerCase(),
      );
    }).toList();
  }

  List<AttributeValue> _getFilteredValues(ProductAttribute attribute) {
    if (_valueSearchQuery.isEmpty) {
      return attribute.values;
    }
    return attribute.values.where((value) {
      return value.value.toLowerCase().contains(
        _valueSearchQuery.toLowerCase(),
      );
    }).toList();
  }

  Widget _buildSelectAttributesStep() {
    final filteredAttributes = _getFilteredAttributes();

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.f(16),
            vertical: ResponsiveDimensions.f(12),
          ),
          decoration: BoxDecoration(color: Colors.white),
          child: Text(
            'اختر السمات لاستخدامها في الاختلافات',
            style: getBold(fontSize: ResponsiveDimensions.f(18)),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TextWithStar(text: 'اختر السمة'),
        ),
        SizedBox(height: 15),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.f(16),
            vertical: ResponsiveDimensions.f(8),
          ),
          child: TextField(
            controller: TextEditingController(text: _attributeSearchQuery),
            onChanged: (value) {
              setState(() {
                _attributeSearchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'ابحث عن سمة...',
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: _attributeSearchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, size: 20),
                      onPressed: () {
                        setState(() {
                          _attributeSearchQuery = '';
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),

        if (_attributeSearchQuery.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${filteredAttributes.length} نتيجة',
                style: getRegular(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),

        Expanded(
          child: filteredAttributes.isEmpty
              ? _buildNoSearchResults()
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: filteredAttributes.length,
                  itemBuilder: (context, index) {
                    final attribute = filteredAttributes[index];
                    return _buildAttributeItemWithCheckbox(attribute);
                  },
                ),
        ),

        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
          ),
          child: Row(
            spacing: 5,
            children: [
              Expanded(
                child: AateneButton(
                  onTap: () => Get.back(),
                  buttonText: "إلغاء",
                  textColor: AppColors.primary400,
                  borderColor: AppColors.primary400,
                  color: AppColors.light1000,
                ),
                // OutlinedButton(
                //   onPressed: () => Get.back(),
                //   style: OutlinedButton.styleFrom(
                //     padding: EdgeInsets.symmetric(vertical: 14),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //     side: BorderSide(color: Colors.grey[400]!),
                //   ),
                //   child: Text('إلغاء', style: getRegular(color: Colors.grey)),
                // ),
              ),
              Expanded(
                child: AateneButton(
                  onTap: _getSelectedAttributesCount() > 0
                      ? _proceedToValuesStep
                      : null,
                  buttonText: "التالي",
                  textColor: AppColors.light1000,
                  borderColor: AppColors.primary400,
                  color: AppColors.primary400,
                ),

                // ElevatedButton(
                //   onPressed: _getSelectedAttributesCount() > 0
                //       ? _proceedToValuesStep
                //       : null,
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: AppColors.primary400,
                //     padding: EdgeInsets.symmetric(vertical: 14),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                //   child: Text('التالي', style: getRegular(color: Colors.white)),
                // ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAttributeItemWithCheckbox(ProductAttribute attribute) {
    final isSelected = _attributeSelectionState[attribute.id] ?? false;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      leading: _buildAttributeCheckbox(isSelected, attribute),
      title: Text(
        attribute.name,
        style: getMedium(
          color: isSelected ? AppColors.primary500 : Colors.black87,
        ),
      ),
      onTap: () {
        _toggleAttributeSelection(attribute);
      },
    );
  }

  Widget _buildAttributeCheckbox(bool isSelected, ProductAttribute attribute) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: Colors.grey[400]),
        child: Checkbox(
          value: isSelected,
          onChanged: (bool? newValue) {
            _toggleAttributeSelection(attribute);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          activeColor: AppColors.primary400,
          checkColor: Colors.white,
          side: BorderSide(color: Colors.grey[400]!, width: 1.5),
        ),
      ),
    );
  }

  void _toggleAttributeSelection(ProductAttribute attribute) {
    if (!widget.isMultiSelectAttributes &&
        !(_attributeSelectionState[attribute.id] ?? false)) {
      for (var attr in widget.allAttributes) {
        _attributeSelectionState[attr.id] = false;
      }
    }

    setState(() {
      _attributeSelectionState[attribute.id] =
          !(_attributeSelectionState[attribute.id] ?? false);
    });
  }

  int _getSelectedAttributesCount() {
    return _attributeSelectionState.values
        .where((isSelected) => isSelected)
        .length;
  }

  void _proceedToValuesStep() {
    final selectedAttributes = widget.allAttributes
        .where((attr) => _attributeSelectionState[attr.id] ?? false)
        .toList();

    if (selectedAttributes.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'يرجى اختيار سمة واحدة على الأقل',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    _tempSelectedAttributes.clear();
    _tempSelectedAttributes.addAll(
      selectedAttributes.map((attr) {
        return attr.copyWith(
          values: attr.values.map((value) {
            return AttributeValue(
              id: value.id,
              value: value.value,
              colorCode: value.colorCode,
              isSelected: false.obs,
            );
          }).toList(),
        );
      }),
    );

    setState(() {
      _currentStep = 1;
      _currentValueTabIndex = 0;
      _valueSearchQuery = '';
    });
  }

  Widget _buildNoSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text('لا توجد نتائج', style: getBold()),
          SizedBox(height: 8),
          Text(
            'لم يتم العثور على سمات تطابق "$_attributeSearchQuery"',
            style: getRegular(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSelectValuesStep() {
    if (_tempSelectedAttributes.isEmpty) {
      return Center(child: Text('لا توجد سمات مختارة'));
    }

    final currentAttribute = _tempSelectedAttributes[_currentValueTabIndex];
    final filteredValues = _getFilteredValues(currentAttribute);

    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.f(16),
            vertical: ResponsiveDimensions.f(12),
          ),
          decoration: BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Text(
                'أضف الصفات الخاصة بالسمات المختارة',
                style: getBold(fontSize: ResponsiveDimensions.f(18)),
              ),
              SizedBox(height: 12),
              _buildAttributesTabs(),
            ],
          ),
        ),

        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveDimensions.f(16),
            vertical: ResponsiveDimensions.f(8),
          ),
          child: TextField(
            controller: TextEditingController(text: _valueSearchQuery),
            onChanged: (value) {
              setState(() {
                _valueSearchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'ابحث في قيم ${currentAttribute.name}...',
              prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              suffixIcon: _valueSearchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, size: 20),
                      onPressed: () {
                        setState(() {
                          _valueSearchQuery = '';
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),

        if (_valueSearchQuery.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '${filteredValues.length} نتيجة',
                style: getRegular(fontSize: 12, color: Colors.grey),
              ),
            ),
          ),

        Expanded(
          child: filteredValues.isEmpty
              ? _buildNoValueSearchResults()
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: filteredValues.length,
                  itemBuilder: (context, index) {
                    final value = filteredValues[index];
                    return _buildValueItemWithCheckbox(value, currentAttribute);
                  },
                ),
        ),

        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey[300]!, width: 1)),
          ),
          child: Expanded(
            child: AateneButton(
              onTap: _saveAndClose,
              buttonText: "حفظ",
              textColor: AppColors.light1000,
              borderColor: AppColors.primary400,
              color: AppColors.primary400,
            ),
            // ElevatedButton(
            //   onPressed: _saveAndClose,
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: AppColors.primary400,
            //     padding: EdgeInsets.symmetric(vertical: 14),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //   ),
            //   child: Text('حفظ', style: getRegular(color: Colors.white)),
            // ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttributesTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tempSelectedAttributes.length, (index) {
          final attribute = _tempSelectedAttributes[index];
          final isSelected = index == _currentValueTabIndex;
          final selectedValuesCount = attribute.values
              .where((value) => value.isSelected.value)
              .length;

          return GestureDetector(
            onTap: () {
              setState(() {
                _currentValueTabIndex = index;
                _valueSearchQuery = '';
              });
            },
            child: Container(
              margin: EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary400 : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary400 : Colors.grey[300]!,
                ),
              ),
              child: Row(
                children: [
                  if (selectedValuesCount > 0)
                    Container(
                      width: 22,
                      height: 22,
                      margin: EdgeInsets.only(left: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : AppColors.primary400,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          selectedValuesCount.toString(),
                          style: getBold(
                            fontSize: 11,
                            color: isSelected
                                ? AppColors.primary400
                                : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  SizedBox(width: 8),
                  Text(
                    attribute.name,
                    style: getRegular(
                      color: isSelected ? Colors.white : Colors.grey,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildValueItemWithCheckbox(
    AttributeValue value,
    ProductAttribute attribute,
  ) {
    return Obx(() {
      final isSelected = value.isSelected.value;

      return ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: _buildValueCheckbox(isSelected, value, attribute),
        title: Text(
          value.value,
          style: getRegular(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: isSelected ? AppColors.primary500 : Colors.black87,
          ),
        ),
        onTap: () {
          _toggleValueSelection(value, attribute);
        },
      );
    });
  }

  Widget _buildValueCheckbox(
    bool isSelected,
    AttributeValue value,
    ProductAttribute attribute,
  ) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Theme(
        data: ThemeData(unselectedWidgetColor: Colors.grey[400]),
        child: Checkbox(
          value: isSelected,
          onChanged: (bool? newValue) {
            _toggleValueSelection(value, attribute);
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          activeColor: AppColors.primary400,
          checkColor: Colors.white,
          side: BorderSide(color: Colors.grey[400]!, width: 1.5),
        ),
      ),
    );
  }

  void _toggleValueSelection(AttributeValue value, ProductAttribute attribute) {
    if (!widget.isMultiSelectValues) {
      for (var v in attribute.values) {
        v.isSelected.value = (v == value);
      }
    } else {
      value.isSelected.toggle();
    }
    setState(() {});
  }

  Widget _buildNoValueSearchResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text('لا توجد نتائج', style: getBold()),
          SizedBox(height: 8),
          Text(
            'لم يتم العثور على قيم تطابق "$_valueSearchQuery"',
            style: getRegular(fontSize: 14, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _saveAndClose() {
    for (var attribute in _tempSelectedAttributes) {
      final hasSelectedValue = attribute.values.any(
        (value) => value.isSelected.value,
      );

      if (!hasSelectedValue) {
        final index = _tempSelectedAttributes.indexOf(attribute);
        setState(() {
          _currentValueTabIndex = index;
        });

        Get.snackbar(
          'تنبيه',
          'يرجى اختيار قيمة واحدة على الأقل لـ ${attribute.name}',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      if (!widget.isMultiSelectValues) {
        final selectedCount = attribute.values
            .where((value) => value.isSelected.value)
            .length;

        if (selectedCount > 1) {
          Get.snackbar(
            'تنبيه',
            'يمكن اختيار قيمة واحدة فقط لـ ${attribute.name}',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }
      }
    }

    widget.onAttributesSelected(_tempSelectedAttributes);
    Get.back();

    Get.snackbar(
      'تم الحفظ',
      'تم حفظ ${_tempSelectedAttributes.length} سمة مع قيمها المختارة',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: _currentStep == 0
          ? _buildSelectAttributesStep()
          : _buildSelectValuesStep(),
    );
  }
}
