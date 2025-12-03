import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/my_app/may_app_controller.dart';
import 'package:attene_mobile/utlis/sheet_controller.dart';
import 'package:attene_mobile/utlis/variation_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/view/product_variations/product_variation_model.dart';

class ProductVariationController extends GetxController {
  final RxBool hasVariations = false.obs;
  final RxList<ProductAttribute> selectedAttributes = <ProductAttribute>[].obs;
  final RxList<ProductAttribute> allAttributes = <ProductAttribute>[].obs;
  
  final RxList<ProductVariation> variations = <ProductVariation>[].obs;
  
  final RxBool isLoadingAttributes = false.obs;
  final RxString attributesError = ''.obs;
  final RxBool hasAttemptedLoad = false.obs;

  static const String attributesUpdateId = 'attributes';
  static const String variationsUpdateId = 'variations';

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> loadAttributesOnOpen() async {
    if (hasAttemptedLoad.value && allAttributes.isNotEmpty) {
      return;
    }
    await _loadAttributesFromApi();
  }

  Future<void> _loadAttributesFromApi() async {
    try {
      final MyAppController myAppController = Get.find<MyAppController>();
      if (!myAppController.isLoggedIn.value) {
        attributesError('يجب تسجيل الدخول أولاً');
        print('⚠️ [ATTRIBUTES] User not logged in');
        return;
      }

      hasAttemptedLoad(true);
      isLoadingAttributes(true);
      attributesError('');
      print('📡 [LOADING ATTRIBUTES FROM API]');

      final response = await ApiHelper.get(
        path: '/merchants/attributes',
        withLoading: false,
      );

      if (response != null && response['status'] == true) {
        final attributesList = List<Map<String, dynamic>>.from(response['data'] ?? []);
        
        final loadedAttributes = attributesList.map((attributeJson) {
          return ProductAttribute.fromApiJson(attributeJson);
        }).toList();

        allAttributes.assignAll(loadedAttributes);
        print('✅ تم تحميل ${allAttributes.length} سمة بنجاح');
      } else {
        final errorMessage = response?['message'] ?? 'فشل في تحميل السمات';
        attributesError(errorMessage);
        print('❌ فشل في تحميل السمات: $errorMessage');
      }
    } catch (e) {
      final error = 'حدث خطأ أثناء تحميل السمات: $e';
      attributesError(error);
      print('❌ خطأ في تحميل السمات: $e');
    } finally {
      isLoadingAttributes(false);
    }
  }

  Future<void> reloadAttributes() async {
    allAttributes.clear();
    await _loadAttributesFromApi();
  }

  void toggleHasVariations(bool value) {
    hasVariations.value = value;
    if (!value) {
      selectedAttributes.clear();
      variations.clear();
    }
    update([attributesUpdateId, variationsUpdateId]);
  }

  void openAttributesManagement() {
    if (isLoadingAttributes.value) {
      Get.snackbar('تنبيه', 'جاري تحميل السمات...');
      return;
    }

    if (allAttributes.isEmpty) {
      Get.snackbar('تنبيه', 'لا توجد سمات متاحة. جاري التحميل...');
      _loadAttributesFromApi().then((_) {
        if (allAttributes.isNotEmpty) {
          _openAttributesBottomSheet();
        }
      });
      return;
    }

    _openAttributesBottomSheet();
  }

  void _openAttributesBottomSheet() {
    final bottomSheetController = Get.find<BottomSheetController>();
    
    print('🎯 [OPENING ATTRIBUTES BOTTOM SHEET]');
    
    bottomSheetController.openManageAttributes(allAttributes);
    bottomSheetController.updateSelectedAttributes(selectedAttributes);
    
    ever(bottomSheetController.selectedAttributesRx, (List<ProductAttribute> attributes) {
      if (attributes.isNotEmpty) {
        updateSelectedAttributes(attributes);
        
        if (variations.isEmpty && hasVariations.value) {
          generateSingleVariation();
        }
      }
    });
  }

  void updateSelectedAttributes(List<ProductAttribute> attributes) {
    selectedAttributes.assignAll(attributes);
    print('✅ [ATTRIBUTES UPDATED]: ${attributes.length} سمات محفوظة');
    update([attributesUpdateId]);
  }

  void removeSelectedAttribute(ProductAttribute attribute) {
    selectedAttributes.removeWhere((attr) => attr.id == attribute.id);
    
    for (final variation in variations) {
      variation.attributes.remove(attribute.name);
    }
    
    update([attributesUpdateId, variationsUpdateId]);
  }

  void clearAllFields() {
    variations.clear();
    update([attributesUpdateId, variationsUpdateId]);
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
      sku: 'SKU_${variations.length + 1}',
      isActive: true,
      images: [],
    );

    variations.add(newVariation);
    update([variationsUpdateId]);
    
