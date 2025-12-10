import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/my_app/my_app_controller.dart';
import 'package:attene_mobile/utlis/sheet_controller.dart';
import 'package:attene_mobile/utlis/variation_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/view/product_variations/product_variation_model.dart';
import 'package:attene_mobile/view/Services/data_lnitializer_service.dart';
import 'package:attene_mobile/view/Services/unified_loading_screen.dart';

class ProductVariationController extends GetxController {
  // حالة التحكم
  final RxBool hasVariations = false.obs;
  final RxList<ProductAttribute> selectedAttributes = <ProductAttribute>[].obs;
  final RxList<ProductAttribute> allAttributes = <ProductAttribute>[].obs;
  final RxList<ProductVariation> variations = <ProductVariation>[].obs;

  // حالة التحميل والأخطاء
  final RxBool isLoadingAttributes = false.obs;
  final RxString attributesError = ''.obs;
  final RxBool hasAttemptedLoad = false.obs;
  final RxBool isGeneratingVariations = false.obs;
  final RxBool isSavingData = false.obs;

  // متغيرات المساعدة
  final RxInt selectedAttributesCount = 0.obs;
  final RxInt totalVariationsCount = 0.obs;
  final RxInt activeVariationsCount = 0.obs;
  final RxBool isOfflineMode = false.obs;
  final RxString lastLoadTime = ''.obs;

  // مفاتيح التحديث
  static const String attributesUpdateId = 'attributes';
  static const String variationsUpdateId = 'variations';
  static const String loadingUpdateId = 'loading';

  // Services
  late DataInitializerService _dataService;
  late MyAppController _myAppController;
  late BottomSheetController _bottomSheetController;

  @override
  void onInit() {
    super.onInit();
    _initializeServices();
    _loadCachedData();
    print('🔄 [VARIATION CONTROLLER] تهيئة متحكم الاختلافات');
  }

  void _initializeServices() {
    _dataService = Get.find<DataInitializerService>();
    _myAppController = Get.find<MyAppController>();
    _bottomSheetController = Get.find<BottomSheetController>();
  }

  Future<void> _loadCachedData() async {
    try {
      // تحميل السمات المخزنة محلياً
      final cachedAttributes = _dataService.getAttributesForVariations();
      if (cachedAttributes.isNotEmpty) {
        allAttributes.assignAll(cachedAttributes);
        print(
          '📥 [VARIATIONS] تم تحميل ${cachedAttributes.length} سمة من التخزين المحلي',
        );
      }

      // تحميل بيانات الاختلافات المخزنة
      final variationsData = _dataService.getVariationsData();
      if (variationsData.isNotEmpty) {
        loadVariationsData(variationsData);
        print('📥 [VARIATIONS] تم تحميل بيانات الاختلافات المخزنة');
      }
    } catch (e) {
      print('⚠️ [VARIATIONS] خطأ في تحميل البيانات المخزنة: $e');
    }
  }

  Future<void> loadAttributesOnOpen() async {
    if (hasAttemptedLoad.value && allAttributes.isNotEmpty) {
      print('📂 [VARIATIONS] استخدام السمات المحملة مسبقاً');
      return;
    }

    if (!_myAppController.isLoggedIn.value) {
      attributesError('يجب تسجيل الدخول أولاً');
      print('⚠️ [VARIATIONS] المستخدم غير مسجل دخول');
      return;
    }

    return UnifiedLoadingScreen.showWithFuture<void>(
      _performLoadAttributes(),
      message: 'جاري تحميل السمات...',
      dialogId: 'loading_attributes',
    );
  }

