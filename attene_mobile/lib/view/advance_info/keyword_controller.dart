import 'package:attene_mobile/view/advance_info/keyword_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KeywordController extends GetxController {
  // إضافة TextEditingController في الـ Controller
  late TextEditingController searchController;

  // القوائم والمتغيرات الأساسية
  final RxList<Keyword> selectedKeywords = <Keyword>[].obs;
  final RxList<Keyword> availableKeywords = <Keyword>[].obs;
  final RxString searchInputText = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedStore = 'المتجر الرئيسي'.obs;

  final List<String> stores = ['المتجر الرئيسي', 'موضة', 'عناية'];
  
  final List<Keyword> allKeywords = [
    Keyword(id: '1', text: 'عناية بالبشرة', category: 'عناية'),
    Keyword(id: '2', text: 'عناية بالشعر', category: 'عناية'),
    Keyword(id: '3', text: 'مستحضرات تجميل', category: 'عناية'),
    Keyword(id: '4', text: 'ملابس نسائية', category: 'موضة'),
    Keyword(id: '5', text: 'أزياء محجبات', category: 'موضة'),
    Keyword(id: '6', text: 'إكسسوارات', category: 'موضة'),
    Keyword(id: '7', text: 'عطور', category: 'المتجر الرئيسي'),
    Keyword(id: '8', text: 'منتجات صحية', category: 'المتجر الرئيسي'),
    Keyword(id: '9', text: 'رياضة', category: 'المتجر الرئيسي'),
    Keyword(id: '10', text: 'أطفال', category: 'المتجر الرئيسي'),
  ];

  @override
  void onInit() {
    super.onInit();
    // تهيئة الـ TextEditingController
    searchController = TextEditingController();
    searchController.addListener(_handleSearchInput);
    
    availableKeywords.assignAll(allKeywords);
  }

  @override
  void onClose() {
    // تنظيف الـ TextEditingController عند إغلاق الـ Controller
    searchController.removeListener(_handleSearchInput);
    searchController.dispose();
    super.onClose();
  }

  void _handleSearchInput() {
    searchInputText.value = searchController.text;
    setSearchQuery(searchController.text);
  }

  // دوال إدارة المتجر
  void setSelectedStore(String store) {
    selectedStore.value = store;
    _filterKeywords();
  }

  // دوال إدارة البحث
  void setSearchQuery(String query) {
    searchQuery.value = query;
    _filterKeywords();
  }

  void clearSearchInput() {
    searchController.clear();
    searchInputText.value = '';
    setSearchQuery('');
  }

  void _filterKeywords() {
    var filtered = allKeywords;
    
    // التصفية حسب المتجر
    if (selectedStore.value != 'المتجر الرئيسي') {
      filtered = filtered.where((keyword) => keyword.category == selectedStore.value).toList();
    }
    
    // التصفية حسب البحث
    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((keyword) => 
        keyword.text.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
    
    availableKeywords.assignAll(filtered);
  }

  // دوال إدارة الوسوم
  void addCustomKeyword() {
    if (searchInputText.value.trim().isEmpty) return;

    if (!canAddMoreKeywords) {
      Get.snackbar(
        'تنبيه',
        'يمكن إضافة 15 وسماً كحد أقصى',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    final newKeyword = Keyword(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      text: searchInputText.value.trim(),
      category: selectedStore.value,
    );

    // التحقق من عدم التكرار
    if (selectedKeywords.any((k) => k.text == newKeyword.text)) {
      Get.snackbar(
        'تنبيه',
        'هذا الوسم مضاف مسبقاً',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    selectedKeywords.add(newKeyword);
    clearSearchInput();

    Get.snackbar(
      'تم الإضافة',
      'تم إضافة الوسم "${newKeyword.text}" بنجاح',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  void addKeyword(Keyword keyword) {
    if (!selectedKeywords.any((k) => k.id == keyword.id) && canAddMoreKeywords) {
      selectedKeywords.add(keyword);
    } else if (!canAddMoreKeywords) {
      Get.snackbar(
        'تنبيه',
        'يمكن إضافة 15 وسماً كحد أقصى',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  void removeKeyword(String keywordId) {
    selectedKeywords.removeWhere((keyword) => keyword.id == keywordId);
  }

  void toggleKeyword(Keyword keyword) {
    if (selectedKeywords.any((k) => k.id == keyword.id)) {
      removeKeyword(keyword.id);
    } else {
      addKeyword(keyword);
    }
  }

  void clearAllKeywords() {
    selectedKeywords.clear();
  }

  // دوال مساعدة
  List<String> getSelectedKeywordsText() {
    return selectedKeywords.map((keyword) => keyword.text).toList();
  }

  bool get canAddMoreKeywords {
    return selectedKeywords.length < 15;
  }

  bool get isSearchInputEmpty {
    return searchInputText.value.trim().isEmpty;
  }

  bool get isDuplicateKeyword {
    return selectedKeywords.any((k) => k.text == searchInputText.value.trim());
  }

  List<Keyword> get filteredAvailableKeywords {
    return availableKeywords.where((keyword) => 
      !selectedKeywords.any((selected) => selected.id == keyword.id)
    ).toList();
  }

  // دالة التأكيد النهائية
  void confirmSelection() {
    if (selectedKeywords.isEmpty) return;

    Get.back(result: getSelectedKeywordsText());
    
    Get.snackbar(
      'تم الحفظ',
      'تم إضافة ${selectedKeywords.length} وسوم بنجاح',
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }
}