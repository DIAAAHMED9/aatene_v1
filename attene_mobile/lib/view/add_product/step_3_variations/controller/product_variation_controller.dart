
import '../../../../general_index.dart';

class ProductVariationController extends GetxController {
  late DataInitializerService _dataService;
  late MyAppController _myAppController;

  final RxBool _hasVariations = false.obs;
  final RxList<ProductAttribute> _selectedAttributes = <ProductAttribute>[].obs;
  final RxList<ProductAttribute> _allAttributes = <ProductAttribute>[].obs;
  final RxList<ProductVariation> _variations = <ProductVariation>[].obs;

  final RxBool _isLoadingAttributes = false.obs;
  final RxString _attributesError = ''.obs;
  final RxBool _hasAttemptedLoad = false.obs;
  final RxBool _isGeneratingVariations = false.obs;
  final RxBool _isSavingData = false.obs;

  final RxInt _selectedAttributesCount = 0.obs;
  final RxInt _totalVariationsCount = 0.obs;
  final RxInt _activeVariationsCount = 0.obs;
  final RxBool _isOfflineMode = false.obs;
  final RxString _lastLoadTime = ''.obs;

  static const String attributesUpdateId = 'attributes';
  static const String variationsUpdateId = 'variations';
  static const String loadingUpdateId = 'loading';

  @override
  void onInit() {
    super.onInit();
    print('🚀 [VARIATION CONTROLLER] Initializing...');

    _initializeServices();
    _loadCachedData();
    _setupListeners();
  }

  void _initializeServices() {
    _dataService = Get.find<DataInitializerService>();
    _myAppController = Get.find<MyAppController>();
  }

  void _setupListeners() {
    ever(_selectedAttributes, (_) {
      _selectedAttributesCount.value = _selectedAttributes.length;
      print(
        '📊 [VARIATIONS] Selected attributes count updated: ${_selectedAttributesCount.value}',
      );
    });

    ever(_variations, (_) {
      _totalVariationsCount.value = _variations.length;
      _activeVariationsCount.value = _variations
          .where((v) => v.isActive.value)
          .length;
      print('📊 [VARIATIONS] Variations count updated: ${_variations.length}');
    });
  }

  Future<void> _loadCachedData() async {
    try {
      final cachedAttributes = _dataService.getAttributesForVariations();
      if (cachedAttributes.isNotEmpty) {
        _allAttributes.assignAll(cachedAttributes);
        print(
          '📥 [VARIATIONS] Loaded ${cachedAttributes.length} cached attributes',
        );
      }

      final variationsData = _dataService.getVariationsData();
      if (variationsData.isNotEmpty) {
        loadVariationsData(variationsData);
        print('📥 [VARIATIONS] Loaded cached variations data');
      }
    } catch (e) {
      print('⚠️ [VARIATIONS] Error loading cached data: $e');
    }
  }

  Future<void> loadAttributesOnOpen() async {
    if (_hasAttemptedLoad.value && _allAttributes.isNotEmpty) {
      print('📂 [VARIATIONS] Using preloaded attributes');
      return;
    }

    if (!_myAppController.isLoggedIn.value) {
      _attributesError.value = 'يجب تسجيل الدخول أولاً';
      print('⚠️ [VARIATIONS] User not logged in');
      return;
    }

    await _performLoadAttributes();
  }

  Future<void> _performLoadAttributes() async {
    try {
      _hasAttemptedLoad.value = true;
      _isLoadingAttributes.value = true;
      _attributesError.value = '';

      print('📡 [VARIATIONS] Fetching attributes from API');

      final response = await ApiHelper.get(
        path: '/merchants/attributes',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final attributesList = List<Map<String, dynamic>>.from(
          response['data'] ?? [],
        );
        final loadedAttributes = attributesList
            .map(ProductAttribute.fromApiJson)
            .toList();

        _allAttributes.assignAll(loadedAttributes);
        _lastLoadTime.value = DateTime.now().toIso8601String();

        print(
          '✅ [VARIATIONS] Loaded ${_allAttributes.length} attributes successfully',
        );

        await _saveAttributesLocally(attributesList);
      } else {
        final errorMessage = response?['message'] ?? 'فشل في تحميل السمات';
        _attributesError.value = errorMessage;
        print('❌ [VARIATIONS] Failed to load attributes: $errorMessage');

        await _useCachedDataAsFallback();
      }
    } catch (e) {
      final error = 'حدث خطأ أثناء تحميل السمات: $e';
      _attributesError.value = error;
      print('❌ [VARIATIONS] Error loading attributes: $e');

      _isOfflineMode.value = true;
      await _useCachedDataAsFallback();
    } finally {
      _isLoadingAttributes.value = false;
      update([loadingUpdateId, attributesUpdateId]);
    }
  }

