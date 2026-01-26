
import '../../../../general_index.dart';
import '../../../../utils/sheet_controller.dart';

class ProductCentralController extends GetxController {
  static ProductCentralController get to => Get.find();

  final DataInitializerService dataService = Get.find<DataInitializerService>();
  final GetStorage storage = GetStorage();
  final MyAppController myAppController = Get.find<MyAppController>();

  final RxString productName = ''.obs;
  final RxString productDescription = ''.obs;
  final RxString price = ''.obs;
  final RxInt selectedCategoryId = 0.obs;
  final RxString selectedCondition = ''.obs;
  final RxList<MediaItem> selectedMedia = <MediaItem>[].obs;
  final Rx<Section?> selectedSection = Rx<Section?>(null);

  final RxList<String> keywords = <String>[].obs;
  final RxList<Map<String, dynamic>> variations = <Map<String, dynamic>>[].obs;
  final Rx<Map<String, dynamic>?> selectedStore = Rx<Map<String, dynamic>?>(
    null,
  );

  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxBool isLoadingCategories = false.obs;
  final RxString categoriesError = ''.obs;

  final RxBool isSubmitting = false.obs;
  final RxBool isUpdatingSection = false.obs;
  final RxBool isProductReadyForSubmission = false.obs;

  // Edit mode
  final RxBool isEditMode = false.obs;
  final RxInt editingProductId = 0.obs;
  final RxString editingSku = ''.obs;

  final RxMap<String, String> validationErrors = <String, String>{}.obs;

  final RxMap<int, bool> stepValidationStatus = <int, bool>{}.obs;

  @override
  void onInit() {
    super.onInit();
    print('🔄 [PRODUCT CENTRAL] تهيئة متحكم المنتجات المركزي');
    loadCachedCategories();

    for (int i = 0; i < 4; i++) {
      stepValidationStatus[i] = false;
    }

    ever(productName, (_) => _checkProductReadiness());
    ever(productDescription, (_) => _checkProductReadiness());
    ever(price, (_) => _checkProductReadiness());
    ever(selectedCategoryId, (_) => _checkProductReadiness());
    ever(selectedCondition, (_) => _checkProductReadiness());
    ever(selectedSection, (_) => _checkProductReadiness());
  }

  void _checkProductReadiness() {
    final isBasicComplete =
        productName.isNotEmpty &&
        productDescription.isNotEmpty &&
        price.isNotEmpty &&
        selectedCategoryId > 0 &&
        selectedCondition.isNotEmpty;

    final hasSection = selectedSection.value != null;

    isProductReadyForSubmission(isBasicComplete && hasSection);

    print('''
🔍 [PRODUCT READINESS CHECK]:
   Basic Info: $isBasicComplete
   Has Section: $hasSection
   Section ID: ${selectedSection.value?.id}
   Ready for Submission: ${isProductReadyForSubmission.value}
''');
  }

  Map<String, dynamic> validateStep(int stepIndex) {
    validationErrors.clear();

    switch (stepIndex) {
      case 0:
        return _validateBasicInfoStep();
      case 2:
        return _validateVariationsStep();
      default:
        return {'isValid': true, 'errors': {}};
    }
  }

  Map<String, dynamic> _validateBasicInfoStep() {
    bool isValid = true;

    if (productName.isEmpty) {
      validationErrors['productName'] = 'اسم المنتج مطلوب';
      isValid = false;
    }

    if (productDescription.isEmpty) {
      validationErrors['productDescription'] = 'وصف المنتج مطلوب';
      isValid = false;
    }

    if (price.isEmpty) {
      validationErrors['price'] = 'سعر المنتج مطلوب';
      isValid = false;
    } else {
      final priceValue = double.tryParse(price.value);
      if (priceValue == null || priceValue <= 0) {
        validationErrors['price'] = 'يرجى إدخال سعر صحيح';
        isValid = false;
      }
    }

    if (selectedCategoryId <= 0) {
      validationErrors['category'] = 'فئة المنتج مطلوبة';
      isValid = false;
    }

    if (selectedCondition.isEmpty) {
      validationErrors['condition'] = 'حالة المنتج مطلوبة';
      isValid = false;
    }

    if (selectedMedia.isEmpty) {
      validationErrors['media'] = 'صور المنتج مطلوبة';
      isValid = false;
    }

    if (selectedSection.value == null) {
      validationErrors['section'] = 'قسم المنتج مطلوب';
      isValid = false;
    }

    return {
      'isValid': isValid,
      'errors': Map<String, String>.from(validationErrors),
    };
  }