  Future<void> _performLoadAttributes() async {
    try {
      hasAttemptedLoad(true);
      isLoadingAttributes(true);
      attributesError('');

      print('📡 [VARIATIONS] جلب السمات من API');

      final response = await ApiHelper.get(
        path: '/merchants/attributes',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final attributesList = List<Map<String, dynamic>>.from(
          response['data'] ?? [],
        );

        final loadedAttributes = attributesList.map((attributeJson) {
          return ProductAttribute.fromApiJson(attributeJson);
        }).toList();

        allAttributes.assignAll(loadedAttributes);
        lastLoadTime.value = DateTime.now().toIso8601String();

        print('✅ [VARIATIONS] تم تحميل ${allAttributes.length} سمة بنجاح');

        // حفظ في التخزين المحلي للاستخدام المستقبلي
        await _saveAttributesLocally(attributesList);
      } else {
        final errorMessage = response?['message'] ?? 'فشل في تحميل السمات';
        attributesError(errorMessage);
        print('❌ [VARIATIONS] فشل في تحميل السمات: $errorMessage');

        // استخدام البيانات المخزنة إذا كانت متاحة
        if (allAttributes.isEmpty) {
          await _useCachedDataAsFallback();
        }
      }
    } catch (e) {
      final error = 'حدث خطأ أثناء تحميل السمات: $e';
      attributesError(error);
      print('❌ [VARIATIONS] خطأ في تحميل السمات: $e');

      // التبديل إلى وضع عدم الاتصال
      isOfflineMode.value = true;

      // استخدام البيانات المخزنة إذا كانت متاحة
      if (allAttributes.isEmpty) {
        await _useCachedDataAsFallback();
      }
    } finally {
      isLoadingAttributes(false);
      update([loadingUpdateId]);
    }
  }

  Future<void> _saveAttributesLocally(
    List<Map<String, dynamic>> attributesList,
  ) async {
    try {
      // حفظ السمات في DataInitializerService
      await _dataService.saveAttributesForVariations(attributesList);
      print('💾 [VARIATIONS] تم حفظ السمات في التخزين المحلي');
    } catch (e) {
      print('⚠️ [VARIATIONS] خطأ في حفظ السمات محلياً: $e');
    }
  }

  Future<void> _useCachedDataAsFallback() async {
    try {
      final cachedAttributes = _dataService.getAttributesForVariations();
      if (cachedAttributes.isNotEmpty) {
        allAttributes.assignAll(cachedAttributes);
        attributesError('يتم استخدام البيانات المخزنة (غير متصل)');
        print('📂 [VARIATIONS] استخدام البيانات المخزنة كنسخة احتياطية');
      }
    } catch (e) {
      print('⚠️ [VARIATIONS] خطأ في استخدام البيانات المخزنة: $e');
    }
  }

