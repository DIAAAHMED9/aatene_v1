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
    print('🔧 تهيئة محرر Quill...');

    // بدء المحرر بمستند فارغ
    quillController = QuillController(
      document: Document(),
      selection: const TextSelection.collapsed(offset: 0),
    );

    // إضافة مستمع لـ FocusNode أولاً
    editorFocusNode.addListener(() {
      if (editorFocusNode.hasFocus) {
        print('🎯 التركيز على محرر الوصف');

        // عندما يلمس المستخدم المحرر، نعتبر أنه بدأ الكتابة
        if (!hasUserTypedInDescription.value) {
          hasUserTypedInDescription.value = true;
          showDescriptionPlaceholder.value = false;
          print('👆 المستخدم لمس المحرر - تشغيل وضع الكتابة');
          update(['description_field']);
        }
      } else {
        // عندما يترك التركيز، تحقق من المحتوى النهائي
        final plainText = quillController.document.toPlainText();
        final hasRealContent = _hasRealContent(plainText);

        if (hasUserTypedInDescription.value && !hasRealContent) {
          isDescriptionError.value = true;
          print('⚠️ ترك المستخدم المحرر دون إدخال محتوى');
          update(['description_field']);
        }
      }
    });

    // مستمع لتغييرات المحتوى - يتم بعد إعداد FocusNode
    quillController.document.changes.listen((event) {
      try {
        final plainText = quillController.document.toPlainText();
        final trimmedText = plainText.trim();

        serviceDescriptionPlainText.value = plainText;
        serviceDescriptionRichText.value = getQuillContentAsJson();

        // التحقق من المحتوى الفعلي
        final hasRealContent = _hasRealContent(plainText);
        isEditorEmpty.value = !hasRealContent;

        // تسجيل التغيير للمساعدة في التنقيح
        print('✍️ تغيير في محتوى الوصف:');
        print('- النص الكامل: "$plainText"');
        print('- النص بعد trim: "$trimmedText"');
        print('- طول النص: ${plainText.length}');
        print('- hasRealContent: $hasRealContent');
        print('- isEditorEmpty: ${isEditorEmpty.value}');
        print('- hasUserTypedInDescription: ${hasUserTypedInDescription.value}');

        // إذا كان هناك محتوى حقيقي، فقد كتب المستخدم
        if (hasRealContent) {
          hasUserTypedInDescription.value = true;
          showDescriptionPlaceholder.value = false;

          print('✅ تم اكتشاف كتابة المستخدم في الوصف');
          print('📝 المحتوى المكتوب: "$plainText"');

          // إزالة الخطأ إذا كان هناك محتوى
          isDescriptionError.value = false;
        } else {
          // إذا لم يكن هناك محتوى حقيقي ولكن المستخدم بدأ الكتابة
          showDescriptionPlaceholder.value = !hasUserTypedInDescription.value;
        }

        // تحديث حالة الخطأ - فقط إذا بدأ المستخدم الكتابة
        if (hasUserTypedInDescription.value) {
          isDescriptionError.value = isEditorEmpty.value;
        } else {
          isDescriptionError.value = false;
        }

        print('- isDescriptionError: ${isDescriptionError.value}');
        print('- showDescriptionPlaceholder: ${showDescriptionPlaceholder.value}');

        // تحديث الواجهة
        update(['description_field']);
      } catch (e) {
        print('❌ خطأ في مستمع تغييرات Quill: $e');
      }
    });
  }

  // دالة مساعدة للتحقق من المحتوى الفعلي
  bool _hasRealContent(String text) {
    if (text.isEmpty) return false;

    // إزالة المسافات البيضاء والأسطر الجديدة
    final trimmed = text.trim();

    // تحقق من أن النص ليس مجرد مسافات أو أسطر جديدة
    if (trimmed.isEmpty) return false;

    // تحقق من أن النص ليس مجرد أحرف غير مرئية
    if (trimmed == '\n' ||
        trimmed == '\r\n' ||
        trimmed == '\n\n' ||
        trimmed == '\r\n\r\n') {
      return false;
    }

    // تحقق من أن هناك أحرف حقيقية (أكبر من ASCII 32 = مسافة)
    final hasRealChars = trimmed.codeUnits.any((unit) {
      return unit > 32; // ASCII codes above space
    });

    return hasRealChars;
  }

  // دالة للتحقق من المحتوى المباشر
  void checkDescriptionContent() {
    try {
      final plainText = quillController.document.toPlainText();
      final hasRealContent = _hasRealContent(plainText);

      print('🔍 التحقق المباشر من محتوى الوصف:');
      print('- النص الكامل: "$plainText"');
      print('- hasRealContent: $hasRealContent');
      print('- hasUserTypedInDescription: ${hasUserTypedInDescription.value}');
      print('- isEditorEmpty: ${isEditorEmpty.value}');

      if (hasRealContent) {
        hasUserTypedInDescription.value = true;
        showDescriptionPlaceholder.value = false;
        isDescriptionError.value = false;

        serviceDescriptionPlainText.value = plainText;
        serviceDescriptionRichText.value = getQuillContentAsJson();

        print('✅ تم العثور على محتوى حقيقي في الوصف');
      } else if (hasUserTypedInDescription.value) {
        // المستخدم لمس المحرر ولكن المحتوى غير صالح
        isDescriptionError.value = true;
        print('❌ المستخدم بدأ الكتابة لكن المحتوى غير صالح');
      }

      update(['description_field']);
    } catch (e) {
      print('❌ خطأ في checkDescriptionContent: $e');
    }
  }

  // دالة لفحص الوصف بشكل مفصل
  void debugDescription() {
    print('🔍 فحص الوصف المفصل:');
    print('- serviceDescriptionPlainText: "${serviceDescriptionPlainText.value}"');
    print('- serviceDescriptionPlainText length: ${serviceDescriptionPlainText.value.length}');
    print('- serviceDescriptionRichText length: ${serviceDescriptionRichText.value.length}');
    print('- hasUserTypedInDescription: ${hasUserTypedInDescription.value}');
    print('- isEditorEmpty: ${isEditorEmpty.value}');
    print('- isValidDescription: ${isValidDescription}');
    print('- isDescriptionError: ${isDescriptionError.value}');
  }

  // الحصول على النصوص الحالية من Quill مباشرة
  String get descriptionPlainText {
    return quillController.document.toPlainText();
  }

  String get descriptionRichText {
    return getQuillContentAsJson();
  }

  // تحديث نصوص الوصف من Quill
  void updateDescriptionTexts() {
    try {
      final plainText = quillController.document.toPlainText();
      serviceDescriptionPlainText.value = plainText;
      serviceDescriptionRichText.value = getQuillContentAsJson();

      // تسجيل التحديث للمساعدة في التنقيح
      print('🔄 تحديث نصوص الوصف:');
      print('- Plain text: "$plainText"');
      print('- Plain text length: ${plainText.length}');
      print('- Rich text length: ${serviceDescriptionRichText.value.length}');
    } catch (e) {
      print('❌ خطأ في updateDescriptionTexts: $e');
    }
  }

  bool get isDescriptionEmpty {
    return isEditorEmpty.value;
  }

  bool get isValidDescription {
    if (!hasUserTypedInDescription.value) return true; // لم يلمس المحرر بعد
    return !isDescriptionError.value;
  }

  bool get hasValidDescription {
    if (!hasUserTypedInDescription.value) return true; // لم يبدأ الكتابة بعد

    final plainText = serviceDescriptionPlainText.value.trim();
    return _hasRealContent(plainText);
  }

  bool validateDescriptionForm() {
    print('✅ بدء التحقق من صحة الوصف...');

    // التحقق المباشر من المحتوى أولاً
    checkDescriptionContent();

    // حالات خاصة للتحقق
    final plainText = serviceDescriptionPlainText.value;
    final hasRealContent = _hasRealContent(plainText);

    print('📝 حالة التحقق:');
    print('- plainText: "$plainText"');
    print('- hasRealContent: $hasRealContent');
    print('- hasUserTypedInDescription: ${hasUserTypedInDescription.value}');

    // الحالات:
    // 1. إذا لم يلمس المستخدم المحرر أصلاً => صالح (لا نطلب منه الوصف)
    if (!hasUserTypedInDescription.value) {
      print('📝 الحالة 1: المستخدم لم يلمس المحرر - صالح');
      isDescriptionError.value = false;
      return true;
    }

    // 2. إذا لمس المستخدم المحرر والمحتوى صالح => صالح
    if (hasUserTypedInDescription.value && hasRealContent) {
      print('📝 الحالة 2: المستخدم لمس المحرر والمحتوى صالح - صالح');
      isDescriptionError.value = false;
      return true;
    }

    // 3. إذا لمس المستخدم المحرر ولكن المحتوى غير صالح => خطأ
    if (hasUserTypedInDescription.value && !hasRealContent) {
      print('📝 الحالة 3: المستخدم لمس المحرر لكن المحتوى غير صالح - خطأ');
      isDescriptionError.value = true;
      return false;
    }

    // الحالة الافتراضية: صالح
    print('📝 الحالة الافتراضية: صالح');
    isDescriptionError.value = false;
    return true;
  }

  // التحقق النهائي للوصف قبل الإرسال
  Future<bool> validateAndPrepareDescription() async {
    print('🔍 التحقق النهائي للوصف قبل الإرسال...');

    // تحديث نصوص الوصف
    updateDescriptionTexts();

    // تسجيل البيانات
    debugDescription();

    // التحقق من صحة الوصف
    if (!validateDescriptionForm()) {
      print('❌ الوصف غير صالح');
      return false;
    }

    // التحقق من وجود محتوى فعلي إذا كان المستخدم قد بدأ الكتابة
    if (hasUserTypedInDescription.value) {
      final plainText = serviceDescriptionPlainText.value.trim();
      if (!_hasRealContent(plainText)) {
        print('❌ الوصف فارغ رغم أن المستخدم كتب فيه');
        return false;
      }
    }

    print('✅ الوصف صالح وجاهز للإرسال');
    print('📄 محتوى الوصف: "${serviceDescriptionPlainText.value}"');
    return true;
  }

  void resetDescription() {
    quillController.document = Document();
    hasUserTypedInDescription.value = false;
    isEditorEmpty.value = true;
    showDescriptionPlaceholder.value = true;
    isDescriptionError.value = false;
    serviceDescriptionPlainText.value = '';
    serviceDescriptionRichText.value = '';
    update(['description_field']);
  }

  void setDescription(String? description) {
    if (description != null && description.trim().isNotEmpty) {
      try {
        // محاولة تحميل كمحتوى Quill Delta
        if (description.trim().startsWith('[') || description.trim().startsWith('{')) {
          try {
            final delta = jsonDecode(description);
            quillController.document = Document.fromJson(delta);
          } catch (e) {
            // إذا فشل تحويل JSON، حمله كنص عادي
            quillController.document = Document()..insert(0, description);
          }
        } else {
          // تحميل كنص عادي
          quillController.document = Document()..insert(0, description);
        }

        hasUserTypedInDescription.value = true;
        isEditorEmpty.value = false;
        showDescriptionPlaceholder.value = false;
        isDescriptionError.value = false;

        // تحديث كلا النصين
        serviceDescriptionPlainText.value = quillController.document.toPlainText();
        serviceDescriptionRichText.value = getQuillContentAsJson();

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
    // تأكد من التحقق من الوصف بشكل صحيح
    validateDescriptionForm();

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
    // تحديث نصوص الوصف قبل الحصول على البيانات
    updateDescriptionTexts();

    return {
      'serviceTitle': serviceTitle.value,
      'mainCategory': selectedMainCategory.value,
      'mainCategoryId': selectedSectionId.value,
      'category': selectedCategory.value,
      'categoryId': selectedCategoryId.value,
      'specializations': specializations.toList(),
      'keywords': keywords.toList(),
      'description': {
        'richText': serviceDescriptionRichText.value,
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
      final json = jsonEncode(quillController.document.toDelta().toJson());
      print('📝 تحويل Quill إلى JSON: ${json.length} حرف');
      return json;
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

      print('🚀 بدء إضافة خدمة جديدة...');

      // التحقق النهائي للوصف
      if (!await validateAndPrepareDescription()) {
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

      // سجل البيانات المرسلة للمساعدة في التنقيح
      print('📦 البيانات المرسلة للخادم:');
      print(jsonEncode(serviceData));

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
        // سجل الخطأ بالتفصيل
        print('❌ خطأ من الخادم: ${response?['message']}');
        print('❌ تفاصيل الخطأ: ${response}');
        throw Exception(response?['message'] ?? 'فشل في إضافة الخدمة');
      }
    } catch (e) {
      isSaving.value = false;
      update();

      print('❌ استثناء في addService: $e');
      print('❌ تفاصيل الاستثناء: ${e.toString()}');

      Get.snackbar(
        'خطأ',
        'فشل في إضافة الخدمة: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );

      return {'success': false, 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>?> updateService(String serviceId) async {
    try {
      isSaving.value = true;
      update();

      print('🔄 بدء تحديث الخدمة $serviceId...');

      // التحقق النهائي للوصف
      if (!await validateAndPrepareDescription()) {
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

      // سجل البيانات المرسلة للمساعدة في التنقيح
      print('📦 البيانات المرسلة للخادم (تحديث):');
      print(jsonEncode(serviceData));

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
        print('❌ خطأ من الخادم (تحديث): ${response?['message']}');
        throw Exception(response?['message'] ?? 'فشل في تحديث الخدمة');
      }
    } catch (e) {
      isSaving.value = false;
      update();

      print('❌ استثناء في updateService: $e');

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
    // تأكد من تحديث نصوص الوصف قبل الإرسال
    updateDescriptionTexts();

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

    // الحصول على الوصف النصي (Plain text)
    String descriptionText = serviceDescriptionPlainText.value.trim();

    // سجل الوصف للمساعدة في التنقيح
    print('📝 وصف الخدمة للإرسال:');
    print('- النص العادي (${descriptionText.length} حرف): ${descriptionText.length > 100 ? descriptionText.substring(0, 100) + '...' : descriptionText}');

    // التحقق من وجود وصف إذا كان المستخدم قد بدأ الكتابة
    if (hasUserTypedInDescription.value && descriptionText.isEmpty) {
      throw Exception('الرجاء إضافة وصف مفصل للخدمة');
    }

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
      'description': descriptionText,
      'questions': questions,
      'accepted_terms': acceptedTerms.value,
      'accepted_privacy': acceptedPrivacy.value,
    };

    if (!forUpdate && storeId != null && storeId.isNotEmpty) {
      serviceData['store_id'] = storeId;
    }

    // سجل البيانات المرسلة كاملة
    print('📦 البيانات المرسلة للخادم (JSON):');
    try {
      final jsonStr = jsonEncode(serviceData);
      print(jsonStr.length > 500 ? jsonStr.substring(0, 500) + '...' : jsonStr);
    } catch (e) {
      print('❌ خطأ في تحويل البيانات إلى JSON: $e');
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

  // دالة لإعادة تعيين حالة الوصف فقط
  void resetDescriptionState() {
    hasUserTypedInDescription.value = false;
    isDescriptionError.value = false;
    showDescriptionPlaceholder.value = true;
    update(['description_field']);

    print('🔄 تم إعادة تعيين حالة الوصف');
    print('- hasUserTypedInDescription: ${hasUserTypedInDescription.value}');
    print('- isDescriptionError: ${isDescriptionError.value}');
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