  Future<void> _saveAttributesLocally(
    List<Map<String, dynamic>> attributesList,
  ) async {
    try {
      await _dataService.saveAttributesForVariations(attributesList);
      print('💾 [VARIATIONS] Saved attributes locally');
    } catch (e) {
      print('⚠️ [VARIATIONS] Error saving attributes locally: $e');
    }
  }

  Future<void> _useCachedDataAsFallback() async {
    try {
      final cachedAttributes = _dataService.getAttributesForVariations();
      if (cachedAttributes.isNotEmpty) {
        _allAttributes.assignAll(cachedAttributes);
        _attributesError.value = 'يتم استخدام البيانات المخزنة (غير متصل)';
        print('📂 [VARIATIONS] Using cached data as fallback');
      }
    } catch (e) {
      print('⚠️ [VARIATIONS] Error using cached data: $e');
    }
  }

  void toggleHasVariations(bool value) {
    _hasVariations.value = value;
    print('🎯 [VARIATIONS] Toggle hasVariations to: $value');

    if (!value) {
      clearAllData();
    }

    _saveCurrentState();

    update([attributesUpdateId, variationsUpdateId]);

    // Get.snackbar(
    //   value ? 'تم التفعيل' : 'تم التعطيل',
    //   value ? 'تم تفعيل نظام الاختلافات' : 'تم تعطيل نظام الاختلافات',
    //   backgroundColor: value ? Colors.green : Colors.orange,
    //   colorText: Colors.white,
    //   duration: const Duration(seconds: 3),
    // );
  }

  Future<void> openAttributesManagement() async {
    print('🎯 [VARIATIONS] Opening attributes management');

    if (_isLoadingAttributes.value) {
      Get.snackbar('تنبيه', 'جاري تحميل السمات...');
      return;
    }

    if (_allAttributes.isEmpty) {
      print('🔄 [VARIATIONS] No attributes found, loading...');
      Get.snackbar('جاري التحميل', 'لا توجد سمات متاحة. جاري التحميل...');
      await loadAttributesOnOpen();

      if (_allAttributes.isEmpty) {
        Get.snackbar('خطأ', 'فشل في تحميل السمات. يرجى المحاولة لاحقاً');
        return;
      }
    }

    _openAttributesBottomSheet();
  }