  Map<String, dynamic> _validateVariationsStep() {
    try {
      if (Get.isRegistered<ProductVariationController>()) {
        final variationController = Get.find<ProductVariationController>();

        if (variationController.hasVariations) {
          final validation = variationController.validateVariations();
          if (!validation.isValid) {
            return {
              'isValid': false,
              'errors': {'variations': validation.errorMessage},
            };
          }
        }
      }
    } catch (e) {
      print('❌ [VARIATIONS VALIDATION] Error: $e');
    }

    return {'isValid': true, 'errors': {}};
  }

  void markStepAsValidated(int stepIndex) {
    stepValidationStatus[stepIndex] = true;
  }

  void clearStepValidation(int stepIndex) {
    stepValidationStatus[stepIndex] = false;
  }

  bool isStepValidated(int stepIndex) {
    return stepValidationStatus[stepIndex] == true;
  }

  Future<void> loadCachedCategories() async {
    try {
      final cachedCategories = dataService.getCategories();
      if (cachedCategories.isNotEmpty) {
        categories.assignAll(List<Map<String, dynamic>>.from(cachedCategories));
        print(
          '✅ [PRODUCT] تم تحميل ${categories.length} فئة من التخزين المحلي',
        );
      }
    } catch (e) {
      print('⚠️ [PRODUCT] خطأ في تحميل الفئات المخزنة: $e');
    }
  }

  Future<void> loadCategoriesIfNeeded() async {
    if (categories.isNotEmpty || isLoadingCategories.value) {
      return;
    }
    await loadCategories();
  }

  Future<void> loadCategories() async {
    return UnifiedLoadingScreen.showWithFuture<void>(
      performLoadCategories(),
      message: 'جاري تحميل الفئات...',
    );
  }

  Future<void> performLoadCategories() async {
    try {
      if (!myAppController.isLoggedIn.value) {
        categoriesError('يجب تسجيل الدخول أولاً');
        print('⚠️ [PRODUCT] المستخدم غير مسجل دخول');
        return;
      }

      isLoadingCategories(true);
      categoriesError('');
      print('📡 [PRODUCT] جلب الفئات من API');

      final response = await ApiHelper.get(
        path: '/merchants/categories/select',
        withLoading: false,
      );

      if (response != null && response['status'] == true) {
        final categoriesList = List<Map<String, dynamic>>.from(
          response['categories'] ?? [],
        );
        categories.assignAll(categoriesList);
        print('✅ [PRODUCT] تم تحميل ${categories.length} فئة بنجاح');
      } else {
        final errorMessage = response?['message'] ?? 'فشل في تحميل الفئات';
        categoriesError(errorMessage);
        print('❌ [PRODUCT] فشل في تحميل الفئات: $errorMessage');
      }
    } catch (e) {
      final error = 'حدث خطأ أثناء تحميل الفئات: $e';
      categoriesError(error);
      print('❌ [PRODUCT] خطأ في تحميل الفئات: $e');
    } finally {
      isLoadingCategories(false);
    }
  }

  Future<void> reloadCategories() async {
    categories.clear();
    await loadCategories();
  }

  void updateSelectedStore(Map<String, dynamic> store) {
    selectedStore(store);
    print(
      '🏪 [PRODUCT] تم تحديث المتجر: ${store['name']} (ID: ${store['id']})',
    );
    printDataSummary();
  }

  void updateBasicInfo({
    required String name,
    required String description,
    required String productPrice,
    required int categoryId,
    required String condition,
    required List<MediaItem> media,
    Section? section,
  }) {
    productName(name);
    productDescription(description);
    price(productPrice);
    selectedCategoryId(categoryId);
    selectedCondition(condition);
    selectedMedia.assignAll(media);

    if (section != null) {
      updateSelectedSection(section);
    }

    print('''
📦 [PRODUCT] تحديث المعلومات الأساسية:
   الاسم: $name
   الوصف: ${description.length} حرف
   السعر: $productPrice
   الفئة: $categoryId
   الحالة: $condition
   القسم: ${section?.name ?? 'غير محدد'}
   الوسائط: ${media.length} عنصر
''');
    _checkProductReadiness();
  }

  void addKeywords(List<String> newKeywords) {
    keywords.assignAll(newKeywords);
    print('🔤 [PRODUCT] تحديث الكلمات المفتاحية: ${newKeywords.length} كلمة');
  }

  void addVariations(List<Map<String, dynamic>> newVariations) {
    variations.assignAll(newVariations);
    print('🎨 [PRODUCT] تحديث المتغيرات: ${newVariations.length} متغير');
  }

