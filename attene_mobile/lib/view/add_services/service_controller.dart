import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/my_app/my_app_controller.dart';
import '../media_library/media_model.dart';
import 'models/models.dart';

class ServiceController extends GetxController {
  static const int maxSpecializations = 20;
  static const int maxKeywords = 25;
  static const int maxImages = 10;
  static const int maxFAQs = 5;

  // النص الافتراضي للوصف
  static const String defaultDescriptionPlaceholder = 'ابدأ الكتابة هنا...';

  RxInt currentStep = 0.obs;

  RxString serviceTitle = ''.obs;
  RxString selectedMainCategory = ''.obs;
  RxString selectedCategory = ''.obs;
  RxList<String> specializations = <String>[].obs;
  RxList<String> keywords = <String>[].obs;
  RxList<FAQ> faqs = <FAQ>[].obs;

  late QuillController quillController;
  RxString serviceDescriptionPlainText = ''.obs;
  RxString serviceDescriptionRichText = ''.obs;
  FocusNode editorFocusNode = FocusNode();
  ScrollController editorScrollController = ScrollController();

  // متغيرات لحالة الوصف
  RxBool hasUserTypedInDescription = false.obs;
  RxBool isEditorEmpty = true.obs;
  RxBool showDescriptionPlaceholder = true.obs;

  RxString price = ''.obs;
  RxString executionTimeValue = ''.obs;
  RxString executionTimeUnit = 'ساعة'.obs;
  RxList<Development> developments = <Development>[].obs;

  RxList<ServiceImage> serviceImages = <ServiceImage>[].obs;

  RxString developmentTitle = ''.obs;
  RxString developmentPrice = ''.obs;
  RxString developmentTimeValue = ''.obs;
  RxString developmentTimeUnit = 'ساعة'.obs;
  RxString tempSelectedCategory = ''.obs;
  RxInt tempSelectedCategoryId = 0.obs;
  RxString searchCategoryQuery = ''.obs;

  RxBool isServiceTitleError = false.obs;
  RxBool isMainCategoryError = false.obs;
  RxBool isCategoryError = false.obs;
  RxBool isPriceError = false.obs;
  RxBool isExecutionTimeError = false.obs;
  RxBool isDescriptionError = false.obs;

  RxBool isLoading = false.obs;
  RxBool isSaving = false.obs;
  RxBool isUploading = false.obs;

  RxList<String> allTimeUnits = [
    'دقيقة',
    'ساعة',
    'يوم',
    'أسبوع',
    'شهر',
    'سنة',
  ].obs;

  TextEditingController specializationTextController = TextEditingController();
  TextEditingController keywordTextController = TextEditingController();

  RxString serviceId = ''.obs;
  RxString serviceSlug = ''.obs;
  RxString serviceStatus = 'pending'.obs;
  RxInt selectedSectionId = 0.obs;
  RxInt selectedCategoryId = 0.obs;
  RxList<String> uploadedImages = <String>[].obs;

  RxList<Map<String, dynamic>> sections = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  RxBool isLoadingCategories = false.obs;
  RxString categoriesError = ''.obs;

  RxBool acceptedTerms = false.obs;
  RxBool acceptedPrivacy = false.obs;
  final RxBool _isSelectionMode = false.obs;
  final RxList<String> _selectedServiceIds = <String>[].obs;

  bool get isInSelectionMode => _isSelectionMode.value;
  List<String> get selectedServiceIds => _selectedServiceIds.toList();

  @override
  void onInit() {
    super.onInit();
    _initializeData();
    _initializeQuill();
    loadSections();
  }

  void _initializeData() {
    specializationTextController.addListener(() {
      update(['specialization_input']);
    });

    keywordTextController.addListener(() {
      update(['keyword_input']);
    });
  }