  Future<void> reloadAttributes({bool forceRefresh = false}) async {
    if (forceRefresh) {
      allAttributes.clear();
      hasAttemptedLoad(false);
    }

    await loadAttributesOnOpen();

    if (forceRefresh) {
      Get.snackbar(
        'تم التحديث',
        'تم تحديث قائمة السمات',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    }
  }

  void toggleHasVariations(bool value) {
    hasVariations.value = value;
    if (!value) {
      clearAllData();
    }

    // حفظ التغيير في التخزين المحلي
    _saveCurrentState();

    update([attributesUpdateId, variationsUpdateId]);

    if (value) {
      Get.snackbar(
        'تم التفعيل',
        'تم تفعيل نظام الاختلافات',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'تم التعطيل',
        'تم تعطيل نظام الاختلافات',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void openAttributesManagement() {
    if (isLoadingAttributes.value) {
      Get.snackbar('تنبيه', 'جاري تحميل السمات...');
      return;
    }

    if (allAttributes.isEmpty) {
      Get.snackbar('تنبيه', 'لا توجد سمات متاحة. جاري التحميل...');
      loadAttributesOnOpen().then((_) {
        if (allAttributes.isNotEmpty) {
          _openAttributesBottomSheet();
        }
      });
      return;
    }

    _openAttributesBottomSheet();
  }

  void _openAttributesBottomSheet() {
    print('🎯 [VARIATIONS] فتح لوحة إدارة السمات');

    _bottomSheetController.openManageAttributes(allAttributes);
    _bottomSheetController.updateSelectedAttributes(selectedAttributes);

    // متابعة التغييرات في السمات المختارة
    ever(_bottomSheetController.selectedAttributesRx, (
      List<ProductAttribute> attributes,
    ) {
      if (attributes.isNotEmpty) {
        updateSelectedAttributes(attributes);

        if (variations.isEmpty && hasVariations.value) {
          generateSingleVariation();
        }
      } else if (attributes.isEmpty && selectedAttributes.isNotEmpty) {
        // تم مسح جميع السمات
        selectedAttributes.clear();
        variations.clear();
        update([attributesUpdateId, variationsUpdateId]);
      }
    });
  }

  void updateSelectedAttributes(List<ProductAttribute> attributes) {
    final oldCount = selectedAttributes.length;
    selectedAttributes.assignAll(attributes);
    selectedAttributesCount.value = attributes.length;

    print('✅ [VARIATIONS] تحديث السمات: ${attributes.length} سمة محفوظة');

    // إذا قمنا بتقليل عدد السمات، نحتاج لإعادة إنشاء الاختلافات
    if (oldCount > attributes.length && variations.isNotEmpty) {
      _regenerateVariationsAfterAttributeChange();
    }

    update([attributesUpdateId]);
    _saveCurrentState();
  }

  void _regenerateVariationsAfterAttributeChange() {
    final List<ProductVariation> updatedVariations = [];

    for (final variation in variations) {
      final newAttributes = Map<String, String>.from(variation.attributes);

      // إزالة السمات التي لم تعد مختارة
      for (final key in variation.attributes.keys.toList()) {
        if (!selectedAttributes.any((attr) => attr.name == key)) {
          newAttributes.remove(key);
        }
      }

      // إضافة السمات المفقودة مع قيم افتراضية
      for (final attribute in selectedAttributes) {
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

      // استخدام دالة copyWith بعد إضافتها
      final updatedVariation = variation.copyWith(attributes: newAttributes);

      updatedVariations.add(updatedVariation);
    }

    variations.assignAll(updatedVariations);
    update([variationsUpdateId]);
  }

  void removeSelectedAttribute(ProductAttribute attribute) {
    final attributeName = attribute.name;
    selectedAttributes.removeWhere((attr) => attr.id == attribute.id);
    selectedAttributesCount.value = selectedAttributes.length;

    // إزالة السمة من جميع الاختلافات
    for (final variation in variations) {
      variation.attributes.remove(attributeName);
    }

    print('🗑️ [VARIATIONS] تم حذف السمة: $attributeName');

    update([attributesUpdateId, variationsUpdateId]);
    _saveCurrentState();
  }

  void clearAllData() {
    variations.clear();
    selectedAttributes.clear();
    selectedAttributesCount.value = 0;
    totalVariationsCount.value = 0;
    activeVariationsCount.value = 0;

    print('🧹 [VARIATIONS] تم مسح جميع البيانات');

    update([attributesUpdateId, variationsUpdateId]);
    _saveCurrentState();
  }

  void generateSingleVariation() {
    if (selectedAttributes.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى اختيار السمات أولاً');
      return;
    }

    if (!hasSelectedAttributesWithValues) {
      Get.snackbar('تنبيه', 'يرجى اختيار قيم للسمات أولاً');
      return;
    }

    final newVariation = ProductVariation(
      id: 'var_${DateTime.now().millisecondsSinceEpoch}_${variations.length}',
      attributes: _getDefaultAttributes(),
      price: 0.0,
      stock: 0,
      sku: _generateAutoSku(),
      isActive: true,
      images: [],
    );

    // التحقق من التكرار
    if (isVariationDuplicate(newVariation.attributes)) {
      Get.snackbar('تنبيه', 'هذه التركيبة موجودة مسبقاً');
      return;
    }

    variations.add(newVariation);
    _updateCounters();

    update([variationsUpdateId]);

    Get.snackbar(
      'نجاح',
      'تم إنشاء بطاقة اختلاف جديدة',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );

    _saveCurrentState();
  }

  String _generateAutoSku() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp % 1000;
    return 'VAR${(variations.length + 1).toString().padLeft(3, '0')}_$random';
  }

  Map<String, String> _getDefaultAttributes() {
    final defaultAttributes = <String, String>{};
    for (final attribute in selectedAttributes) {
      final selectedValue = attribute.values.firstWhereOrNull(
        (value) => value.isSelected.value,
      );
      if (selectedValue != null) {
        defaultAttributes[attribute.name] = selectedValue.value;
      } else if (attribute.values.isNotEmpty) {
        defaultAttributes[attribute.name] = attribute.values.first.value;
      }
    }
    return defaultAttributes;
  }

  void generateAllVariations() {
    if (selectedAttributes.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى اختيار السمات أولاً');
      return;
    }

    if (!hasSelectedAttributesWithValues) {
      Get.snackbar('تنبيه', 'يرجى اختيار قيم للسمات أولاً');
      return;
    }

    isGeneratingVariations(true);

    try {
      // حساب جميع التركيبات الممكنة
      final allCombinations = _generateAllAttributeCombinations();

      // إنشاء اختلاف لكل تركيبة
      for (final combination in allCombinations) {
        if (isVariationDuplicate(combination)) {
          continue;
        }

        final newVariation = ProductVariation(
          id: 'var_${DateTime.now().millisecondsSinceEpoch}_${variations.length}',
          attributes: combination,
          price: 0.0,
          stock: 0,
          sku: _generateAutoSku(),
          isActive: true,
          images: [],
        );

        variations.add(newVariation);
      }

      _updateCounters();
      update([variationsUpdateId]);

      Get.snackbar(
        'نجاح',
        'تم إنشاء ${allCombinations.length} اختلاف',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في إنشاء جميع الاختلافات: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isGeneratingVariations(false);
      _saveCurrentState();
    }
  }

  List<Map<String, String>> _generateAllAttributeCombinations() {
    final List<Map<String, String>> combinations = [];

    // جمع جميع القيم المختارة لكل سمة
    final List<List<MapEntry<String, String>>> attributeValues = [];

    for (final attribute in selectedAttributes) {
      final selectedValues = attribute.values
          .where((value) => value.isSelected.value)
          .map((value) => MapEntry(attribute.name, value.value))
          .toList();

      if (selectedValues.isNotEmpty) {
        attributeValues.add(selectedValues);
      }
    }

    // إنشاء جميع التركيبات باستخدام backtracking
    void backtrack(int index, Map<String, String> current) {
      if (index == attributeValues.length) {
        combinations.add(Map.from(current));
        return;
      }

      for (final entry in attributeValues[index]) {
        current[entry.key] = entry.value;
        backtrack(index + 1, current);
        current.remove(entry.key);
      }
    }

    backtrack(0, {});
    return combinations;
  }

  bool isVariationDuplicate(Map<String, String> newAttributes) {
    for (final variation in variations) {
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

  void updateVariationAttribute(
    ProductVariation variation,
    String attributeName,
    String attributeValue,
  ) {
    final index = variations.indexWhere((v) => v.id == variation.id);
    if (index != -1) {
      final newAttributes = Map<String, String>.from(variation.attributes);
      newAttributes[attributeName] = attributeValue;

      if (isVariationDuplicate(newAttributes)) {
        Get.snackbar('تنبيه', 'هذه التركيبة موجودة مسبقاً');
        return;
      }

      variations[index].attributes[attributeName] = attributeValue;
      update([variationsUpdateId]);
      _saveCurrentState();
    }
  }

  void toggleVariationActive(ProductVariation variation) {
    final index = variations.indexWhere((v) => v.id == variation.id);
    if (index != -1) {
      variations[index].isActive.toggle();
      _updateCounters();
      update([variationsUpdateId]);
      _saveCurrentState();
    }
  }

  void updateVariationPrice(ProductVariation variation, String price) {
    final index = variations.indexWhere((v) => v.id == variation.id);
    if (index != -1) {
      final parsedPrice = double.tryParse(price);
      if (parsedPrice == null) {
        Get.snackbar('خطأ', 'يرجى إدخال سعر صحيح');
        return;
      }
      variations[index].price.value = parsedPrice;
      update([variationsUpdateId]);
      _saveCurrentState();
    }
  }

  void updateVariationStock(ProductVariation variation, String stock) {
    final index = variations.indexWhere((v) => v.id == variation.id);
    if (index != -1) {
      variations[index].stock.value = int.tryParse(stock) ?? 0;
      update([variationsUpdateId]);
      _saveCurrentState();
    }
  }

  void updateVariationSku(ProductVariation variation, String sku) {
    final index = variations.indexWhere((v) => v.id == variation.id);
    if (index != -1) {
      variations[index].sku.value = sku.trim();
      update([variationsUpdateId]);
      _saveCurrentState();
    }
  }

  void addImageToVariation(ProductVariation variation, String imageUrl) {
    final index = variations.indexWhere((v) => v.id == variation.id);
    if (index != -1) {
      if (imageUrl.isNotEmpty && !imageUrl.contains('variation_default.jpg')) {
        variations[index].images.add(imageUrl);
        update([variationsUpdateId]);
        _saveCurrentState();
      }
    }
  }

  void removeImageFromVariation(ProductVariation variation, String imageUrl) {
    final index = variations.indexWhere((v) => v.id == variation.id);
    if (index != -1) {
      variations[index].images.remove(imageUrl);
      update([variationsUpdateId]);
      _saveCurrentState();
    }
  }

  void removeVariation(ProductVariation variation) {
    variations.removeWhere((v) => v.id == variation.id);
    _updateCounters();
    update([variationsUpdateId]);
    _saveCurrentState();

    Get.snackbar(
      'تم الحذف',
      'تم حذف الاختلاف',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 1),
    );
  }

  void _updateCounters() {
    totalVariationsCount.value = variations.length;
    activeVariationsCount.value = variations
        .where((v) => v.isActive.value)
        .length;
  }

  ValidationResult validateVariations() {
    if (hasVariations.value && selectedAttributes.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'يرجى إضافة السمات أولاً',
      );
    }

    if (hasVariations.value && variations.isEmpty) {
      return ValidationResult(
        isValid: false,
        errorMessage: 'يرجى إنشاء قيم الاختلافات أولاً',
      );
    }

    // التحقق من اكتمال جميع الاختلافات
    for (final variation in variations) {
      // التحقق من السعر
      if (variation.price.value <= 0) {
        return ValidationResult(
          isValid: false,
          errorMessage: 'يرجى إدخال سعر صحيح لجميع الاختلافات',
        );
      }

      // التحقق من السمات
      for (final attribute in selectedAttributes) {
        if (!variation.attributes.containsKey(attribute.name)) {
          return ValidationResult(
            isValid: false,
            errorMessage:
                'يرجى اختيار قيمة لـ ${attribute.name} في جميع الاختلافات',
          );
        }
      }

      // التحقق من SKU الفريد
      final sku = variation.sku.value.trim();
      if (sku.isEmpty) {
        return ValidationResult(
          isValid: false,
          errorMessage: 'يرجى إدخال SKU لجميع الاختلافات',
        );
      }

      // التحقق من تكرار SKU
      final sameSkuVariations = variations
          .where((v) => v.id != variation.id && v.sku.value.trim() == sku)
          .length;

      if (sameSkuVariations > 0) {
        return ValidationResult(
          isValid: false,
          errorMessage: 'SKU $sku مكرر في أكثر من اختلاف',
        );
      }
    }

    return ValidationResult(isValid: true, errorMessage: '');
  }

  Map<String, dynamic> getVariationsData() {
    final data = {
      'hasVariations': hasVariations.value,
      'selectedAttributes': selectedAttributes
          .map((attr) => attr.toJson())
          .toList(),
      'variations': variations.map((v) => v.toJson()).toList(),
      'lastUpdated': DateTime.now().toIso8601String(),
      'version': '2.0',
    };

    return data;
  }

  Future<void> saveCurrentState() async {
    try {
      isSavingData(true);
      final variationsData = getVariationsData();
      await _dataService.saveVariationsData(variationsData);
      print('💾 [VARIATIONS] تم حفظ حالة الاختلافات');
    } catch (e) {
      print('❌ [VARIATIONS] خطأ في حفظ الحالة: $e');
    } finally {
      isSavingData(false);
    }
  }

  void _saveCurrentState() {
    // تأخير حفظ الحالة لتجنب تكرار العمليات
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!isSavingData.value) {
        saveCurrentState();
      }
    });
  }

  void loadVariationsData(Map<String, dynamic> data) {
    try {
      hasVariations.value = data['hasVariations'] ?? false;

      if (data['selectedAttributes'] != null) {
        selectedAttributes.assignAll(
          (data['selectedAttributes'] as List)
              .map((item) => ProductAttribute.fromJson(item))
              .toList(),
        );
        selectedAttributesCount.value = selectedAttributes.length;
      }

      if (data['variations'] != null) {
        variations.assignAll(
          (data['variations'] as List)
              .map((item) => ProductVariation.fromJson(item))
              .toList(),
        );
        _updateCounters();
      }

      print('📥 [VARIATIONS] تم تحميل بيانات الاختلافات');

      update([attributesUpdateId, variationsUpdateId]);
    } catch (e) {
      print('❌ [VARIATIONS] خطأ في تحميل بيانات الاختلافات: $e');
    }
  }

  List<Map<String, dynamic>> prepareVariationsForApi() {
    final List<Map<String, dynamic>> apiVariations = [];

    for (final variation in variations) {
      if (!variation.isActive.value) {
        continue; // تخطي الاختلافات المعطلة
      }

      final attributeOptions = <Map<String, dynamic>>[];

      for (final attrEntry in variation.attributes.entries) {
        // البحث عن السمة في القائمة الكاملة
        final attribute = allAttributes.firstWhere(
          (attr) => attr.name == attrEntry.key,
          orElse: () => ProductAttribute(id: '', name: '', values: []),
        );

        if (attribute.id.isNotEmpty) {
          // البحث عن قيمة السمة
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
        'price': variation.price.value,
        'attributeOptions': attributeOptions,
        'sku': variation.sku.value,
        'stock': variation.stock.value,
        'is_active': variation.isActive.value,
      };

      // إضافة الصور إذا كانت موجودة
      if (variation.images.isNotEmpty) {
        variationData['image'] = variation.images.first;
        variationData['gallery'] = variation.images;
      }

      apiVariations.add(variationData);
    }

    print('🎯 [VARIATIONS] تم إعداد ${apiVariations.length} اختلاف للإرسال');

    return apiVariations;
  }

  bool get hasSelectedAttributesWithValues {
    if (selectedAttributes.isEmpty) return false;

    for (final attribute in selectedAttributes) {
      if (attribute.values.any((value) => value.isSelected.value)) {
        return true;
      }
    }
    return false;
  }

  void resetAllData() {
    clearAllData();
    hasVariations.value = false;
    isLoadingAttributes.value = false;
    attributesError.value = '';
    hasAttemptedLoad.value = false;

    print('🔄 [VARIATIONS] تم إعادة تعيين جميع البيانات');

    update([attributesUpdateId, variationsUpdateId, loadingUpdateId]);
  }

  Map<String, dynamic> getStatistics() {
    final totalImages = variations.fold<int>(
      0,
      (sum, variation) => sum + variation.images.length,
    );

    return {
      'selected_attributes_count': selectedAttributesCount.value,
      'total_variations': totalVariationsCount.value,
      'active_variations': activeVariationsCount.value,
      'inactive_variations':
          totalVariationsCount.value - activeVariationsCount.value,
      'total_images': totalImages,
      'is_offline': isOfflineMode.value,
      'last_load_time': lastLoadTime.value,
      'has_data': variations.isNotEmpty,
    };
  }

  void printDebugInfo() {
    print('''
📊 [VARIATIONS DEBUG INFO]:
   نظام الاختلافات: ${hasVariations.value ? 'مفعل' : 'معطل'}
   عدد السمات المختارة: ${selectedAttributes.length}
   عدد الاختلافات: ${variations.length}
   عدد الاختلافات النشطة: ${activeVariationsCount.value}
   حالة التحميل: ${isLoadingAttributes.value ? 'قيد التحميل' : 'جاهز'}
   وضع عدم الاتصال: ${isOfflineMode.value ? 'نعم' : 'لا'}
   آخر وقت تحميل: ${lastLoadTime.value}
''');
  }

  @override
  void onClose() {
    print('🔚 [VARIATION CONTROLLER] إغلاق متحكم الاختلافات');

    // حفظ الحالة النهائية قبل الإغلاق
    saveCurrentState();

    super.onClose();
  }
}
