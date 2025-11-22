import 'package:get/get.dart';

class ProductAttribute {
  final String id;
  final String name;
  final RxList<AttributeValue> values;

  ProductAttribute({
    required this.id,
    required this.name,
    List<AttributeValue>? values,
  }) : values = (values ?? []).obs;

  ProductAttribute copyWith({
    String? id,
    String? name,
    List<AttributeValue>? values,
  }) {
    return ProductAttribute(
      id: id ?? this.id,
      name: name ?? this.name,
      values: values ?? this.values,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'values': values.map((value) => value.toJson()).toList(),
    };
  }

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      values: (json['values'] as List<dynamic>?)
          ?.map((value) => AttributeValue.fromJson(value))
          .toList(),
    );
  }

  List<AttributeValue> get selectedValues {
    return values.where((value) => value.isSelected.value).toList();
  }

  bool get hasSelectedValues {
    return values.any((value) => value.isSelected.value);
  }

  List<String> get selectedValueNames {
    return selectedValues.map((value) => value.value).toList();
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductAttribute && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProductAttribute(id: $id, name: $name, values: ${values.length})';
  }
}

class AttributeValue {
  final String id;
  final String value;
  final RxBool isSelected;

  AttributeValue({
    required this.id,
    required this.value,
    bool isSelected = false,
  }) : isSelected = RxBool(isSelected);

  AttributeValue copyWith({
    String? id,
    String? value,
    bool? isSelected,
  }) {
    return AttributeValue(
      id: id ?? this.id,
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected.value,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'isSelected': isSelected.value,
    };
  }

  factory AttributeValue.fromJson(Map<String, dynamic> json) {
    return AttributeValue(
      id: json['id'] ?? '',
      value: json['value'] ?? '',
      isSelected: json['isSelected'] ?? false,
    );
  }

  void toggleSelection() {
    isSelected.toggle();
  }

  void setSelected(bool selected) {
    isSelected.value = selected;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AttributeValue && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'AttributeValue(id: $id, value: $value, isSelected: ${isSelected.value})';
  }
}

class ProductVariation {
  final String id;
  final RxMap<String, String> attributes; // ✅ تغيير إلى RxMap
  final RxDouble price; // ✅ تغيير إلى RxDouble
  final RxInt stock; // ✅ تغيير إلى RxInt
  final RxString sku; // ✅ تغيير إلى RxString
  final RxList<String> images; // ✅ تغيير إلى RxList
  final RxBool isActive; // ✅ تغيير إلى RxBool

  ProductVariation({
    required this.id,
    required Map<String, String> attributes,
    required double price,
    required int stock,
    String sku = '',
    List<String> images = const [],
    bool isActive = true,
  })  : attributes = RxMap(attributes),
        price = RxDouble(price),
        stock = RxInt(stock),
        sku = RxString(sku),
        images = RxList(images),
        isActive = RxBool(isActive);

  ProductVariation copyWith({
    String? id,
    Map<String, String>? attributes,
    double? price,
    int? stock,
    String? sku,
    List<String>? images,
    bool? isActive,
  }) {
    return ProductVariation(
      id: id ?? this.id,
      attributes: attributes ?? this.attributes,
      price: price ?? this.price.value,
      stock: stock ?? this.stock.value,
      sku: sku ?? this.sku.value,
      images: images ?? this.images,
      isActive: isActive ?? this.isActive.value,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'attributes': Map<String, String>.from(attributes),
      'price': price.value,
      'stock': stock.value,
      'sku': sku.value,
      'images': images.toList(),
      'isActive': isActive.value,
    };
  }

  factory ProductVariation.fromJson(Map<String, dynamic> json) {
    return ProductVariation(
      id: json['id'] ?? '',
      attributes: Map<String, String>.from(json['attributes'] ?? {}),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: (json['stock'] as num?)?.toInt() ?? 0,
      sku: json['sku'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      isActive: json['isActive'] ?? true,
    );
  }

  String get variationName {
    if (attributes.isEmpty) return 'بدون اختلافات';
    return attributes.entries.map((entry) => '${entry.key}: ${entry.value}').join(' - ');
  }

  String get shortDescription {
    if (attributes.isEmpty) return 'المنتج الأساسي';
    final limitedAttributes = attributes.entries.take(2).toList();
    final description = limitedAttributes.map((entry) => '${entry.key}: ${entry.value}').join('، ');
    if (attributes.length > 2) {
      return '$description +${attributes.length - 2}';
    }
    return description;
  }

  bool get isComplete {
    return price.value > 0 && stock.value >= 0 && attributes.isNotEmpty;
  }

  String get stockStatus {
    if (stock.value == 0) return 'نفذ من المخزون';
    if (stock.value < 10) return 'كمية محدودة';
    return 'متوفر في المخزون';
  }

  int get stockStatusColor {
    if (stock.value == 0) return 0xFFFF0000;
    if (stock.value < 10) return 0xFFFFA500;
    return 0xFF4CAF50;
  }

  void addImage(String imageUrl) {
    images.add(imageUrl);
  }

  void removeImage(String imageUrl) {
    images.remove(imageUrl);
  }

  void updateAttribute(String attributeName, String attributeValue) {
    attributes[attributeName] = attributeValue;
  }

  void removeAttribute(String attributeName) {
    attributes.remove(attributeName);
  }

  bool hasAttribute(String attributeName) {
    return attributes.containsKey(attributeName);
  }

  String? getAttributeValue(String attributeName) {
    return attributes[attributeName];
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductVariation && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ProductVariation(id: $id, attributes: $attributes, price: ${price.value}, stock: ${stock.value}, isActive: ${isActive.value})';
  }
}

class VariationData {
  final RxBool hasVariations;
  final RxList<ProductAttribute> selectedAttributes;
  final RxList<ProductVariation> variations;

  VariationData({
    required bool hasVariations,
    required List<ProductAttribute> selectedAttributes,
    required List<ProductVariation> variations,
  })  : hasVariations = RxBool(hasVariations),
        selectedAttributes = RxList(selectedAttributes),
        variations = RxList(variations);

  Map<String, dynamic> toJson() {
    return {
      'hasVariations': hasVariations.value,
      'selectedAttributes': selectedAttributes.map((attr) => attr.toJson()).toList(),
      'variations': variations.map((v) => v.toJson()).toList(),
    };
  }

  factory VariationData.fromJson(Map<String, dynamic> json) {
    return VariationData(
      hasVariations: json['hasVariations'] ?? false,
      selectedAttributes: (json['selectedAttributes'] as List<dynamic>?)
          ?.map((attr) => ProductAttribute.fromJson(attr))
          .toList() ?? [],
      variations: (json['variations'] as List<dynamic>?)
          ?.map((v) => ProductVariation.fromJson(v))
          .toList() ?? [],
    );
  }

  bool get isValid {
    if (hasVariations.value) {
      return selectedAttributes.isNotEmpty && variations.isNotEmpty;
    }
    return true;
  }

  int get activeVariationsCount {
    return variations.where((variation) => variation.isActive.value).length;
  }

  int get totalStock {
    return variations.fold(0, (sum, variation) => sum + variation.stock.value);
  }

  @override
  String toString() {
    return 'VariationData(hasVariations: ${hasVariations.value}, attributes: ${selectedAttributes.length}, variations: ${variations.length})';
  }
}