  void _initializeQuill() {
    // بدء المحرر بمستند فارغ
    quillController = QuillController(
      document: Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    // مستمع لتغييرات المحتوى
    quillController.document.changes.listen((event) {
      String plainText = quillController.document.toPlainText();

      serviceDescriptionPlainText.value = plainText;

      // التحقق مما إذا كان المحتوى فارغاً
      bool isEmpty = plainText.trim().isEmpty;
      bool isOnlyNewline = plainText == '\n' || plainText == '\n\n';

      isEditorEmpty.value = isEmpty || isOnlyNewline;

      // إذا كان هناك نص حقيقي، فقد كتب المستخدم
      if (plainText.trim().isNotEmpty && !isOnlyNewline) {
        hasUserTypedInDescription.value = true;
        showDescriptionPlaceholder.value = false;
      } else {
        showDescriptionPlaceholder.value = true;
      }

      // التحقق من الخطأ - الوصف مطلوب فقط إذا كان المستخدم قد بدأ الكتابة
      if (hasUserTypedInDescription.value) {
        isDescriptionError.value = isEditorEmpty.value;
      } else {
        isDescriptionError.value = false;
      }

      // تحديث الواجهة
      update(['description_field']);
    });

    // إضافة مستمع لـ FocusNode
    editorFocusNode.addListener(() {
      if (editorFocusNode.hasFocus) {
        // إذا كان المحرر فارغاً ونقره المستخدم، فلنفترض أنه يريد الكتابة
        if (isEditorEmpty.value && !hasUserTypedInDescription.value) {
          hasUserTypedInDescription.value = true;
          showDescriptionPlaceholder.value = false;
        }
      }
    });
  }

  void _checkDescriptionContent() {
    String plainText = quillController.document.toPlainText();

    bool isEmpty = plainText.trim().isEmpty;
    bool isOnlyNewline = plainText == '\n' || plainText == '\n\n';

    isEditorEmpty.value = isEmpty || isOnlyNewline;

    // تحديث حالة النص الافتراضي
    if (plainText.trim().isNotEmpty && !isOnlyNewline) {
      hasUserTypedInDescription.value = true;
      showDescriptionPlaceholder.value = false;
    } else {
      showDescriptionPlaceholder.value = true;
    }

    // تحديث حالة الخطأ
    if (hasUserTypedInDescription.value) {
      isDescriptionError.value = isEditorEmpty.value;
    } else {
      isDescriptionError.value = false;
    }
  }

  bool get isDescriptionEmpty {
    return isEditorEmpty.value;
  }

  bool get isValidDescription {
    if (!hasUserTypedInDescription.value) return false;
    return !isDescriptionError.value;
  }

  bool validateDescriptionForm() {
    _checkDescriptionContent();
    return isValidDescription;
  }

  void resetDescription() {
    quillController.document = Document();
    hasUserTypedInDescription.value = false;
    isEditorEmpty.value = true;
    showDescriptionPlaceholder.value = true;
    isDescriptionError.value = false;
    serviceDescriptionPlainText.value = '';
    update(['description_field']);
  }

  void setDescription(String? description) {
    if (description != null && description.trim().isNotEmpty) {
      try {
        quillController.document = Document()..insert(0, description);
        hasUserTypedInDescription.value = true;
        isEditorEmpty.value = false;
        showDescriptionPlaceholder.value = false;
        isDescriptionError.value = false;
      } catch (e) {
        print('❌ خطأ في تحميل الوصف: $e');
        resetDescription();
      }
    } else {
      resetDescription();
    }
    update(['description_field']);
  }

  bool get allPoliciesAccepted {
    return acceptedTerms.value && acceptedPrivacy.value;
  }

  void updateTermsAcceptance(bool value) {
    acceptedTerms.value = value;
    update(['terms_section']);
  }

  void updatePrivacyAcceptance(bool value) {
    acceptedPrivacy.value = value;
    update(['privacy_section']);
  }

  bool validatePoliciesForm() {
    final bool allAccepted = acceptedTerms.value && acceptedPrivacy.value;

    if (!allAccepted) {
      Get.snackbar(
        'تنبيه',
        'يجب الموافقة على جميع السياسات والشروط قبل المتابعة',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );

      if (!acceptedTerms.value) {
        Get.snackbar(
          'شروط الخدمة',
          'يجب الموافقة على شروط الخدمة',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }

      if (!acceptedPrivacy.value) {
        Get.snackbar(
          'سياسة الخصوصية',
          'يجب الموافقة على سياسة الخصوصية',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }

    return allAccepted;
  }

  bool validateServiceForm() {
    bool isValid = true;

    if (serviceTitle.value.isEmpty) {
      isServiceTitleError.value = true;
      isValid = false;
    }

    if (selectedMainCategory.value.isEmpty) {
      isMainCategoryError.value = true;
      isValid = false;
    }

    if (selectedCategory.value.isEmpty || selectedCategoryId.value == 0) {
      isCategoryError.value = true;
      isValid = false;
    }

    update(['service_title_field', 'main_category_field', 'category_field']);
    return isValid;
  }

  bool validatePriceForm() {
    bool isValid = true;

    if (price.value.isEmpty) {
      isPriceError.value = true;
      isValid = false;
    }

    if (executionTimeValue.value.isEmpty) {
      isExecutionTimeError.value = true;
      isValid = false;
    }

    update(['price_field', 'execution_time_field']);
    return isValid;
  }

  bool validateImagesForm() {
    return serviceImages.isNotEmpty;
  }

  bool validateAllForms() {
    return validateServiceForm() &&
        validatePriceForm() &&
        validateImagesForm() &&
        validateDescriptionForm() &&
        validatePoliciesForm();
  }

  void toggleServiceSelection(String serviceId) {
    if (_selectedServiceIds.contains(serviceId)) {
      _selectedServiceIds.remove(serviceId);
    } else {
      _selectedServiceIds.add(serviceId);
    }

    if (_selectedServiceIds.isEmpty) {
      _isSelectionMode.value = false;
    }
  }

  String getFullImageUrl(String imagePath) {
    if (imagePath.isEmpty) {
      return '';
    }

    if (imagePath.startsWith('http')) {
      return imagePath;
    }

    String baseUrl = ApiHelper.getBaseUrl();

    if (imagePath.startsWith('storage/')) {
      return '$baseUrl/$imagePath';
    } else if (imagePath.startsWith('images/')) {
      return '$baseUrl/storage/$imagePath';
    } else {
      return '$baseUrl/storage/$imagePath';
    }
  }

  void toggleSelectionMode() {
    _isSelectionMode.value = !_isSelectionMode.value;
    if (!_isSelectionMode.value) {
      _selectedServiceIds.clear();
    }
  }

  void clearSelection() {
    _selectedServiceIds.clear();
    _isSelectionMode.value = false;
  }

  void selectAllServices(List<String> allServiceIds) {
    _selectedServiceIds.assignAll(allServiceIds);
    if (allServiceIds.isNotEmpty) {
      _isSelectionMode.value = true;
    }
  }

  void goToNextStep() {
    if (currentStep.value < 4) {
      currentStep.value++;
    }
  }

  void goToPreviousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    }
  }

  void goToStep(int step) {
    if (step >= 0 && step <= 4) {
      currentStep.value = step;
    }
  }

  bool canGoToNextStep() {
    switch (currentStep.value) {
      case 0:
        return validateServiceForm();
      case 1:
        return validatePriceForm();
      case 2:
        return validateImagesForm();
      case 3:
        return validateDescriptionForm();
      case 4:
        return validatePoliciesForm();
      default:
        return false;
    }
  }

  Future<void> navigateToNextStep() async {
    if (canGoToNextStep()) {
      if (currentStep.value < 4) {
        goToNextStep();
      } else {
        await saveService();
      }
    }
  }

  void validateServiceTitle(String value) {
    serviceTitle.value = value.trim();
    isServiceTitleError.value = serviceTitle.value.isEmpty;
    update(['service_title_field']);
  }

  void selectMainCategory(String category, int sectionId) {
    selectedMainCategory.value = category;
    selectedSectionId.value = sectionId;
    isMainCategoryError.value = false;

    loadCategories();

    update(['main_category_field', 'category_field']);
  }

  void searchCategories(String query) {
    searchCategoryQuery.value = query.trim();
    update(['categories_list']);
  }

  void selectTempCategory(int categoryId, String categoryName) {
    tempSelectedCategoryId.value = categoryId;
    tempSelectedCategory.value = categoryName;
    update(['categories_list']);
  }

  void saveSelectedCategory() {
    if (tempSelectedCategory.value.isNotEmpty &&
        tempSelectedCategoryId.value > 0) {
      selectedCategory.value = tempSelectedCategory.value;
      selectedCategoryId.value = tempSelectedCategoryId.value;
      isCategoryError.value = false;
      update(['category_field']);
    }
  }

  void addSpecialization() {
    final text = specializationTextController.text.trim();

    if (text.isEmpty) return;
    if (specializations.contains(text)) return;
    if (specializations.length >= maxSpecializations) return;

    specializations.add(text);
    specializationTextController.clear();
    update(['specializations_list', 'specialization_input']);
  }

  void removeSpecialization(int index) {
    if (index >= 0 && index < specializations.length) {
      specializations.removeAt(index);
      update(['specializations_list']);
    }
  }

  void addKeyword() {
    final text = keywordTextController.text.trim();

    if (text.isEmpty) return;
    if (keywords.contains(text)) return;
    if (keywords.length >= maxKeywords) return;

    keywords.add(text);
    keywordTextController.clear();
    update(['keywords_list', 'keyword_input']);
  }

  void removeKeyword(int index) {
    if (index >= 0 && index < keywords.length) {
      keywords.removeAt(index);
      update(['keywords_list']);
    }
  }

  void validatePrice(String value) {
    price.value = value.trim();
    isPriceError.value = price.value.isEmpty;
    update(['price_field']);
  }

  void updateExecutionTimeValue(String value) {
    executionTimeValue.value = value.trim();
    isExecutionTimeError.value = executionTimeValue.value.isEmpty;
    update(['execution_time_field']);
  }

  void selectTimeUnit(String unit) {
    executionTimeUnit.value = unit;
    update(['execution_time_field']);
  }

  void updateDevelopmentTitle(String text) {
    developmentTitle.value = text.trim();
    update(['development_form']);
  }

  void updateDevelopmentPrice(String text) {
    developmentPrice.value = text.trim();
    update(['development_form']);
  }

  void updateDevelopmentTimeValue(String text) {
    developmentTimeValue.value = text.trim();
    update(['development_form']);
  }

  void selectDevelopmentTimeUnit(String unit) {
    developmentTimeUnit.value = unit;
    update(['development_form']);
  }

  void addDevelopment() {
    final title = developmentTitle.value.trim();
    final priceText = developmentPrice.value.trim();
    final timeValue = developmentTimeValue.value.trim();
    final timeUnit = developmentTimeUnit.value;

    if (title.isEmpty || priceText.isEmpty || timeValue.isEmpty) return;

    final price = double.tryParse(priceText) ?? 0.0;
    final executionTime = int.tryParse(timeValue) ?? 0;

    if (price <= 0 || executionTime <= 0) return;

    final newDevelopment = Development(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      price: price,
      executionTime: executionTime,
      timeUnit: timeUnit,
    );

    developments.add(newDevelopment);

    developmentTitle.value = '';
    developmentPrice.value = '';
    developmentTimeValue.value = '';
    developmentTimeUnit.value = 'ساعة';

    update(['developments_list', 'development_form']);
  }

  void removeDevelopment(int id) {
    developments.removeWhere((dev) => dev.id == id);
    update(['developments_list']);
  }

  void addFAQ(String question, String answer) {
    if (faqs.length >= maxFAQs) return;

    final newFAQ = FAQ(
      id: DateTime.now().millisecondsSinceEpoch,
      question: question.trim(),
      answer: answer.trim(),
    );

    faqs.add(newFAQ);
    update(['faqs_list']);
  }

  void updateFAQ(int id, String newQuestion, String newAnswer) {
    final index = faqs.indexWhere((faq) => faq.id == id);
    if (index != -1) {
      faqs[index] = FAQ(
        id: id,
        question: newQuestion.trim(),
        answer: newAnswer.trim(),
      );
      update(['faqs_list']);
    }
  }

  void removeFAQ(int id) {
    faqs.removeWhere((faq) => faq.id == id);
    update(['faqs_list']);
  }

  void addImagesFromMediaLibrary(List<MediaItem> mediaItems) {
    final List<ServiceImage> newImages = [];

    for (var mediaItem in mediaItems) {
      if (serviceImages.length >= maxImages) {
        Get.snackbar(
          'تنبيه',
          'لا يمكن إضافة أكثر من $maxImages صور',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        break;
      }

      try {
        final isDuplicate = serviceImages.any((img) => img.url == mediaItem.path);
        if (isDuplicate) continue;

        final isNetworkUrl = mediaItem.path.startsWith('http');
        final serviceImage = ServiceImage(
          id: DateTime.now().millisecondsSinceEpoch,
          url: mediaItem.path,
          isMain: serviceImages.isEmpty,
          isLocalFile: !isNetworkUrl,
          file: !isNetworkUrl ? File(mediaItem.path) : null,
        );

        newImages.add(serviceImage);
      } catch (e) {
        print('خطأ في إضافة الصورة: $e');
      }
    }

    if (newImages.isNotEmpty) {
      serviceImages.addAll(newImages);
      update(['images_list']);
    }
  }

  void removeImage(int id) {
    final imageIndex = serviceImages.indexWhere((img) => img.id == id);
    if (imageIndex != -1) {
      final wasMain = serviceImages[imageIndex].isMain;
      serviceImages.removeAt(imageIndex);

      if (wasMain && serviceImages.isNotEmpty) {
        serviceImages[0] = serviceImages[0].copyWith(isMain: true);
      }

      update(['images_list']);
    }
  }

  void setMainImage(int id) {
    final updatedImages = serviceImages.map((image) {
      return image.copyWith(isMain: image.id == id);
    }).toList();

    serviceImages.assignAll(updatedImages);
    update(['images_list']);
  }

  void reorderImages(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= serviceImages.length) return;
    if (newIndex < 0) newIndex = 0;
    if (newIndex >= serviceImages.length) newIndex = serviceImages.length - 1;

    final List<ServiceImage> updatedList = List<ServiceImage>.from(serviceImages);
    final ServiceImage item = updatedList.removeAt(oldIndex);

    if (oldIndex < newIndex) {
      updatedList.insert(newIndex - 1, item);
    } else {
      updatedList.insert(newIndex, item);
    }

    serviceImages.assignAll(updatedList);
    update(['images_list']);
  }

  Future<void> loadSections() async {
    try {
      isLoadingCategories(true);
      categoriesError('');

      final response = await ApiHelper.get(
        path: '/merchants/sections',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final sectionsList = List<Map<String, dynamic>>.from(
          response['data'] ?? [],
        );
        sections.assignAll(sectionsList);
      } else {
        final errorMsg = response?['message'] ?? 'فشل في تحميل الأقسام';
        categoriesError(errorMsg);
      }
    } catch (e) {
      final error = 'حدث خطأ أثناء تحميل الأقسام: $e';
      categoriesError(error);
    } finally {
      isLoadingCategories(false);
    }
  }

  Future<void> loadCategories() async {
    try {
      if (selectedSectionId.value == 0) {
        categories.clear();
        return;
      }

      isLoadingCategories(true);
      categoriesError('');

      final response = await ApiHelper.get(
        path: '/merchants/categories/select',
        queryParameters: {'section_id': selectedSectionId.value},
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final categoriesList = List<Map<String, dynamic>>.from(
          response['categories'] ?? [],
        );
        categories.assignAll(categoriesList);

        update(['categories_list', 'category_field']);
      } else {
        final errorMsg = response?['message'] ?? 'فشل في تحميل الفئات';
        categoriesError(errorMsg);
      }
    } catch (e) {
      final error = 'حدث خطأ أثناء تحميل الفئات: $e';
      categoriesError(error);
    } finally {
      isLoadingCategories(false);
    }
  }

  List<Map<String, dynamic>> get filteredCategories {
    final List<Map<String, dynamic>> filtered = [];

    for (var category in categories) {
      final categoryName = (category['name'] ?? '').toString();
      if (searchCategoryQuery.value.isEmpty ||
          categoryName.toLowerCase().contains(
            searchCategoryQuery.value.toLowerCase(),
          )) {
        filtered.add(category);
      }
    }

    return filtered;
  }

  bool get canAddSpecialization {
    final text = specializationTextController.text.trim();
    if (text.isEmpty) return false;
    if (specializations.contains(text)) return false;
    if (specializations.length >= maxSpecializations) return false;
    return true;
  }

  bool get canAddKeyword {
    final text = keywordTextController.text.trim();
    if (text.isEmpty) return false;
    if (keywords.contains(text)) return false;
    if (keywords.length >= maxKeywords) return false;
    return true;
  }

  bool get canAddDevelopment {
    final title = developmentTitle.value.trim();
    final priceText = developmentPrice.value.trim();
    final timeValue = developmentTimeValue.value.trim();

    return title.isNotEmpty &&
        priceText.isNotEmpty &&
        timeValue.isNotEmpty &&
        (double.tryParse(priceText) ?? 0) > 0 &&
        (int.tryParse(timeValue) ?? 0) > 0;
  }

  bool get canAddFAQ {
    return faqs.length < maxFAQs;
  }

  Color get specializationsButtonColor {
    if (!canAddSpecialization) return Colors.grey[300]!;
    return AppColors.primary400;
  }

  Color get keywordsButtonColor {
    if (!canAddKeyword) return Colors.grey[300]!;
    return AppColors.primary400;
  }

  Color get developmentButtonColor {
    if (!canAddDevelopment) return Colors.grey[300]!;
    return AppColors.primary400;
  }

  Color get faqButtonColor {
    if (!canAddFAQ) return Colors.grey[300]!;
    return AppColors.primary400;
  }

  String get specializationTooltip {
    final text = specializationTextController.text.trim();
    if (text.isEmpty) return 'اكتب تخصصاً لإضافته';
    if (specializations.contains(text)) return 'هذا التخصص موجود بالفعل';
    if (specializations.length >= maxSpecializations)
      return 'تم الوصول للحد الأقصى';
    return 'إضافة "${text}" إلى التخصصات';
  }

  String get keywordTooltip {
    final text = keywordTextController.text.trim();
    if (text.isEmpty) return 'اكتب كلمة مفتاحية لإضافتها';
    if (keywords.contains(text)) return 'هذه الكلمة موجودة بالفعل';
    if (keywords.length >= maxKeywords) return 'تم الوصول للحد الأقصى';
    return 'إضافة "${text}" إلى الكلمات المفتاحية';
  }

  String get developmentTooltip {
    if (!canAddDevelopment) return 'املأ جميع الحقول المطلوبة';
    return 'إضافة التطوير الجديد';
  }

  String get faqTooltip {
    if (!canAddFAQ) return 'تم الوصول للحد الأقصى (5 أسئلة)';
    return 'إضافة سؤال شائع جديد';
  }

  Map<String, dynamic> getAllData() {
    return {
      'serviceTitle': serviceTitle.value,
      'mainCategory': selectedMainCategory.value,
      'mainCategoryId': selectedSectionId.value,
      'category': selectedCategory.value,
      'categoryId': selectedCategoryId.value,
      'specializations': specializations.toList(),
      'keywords': keywords.toList(),
      'description': {
        'richText': getQuillContentAsJson(),
        'plainText': serviceDescriptionPlainText.value,
      },
      'faqs': faqs.map((faq) => faq.toJson()).toList(),
      'price': price.value,
      'executionTime': {
        'value': executionTimeValue.value,
        'unit': executionTimeUnit.value,
      },
      'developments': developments.map((dev) => dev.toJson()).toList(),
      'images': serviceImages
          .map((img) => ({'id': img.id, 'url': img.url, 'isMain': img.isMain}))
          .toList(),
      'imagesCount': serviceImages.length,
      'policies': {
        'acceptedTerms': acceptedTerms.value,
        'acceptedPrivacy': acceptedPrivacy.value,
      },
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  String getQuillContentAsJson() {
    try {
      return jsonEncode(quillController.document.toDelta().toJson());
    } catch (e) {
      print('❌ خطأ في تحويل محتوى Quill إلى JSON: $e');
      return '[]';
    }
  }

  void resetAll() {
    currentStep.value = 0;
    serviceTitle.value = '';
    selectedMainCategory.value = '';
    selectedCategory.value = '';
    selectedSectionId.value = 0;
    selectedCategoryId.value = 0;
    specializations.clear();
    keywords.clear();

    resetDescription();

    faqs.clear();
    price.value = '';
    executionTimeValue.value = '';
    executionTimeUnit.value = 'ساعة';
    developments.clear();
    serviceImages.clear();
    developmentTitle.value = '';
    developmentPrice.value = '';
    developmentTimeValue.value = '';
    developmentTimeUnit.value = 'ساعة';
    tempSelectedCategory.value = '';
    tempSelectedCategoryId.value = 0;
    searchCategoryQuery.value = '';
    isServiceTitleError.value = false;
    isMainCategoryError.value = false;
    isCategoryError.value = false;
    isPriceError.value = false;
    isExecutionTimeError.value = false;
    specializationTextController.clear();
    keywordTextController.clear();

    serviceId.value = '';
    serviceSlug.value = '';
    serviceStatus.value = 'pending';
    uploadedImages.clear();

    categories.clear();

    acceptedTerms.value = false;
    acceptedPrivacy.value = false;

    update();
  }

  Future<Map<String, dynamic>?> addService() async {
    try {
      isSaving.value = true;
      update();

      // التحقق من الوصف إذا كان المستخدم قد كتب فيه
      if (hasUserTypedInDescription.value && !validateDescriptionForm()) {
        Get.snackbar(
          'خطأ',
          'الرجاء إضافة وصف مفصل للخدمة',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isSaving.value = false;
        update();
        return null;
      }

      if (!validateAllForms()) {
        Get.snackbar(
          'خطأ',
          'يرجى ملء جميع الحقول المطلوبة',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isSaving.value = false;
        update();
        return null;
      }

      await _uploadServiceImages();

      final serviceData = _prepareServiceData();

      final response = await ApiHelper.post(
        path: '/merchants/services',
        body: serviceData,
        withLoading: false,
        shouldShowMessage: true,
      );

      if (response != null && response['status'] == true) {
        final data = response['data'] ?? {};
        serviceId.value = data['id']?.toString() ?? '';
        serviceSlug.value = data['slug'] ?? '';

        Get.snackbar(
          'نجاح',
          'تم إضافة الخدمة بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        isSaving.value = false;
        update();

        return {
          'success': true,
          'message': 'تم إضافة الخدمة بنجاح',
          'data': data,
          'service_id': serviceId.value,
        };
      } else {
        throw Exception(response?['message'] ?? 'فشل في إضافة الخدمة');
      }
    } catch (e) {
      isSaving.value = false;
      update();

      Get.snackbar(
        'خطأ',
        'فشل في إضافة الخدمة: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> updateService(String serviceId) async {
    try {
      isSaving.value = true;
      update();

      // التحقق من الوصف إذا كان المستخدم قد كتب فيه
      if (hasUserTypedInDescription.value && !validateDescriptionForm()) {
        Get.snackbar(
          'خطأ',
          'الرجاء إضافة وصف مفصل للخدمة',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isSaving.value = false;
        update();
        return null;
      }

      if (!validateAllForms()) {
        Get.snackbar(
          'خطأ',
          'يرجى ملء جميع الحقول المطلوبة',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isSaving.value = false;
        update();
        return null;
      }

      await _uploadServiceImages();

      final serviceData = _prepareServiceData(forUpdate: true);

      final response = await ApiHelper.put(
        path: '/merchants/services/$serviceId',
        body: serviceData,
        withLoading: false,
        shouldShowMessage: true,
      );

      if (response != null && response['status'] == true) {
        Get.snackbar(
          'نجاح',
          'تم تحديث الخدمة بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        isSaving.value = false;
        update();

        return {
          'success': true,
          'message': 'تم تحديث الخدمة بنجاح',
          'data': response['data'],
        };
      } else {
        throw Exception(response?['message'] ?? 'فشل في تحديث الخدمة');
      }
    } catch (e) {
      isSaving.value = false;
      update();

      Get.snackbar(
        'خطأ',
        'فشل في تحديث الخدمة: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> deleteService(String serviceId) async {
    try {
      isLoading.value = true;
      update();

      final response = await ApiHelper.delete(
        path: '/merchants/services/$serviceId',
        withLoading: false,
        shouldShowMessage: true,
      );

      if (response != null && response['status'] == true) {
        Get.snackbar(
          'نجاح',
          'تم حذف الخدمة بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        isLoading.value = false;
        update();

        return {
          'success': true,
          'message': 'تم حذف الخدمة بنجاح',
          'data': response['data'],
        };
      } else {
        throw Exception(response?['message'] ?? 'فشل في حذف الخدمة');
      }
    } catch (e) {
      isLoading.value = false;
      update();

      Get.snackbar(
        'خطأ',
        'فشل في حذف الخدمة: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  Future<Service?> getServiceById(String serviceId) async {
    try {
      isLoading.value = true;
      update();

      final response = await ApiHelper.get(
        path: '/merchants/services/$serviceId',
        withLoading: false,
        shouldShowMessage: false,
      );

      if (response != null && response['status'] == true) {
        final data = response['data'] ?? {};
        final service = Service.fromApiJson(data);

        _updateControllerFromService(service);

        isLoading.value = false;
        update();

        return service;
      } else {
        throw Exception(response?['message'] ?? 'فشل في جلب الخدمة');
      }
    } catch (e) {
      isLoading.value = false;
      update();

      Get.snackbar(
        'خطأ',
        'فشل في جلب الخدمة: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return null;
    }
  }

  Future<List<Service>> getAllServices({
    int page = 1,
    int limit = 20,
    String? status,
    int? sectionId,
    int? categoryId,
  }) async {
    try {
      isLoading.value = true;
      update();

      final Map<String, dynamic> queryParams = {'page': page, 'limit': limit};

      if (status != null) queryParams['status'] = status;

      final response = await ApiHelper.get(
        path: '/merchants/services',
        queryParameters: queryParams,
        withLoading: false,
        shouldShowMessage: false,
      );
      if (response != null && response['status'] == true) {

        final data = response['data'] ?? [];

        final services = (data as List<dynamic>)
            .map((item) => Service.fromApiJson(item))
            .toList();

        isLoading.value = false;
        update();

        return services;
      } else {
        throw Exception(response?['message'] ?? 'فشل في جلب الخدمات');
      }
    } catch (e) {
      isLoading.value = false;
      update();

      Get.snackbar(
        'خطأ',
        'فشل في جلب الخدمات: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );

      return [];
    }
  }

  String _extractRelativePath(String fullUrl) {
    try {
      if (fullUrl.contains('/storage/')) {
        return fullUrl.split('/storage/')[1];
      }
      if (fullUrl.contains('images/')) {
        return fullUrl.substring(fullUrl.indexOf('images/'));
      }
      return fullUrl;
    } catch (e) {
      print('❌ خطأ في استخراج المسار النسبي من $fullUrl: $e');
      return fullUrl;
    }
  }

  Future<void> _uploadServiceImages() async {
    try {
      isUploading.value = true;
      uploadedImages.clear();

      for (final image in serviceImages) {
        if (image.isLocalFile && image.file != null) {
          final response = await ApiHelper.uploadMedia(
            file: image.file!,
            type: 'service',
            withLoading: false,
          );

          if (response != null && response['status'] == true) {
            final imagePath = response['data']?['path'] ?? '';
            if (imagePath.isNotEmpty) {
              final relativePath = _extractRelativePath(imagePath);
              uploadedImages.add(relativePath);
            }
          }
        } else if (image.url.isNotEmpty) {
          final relativePath = _extractRelativePath(image.url);
          uploadedImages.add(relativePath);
        }
      }

      if (uploadedImages.isEmpty) {
        throw Exception('لم يتم رفع أي صورة بنجاح');
      }
    } catch (e) {
      print('❌ خطأ في رفع الصور: $e');
      throw Exception('فشل في رفع الصور: $e');
    } finally {
      isUploading.value = false;
    }
  }

  Map<String, dynamic> _prepareServiceData({bool forUpdate = false}) {
    final slug = _generateSlug(serviceTitle.value);

    final MyAppController myAppController = Get.find<MyAppController>();
    final storeId = myAppController.userData['store_id']?.toString();

    final apiTimeUnit = _convertTimeUnitToApi(executionTimeUnit.value);

    final extras = developments.map((dev) {
      return {
        'title': dev.title,
        'price': dev.price,
        'execute_count': dev.executionTime,
        'execute_type': _convertTimeUnitToApi(dev.timeUnit),
      };
    }).toList();

    final questions = faqs.map((faq) {
      return {'question': faq.question, 'answer': faq.answer};
    }).toList();

    final List<String> imagesToSend = uploadedImages.isNotEmpty
        ? uploadedImages
        : serviceImages
        .map((img) {
      return _extractRelativePath(img.url);
    })
        .where((url) => url.isNotEmpty)
        .toList();

    final serviceData = {
      'slug': slug,
      'title': serviceTitle.value,
      'section_id': selectedSectionId.value,
      'category_id': selectedCategoryId.value,
      'specialties': specializations.toList(),
      'tags': keywords.toList(),
      'status': serviceStatus.value,
      'price': double.tryParse(price.value) ?? 0.0,
      'execute_type': apiTimeUnit,
      'execute_count': int.tryParse(executionTimeValue.value) ?? 0,
      'extras': extras,
      'images': imagesToSend,
      'description': serviceDescriptionPlainText.value,
      'questions': questions,
      'accepted_terms': acceptedTerms.value,
      'accepted_privacy': acceptedPrivacy.value,
    };

    if (!forUpdate && storeId != null && storeId.isNotEmpty) {
      serviceData['store_id'] = storeId;
    }

    return serviceData;
  }

  void _updateControllerFromService(Service service) {
    serviceId.value = service.id.toString() ?? '';
    serviceSlug.value = service.slug;
    serviceTitle.value = service.title;
    selectedSectionId.value = service.sectionId;
    selectedCategoryId.value = service.categoryId;
    specializations.assignAll(service.specialties);
    keywords.assignAll(service.tags);
    serviceStatus.value = service.status;
    price.value = service.price.toString();

    executionTimeValue.value = service.executeCount.toString();
    executionTimeUnit.value = _convertTimeUnitFromApi(service.executeType);

    developments.assignAll(service.extras);

    faqs.assignAll(service.questions);

    // تحميل الوصف
    setDescription(service.description);

    serviceImages.clear();
    for (int i = 0; i < service.images.length; i++) {
      final imageUrl = service.images[i];
      serviceImages.add(ServiceImage(
        id: service.id??0,
        url: imageUrl,
        isMain: i == 0,
        isLocalFile: false,
        file: null,
      ));
    }

    acceptedTerms.value = service.acceptedTerms;
    acceptedPrivacy.value = service.acceptedPrivacy;

    _loadCategoryAndSectionNames(service.sectionId, service.categoryId);
  }

  Future<void> _loadCategoryAndSectionNames(
      int sectionId,
      int categoryId,
      ) async {
    try {
      if (sections.isEmpty) {
        await loadSections();
      }

      final section = sections.firstWhere(
            (s) => (s['id'] as int?) == sectionId,
        orElse: () => {'name': ''},
      );
      selectedMainCategory.value = section['name']?.toString() ?? '';
      selectedSectionId.value = sectionId;

      if (selectedSectionId.value > 0) {
        await loadCategories();

        final category = categories.firstWhere(
              (c) => (c['id'] as int?) == categoryId,
          orElse: () => {'name': ''},
        );
        selectedCategory.value = category['name']?.toString() ?? '';
        selectedCategoryId.value = categoryId;
      }
    } catch (e) {
      print('❌ خطأ في تحميل أسماء القسم والفئة: $e');
    }
  }

  String _convertTimeUnitToApi(String timeUnit) {
    final Map<String, String> mapping = {
      'دقيقة': 'min',
      'ساعة': 'hour',
      'يوم': 'day',
      'أسبوع': 'week',
      'شهر': 'month',
      'سنة': 'year',
    };
    return mapping[timeUnit] ?? 'hour';
  }

  String _convertTimeUnitFromApi(String apiTimeUnit) {
    final Map<String, String> mapping = {
      'min': 'دقيقة',
      'hour': 'ساعة',
      'day': 'يوم',
      'week': 'أسبوع',
      'month': 'شهر',
      'year': 'سنة',
    };
    return mapping[apiTimeUnit] ?? 'ساعة';
  }

  String _generateSlug(String title) {
    String slug = title
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .replaceAll(RegExp(r'[\s_-]+'), '-')
        .replaceAll(RegExp(r'^-+|-+$'), '');

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return '$slug-$timestamp';
  }

  Future<Map<String, dynamic>?> saveService() async {
    // التحقق النهائي من جميع السياسات
    if (!allPoliciesAccepted) {
      Get.snackbar(
        'خطأ',
        'يجب الموافقة على جميع السياسات قبل نشر الخدمة',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      return null;
    }

    if (serviceId.value.isNotEmpty) {
      return await updateService(serviceId.value);
    } else {
      return await addService();
    }
  }

  Future<void> loadServiceForEditing(String id) async {
    try {
      final service = await getServiceById(id);
      if (service != null) {
        serviceId.value = id;
        Get.snackbar(
          'تم التحميل',
          'تم تحميل بيانات الخدمة للتعديل',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'فشل في تحميل الخدمة: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> deleteCurrentService() async {
    if (serviceId.value.isEmpty) {
      Get.snackbar(
        'خطأ',
        'لا توجد خدمة محددة للحذف',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final confirm = await Get.defaultDialog<bool>(
      title: 'تأكيد الحذف',
      middleText: 'هل أنت متأكد من حذف هذه الخدمة؟',
      textConfirm: 'نعم، احذف',
      textCancel: 'إلغاء',
      confirmTextColor: Colors.white,
      onConfirm: () async {
        final result = await deleteService(serviceId.value);
        if (result?['success'] == true) {
          resetAll();
          Get.back(result: true);
        }
      },
      onCancel: () => Get.back(result: false),
    );

    if (confirm == true) {
      Get.back();
    }
  }

  void setEditMode(String id, String title) {
    serviceId.value = id;
    serviceTitle.value = title;
    Get.snackbar(
      'وضع التعديل',
      'أنت الآن تقوم بتعديل الخدمة: $title',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }

  void setCreateMode() {
    serviceId.value = '';
    resetAll();
    Get.snackbar(
      'وضع الإنشاء',
      'أنت الآن تقوم بإنشاء خدمة جديدة',
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  bool get isInEditMode => serviceId.value.isNotEmpty;

  String get currentServiceId => serviceId.value;

  String get currentServiceTitle => serviceTitle.value;

  void setServiceStatus(String status) {
    if (['pending', 'draft', 'rejected', 'active'].contains(status)) {
      serviceStatus.value = status;
    }
  }

  @override
  void onClose() {
    specializationTextController.dispose();
    keywordTextController.dispose();
    quillController.dispose();
    editorFocusNode.dispose();
    editorScrollController.dispose();
    super.onClose();
  }
}