    Get.snackbar(
      'نجاح',
      'تم إنشاء بطاقة اختلاف جديدة',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  Map<String, String> _getDefaultAttributes() {
    final defaultAttributes = <String, String>{};
    for (final attribute in selectedAttributes) {
      final selectedValue = attribute.values.firstWhereOrNull(
        (value) => value.isSelected.value
      );
      if (selectedValue != null) {
        defaultAttributes[attribute.name] = selectedValue.value;
      } else if (attribute.values.isNotEmpty) {
        defaultAttributes[attribute.name] = attribute.values.first.value;
      }
    }
    return defaultAttributes;
  }

  bool isVariationDuplicate(Map<String, String> newAttributes) {
    for (final variation in variations) {
      if (_areAttributesEqual(variation.attributes, newAttributes)) {
        return true;
      }
    }
    return false;
  }

  bool _areAttributesEqual(Map<String, String> attributes1, Map<String, String> attributes2) {
    if (attributes1.length != attributes2.length) return false;
    
    for (final entry in attributes1.entries) {
      if (attributes2[entry.key] != entry.value) {
        return false;
      }
    }
    return true;
  }

  void updateVariationAttribute(ProductVariation variation, String attributeName, String attributeValue) {
    final index = variations.indexWhere((v) => v.id == variation.id);
    if (index != -1) {
      final newAttributes = Map<String, String>.from(variation.attributes);
      newAttributes[attributeName] = attributeValue;
      
      if (isVariationDuplicate(newAttributes)) {
        Get.snackbar('تنبيه', 'هذه التركيبة موجودة مسبقاً');
        return;
      }
      
      variations[index].attributes[attributeName] = attributeValue;
    }
  }

  void toggleVariationActive(ProductVariation variation) {
    final index = variations.indexWhere((v) => v.id == variation.id);
    if (index != -1) {
      variations[index].isActive.toggle();
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
    }
  }

  void updateVariationStock(ProductVariation variation, String stock) {
    final index = variations.indexWhere((v) => v.id == variation.id);
    if (index != -1) {
      variations[index].stock.value = int.tryParse(stock) ?? 0;
    }
  }

  void updateVariationSku(ProductVariation variation, String sku) {
    final index = variations.indexWhere((v) => v.id == variation.id);
    if (index != -1) {
      variations[index].sku.value = sku;
    }
  }

  void addImageToVariation(ProductVariation variation, String imageUrl) {
    final index = variations.indexWhere((v) => v.id == variation.id);
    if (index != -1) {
      if (!imageUrl.contains('variation_default.jpg') && imageUrl.isNotEmpty) {
        variations[index].images.add(imageUrl);
      }
    }
  }

  void removeImageFromVariation(ProductVariation variation, String imageUrl) {
    final index = variations.indexWhere((v) => v.id == variation.id);
    if (index != -1) {
      variations[index].images.remove(imageUrl);
    }
  }

  void removeVariation(ProductVariation variation) {
    variations.removeWhere((v) => v.id == variation.id);
    update([variationsUpdateId]);
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

    for (final variation in variations) {
      if (variation.price.value <= 0) {
        return ValidationResult(
          isValid: false,
          errorMessage: 'يرجى إدخال سعر صحيح لجميع الاختلافات',
        );
      }

      for (final attribute in selectedAttributes) {
        if (!variation.attributes.containsKey(attribute.name)) {
          return ValidationResult(
            isValid: false,
            errorMessage: 'يرجى اختيار قيمة لـ ${attribute.name} في جميع الاختلافات',
          );
        }
      }
    }
    
    return ValidationResult(isValid: true, errorMessage: '');
  }

  Map<String, dynamic> getVariationsData() {
    return {
      'hasVariations': hasVariations.value,
      'selectedAttributes': selectedAttributes.map((attr) => attr.toJson()).toList(),
      'variations': variations.map((v) => v.toJson()).toList(),
    };
  }

  void loadVariationsData(Map<String, dynamic> data) {
    hasVariations.value = data['hasVariations'] ?? false;
    
    if (data['selectedAttributes'] != null) {
      selectedAttributes.assignAll(
        (data['selectedAttributes'] as List).map((item) => ProductAttribute.fromJson(item)).toList()
      );
    }
    
    if (data['variations'] != null) {
      variations.assignAll(
        (data['variations'] as List).map((item) => ProductVariation.fromJson(item)).toList()
      );
    }
    
    update([attributesUpdateId, variationsUpdateId]);
  }

  List<Map<String, dynamic>> prepareVariationsForApi() {
    return variations.map((variation) {
      final attributeOptions = <Map<String, dynamic>>[];
      
      for (final attrEntry in variation.attributes.entries) {
        final attribute = allAttributes.firstWhere(
          (attr) => attr.name == attrEntry.key,
          orElse: () => ProductAttribute(id: '', name: '', values: []),
        );
        
        if (attribute.id.isNotEmpty) {
          final value = attribute.values.firstWhere(
            (v) => v.value == attrEntry.value,
            orElse: () => AttributeValue(id: '', value: '', isSelected: false.obs),
          );
          
          if (value.id.isNotEmpty) {
            attributeOptions.add({
              'attribute_id': int.parse(attribute.id),
              'option_id': int.parse(value.id),
            });
          }
        }
      }
      
      return {
        'price': variation.price.value,
        'attributeOptions': attributeOptions,
      };
    }).toList();
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

  @override
  void onClose() {
    super.onClose();
  }
}