  void updateRelatedProductsFromRelatedController() {
    try {
      final relatedController = Get.find<RelatedProductsController>();

      print('🔗 [PRODUCT] تم استقبال طلب الربط من RelatedProductsController');
      print(
        '🔗 [PRODUCT] عدد المنتجات المختارة: ${relatedController.selectedProductsCount}',
      );

      Get.snackbar(
        'تم الربط',
        'تم ربط ${relatedController.selectedProductsCount} منتج بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('⚠️ [PRODUCT] خطأ في تحديث المنتجات المرتبطة: $e');
    }
  }

  Map<String, dynamic> getCrossSellData() {
    try {
      if (Get.isRegistered<RelatedProductsController>()) {
        final relatedController = Get.find<RelatedProductsController>();
        return relatedController.getCrossSellData();
      }
    } catch (e) {
      print('⚠️ [PRODUCT] خطأ في جلب بيانات cross sell: $e');
    }

    return {
      'crossSells': [],
      'cross_sells_price': 0.0,
      'cross_sells_due_date': '',
    };
  }

  bool isBasicInfoComplete() {
    return productName.isNotEmpty &&
        productDescription.isNotEmpty &&
        price.isNotEmpty &&
        selectedCategoryId > 0 &&
        selectedCondition.isNotEmpty;
  }

  bool isSectionSelected() {
    final hasSection = selectedSection.value != null;
    final hasValidSectionId = selectedSection.value?.id != null;

    print('''
🔍 [SECTION CHECK]:
   Has Section: $hasSection
   Has Valid Section ID: $hasValidSectionId
   Section ID: ${selectedSection.value?.id}
   Section Name: ${selectedSection.value?.name}
''');

    return hasValidSectionId;
  }

  void printCurrentSection() {
    print('''
📋 [CURRENT SECTION INFO]:
   Section: ${selectedSection.value?.name}
   Section ID: ${selectedSection.value?.id}
   Is Null: ${selectedSection.value == null}
''');
  }

  /// Load product details and prefill controllers for editing.
  /// This enables using the same "Add Product" stepper for update.
  Future<bool> loadProductForEdit(int productId) async {
    try {
      final response = await ApiHelper.get(
        path: '/merchants/products/$productId',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response == null || response['status'] != true) {
        print('❌ [EDIT PRODUCT] Failed to fetch product: ${response?['message']}');
        return false;
      }

      dynamic data = response['data'];
      if (data is List && data.isNotEmpty) {
        data = data.first;
      }

      if (data is! Map) {
        print('❌ [EDIT PRODUCT] Unexpected product data shape');
        return false;
      }

      final productData = Map<String, dynamic>.from(data as Map);
      await applyProductDataForEdit(productId: productId, productData: productData);
      return true;
    } catch (e) {
      print('❌ [EDIT PRODUCT] Error loading product: $e');
      return false;
    }
  }

  /// Apply API product data into stepper controllers (basic info, media, keywords, variations, cross-sells)
  Future<void> applyProductDataForEdit({
    required int productId,
    required Map<String, dynamic> productData,
  }) async {
    isEditMode(true);
    editingProductId(productId);
    editingSku(productData['sku']?.toString() ?? '');

    productName(productData['name']?.toString() ?? '');
    // Prefer full HTML description, fallback to short_description
    productDescription(
      (productData['description'] ?? productData['short_description'] ?? '').toString(),
    );
    price((productData['price'] ?? '').toString());
    selectedCategoryId(
      productData['category_id'] is int
          ? productData['category_id']
          : int.tryParse(productData['category_id']?.toString() ?? '') ?? 0,
    );
    selectedCondition(_toArabicCondition(productData['condition']?.toString()));

    // Section
    final int sectionId = productData['section_id'] is int
        ? productData['section_id']
        : int.tryParse(productData['section_id']?.toString() ?? '') ?? 0;
    if (sectionId > 0) {
      final sectionName = (productData['section'] is Map)
          ? (productData['section']['name']?.toString() ?? '')
          : (productData['section_name']?.toString() ?? '');
      final Section? resolved = _resolveSection(sectionId, sectionName);
      selectedSection(resolved);
    }

    // Media (cover + gallery)
    final List<String> paths = [];
    final cover = productData['cover']?.toString();
    if (cover != null && cover.trim().isNotEmpty) paths.add(cover);
    if (productData['gallary'] is List) {
      paths.addAll((productData['gallary'] as List).map((e) => e.toString()));
    } else if (productData['gallery'] is List) {
      paths.addAll((productData['gallery'] as List).map((e) => e.toString()));
    }
    final uniquePaths = paths.where((p) => p.trim().isNotEmpty).toSet().toList();
    selectedMedia.assignAll(uniquePaths.map(_mediaItemFromRelativePath).toList());

    // Keywords/tags
    if (productData['tags'] is List) {
      keywords.assignAll((productData['tags'] as List).map((e) => e.toString()));
    } else {
      keywords.clear();
    }

    // Sync keyword controller UI if already initialized
    if (Get.isRegistered<KeywordController>()) {
      Get.find<KeywordController>().syncFromProductController();
    }

    // Variations
    if (Get.isRegistered<ProductVariationController>()) {
      final variationController = Get.find<ProductVariationController>();

      final rawVars = productData['variations'];
      final bool hasVars = rawVars is List && rawVars.isNotEmpty;

      // بعض المنتجات قد تُرجع type مختلف رغم وجود variations، لذلك نعتمد على وجود القائمة فعلياً.
      if (hasVars) {
        // Ensure attributes are available for mapping attribute_id/option_id -> names/values
        await variationController.loadAttributesOnOpen();
        await variationController.loadFromProductApi(
          productData: productData,
          isEditMode: true,
        );
      } else {
        // Only disable if there are truly no variations in API data.
        variationController.toggleHasVariations(false);
      }
    }

    // Cross-sells / related products

    if (Get.isRegistered<RelatedProductsController>()) {
      // Await so the controller can ensure products are loaded (cache/API)
      // and apply selected ids before the UI builds.
      await Get.find<RelatedProductsController>().loadFromProductApi(productData);
    }

    // Sync basic info text controllers
    if (Get.isRegistered<AddProductController>()) {
      Get.find<AddProductController>().applyCentralToTextFields();
    }

    print('✅ [EDIT PRODUCT] Prefilled stepper for product #$productId');
  }

  String _toArabicCondition(String? apiCondition) {
    switch ((apiCondition ?? '').toLowerCase()) {
      case 'used':
        return 'مستعمل';
      case 'refurbished':
        return 'مجدول';
      case 'new':
      default:
        return 'جديد';
    }
  }

  Section? _resolveSection(int sectionId, String sectionName) {
    try {
      final sectionsData = dataService.getSections();
      if (sectionsData is List && sectionsData.isNotEmpty) {
        final sections = sectionsData
            .whereType<Map>()
            .map((e) => Section.fromJson(Map<String, dynamic>.from(e)))
            .toList();
        final match = sections.firstWhereOrNull((s) => s.id == sectionId);
        if (match != null) return match;
      }
    } catch (e) {
      print('⚠️ [EDIT PRODUCT] Error resolving section locally: $e');
    }
    if (sectionId <= 0) return null;
    return Section(id: sectionId, name: sectionName.isNotEmpty ? sectionName : 'قسم #$sectionId', storeId: '');
  }

  MediaItem _mediaItemFromRelativePath(String relativePath) {
    final String url = _toFullMediaUrl(relativePath);
    final String name = relativePath.split('/').last;
    return MediaItem(
      id: '${editingProductId.value}_${name}_${DateTime.now().millisecondsSinceEpoch}',
      path: url,
      type: MediaType.image,
      name: name,
      dateAdded: DateTime.now(),
      size: 0,
      isLocal: false,
      fileName: name,
      fileUrl: url,
    );
  }

  String _toFullMediaUrl(String path) {
    final p = path.trim();
    if (p.isEmpty) return '';
    if (p.startsWith('http://') || p.startsWith('https://')) return p;

    // Most media served under /storage
    final base = ApiHelper.getBaseUrl().replaceAll(RegExp(r'/$'), '');
    final cleaned = p.startsWith('/') ? p.substring(1) : p;
    if (cleaned.startsWith('storage/')) {
      return '$base/$cleaned';
    }
    return '$base/storage/$cleaned';
  }

  Future<Map<String, dynamic>?> submitProduct() async {
    return UnifiedLoadingScreen.showWithFuture<Map<String, dynamic>>(
      performSubmitProduct(),
      message: isEditMode.value ? 'جاري تحديث المنتج...' : 'جاري إضافة المنتج...',
    );
  }

  Future<Map<String, dynamic>> performSubmitProduct() async {
    try {
      isSubmitting(true);

      if (!isSectionSelected()) {
        print('❌ [PRODUCT] فشل: لم يتم اختيار قسم للمنتج');
        return {
          'success': false,
          'message': 'يجب اختيار قسم للمنتج قبل الإرسال',
        };
      }

      printCurrentSection();

      print('''
🚀 [PRODUCT] إرسال المنتج:
   الاسم: ${productName.value}
   الفئة: ${selectedCategoryId.value}
   السعر: ${price.value}
   القسم: ${selectedSection.value?.name} (ID: ${selectedSection.value?.id})
   الوسائط: ${selectedMedia.length}
   الكلمات المفتاحية: ${keywords.length}
''');

      updateVariationsData();

      final variationController = Get.find<ProductVariationController>();
      final variationsData = variationController.prepareVariationsForApi();

      print(
        '🎯 [PRODUCT] بيانات المتغيرات المعدة: ${variationsData.length} متغير',
      );

      final productData = await prepareProductData(variationsData);

      print('📤 [PRODUCT] بيانات المنتج المرسلة: ${jsonEncode(productData)}');

      final String path = isEditMode.value && editingProductId.value > 0
          ? '/merchants/products/${editingProductId.value}'
          : '/merchants/products';

      // NOTE: Backend uses POST for both create and update.
      final response = await ApiHelper.post(
        path: path,
        body: productData,
        withLoading: false,
      );

      print('📥 [PRODUCT] استجابة API: ${jsonEncode(response)}');

      if (response != null && response['status'] == true) {
        final dynamic data = response['data'];
        final Map<String, dynamic>? product = data is List
            ? (data.isNotEmpty ? Map<String, dynamic>.from(data.first) : null)
            : (data is Map ? Map<String, dynamic>.from(data) : null);

        print(
          '✅ [PRODUCT] تم ${isEditMode.value ? 'تحديث' : 'إنشاء'} المنتج بنجاح: ${product?['name']}',
        );

        await dataService.refreshProducts();

        _notifyProductUpdate();

        // In edit mode we keep controllers values (so user can continue) but we
        // reset edit flag. In add mode we reset completely.
        if (isEditMode.value) {
          isEditMode(false);
          editingProductId(0);
          editingSku('');
        } else {
          resetAfterSuccess(variationController);
        }

        return {'success': true, 'data': response['data']};
      } else {
        final errorMessage = parseErrorMessage(response);
        print(
          '❌ [PRODUCT] فشل ${isEditMode.value ? 'تحديث' : 'إنشاء'} المنتج: $errorMessage',
        );
        return {'success': false, 'message': errorMessage};
      }
    } catch (e) {
      print('❌ [PRODUCT] خطأ في إرسال المنتج: $e');
      return {'success': false, 'message': 'حدث خطأ أثناء إضافة المنتج: $e'};
    } finally {
      isSubmitting(false);
    }
  }

  Future<Map<String, dynamic>> prepareProductData(
    List<Map<String, dynamic>> variationsData,
  ) async {
    if (selectedSection.value == null || selectedSection.value!.id == null) {
      throw Exception('القسم غير محدد. يرجى اختيار قسم للمنتج.');
    }

    print('selectedSection.value?.id :: ${selectedSection.value?.id}');
    final productData = <String, dynamic>{
      'section_id': selectedSection.value!.id,
      // Keep existing SKU in edit mode (backend may validate it)
      if (isEditMode.value && editingSku.value.trim().isNotEmpty)
        'sku': editingSku.value.trim(),
      'name': productName.value.trim(),
      'description': productDescription.value.trim(),
      'price': double.tryParse(price.value) ?? 0.0,
      'category_id': selectedCategoryId.value,
      'condition': formatCondition(selectedCondition.value),
      'short_description': getShortDescription(),
      // Keep SKU on edit if provided by API
      'sku': (isEditMode.value && editingSku.value.trim().isNotEmpty)
          ? editingSku.value.trim()
          : generateSku(),
    };

    if (selectedMedia.isNotEmpty) {
      final firstMedia = selectedMedia.first;
      productData['cover'] = getFilePath(firstMedia.fileUrl);
      productData['gallary'] = selectedMedia
          .map((media) => getFilePath(media.fileUrl))
          .toList();
    }

    if (keywords.isNotEmpty) {
      productData['tags'] = keywords;
    } else {
      productData['tags'] = [];
    }

    if (variationsData.isNotEmpty) {
      productData['type'] = 'variation';
      productData['variations'] = prepareVariationsData(variationsData);
    } else {
      productData['type'] = 'simple';
      productData['variations'] = [];
    }

    final crossSellData = getCrossSellData();

    productData['crossSells'] = crossSellData['crossSells'] ?? [];

    if (crossSellData['crossSells'] != null &&
        (crossSellData['crossSells'] as List).isNotEmpty) {
      productData['cross_sells_price'] =
          crossSellData['cross_sells_price'] ?? 0.0;

      if (crossSellData['cross_sells_due_date'] != null &&
          (crossSellData['cross_sells_due_date'] as String).isNotEmpty) {
        productData['cross_sells_due_date'] =
            crossSellData['cross_sells_due_date'];
      } else {
        final dueDate = DateTime.now().add(const Duration(days: 30));
        productData['cross_sells_due_date'] =
            '${dueDate.year}-${dueDate.month.toString().padLeft(2, '0')}-${dueDate.day.toString().padLeft(2, '0')}';
      }
    } else {
      productData['cross_sells_price'] = 0;
      productData['cross_sells_due_date'] = '';
    }

    print('''
📤 [PRODUCT] بيانات cross sell:
   crossSells: ${productData['crossSells']}
   cross_sells_price: ${productData['cross_sells_price']}
   cross_sells_due_date: ${productData['cross_sells_due_date']}
''');

    return productData;
  }

  List<Map<String, dynamic>> prepareVariationsData(
    List<Map<String, dynamic>> variationsData,
  ) {
    return variationsData.map((variation) {
      final variationData = {
        if (isEditMode.value && variation['id'] != null) 'id': variation['id'],
        'price': variation['price'],
        'attributeOptions': prepareAttributeOptions(
          variation['attributeOptions'] ?? [],
        ),
      };

      if (variation['image'] != null &&
          variation['image'].toString().isNotEmpty) {
        variationData['image'] = getFilePath(variation['image'].toString());
      }

      return variationData;
    }).toList();
  }

  List<Map<String, dynamic>> prepareAttributeOptions(
    List<dynamic> attributeOptions,
  ) {
    final List<Map<String, dynamic>> result = [];

    for (final option in attributeOptions) {
      if (option is Map<String, dynamic>) {
        final attributeId = option['attribute_id'];
        final optionId = option['option_id'];

        if (attributeId != null && optionId != null) {
          result.add({
            'attribute_id': attributeId is int
                ? attributeId
                : int.tryParse(attributeId.toString()) ?? 0,
            'option_id': optionId is int
                ? optionId
                : int.tryParse(optionId.toString()) ?? 0,
          });
        }
      } else if (option is Map) {
        final attributeId = option['attribute_id'];
        final optionId = option['option_id'];

        if (attributeId != null && optionId != null) {
          result.add({
            'attribute_id': attributeId is int
                ? attributeId
                : int.tryParse(attributeId.toString()) ?? 0,
            'option_id': optionId is int
                ? optionId
                : int.tryParse(optionId.toString()) ?? 0,
          });
        }
      }
    }

    return result;
  }

  void updateVariationsData() {
    final variationController = Get.find<ProductVariationController>();

    for (final variation in variationController.variations) {
      if (variation.images.isNotEmpty) {
        if (variation.images.first.contains('variation_default.jpg') ||
            variation.images.first.isEmpty) {
          variation.images.clear();
        }
      }
    }

    print('✅ [PRODUCT] تحديث بيانات المتغيرات: تم تنظيف الصور لـ API');
  }

  String parseErrorMessage(Map<String, dynamic>? response) {
    if (response == null) {
      return 'فشل في الاتصال بالخادم';
    }

    if (response['errors'] != null && response['errors'] is Map) {
      final errors = Map<String, dynamic>.from(response['errors']);
      if (errors.isNotEmpty) {
        final firstError = errors.entries.first;
        final errorMessages = List<String>.from(firstError.value);
        return errorMessages.isNotEmpty
            ? errorMessages.first
            : 'حدث خطأ غير معروف';
      }
    }

    return response['message'] ?? 'فشل في إضافة المنتج';
  }

  
  /// Reset ALL stepper-related data (used before starting add/edit flow)
  void resetAllData() {
    // reset core product fields + section
    reset(resetSection: true);
    // reset edit flags
    isEditMode(false);
    editingProductId(0);
    editingSku('');
  }

void resetAfterSuccess(ProductVariationController variationController) {
    reset(resetSection: true);
    variationController.toggleHasVariations(false);
    variationController.selectedAttributes.clear();
    variationController.variations.clear();
  }

  void reset({bool resetSection = false}) {
    productName('');
    productDescription('');
    price('');
    selectedCategoryId(0);
    selectedCondition('');
    selectedMedia.clear();
    keywords.clear();
    variations.clear();
    validationErrors.clear();

    for (int i = 0; i < 4; i++) {
      stepValidationStatus[i] = false;
    }

    if (resetSection) {
      selectedSection(null);
    }

    print(
      '🔄 [PRODUCT] إعادة تعيين بيانات المنتج ${resetSection ? 'مع القسم' : 'بدون القسم'}',
    );
    _checkProductReadiness();
  }


  String _apiConditionToArabic(String? apiCondition) {
    switch ((apiCondition ?? '').toLowerCase()) {
      case 'new':
        return 'جديد';
      case 'used':
        return 'مستعمل';
      case 'refurbished':
        return 'مجدول';
      default:
        return 'جديد';
    }
  }

  void _setSectionFromId(int sectionId, dynamic sectionObj) {
    if (sectionId <= 0) return;

    try {
      final cached = dataService.getSections();
      final sections = cached.map((e) => Section.fromJson(e)).toList();
      final found = sections.firstWhereOrNull((s) => s.id == sectionId);

      if (found != null) {
        selectedSection(found);
        return;
      }
    } catch (_) {}

    // Fallback using API object
    try {
      if (sectionObj is Map) {
        selectedSection(Section.fromJson(Map<String, dynamic>.from(sectionObj)));
      } else {
        selectedSection(Section(id: sectionId, name: 'قسم #$sectionId', storeId: ''));
      }
    } catch (_) {
      selectedSection(Section(id: sectionId, name: 'قسم #$sectionId', storeId: ''));
    }
  }

  void _setMediaFromApi(Map<String, dynamic> p) {
    final List<String> paths = [];
    final cover = p['cover']?.toString();
    if (cover != null && cover.trim().isNotEmpty) {
      paths.add(cover.trim());
    }

    if (p['gallary'] is List) {
      for (final g in (p['gallary'] as List)) {
        final s = g?.toString() ?? '';
        if (s.trim().isNotEmpty) paths.add(s.trim());
      }
    }

    final unique = <String>{};
    final List<MediaItem> items = [];
    for (final rel in paths) {
      if (unique.contains(rel)) continue;
      unique.add(rel);
      final url = _fullMediaUrl(rel);
      items.add(
        MediaItem(
          id: rel,
          path: url,
          type: MediaType.image,
          name: rel.split('/').last,
          dateAdded: DateTime.now(),
          size: 0,
          isLocal: false,
          fileName: rel.split('/').last,
          fileUrl: url,
        ),
      );
    }
    selectedMedia.assignAll(items);
  }

  String _fullMediaUrl(String relPath) {
    final p = relPath.trim();
    if (p.isEmpty) return '';
    if (p.startsWith('http://') || p.startsWith('https://')) return p;

    final base = ApiHelper.getBaseUrl();
    // Most of backend files are served under /storage/
    if (p.startsWith('storage/')) {
      return '$base/$p';
    }
    if (p.startsWith('/storage/')) {
      return '$base${p.startsWith('/') ? '' : '/'}$p';
    }
    final clean = p.startsWith('/') ? p.substring(1) : p;
    return '$base/storage/$clean';
  }

  String formatCondition(String condition) {
    switch (condition) {
      case 'جديد':
        return 'new';
      case 'مستعمل':
        return 'used';
      case 'مجدول':
        return 'refurbished';
      default:
        return 'new';
    }
  }

  String generateSku() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = timestamp % 10000;
    return 'SKU${productName.value.replaceAll(' ', '_').toUpperCase()}_$random';
  }

