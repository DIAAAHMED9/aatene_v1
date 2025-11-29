import 'package:attene_mobile/utlis/sheet_controller.dart';
import 'package:attene_mobile/utlis/variation_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/view/product_variations/product_variation_model.dart';

class ProductVariationController extends GetxController {
  // === الحالة الأساسية ===
  final RxBool hasVariations = false.obs;
  final RxList<ProductAttribute> selectedAttributes = <ProductAttribute>[].obs;
  final RxList<ProductAttribute> allAttributes = <ProductAttribute>[].obs;
  
  // === متغيرات الاختلافات ===
  final RxList<ProductVariation> variations = <ProductVariation>[].obs;
  
  // === IDs للتحديث المحدد ===
  static const String attributesUpdateId = 'attributes';
  static const String variationsUpdateId = 'variations';

  @override
  void onInit() {
    super.onInit();
    _initializeAttributes();
  }

  void _initializeAttributes() {
    allAttributes.assignAll([
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

  // === دوال التحكم الرئيسية ===
  
  void toggleHasVariations(bool value) {
    hasVariations.value = value;
    if (!value) {
      selectedAttributes.clear();
      variations.clear();
    }
    update([attributesUpdateId, variationsUpdateId]);
  }

  // ✅ جديد: فتح إدارة السمات باستخدام BottomSheetController
  void openAttributesManagement() {
    final bottomSheetController = Get.find<BottomSheetController>();
    bottomSheetController.openManageAttributes(allAttributes);
    
    // // ✅ الاستماع للتحديثات عند إغلاق الـ Bottom Sheet
    // ever(bottomSheetController.selectedAttributes, (attributes) {
    //   selectedAttributes.assignAll(attributes);
    //   update([attributesUpdateId, variationsUpdateId]);
    // });
  }

  void removeSelectedAttribute(ProductAttribute attribute) {
    selectedAttributes.removeWhere((attr) => attr.id == attribute.id);
    update([attributesUpdateId, variationsUpdateId]);
  }

  void clearAllFields() {
    variations.clear();
    update([attributesUpdateId, variationsUpdateId]);
  }

  // === دوال الاختلافات ===
  void generateSingleVariation() {
    if (selectedAttributes.isEmpty) {
      Get.snackbar('تنبيه', 'يرجى اختيار السمات أولاً');
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
    Get.snackbar('نجاح', 'تم إنشاء بطاقة اختلاف جديدة');
  }

  // ✅ جديد: الحصول على السمات الافتراضية
  Map<String, String> _getDefaultAttributes() {
    final defaultAttributes = <String, String>{};
    for (final attribute in selectedAttributes) {
      final selectedValue = attribute.values.firstWhereOrNull(
        (value) => value.isSelected.value
      );
      if (selectedValue != null) {
        defaultAttributes[attribute.name] = selectedValue.value;
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
    
    // ✅ تحديث مباشر على الـ RxMap
    variations[index].attributes[attributeName] = attributeValue;
    
    // ❌ لا حاجة لـ update لأن البيانات تفاعلية
    // variations[index] = variation.copyWith(attributes: newAttributes);
  }
}

  // دوال إدارة الاختلافات
void toggleVariationActive(ProductVariation variation) {
  final index = variations.indexWhere((v) => v.id == variation.id);
  if (index != -1) {
    // ✅ تحديث مباشر على الـ RxBool
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
    // ✅ تحديث مباشر على الـ RxDouble
    variations[index].price.value = parsedPrice;
  }
}


void updateVariationStock(ProductVariation variation, String stock) {
  final index = variations.indexWhere((v) => v.id == variation.id);
  if (index != -1) {
    // ✅ تحديث مباشر على الـ RxInt
    variations[index].stock.value = int.tryParse(stock) ?? 0;
  }
}

void updateVariationSku(ProductVariation variation, String sku) {
  final index = variations.indexWhere((v) => v.id == variation.id);
  if (index != -1) {
    // ✅ تحديث مباشر على الـ RxString
    variations[index].sku.value = sku;
  }
}

void addImageToVariation(ProductVariation variation, String imageUrl) {
  final index = variations.indexWhere((v) => v.id == variation.id);
  if (index != -1) {
    // ✅ تحديث مباشر على الـ RxList
    variations[index].images.add(imageUrl);
  }
}

void removeImageFromVariation(ProductVariation variation, String imageUrl) {
  final index = variations.indexWhere((v) => v.id == variation.id);
  if (index != -1) {
    // ✅ تحديث مباشر على الـ RxList
    variations[index].images.remove(imageUrl);
  }
}

  void removeVariation(ProductVariation variation) {
    variations.removeWhere((v) => v.id == variation.id);
    update([variationsUpdateId]);
  }

  // === التحقق من الصحة ===
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
      if (variation.price <= 0) {
        return ValidationResult(
          isValid: false,
          errorMessage: 'يرجى إدخال سعر صحيح لجميع الاختلافات',
        );
      }

      // ✅ جديد: التحقق من اكتمال جميع السمات
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

  // === دوال المساعدة ===
  
  bool isAttributeSelected(ProductAttribute attribute) {
    return selectedAttributes.any((attr) => attr.id == attribute.id);
  }

  bool get hasSelectedValues {
    if (selectedAttributes.isEmpty) return false;
    return selectedAttributes.any((attribute) => 
      attribute.values.any((value) => value.isSelected.value)
    );
  }

  // ✅ جديد: الحصول على تفاصيل الاختلافات للتخزين
  Map<String, dynamic> getVariationsData() {
    return {
      'hasVariations': hasVariations.value,
      'selectedAttributes': selectedAttributes.map((attr) => attr.toJson()).toList(),
      'variations': variations.map((v) => v.toJson()).toList(),
    };
  }

  // ✅ جديد: تحميل بيانات الاختلافات
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

  @override
  void onClose() {
    super.onClose();
  }
}