  void _openAttributesBottomSheet() {
    print('📱 [VARIATIONS] Opening attributes bottom sheet');

    Get.bottomSheet(
      AttributesBottomSheet(
        allAttributes: _allAttributes,
        selectedAttributes: _selectedAttributes,
        onAttributesSelected: (selectedAttributes) {
          updateSelectedAttributes(selectedAttributes);
          if (_variations.isEmpty && _hasVariations.value) {
            generateSingleVariation();
          }
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void updateSelectedAttributes(List<ProductAttribute> attributes) {
    final oldCount = _selectedAttributes.length;
    _selectedAttributes.assignAll(attributes);
    _selectedAttributesCount.value = attributes.length;

    print(
      '✅ [VARIATIONS] Updated attributes: ${attributes.length} attributes saved',
    );

    if (oldCount > attributes.length && _variations.isNotEmpty) {
      _regenerateVariationsAfterAttributeChange();
    }

    update([attributesUpdateId]);
    _saveCurrentState();
  }

  void _regenerateVariationsAfterAttributeChange() {
    final List<ProductVariation> updatedVariations = [];

    for (final variation in _variations) {
      final newAttributes = Map<String, String>.from(variation.attributes);

      for (final key in variation.attributes.keys.toList()) {
        if (!_selectedAttributes.any((attr) => attr.name == key)) {
          newAttributes.remove(key);
        }
      }

      for (final attribute in _selectedAttributes) {
        if (!newAttributes.containsKey(attribute.name)) {
          final selectedValue = attribute.values.firstWhereOrNull(
            (value) => value.isSelected.value,
          );
          if (selectedValue != null) {
            newAttributes[attribute.name] = selectedValue.value;
          } else if (attribute.values.isNotEmpty) {
            newAttributes[attribute.name] = attribute.values.first.value;
          }
        }
      }

      final updatedVariation = variation.copyWith(attributes: newAttributes);
      updatedVariations.add(updatedVariation);
    }

    _variations.assignAll(updatedVariations);
    update([variationsUpdateId]);
  }

  void removeSelectedAttribute(ProductAttribute attribute) {
    final attributeName = attribute.name;
    _selectedAttributes.removeWhere((attr) => attr.id == attribute.id);
    _selectedAttributesCount.value = _selectedAttributes.length;

    for (final variation in _variations) {
      variation.attributes.remove(attributeName);
    }

    print('🗑️ [VARIATIONS] Deleted attribute: $attributeName');

    update([attributesUpdateId, variationsUpdateId]);
    _saveCurrentState();
  }

  void clearAllData() {
    _variations.clear();
    _selectedAttributes.clear();
    _selectedAttributesCount.value = 0;
    _totalVariationsCount.value = 0;
    _activeVariationsCount.value = 0;

    print('🧹 [VARIATIONS] Cleared all data');

    update([attributesUpdateId, variationsUpdateId]);
    _saveCurrentState();
  }

  void generateSingleVariation() {
    if (_selectedAttributes.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى اختيار السمات أولاً');
      return;
    }

    if (!_allAttributesHaveSelectedValues()) {
      Get.snackbar('تنبيه', 'يرجى اختيار قيم لجميع السمات المختارة');
      return;
    }

    final newVariation = ProductVariation(
      id: 'var_${DateTime.now().millisecondsSinceEpoch}_${_variations.length}',
      attributes: _getCombinedAttributes(),
      price: 0.0,
      stock: 0,
      sku: _generateAutoSku(),
      isActive: true,
      images: [],
    );

    if (_isVariationDuplicate(newVariation.attributes)) {
      Get.snackbar('تنبيه', 'هذه التركيبة موجودة مسبقاً');
      return;
    }

    _variations.add(newVariation);
    _updateCounters();

    update([variationsUpdateId]);

    Get.snackbar(
      'نجاح',
      'تم إنشاء بطاقة اختلاف جديدة',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );

    _saveCurrentState();
  }

  String _generateAutoSku() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp % 1000;
    return 'VAR${(_variations.length + 1).toString().padLeft(3, '0')}_$random';
  }

  Map<String, String> _getCombinedAttributes() {
    final combinedAttributes = <String, String>{};

    for (final attribute in _selectedAttributes) {
      final selectedValues = attribute.values
          .where((value) => value.isSelected.value)
          .toList();

      if (selectedValues.isNotEmpty) {
        combinedAttributes[attribute.name] = selectedValues.first.value;
      }
    }

    return combinedAttributes;
  }

  Map<String, String> _getDefaultAttributes() {
    final defaultAttributes = <String, String>{};

    for (final attribute in _selectedAttributes) {
      final selectedValues = attribute.values
          .where((value) => value.isSelected.value)
          .toList();

      if (selectedValues.isNotEmpty) {
        defaultAttributes[attribute.name] = selectedValues.first.value;
      } else if (attribute.values.isNotEmpty) {
        defaultAttributes[attribute.name] = attribute.values.first.value;
      }
    }

    return defaultAttributes;
  }

  bool _allAttributesHaveSelectedValues() {
    // In edit flows the user may change variation attributes directly from
    // the variation cards without opening the attributes bottom sheet.
    // In that case `isSelected` might not reflect the current state.
    // So we consider an attribute "has selected values" if:
    // - at least one value isSelected in the UI, OR
    // - at least one existing variation has a value for this attribute.
    for (final attribute in _selectedAttributes) {
      final hasUiSelection =
          attribute.values.any((value) => value.isSelected.value);
      if (hasUiSelection) continue;

      final hasAnyInVariations = _variations.any((v) {
        final val = v.attributes[attribute.name];
        return val != null && val.toString().trim().isNotEmpty;
      });

      if (!hasAnyInVariations) return false;
    }
    return true;
  }

  bool _isVariationDuplicate(Map<String, String> newAttributes) {
    for (final variation in _variations) {
      if (_areAttributesEqual(variation.attributes, newAttributes)) {
        return true;
      }
    }
    return false;
  }

  bool _areAttributesEqual(
    Map<String, String> attributes1,
    Map<String, String> attributes2,
  ) {
    if (attributes1.length != attributes2.length) return false;

    for (final entry in attributes1.entries) {
      if (attributes2[entry.key] != entry.value) {
        return false;
      }
    }
    return true;
  }

  void _updateCounters() {
    _totalVariationsCount.value = _variations.length;
    _activeVariationsCount.value = _variations
        .where((v) => v.isActive.value)
        .length;
  }

  void toggleVariationActive(ProductVariation variation) {
    final index = _variations.indexWhere((v) => v.id == variation.id);
    if (index != -1) {
      _variations[index].isActive.toggle();
      _updateCounters();
      update([variationsUpdateId]);
      _saveCurrentState();
    }
  }

  void removeVariation(ProductVariation variation) {
    _variations.removeWhere((v) => v.id == variation.id);
    _updateCounters();
    update([variationsUpdateId]);
    _saveCurrentState();

    Get.snackbar(
      'تم الحذف',
      'تم حذف الاختلاف',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  ValidationResult validateVariations() {
    if (_hasVariations.value && _selectedAttributes.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'يرجى إضافة السمات أولاً',
      );
    }

    if (_hasVariations.value && _variations.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'يرجى إنشاء قيم الاختلافات أولاً',
      );
    }

    if (_hasVariations.value && !_allAttributesHaveSelectedValues()) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'يرجى اختيار قيم لجميع السمات المختارة',
      );
    }

    for (final variation in _variations) {
      if (variation.price.value <= 0) {
        return ValidationResult(
          isValid: false,
          errorMessage: 'يرجى إدخال سعر صحيح لجميع الاختلافات',
        );
      }

      for (final attribute in _selectedAttributes) {
        if (!variation.attributes.containsKey(attribute.name)) {
          return ValidationResult(
            isValid: false,
            errorMessage:
                'يرجى اختيار قيمة لـ ${attribute.name} في جميع الاختلافات',
          );
        }
      }
      // SKU is optional for variations (backend doesn't require it).
      // If provided, we still ensure it isn't duplicated among variations.
      final sku = variation.sku.value.trim();
      if (sku.isNotEmpty) {
        final sameSkuVariations = _variations
            .where((v) => v.id != variation.id && v.sku.value.trim() == sku)
            .length;

        if (sameSkuVariations > 0) {
          return ValidationResult(
            isValid: false,
            errorMessage: 'SKU $sku مكرر في أكثر من اختلاف',
          );
        }
      }
}

    return ValidationResult(isValid: true, errorMessage: '');
  }

  Map<String, dynamic> getVariationsData() {
    final data = {
      'hasVariations': _hasVariations.value,
      'selectedAttributes': _selectedAttributes
          .map((attr) => attr.toJson())
          .toList(),
      'variations': _variations.map((v) => v.toJson()).toList(),
      'lastUpdated': DateTime.now().toIso8601String(),
      'version': '2.0',
    };

    return data;
  }

  Future<void> saveCurrentState() async {
    try {
      _isSavingData.value = true;
      final variationsData = getVariationsData();
      await _dataService.saveVariationsData(variationsData);
      print('💾 [VARIATIONS] Saved variations state');
    } catch (e) {
      print('❌ [VARIATIONS] Error saving state: $e');
    } finally {
      _isSavingData.value = false;
    }
  }

  void _saveCurrentState() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!_isSavingData.value) {
        saveCurrentState();
      }
    });
  }

  void loadVariationsData(Map<String, dynamic> data) {
    try {
      _hasVariations.value = data['hasVariations'] ?? false;

      if (data['selectedAttributes'] != null) {
        final attributesList = (data['selectedAttributes'] as List)
            .map((item) {
              try {
                return ProductAttribute.fromJson(item);
              } catch (e) {
                print(
                  '❌ [VARIATIONS] Error parsing attribute: $e, item: $item',
                );
                return ProductAttribute(
                  id: '',
                  name: 'خطأ في التحميل',
                  values: [],
                );
              }
            })
            .where((attr) => attr.id.isNotEmpty)
            .toList();

        _selectedAttributes.assignAll(attributesList);
        _selectedAttributesCount.value = _selectedAttributes.length;
      }

      if (data['variations'] != null) {
        final variationsList = (data['variations'] as List)
            .map((item) {
              try {
                return ProductVariation.fromJson(item);
              } catch (e) {
                print(
                  '❌ [VARIATIONS] Error parsing variation: $e, item: $item',
                );
                return ProductVariation(
                  id: 'error_${DateTime.now().millisecondsSinceEpoch}',
                  attributes: {},
                  price: 0.0,
                  stock: 0,
                  sku: 'ERROR',
                  isActive: false,
                  images: [],
                );
              }
            })
            .where(
              (variation) =>
                  variation.id.isNotEmpty && !variation.id.startsWith('error_'),
            )
            .toList();

        _variations.assignAll(variationsList);
        _updateCounters();
      }

      print(
        '📥 [VARIATIONS] Loaded variations data: ${_variations.length} variations, ${_selectedAttributes.length} attributes',
      );

      update([attributesUpdateId, variationsUpdateId]);
    } catch (e) {
      print('❌ [VARIATIONS] Error loading variations data: $e');
      clearAllData();
    }
  }

  void resetAllData() {
    clearAllData();
    _hasVariations.value = false;
    _isLoadingAttributes.value = false;
    _attributesError.value = '';
    _hasAttemptedLoad.value = false;

    print('🔄 [VARIATIONS] Reset all data');

    update([attributesUpdateId, variationsUpdateId, loadingUpdateId]);
  }

  Map<String, dynamic> getStatistics() {
    final totalImages = _variations.fold<int>(
      0,
      (sum, variation) => sum + variation.images.length,
    );

    return {
      'selected_attributes_count': _selectedAttributesCount.value,
      'total_variations': _totalVariationsCount.value,
      'active_variations': _activeVariationsCount.value,
      'inactive_variations':
          _totalVariationsCount.value - _activeVariationsCount.value,
      'total_images': totalImages,
      'is_offline': _isOfflineMode.value,
      'last_load_time': _lastLoadTime.value,
      'has_data': _variations.isNotEmpty,
    };
  }

  void printDebugInfo() {
    print('''
📊 [VARIATIONS DEBUG INFO]:
   نظام الاختلافات: ${_hasVariations.value ? 'مفعل' : 'معطل'}
   عدد السمات المختارة: ${_selectedAttributes.length}
   عدد الاختلافات: ${_variations.length}
   عدد الاختلافات النشطة: ${_activeVariationsCount.value}
   حالة التحميل: ${_isLoadingAttributes.value ? 'قيد التحميل' : 'جاهز'}
   وضع عدم الاتصال: ${_isOfflineMode.value ? 'نعم' : 'لا'}
   آخر وقت تحميل: ${_lastLoadTime.value}
''');
  }

  List<Map<String, dynamic>> prepareVariationsForApi() {
    final List<Map<String, dynamic>> apiVariations = [];

    /// Backend expects relative paths like: images/xxx.jpg or gallery/xxx.jpg
    /// This helper converts any stored value (full URL, /storage/..., etc.)
    /// into a relative path.
    String _toRelativePath(String input) {
      final v = input.trim();
      if (v.isEmpty) return '';

      // Full URL -> keep only after /storage/
      final storageIdx = v.indexOf('/storage/');
      if (storageIdx != -1) {
        final after = v.substring(storageIdx + '/storage/'.length);
        return after.startsWith('/') ? after.substring(1) : after;
      }

      // Leading slash paths
      if (v.startsWith('/')) return v.substring(1);

      return v;
    }

    for (final variation in _variations) {

      final attributeOptions = <Map<String, dynamic>>[];

      for (final attrEntry in variation.attributes.entries) {
        final attribute = _allAttributes.firstWhere(
          (attr) => attr.name == attrEntry.key,
          orElse: () => ProductAttribute(id: '', name: '', values: []),
        );

        if (attribute.id.isNotEmpty) {
          final value = attribute.values.firstWhere(
            (v) => v.value == attrEntry.value,
            orElse: () =>
                AttributeValue(id: '', value: '', isSelected: false.obs),
          );

          if (value.id.isNotEmpty) {
            attributeOptions.add({
              'attribute_id': int.parse(attribute.id),
              'option_id': int.parse(value.id),
            });
          }
        }
      }

      final variationData = {
        // If this variation already exists (edit mode), keep its id so backend can update it.
        if (int.tryParse(variation.id) != null) 'id': int.parse(variation.id),
        'price': variation.price.value,
        'attributeOptions': attributeOptions,
        // Backend uses string status: active / not-active
        'status': variation.isActive.value ? 'active' : 'not-active',
      };

      if (variation.images.isNotEmpty) {
        // API examples show only a single "image" field for variation.
        // Use the first selected image.
        final img = _toRelativePath(variation.images.first);
        if (img.isNotEmpty) {
          variationData['image'] = img;
        }
      }

      apiVariations.add(variationData);
    }

    print('🎯 [VARIATIONS] تم إعداد ${apiVariations.length} اختلاف للإرسال');

    return apiVariations;
  }

  /// Prefill variation system from API product response.
  /// Expected productData['variations'] to be a list with items like:
  /// {id, price, image, status, attributeOptions:[{attribute_id, option_id}]}
  ///
  /// It will map attribute_id/option_id into human readable names/values using
  /// already loaded attributes (call loadAttributesOnOpen() before this).
  Future<void> loadFromProductApi({
    required Map<String, dynamic> productData,
    bool isEditMode = false,
  }) async {
    try {
      // The API response may be wrapped (e.g. {status:true, data:{...}}). Unwrap if needed.
      final Map<String, dynamic> p = (productData['data'] is Map)
          ? Map<String, dynamic>.from(productData['data'] as Map)
          : (productData['product'] is Map)
              ? Map<String, dynamic>.from(productData['product'] as Map)
              : productData;

      final rawVariations = p['variations'];
      if (rawVariations is! List) {
        // In edit mode, do NOT auto-disable variations just because the payload shape is unexpected.
        // This avoids the "variations disabled on edit" issue when backend responses differ slightly.
        if (!isEditMode) {
          toggleHasVariations(false);
        }
        return;
      }

      _hasVariations.value = rawVariations.isNotEmpty;

      // Collect used attribute ids to mark selected attributes
      final Set<String> usedAttributeIds = <String>{};
      // Collect used option ids per attribute id so we can mark selected values
      // This is critical in edit mode; validation requires at least one selected value per attribute.
      final Map<String, Set<String>> usedOptionIdsByAttrId = <String, Set<String>>{};
      final List<ProductVariation> parsedVariations = [];

      for (final v in rawVariations) {
        if (v is! Map) continue;
        final vm = Map<String, dynamic>.from(v as Map);

        final String id = vm['id']?.toString() ?? '';
        final double price = (vm['price'] is num)
            ? (vm['price'] as num).toDouble()
            : double.tryParse(vm['price']?.toString() ?? '0') ?? 0.0;
        final int stock = (vm['stock'] is num)
            ? (vm['stock'] as num).toInt()
            : int.tryParse(vm['stock']?.toString() ?? '0') ?? 0;
        final String sku = vm['sku']?.toString() ?? '';

        final status = vm['status']?.toString().toLowerCase();
        final bool isActive = status == null
            ? true
            : (status == 'active' || status == '1' || status == 'true');

        final Map<String, String> attributes = {};
        final List<dynamic> attrOptions =
            (vm['attributeOptions'] is List) ? (vm['attributeOptions'] as List) : const [];

        for (final ao in attrOptions) {
          if (ao is! Map) continue;
          final aom = Map<String, dynamic>.from(ao as Map);
          final String attrId = aom['attribute_id']?.toString() ?? '';
          final String optId = aom['option_id']?.toString() ?? '';
          if (attrId.isEmpty || optId.isEmpty) continue;

          usedAttributeIds.add(attrId);
          (usedOptionIdsByAttrId[attrId] ??= <String>{}).add(optId);

          // Track used option ids for this attribute
          usedOptionIdsByAttrId.putIfAbsent(attrId, () => <String>{}).add(optId);

          final attr = _allAttributes.firstWhereOrNull((a) => a.id == attrId);
          if (attr == null) continue;
          final opt = attr.values.firstWhereOrNull((o) => o.id == optId);
          if (opt == null) continue;
          attributes[attr.name] = opt.value;
        }

        // Images
        final List<String> images = [];
        if (vm['gallery'] is List) {
          images.addAll((vm['gallery'] as List).map((e) => e.toString()));
        } else if (vm['gallary'] is List) {
          images.addAll((vm['gallary'] as List).map((e) => e.toString()));
        }
        final img = vm['image']?.toString();
        if (img != null && img.trim().isNotEmpty) {
          images.insert(0, img);
        }

        parsedVariations.add(
          ProductVariation(
            id: id,
            attributes: attributes,
            price: price,
            stock: stock,
            sku: sku,
            isActive: isActive,
            images: images,
          ),
        );
      }

      // Mark selected attributes in UI
      final selected = _allAttributes
          .where((a) => usedAttributeIds.contains(a.id))
          .toList();

      _selectedAttributes.assignAll(selected);

      // IMPORTANT: mark the values as selected so validation passes and the user can
      // add/edit variations without having to delete/recreate everything.
      for (final attr in _selectedAttributes) {
        final usedOptionIds = usedOptionIdsByAttrId[attr.id] ?? const <String>{};

        // Clear previous selection state
        for (final v in attr.values) {
          v.isSelected.value = false;
        }

        // Select the values that exist in current variations (if any)
        if (usedOptionIds.isNotEmpty) {
          for (final v in attr.values) {
            if (usedOptionIds.contains(v.id)) {
              v.isSelected.value = true;
            }
          }
        }

        // Fallback (very rare): if no matching option found, select the first value
        // so the attribute isn't "empty" for validation.
        final hasAnySelected = attr.values.any((v) => v.isSelected.value);
        if (!hasAnySelected && attr.values.isNotEmpty) {
          attr.values.first.isSelected.value = true;
        }
      }

      _variations.assignAll(parsedVariations);
      _updateCounters();

      update([attributesUpdateId, variationsUpdateId]);
      _saveCurrentState();

      print(
        '✅ [VARIATIONS] Loaded from API: ${_variations.length} variations, ${_selectedAttributes.length} attributes',
      );
    } catch (e) {
      print('❌ [VARIATIONS] Error loading from API: $e');
    }
  }

  void reset() {}

  bool get hasVariations => _hasVariations.value;

  List<ProductAttribute> get selectedAttributes => _selectedAttributes;

  List<ProductAttribute> get allAttributes => _allAttributes;

  List<ProductVariation> get variations => _variations;

  bool get isLoadingAttributes => _isLoadingAttributes.value;

  String get attributesError => _attributesError.value;

  int get selectedAttributesCount => _selectedAttributesCount.value;

  int get totalVariationsCount => _totalVariationsCount.value;

  int get activeVariationsCount => _activeVariationsCount.value;

  bool get isOfflineMode => _isOfflineMode.value;

  bool get isGeneratingVariations => _isGeneratingVariations.value;

  bool get isSavingData => _isSavingData.value;

  String get lastLoadTime => _lastLoadTime.value;

  @override
  void onClose() {
    print('🔚 [VARIATION CONTROLLER] Closing...');
    saveCurrentState();
    super.onClose();
  }
}

class ValidationResult {
  final bool isValid;
  final String errorMessage;

  ValidationResult({required this.isValid, required this.errorMessage});
}