  String getShortDescription() {
    if (productDescription.value.length <= 100) {
      return productDescription.value;
    }
    return '${productDescription.value.substring(0, 100)}...';
  }

  String getFilePath(String? url) {
    if (url == null || url.isEmpty) return '';

    try {
      final uri = Uri.parse(url);
      String path = uri.path;

      if (path.startsWith('/storage/')) {
        final newPath = path.replaceFirst('/storage/', '');
        return newPath;
      }

      if (path.startsWith('/gallery/')) {
        final newPath = path.substring(1);
        return newPath;
      }

      if (path.startsWith('/images/')) {
        final newPath = path.substring(1);
        return newPath;
      }

      return path;
    } catch (e) {
      print('❌ [PRODUCT] خطأ في تحويل المسار: $e');
      return url;
    }
  }

  void printDataSummary() {
    final variationController = Get.find<ProductVariationController>();

    try {
      final relatedProductsCount = Get.isRegistered<RelatedProductsController>()
          ? Get.find<RelatedProductsController>().selectedProductsCount
          : 0;

      print('''
📊 [PRODUCT SUMMARY]:
   الاسم: ${productName.value}
   الوصف: ${productDescription.value.length} حرف
   السعر: ${price.value}
   الفئة: ${selectedCategoryId.value}
   الحالة: ${selectedCondition.value}
   القسم: ${selectedSection.value?.name ?? 'غير محدد'} (ID: ${selectedSection.value?.id})
   الوسائط: ${selectedMedia.length}
   الكلمات المفتاحية: ${keywords.length}
   السمات المختارة: ${variationController.selectedAttributes.length}
   المتغيرات: ${variationController.variations.length}
   المنتجات المرتبطة: $relatedProductsCount
   جاهز للإرسال: ${isProductReadyForSubmission.value}
   أخطاء التحقق: ${validationErrors.length}
''');
    } catch (e) {
      print('⚠️ [PRODUCT] خطأ في طباعة ملخص البيانات: $e');
    }
  }

  void updateSelectedSection(Section section) {
    if (isUpdatingSection.value) return;

    isUpdatingSection.value = true;

    try {
      if (selectedSection.value?.id == section.id) {
        print(
          '⚠️ [PRODUCT] القسم محدث بالفعل: ${section.name} (ID: ${section.id})',
        );
        return;
      }

      selectedSection(section);
      print('✅ [PRODUCT] تحديث القسم: ${section.name} (ID: ${section.id})');

      if (validationErrors.containsKey('section')) {
        validationErrors.remove('section');
      }

      if (Get.isRegistered<BottomSheetController>()) {
        final bottomSheetController = Get.find<BottomSheetController>();
        bottomSheetController.updateSelectedSectionInBottomSheet(section);
      }
    } finally {
      Future.delayed(const Duration(milliseconds: 100), () {
        isUpdatingSection.value = false;
        _checkProductReadiness();
      });
    }
  }

  void setSectionDirectly(Section section) {
    selectedSection(section);
    print(
      '🎯 [PRODUCT] تم تعيين القسم مباشرة: ${section.name} (ID: ${section.id})',
    );
    _checkProductReadiness();
  }

  void _notifyProductUpdate() {
    try {
      dataService.refreshProducts();

      if (Get.isRegistered<ProductController>()) {
        final productController = Get.find<ProductController>();
        productController.notifyProductsUpdated();
      }

      if (Get.isRegistered<BottomSheetController>()) {
        final bottomSheetController = Get.find<BottomSheetController>();
        bottomSheetController.notifySectionsUpdated();
      }

      print('📢 [PRODUCT CENTRAL] تم إشعار جميع المتحكمين بتحديث المنتجات');

      Get.snackbar(
        'تمت الإضافة',
        'تم إضافة المنتج بنجاح وتحديث القوائم',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('⚠️ [PRODUCT CENTRAL] خطأ في إشعار التحديث: $e');
    }
  }

  Future<Map<String, dynamic>> testWithCorrectStructure() async {
    try {
      print('🧪 [PRODUCT] اختبار الهيكل الصحيح');

      final testData = {
        "section_id": 18,
        "name": "منتج تجريبي",
        "price": 100.0,
        "condition": "new",
        "category_id": 83,
        "short_description": "هذا وصف مختصر للمنتج",
        "description": "<p>هذا وصف مفصل للمنتج التجريبي</p>",
        "tags": ["تجريبي", "اختبار"],
        "type": "simple",
        "variations": [],
        "crossSells": [],
      };

      print('🧪 [PRODUCT] بيانات الاختبار: ${jsonEncode(testData)}');

      final response = await ApiHelper.post(
        path: '/merchants/products',
        body: testData,
        withLoading: false,
      );

      print('🧪 [PRODUCT] استجابة الاختبار: ${jsonEncode(response)}');

      if (response != null && response['status'] == true) {
        return {'success': true, 'message': '✅ الاختبار نجح - الهيكل صحيح'};
      } else {
        return {
          'success': false,
          'message': '❌ فشل الاختبار: ${response?['message']}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': '❌ خطأ في الاختبار: $e'};
    }
  }

  Map<String, dynamic> getCategoryById(int id) {
    return categories.firstWhere(
      (category) => category['id'] == id,
      orElse: () => {'name': 'غير محدد'},
    );
  }

  String getCategoryName(int id) {
    final category = getCategoryById(id);
    return category['name']?.toString() ?? 'غير محدد';
  }

  Map<String, dynamic> validateProductData() {
    final errors = <String>[];

    if (productName.isEmpty) errors.add('اسم المنتج مطلوب');
    if (productDescription.isEmpty) errors.add('وصف المنتج مطلوب');
    if (price.isEmpty) errors.add('سعر المنتج مطلوب');
    if (selectedCategoryId <= 0) errors.add('فئة المنتج مطلوبة');
    if (selectedCondition.isEmpty) errors.add('حالة المنتج مطلوبة');
    if (selectedSection.value == null) errors.add('قسم المنتج مطلوب');

    return {
      'isValid': errors.isEmpty,
      'errors': errors,
      'sectionId': selectedSection.value?.id,
      'sectionName': selectedSection.value?.name,
    };
  }

  Map<String, dynamic> getProductSummary() {
    return {
      'productName': productName.value,
      'productDescription': productDescription.value,
      'price': price.value,
      'categoryId': selectedCategoryId.value,
      'categoryName': getCategoryName(selectedCategoryId.value),
      'condition': selectedCondition.value,
      'sectionId': selectedSection.value?.id,
      'sectionName': selectedSection.value?.name,
      'mediaCount': selectedMedia.length,
      'keywordsCount': keywords.length,
      'variationsCount': variations.length,
      'isReadyForSubmission': isProductReadyForSubmission.value,
      'validation': validateProductData(),
      'validationErrors': Map<String, String>.from(validationErrors),
    };
  }

  @override
  void onClose() {
    print('🔚 [PRODUCT] إغلاق متحكم المنتجات المركزي');
    super.onClose();
  }
}