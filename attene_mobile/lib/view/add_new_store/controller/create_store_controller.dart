
import 'package:image_picker/image_picker.dart';

import '../../../general_index.dart';

class CreateStoreController extends GetxController {
  final MyAppController myAppController = Get.find<MyAppController>();
  final DataInitializerService dataService = Get.find<DataInitializerService>();
  final GetStorage storage = GetStorage();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController cityIdController = TextEditingController();
  final TextEditingController districtIdController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController currencyIdController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController whatsappController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController tiktokController = TextEditingController();
  final TextEditingController youtubeController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  final TextEditingController pinterestController = TextEditingController();
  final TextEditingController latController = TextEditingController();
  final TextEditingController lngController = TextEditingController();

  final RxList<Map<String, dynamic>> cities = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> districts = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> currencies = <Map<String, dynamic>>[].obs;

  final RxString storeType = 'products'.obs;
  final RxString deliveryType = 'free'.obs;
  final RxString selectedCityName = 'اختر المدينة'.obs;
  final RxString selectedDistrictName = 'اختر الحي'.obs;
  final RxString selectedCurrencyName = 'اختر العملة'.obs;
  final RxBool hidePhone = false.obs;

  final RxList<Map<String, dynamic>> shippingCompanies =
      <Map<String, dynamic>>[].obs;
  final RxList<int> locationCities = <int>[].obs;
  final RxList<int> serviceCities = <int>[].obs;

  final RxList<MediaItem> selectedLogoMedia = <MediaItem>[].obs;
  final Rx<MediaItem?> primaryLogo = Rx<MediaItem?>(null);
  final RxList<MediaItem> selectedCoverMedia = <MediaItem>[].obs;
  final Rx<MediaItem?> primaryCover = Rx<MediaItem?>(null);

  final RxBool isUploadingLogo = false.obs;
  final RxBool isUploadingCover = false.obs;
  final RxMap<String, bool> logoUploadingStates = <String, bool>{}.obs;
  final RxMap<String, bool> coverUploadingStates = <String, bool>{}.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool createStoreLoading = false.obs;

  final RxInt editingStoreId = 0.obs;
  final RxBool isEditMode = false.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _initializeDefaultValues();
    loadInitialData();
    update();
  }

  void _initializeDefaultValues() {
    storeType.value = 'products';
    deliveryType.value = 'free';

    if (cityIdController.text.isEmpty) cityIdController.text = "1";
    if (districtIdController.text.isEmpty) districtIdController.text = "1";
    if (currencyIdController.text.isEmpty) currencyIdController.text = "2";
    update();
  }

  Future<void> loadInitialData() async {
    return UnifiedLoadingScreen.showWithFuture<void>(
      _performLoadInitialData(),
      message: 'جاري تحميل البيانات...',
    );
  }

  Future<void> _performLoadInitialData() async {
    try {
      isLoading.value = true;
      print('🔄 [STORE] تحميل البيانات الأولية...');

      await _loadCachedData();

      if (cities.isEmpty || districts.isEmpty || currencies.isEmpty) {
        await _fetchDataFromApi();
      }

      _updateSelectedValues();
      print('✅ [STORE] تم تحميل البيانات الأولية بنجاح');
      update();
    } catch (e) {
      print('❌ [STORE] خطأ في تحميل البيانات الأولية: $e');
      errorMessage.value = 'فشل في تحميل البيانات: ${e.toString()}';

      Get.snackbar(
        'خطأ',
        'فشل في تحميل البيانات',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCachedData() async {
    final cachedCities = dataService.getCities();
    if (cachedCities.isNotEmpty) {
      cities.assignAll(List<Map<String, dynamic>>.from(cachedCities));
      print('✅ [STORE] تم تحميل ${cities.length} مدينة من التخزين المحلي');
    }

    final cachedDistricts = dataService.getDistricts();
    if (cachedDistricts.isNotEmpty) {
      districts.assignAll(List<Map<String, dynamic>>.from(cachedDistricts));
      print('✅ [STORE] تم تحميل ${districts.length} منطقة من التخزين المحلي');
    }

    final cachedCurrencies = dataService.getCurrencies();
    if (cachedCurrencies.isNotEmpty) {
      currencies.assignAll(List<Map<String, dynamic>>.from(cachedCurrencies));
      print('✅ [STORE] تم تحميل ${currencies.length} عملة من التخزين المحلي');
    }
  }

  Future<void> _fetchDataFromApi() async {
    try {
      if (cities.isEmpty) {
        final citiesResponse = await ApiHelper.getCities();
        if (citiesResponse != null && citiesResponse['status'] == true) {
          final citiesList = List<Map<String, dynamic>>.from(
            citiesResponse['data'] ?? [],
          );
          cities.assignAll(citiesList);
        }
      }

      if (districts.isEmpty) {
        final districtsResponse = await ApiHelper.getDistricts();
        if (districtsResponse != null && districtsResponse['status'] == true) {
          final districtsList = List<Map<String, dynamic>>.from(
            districtsResponse['data'] ?? [],
          );
          districts.assignAll(districtsList);
        }
      }

      if (currencies.isEmpty) {
        final currenciesResponse = await ApiHelper.getCurrencies();
        if (currenciesResponse != null &&
            currenciesResponse['status'] == true) {
          final currenciesList = List<Map<String, dynamic>>.from(
            currenciesResponse['data'] ?? [],
          );
          currencies.assignAll(currenciesList);
        }
      }
    } catch (e) {
      print('⚠️ [STORE] خطأ في جلب البيانات من API: $e');
    }
  }

  void _updateSelectedValues() {
    if (cityIdController.text.isNotEmpty) {
      selectedCityName.value = getCityName(cityIdController.text);
    }

    if (districtIdController.text.isNotEmpty) {
      selectedDistrictName.value = getDistrictName(districtIdController.text);
    }

    if (currencyIdController.text.isNotEmpty) {
      selectedCurrencyName.value = getCurrencyName(currencyIdController.text);
    }
    update();
  }

  Future<bool?> updateStoreBasicInfo() async {
    return UnifiedLoadingScreen.showWithFuture<bool>(
      _performUpdateStoreBasicInfo(),
      message: 'جاري تحديث البيانات الأساسية...',
    );
  }

  Future<bool> _performUpdateStoreBasicInfo() async {
    try {
      createStoreLoading.value = true;

      if (!_validateBasicInfo()) {
        return false;
      }

      final bool hasLocalImages = await _uploadLocalImagesIfNeeded();
      if (!hasLocalImages) {
        return false;
      }

      final Map<String, dynamic> data = _prepareBasicInfoData();

      print('📤 [STORE] تحديث البيانات الأساسية للمتجر: ${jsonEncode(data)}');

      final response = await ApiHelper.updateStore(editingStoreId.value, data);

      if (response != null && response['status'] == true) {
        await dataService.refreshStores();

        Get.snackbar(
          'نجاح',
          'تم تحديث البيانات الأساسية',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        update();

        return true;
      } else {
        final errorMsg = response?['message'] ?? 'فشل التحديث';
        throw Exception(errorMsg);
      }
    } catch (e) {
      print('❌ [STORE] خطأ في تحديث البيانات الأساسية: $e');

      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء التحديث: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      createStoreLoading.value = false;
    }
  }

  bool _validateBasicInfo() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        selectedLogoMedia.isEmpty ||
        selectedCoverMedia.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى تعبئة جميع الحقول الإلزامية',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!emailController.text.contains('@')) {
      Get.snackbar(
        'خطأ',
        'البريد الإلكتروني غير صحيح',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  Future<bool> _uploadLocalImagesIfNeeded() async {
    try {
      isUploadingLogo.value = true;
      isUploadingCover.value = true;

      bool allUploaded = true;

      for (int i = 0; i < selectedLogoMedia.length; i++) {
        final media = selectedLogoMedia[i];
        if (media.isLocal == true && media.path.isNotEmpty) {
          final success = await _uploadMediaFile(media, i, true);
          if (!success) allUploaded = false;
        }
      }

      for (int i = 0; i < selectedCoverMedia.length; i++) {
        final media = selectedCoverMedia[i];
        if (media.isLocal == true && media.path.isNotEmpty) {
          final success = await _uploadMediaFile(media, i, false);
          if (!success) allUploaded = false;
        }
      }

      return allUploaded;
    } catch (e) {
      print('❌ [STORE] خطأ في رفع الصور المحلية: $e');
      return false;
    } finally {
      isUploadingLogo.value = false;
      isUploadingCover.value = false;
    }
  }

  Future<bool> _uploadMediaFile(MediaItem media, int index, bool isLogo) async {
    try {
      if (isLogo) {
        logoUploadingStates[media.id] = true;
      } else {
        coverUploadingStates[media.id] = true;
      }

      final XFile file = XFile(media.path);
      final response = await ApiHelper.uploadMedia(
        file: file,
        type: 'images',
        withLoading: false,
      );

      if (response != null && response['status'] == true) {
        final path = response['path'];
        final fileName = response['file_name'];
        final fileUrl = response['file_url'];

        if (isLogo) {
          selectedLogoMedia[index] = MediaItem(
            id: media.id,
            path: path,
            type: media.type,
            name: media.name,
            dateAdded: media.dateAdded,
            size: media.size,
            isLocal: false,
            fileName: fileName,
            fileUrl: fileUrl,
          );
        } else {
          selectedCoverMedia[index] = MediaItem(
            id: media.id,
            path: path,
            type: media.type,
            name: media.name,
            dateAdded: media.dateAdded,
            size: media.size,
            isLocal: false,
            fileName: fileName,
            fileUrl: fileUrl,
          );
        }
        return true;
      }
      return false;
    } catch (e) {
      print('❌ [STORE] خطأ في رفع ملف الوسائط: $e');
      return false;
    } finally {
      if (isLogo) {
        logoUploadingStates[media.id] = false;
      } else {
        coverUploadingStates[media.id] = false;
      }
    }
  }

  Map<String, dynamic> _prepareBasicInfoData() {
    final data = <String, dynamic>{
      'type': storeType.value,
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'hide_phone': hidePhone.value ? "1" : "0",
      'delivery_type': deliveryType.value,
    };

    final primaryLogoPath = getPrimaryLogoPath();
    if (primaryLogoPath != null && primaryLogoPath.isNotEmpty) {
      data['logo'] = primaryLogoPath;
    }

    final coverPaths = getAllCoverPaths();
    if (coverPaths.isNotEmpty) {
      data['cover'] = coverPaths;
    }

    data['city_id'] = int.tryParse(cityIdController.text.trim()) ?? 1;
    data['district_id'] = int.tryParse(districtIdController.text.trim()) ?? 1;
    data['address'] = addressController.text.trim().isEmpty
        ? "العنوان"
        : addressController.text.trim();
    data['currency_id'] = int.tryParse(currencyIdController.text.trim()) ?? 2;

    _addSocialMediaData(data);

    data.removeWhere((key, value) {
      if (value == null) return true;
      if (value is String && value.isEmpty) return true;
      return false;
    });

    return data;
  }

  void _addSocialMediaData(Map<String, dynamic> data) {
    if (whatsappController.text.isNotEmpty) {
      data['whats_app'] = whatsappController.text.trim();
    }

    if (facebookController.text.isNotEmpty) {
      data['facebook'] = facebookController.text.trim();
    }

    if (instagramController.text.isNotEmpty) {
      data['instagram'] = instagramController.text.trim();
    }

    if (tiktokController.text.isNotEmpty) {
      data['tiktok'] = tiktokController.text.trim();
    }

    if (youtubeController.text.isNotEmpty) {
      data['youtube'] = youtubeController.text.trim();
    }

    if (twitterController.text.isNotEmpty) {
      data['twitter'] = twitterController.text.trim();
    }

    if (linkedinController.text.isNotEmpty) {
      data['linkedin'] = linkedinController.text.trim();
    }

    if (pinterestController.text.isNotEmpty) {
      data['pinterest'] = pinterestController.text.trim();
    }

    if (latController.text.isNotEmpty && lngController.text.isNotEmpty) {
      data['lat'] = latController.text.trim();
      data['lng'] = lngController.text.trim();
    }
  }

  Future<bool?> saveCompleteStore() async {
    return UnifiedLoadingScreen.showWithFuture<bool>(
      _performSaveCompleteStore(),
      message: isEditMode.value
          ? 'جاري تحديث المتجر...'
          : 'جاري إنشاء المتجر...',
    );
  }

  Future<bool> _performSaveCompleteStore() async {
    try {
      createStoreLoading.value = true;

      if (!_validateCompleteStoreData()) {
        return false;
      }

      final bool hasLocalImages = await _uploadLocalImagesIfNeeded();
      if (!hasLocalImages) {
        return false;
      }

      final Map<String, dynamic> data = _prepareCompleteStoreData();

      print('📤 [STORE] البيانات النهائية المرسلة للخادم: ${jsonEncode(data)}');

      dynamic response;

      if (isEditMode.value && editingStoreId.value > 0) {
        response = await ApiHelper.updateStore(editingStoreId.value, data);
      } else {
        response = await ApiHelper.post(
          path: '/merchants/mobile/stores',
          body: data,
          withLoading: false,
          shouldShowMessage: false,
        );
      }

      if (response != null && response['status'] == true) {
        print('✅ [STORE] استجابة الخادم: ${jsonEncode(response)}');

        await dataService.refreshStores();

        if (Get.isRegistered<ManageAccountStoreController>()) {
          Get.find<ManageAccountStoreController>().loadStores();
        }

        Get.snackbar(
          'نجاح',
          isEditMode.value ? 'تم تحديث المتجر بنجاح' : 'تم إنشاء المتجر بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        resetData();
        return true;
      } else {
        final errorMsg = response?['message'] ?? 'فشل العملية';
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      print('❌ [STORE] خطأ في حفظ المتجر: $e');
      print('📜 Stack trace: $stackTrace');

      Get.snackbar(
        '❌ خطأ',
        'حدث خطأ أثناء الحفظ: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      createStoreLoading.value = false;
    }
  }

  bool _validateCompleteStoreData() {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneController.text.isEmpty ||
        selectedLogoMedia.isEmpty ||
        selectedCoverMedia.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى تعبئة جميع الحقول الإلزامية',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (!emailController.text.contains('@')) {
      Get.snackbar(
        'خطأ',
        'البريد الإلكتروني غير صحيح',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }

    if (deliveryType.value == 'shipping') {
      if (shippingCompanies.isEmpty) {
        Get.snackbar(
          'خطأ',
          'يرجى إضافة شركة شحن واحدة على الأقل',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      for (int i = 0; i < shippingCompanies.length; i++) {
        final company = shippingCompanies[i];
        if (company['prices'] == null ||
            (company['prices'] is List && company['prices'].isEmpty)) {
          Get.snackbar(
            'خطأ',
            'يرجى تعبئة أسعار التوصيل لشركة ${company['name']}',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return false;
        }
      }
    }

    return true;
  }

  Map<String, dynamic> _prepareCompleteStoreData() {
    final data = <String, dynamic>{
      'type': storeType.value,
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'email': emailController.text.trim(),
      'city_id': int.tryParse(cityIdController.text.trim()) ?? 1,
      'district_id': int.tryParse(districtIdController.text.trim()) ?? 1,
      'address': addressController.text.trim().isEmpty
          ? "العنوان"
          : addressController.text.trim(),
      'currency_id': int.tryParse(currencyIdController.text.trim()) ?? 2,
      'phone': phoneController.text.trim(),
      'hide_phone': hidePhone.value ? "1" : "0",
      'delivery_type': deliveryType.value == 'free'
          ? 'hand'
          : deliveryType.value,
    };

    if (!isEditMode.value) {
      data['owner_id'] = myAppController.userData['id']?.toString() ?? '41';
    }

    final primaryLogoPath = getPrimaryLogoPath();
    if (primaryLogoPath != null && primaryLogoPath.isNotEmpty) {
      data['logo'] = primaryLogoPath;
    }

    final coverPaths = getAllCoverPaths();
    if (coverPaths.isNotEmpty) {
      data['cover'] = coverPaths;
    }

    _addSocialMediaData(data);

    if (deliveryType.value == 'shipping' && shippingCompanies.isNotEmpty) {
      _prepareShippingCompaniesData(data);
    }

    return data;
  }

  void _prepareShippingCompaniesData(Map<String, dynamic> data) {
    final List<Map<String, dynamic>> formattedCompanies = [];
    final Set<dynamic> allCities = {};

    for (var company in shippingCompanies) {
      final Map<String, dynamic> formattedCompany = {
        'name': company['name']?.toString() ?? '',
        'phone': company['phone']?.toString() ?? '',
      };

      if (company['prices'] != null && company['prices'] is List) {
        formattedCompany['prices'] = (company['prices'] as List).map((price) {
          if (price['city_id'] != null) {
            allCities.add(price['city_id']);
          }

          return {
            'city_id': price['city_id'] ?? 0,
            'days': int.tryParse(price['days'].toString()) ?? 0,
            'price': double.tryParse(price['price'].toString()) ?? 0.0,
          };
        }).toList();
      }

      formattedCompanies.add(formattedCompany);
    }

    data['shippingCompanies'] = formattedCompanies;

    if (allCities.isNotEmpty) {
      data['locationCities'] = allCities.toList();
      data['serviceCities'] = allCities.toList();
    }
  }

  Future<void> openCitySelection() async {
    try {
      if (cities.isEmpty) {
        await loadInitialData();
      }

      if (cities.isEmpty) {
        Get.snackbar('تنبيه', 'لا توجد مدن متاحة حالياً');
        return;
      }

      await Get.bottomSheet(
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'اختر المدينة',
                      style: getBold(fontSize: 18, color: AppColors.neutral100),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: cities.length,
                  itemBuilder: (context, index) {
                    final city = cities[index];
                    final isSelected =
                        cityIdController.text == city['id'].toString();

                    return ListTile(
                      title: Text(
                        city['name']?.toString() ?? 'مدينة',
                        style: getRegular(
                          color: isSelected
                              ? AppColors.primary400
                              : AppColors.neutral100,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.primary400,
                            )
                          : null,
                      onTap: () {
                        cityIdController.text = city['id'].toString();
                        selectedCityName.value =
                            city['name']?.toString() ?? 'اختر المدينة';
                        Get.back();
                        update();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        isScrollControlled: true,
      );
    } catch (e) {
      print('❌ [STORE] خطأ في فتح قائمة المدن: $e');
    }
  }

  Future<void> openDistrictSelection() async {
    try {
      if (districts.isEmpty) {
        await loadInitialData();
      }

      if (districts.isEmpty) {
        Get.snackbar('تنبيه', 'لا توجد أحياء متاحة حالياً');
        return;
      }

      await Get.bottomSheet(
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'اختر الحي',
                      style: getBold(fontSize: 18, color: AppColors.neutral100),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: districts.length,
                  itemBuilder: (context, index) {
                    final district = districts[index];
                    final isSelected =
                        districtIdController.text == district['id'].toString();

                    return ListTile(
                      title: Text(
                        district['name']?.toString() ?? 'حي',
                        style: getRegular(
                          color: isSelected
                              ? AppColors.primary400
                              : AppColors.neutral100,
                        ),
                      ),
                      subtitle: district['city_name'] != null
                          ? Text(
                              'مدينة: ${district['city_name']}',
                              style: getRegular(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            )
                          : null,
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.primary400,
                            )
                          : null,
                      onTap: () {
                        districtIdController.text = district['id'].toString();
                        selectedDistrictName.value =
                            district['name']?.toString() ?? 'اختر الحي';
                        Get.back();
                        update();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        isScrollControlled: true,
      );
    } catch (e) {
      print('❌ [STORE] خطأ في فتح قائمة الأحياء: $e');
    }
  }

  Future<void> openCurrencySelection() async {
    try {
      if (currencies.isEmpty) {
        await loadInitialData();
      }

      if (currencies.isEmpty) {
        Get.snackbar('تنبيه', 'لا توجد عملات متاحة حالياً');
        return;
      }

      await Get.bottomSheet(
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'اختر العملة',
                      style: getBold(fontSize: 18, color: AppColors.neutral900),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: currencies.length,
                  itemBuilder: (context, index) {
                    final currency = currencies[index];
                    final isSelected =
                        currencyIdController.text == currency['id'].toString();

                    return ListTile(
                      leading: currency['symbol'] != null
                          ? Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary100,
                              ),
                              child: Center(
                                child: Text(
                                  currency['symbol']?.toString() ?? 'ر.س',
                                  style: getBold(color: AppColors.primary500),
                                ),
                              ),
                            )
                          : null,
                      title: Text(
                        currency['name']?.toString() ?? 'عملة',
                        style: getRegular(
                          color: isSelected
                              ? AppColors.primary400
                              : AppColors.neutral800,
                        ),
                      ),
                      subtitle: currency['code'] != null
                          ? Text(
                              'الرمز: ${currency['code']}',
                              style: getRegular(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            )
                          : null,
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.primary400,
                            )
                          : null,
                      onTap: () {
                        currencyIdController.text = currency['id'].toString();
                        selectedCurrencyName.value =
                            currency['name']?.toString() ?? 'اختر العملة';
                        Get.back();
                        update();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        isScrollControlled: true,
      );
    } catch (e) {
      print('❌ [STORE] خطأ في فتح قائمة العملات: $e');
    }
  }

  String getCityName(String cityId) {
    if (cityId.isEmpty) return 'اختر المدينة';

    try {
      final city = cities.firstWhereOrNull((c) => c['id'].toString() == cityId);

      return city != null
          ? city['name']?.toString() ?? 'اختر المدينة'
          : 'اختر المدينة';
    } catch (e) {
      return 'اختر المدينة';
    }
  }

  String getDistrictName(String districtId) {
    if (districtId.isEmpty) return 'اختر الحي';

    try {
      final district = districts.firstWhereOrNull(
        (d) => d['id'].toString() == districtId,
      );

      return district != null
          ? district['name']?.toString() ?? 'اختر الحي'
          : 'اختر الحي';
    } catch (e) {
      return 'اختر الحي';
    }
  }

  String getCurrencyName(String currencyId) {
    if (currencyId.isEmpty) return 'اختر العملة';

    try {
      final currency = currencies.firstWhereOrNull(
        (c) => c['id'].toString() == currencyId,
      );

      return currency != null
          ? currency['name']?.toString() ?? 'اختر العملة'
          : 'اختر العملة';
    } catch (e) {
      return 'اختر العملة';
    }
  }

  Future<void> loadStoreForEdit(int storeId) async {
    return UnifiedLoadingScreen.showWithFuture<void>(
      _performLoadStoreForEdit(storeId),
      message: 'جاري تحميل بيانات المتجر...',
    );
  }

  Future<void> _performLoadStoreForEdit(int storeId) async {
    try {
      isLoading.value = true;
      isEditMode.value = true;
      editingStoreId.value = storeId;

      print('🔄 [STORE] تحميل بيانات المتجر للتعديل - ID: $storeId');

      await loadInitialData();

      final response = await ApiHelper.getStoreDetails(storeId);

      if (response != null && response['status'] == true) {
        final storeData = response['record'] ?? response['data'];

        if (storeData == null) {
          throw Exception('بيانات المتجر غير موجودة');
        }

        _populateStoreData(storeData);
        await _loadStoreImages(storeData);

        print('✅ [STORE] تم تحميل بيانات المتجر بنجاح');
        update();
      } else {
        final errorMsg = response?['message'] ?? 'فشل تحميل بيانات المتجر';
        throw Exception(errorMsg);
      }
    } catch (e, stackTrace) {
      print('❌ [STORE] خطأ في تحميل بيانات المتجر: $e\n$stackTrace');

      Get.snackbar(
        'خطأ',
        'فشل في تحميل بيانات المتجر',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _populateStoreData(Map<String, dynamic> storeData) {
    storeType.value = storeData['type']?.toString() ?? 'products';
    nameController.text = storeData['name']?.toString() ?? '';
    descriptionController.text = storeData['description']?.toString() ?? '';
    emailController.text = storeData['email']?.toString() ?? '';

    if (storeData['city_id'] != null) {
      final cityId = storeData['city_id'].toString();
      cityIdController.text = cityId;
      selectedCityName.value = getCityName(cityId);
    }

    if (storeData['district_id'] != null) {
      final districtId = storeData['district_id'].toString();
      districtIdController.text = districtId;
      selectedDistrictName.value = getDistrictName(districtId);
    }

    addressController.text = storeData['address']?.toString() ?? '';

    if (storeData['currency_id'] != null) {
      final currencyId = storeData['currency_id'].toString();
      currencyIdController.text = currencyId;
      selectedCurrencyName.value = getCurrencyName(currencyId);
    }

    phoneController.text = storeData['phone']?.toString() ?? '';
    hidePhone.value =
        storeData['hide_phone'] == "1" ||
        storeData['hide_phone'] == 1 ||
        storeData['hide_phone'] == true;

    final deliveryTypeValue = storeData['delivery_type']?.toString() ?? 'free';
    deliveryType.value = deliveryTypeValue == 'hand_delivery'
        ? 'hand'
        : deliveryTypeValue;
  }

  Future<void> _loadStoreImages(Map<String, dynamic> storeData) async {
    try {
      final logoUrl = storeData['logo_url']?.toString();
      final logoPath = storeData['logo']?.toString();

      if (logoUrl != null && logoUrl.isNotEmpty) {
        selectedLogoMedia.clear();

        final logoMedia = MediaItem(
          id: 'logo_${storeData['id']}',
          path: logoUrl,
          type: MediaType.image,
          name: 'شعار المتجر',
          dateAdded: DateTime.now(),
          size: 0,
          isLocal: false,
          fileUrl: logoUrl,
          fileName: logoPath,
        );

        selectedLogoMedia.add(logoMedia);
        primaryLogo.value = logoMedia;
      } else {
        selectedLogoMedia.clear();
        primaryLogo.value = null;
      }

      final coverUrls = storeData['cover_urls'];
      final coverPaths = storeData['cover'];

      if (coverUrls != null && coverUrls is List && coverUrls.isNotEmpty) {
        selectedCoverMedia.clear();

        for (int i = 0; i < coverUrls.length; i++) {
          final coverUrl = coverUrls[i]?.toString();
          final coverPath = (coverPaths is List && i < coverPaths.length)
              ? coverPaths[i]?.toString()
              : null;

          if (coverUrl != null && coverUrl.isNotEmpty) {
            final coverMedia = MediaItem(
              id: 'cover_${storeData['id']}_$i',
              path: coverUrl,
              type: MediaType.image,
              name: 'غلاف ${i + 1}',
              dateAdded: DateTime.now(),
              size: 0,
              isLocal: false,
              fileUrl: coverUrl,
              fileName: coverPath,
            );

            selectedCoverMedia.add(coverMedia);
          }
        }

        if (selectedCoverMedia.isNotEmpty) {
          primaryCover.value = selectedCoverMedia.first;
        } else {
          primaryCover.value = null;
        }
      } else {
        selectedCoverMedia.clear();
        primaryCover.value = null;
      }
    } catch (e) {
      print('❌ [STORE] خطأ في تحميل صور المتجر: $e');
    }
  }

  void setStoreType(String type) {
    storeType.value = type;
    update();
  }

  void setDeliveryType(String type) {
    deliveryType.value = type;
    update();
  }

  String getDeliveryTypeDisplay() {
    switch (deliveryType.value) {
      case 'free':
        return 'مجاني';
      case 'hand':
        return 'من يد ليد';
      case 'shipping':
        return 'شركات الشحن';
      default:
        return 'غير محدد';
    }
  }

  void addShippingCompany(Map<String, dynamic> company) {
    shippingCompanies.add(company);

    if (company['prices'] != null && company['prices'] is List) {
      for (var price in company['prices']) {
        if (price['city_id'] != null &&
            !locationCities.contains(price['city_id'])) {
          locationCities.add(price['city_id']);
        }
        if (price['city_id'] != null &&
            !serviceCities.contains(price['city_id'])) {
          serviceCities.add(price['city_id']);
        }
      }
    }

    update();
  }

  void removeShippingCompany(int index) {
    if (index >= 0 && index < shippingCompanies.length) {
      shippingCompanies.removeAt(index);
      update();
    }
  }

  void addLocationCity(int cityId) {
    if (!locationCities.contains(cityId)) {
      locationCities.add(cityId);
      update();
    }
  }

  void removeLocationCity(int cityId) {
    locationCities.remove(cityId);
    update();
  }

  void addServiceCity(int cityId) {
    if (!serviceCities.contains(cityId)) {
      serviceCities.add(cityId);
      update();
    }
  }

  void removeServiceCity(int cityId) {
    serviceCities.remove(cityId);
    update();
  }

  List<MediaItem> get selectedMedia {
    return [...selectedLogoMedia, ...selectedCoverMedia];
  }

  bool isLogoUploading(String mediaId) => logoUploadingStates[mediaId] ?? false;

  bool isCoverUploading(String mediaId) =>
      coverUploadingStates[mediaId] ?? false;

  bool isPrimaryLogo(MediaItem media) => primaryLogo.value?.id == media.id;

  bool isPrimaryCover(MediaItem media) => primaryCover.value?.id == media.id;

  String getMediaDisplayUrl(MediaItem media) {
    if (media.fileUrl != null && media.fileUrl!.isNotEmpty) {
      return media.fileUrl!;
    } else if (media.path.isNotEmpty) {
      if (media.path.startsWith('http')) {
        return media.path;
      } else if (media.isLocal == true) {
        return media.path;
      } else {
        return '${ApiHelper.getBaseUrl()}/storage/${media.path}';
      }
    }
    return '';
  }

  Future<void> openMediaLibraryForLogo() async {
    try {
      if (selectedLogoMedia.length >= 5) {
        Get.snackbar('تنبيه', 'يمكنك إضافة 5 صور كحد أقصى للشعار');
        return;
      }

      final List<MediaItem>? selectedImages = await Get.to<List<MediaItem>>(
        () => MediaLibraryScreen(isSelectionMode: true),
        preventDuplicates: false,
      );

      if (selectedImages != null && selectedImages.isNotEmpty) {
        for (var image in selectedImages) {
          if (!selectedLogoMedia.any((item) => item.id == image.id)) {
            selectedLogoMedia.add(image);
          }
        }

        if (primaryLogo.value == null && selectedLogoMedia.isNotEmpty) {
          primaryLogo.value = selectedLogoMedia.first;
        }

        update();
      }
    } catch (e) {
      print('❌ [STORE] خطأ في فتح مكتبة الوسائط للشعار: $e');
      Get.snackbar('خطأ', 'فشل في فتح مكتبة الوسائط');
    }
  }

  Future<void> openMediaLibraryForCover() async {
    try {
      if (selectedCoverMedia.length >= 10) {
        Get.snackbar('تنبيه', 'يمكنك إضافة 10 صور كحد أقصى للغلاف');
        return;
      }

      final List<MediaItem>? selectedImages = await Get.to<List<MediaItem>>(
        () => MediaLibraryScreen(isSelectionMode: true),
        preventDuplicates: false,
      );

      if (selectedImages != null && selectedImages.isNotEmpty) {
        for (var image in selectedImages) {
          if (!selectedCoverMedia.any((item) => item.id == image.id)) {
            selectedCoverMedia.add(image);
          }
        }

        if (primaryCover.value == null && selectedCoverMedia.isNotEmpty) {
          primaryCover.value = selectedCoverMedia.first;
        }

        update();
      }
    } catch (e) {
      print('❌ [STORE] خطأ في فتح مكتبة الوسائط للغلاف: $e');
      Get.snackbar('خطأ', 'فشل في فتح مكتبة الوسائط');
    }
  }

  Future<void> pickLogoFromDevice() async {
    try {
      if (selectedLogoMedia.length >= 5) {
        Get.snackbar('تنبيه', 'يمكنك إضافة 5 صور كحد أقصى للشعار');
        return;
      }

      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final XFile file = image;
        final fileSize = await file.length();

        final mediaItem = MediaItem(
          id: 'local_logo_${DateTime.now().millisecondsSinceEpoch}',
          path: image.path,
          type: MediaType.image,
          name: image.name,
          dateAdded: DateTime.now(),
          size: fileSize,
          isLocal: true,
        );

        selectedLogoMedia.add(mediaItem);

        if (selectedLogoMedia.length == 1) {
          primaryLogo.value = mediaItem;
        }

        update();
      }
    } catch (e) {
      print('❌ [STORE] خطأ في اختيار صورة الشعار: $e');
      Get.snackbar('خطأ', 'فشل في اختيار الصورة');
    }
  }

  Future<void> pickCoverFromDevice() async {
    try {
      if (selectedCoverMedia.length >= 10) {
        Get.snackbar('تنبيه', 'يمكنك إضافة 10 صور كحد أقصى للغلاف');
        return;
      }

      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final XFile file = image;
        final fileSize = await file.length();

        final mediaItem = MediaItem(
          id: 'local_cover_${DateTime.now().millisecondsSinceEpoch}',
          path: image.path,
          type: MediaType.image,
          name: image.name,
          dateAdded: DateTime.now(),
          size: fileSize,
          isLocal: true,
        );

        selectedCoverMedia.add(mediaItem);

        if (selectedCoverMedia.length == 1) {
          primaryCover.value = mediaItem;
        }

        update();
      }
    } catch (e) {
      print('❌ [STORE] خطأ في اختيار صورة الغلاف: $e');
      Get.snackbar('خطأ', 'فشل في اختيار الصورة');
    }
  }

  void removeLogo(int index) {
    if (index >= 0 && index < selectedLogoMedia.length) {
      final removedMedia = selectedLogoMedia[index];
      selectedLogoMedia.removeAt(index);

      if (primaryLogo.value?.id == removedMedia.id) {
        primaryLogo.value = selectedLogoMedia.isEmpty
            ? null
            : selectedLogoMedia.first;
      }

      update();
    }
  }

  void removeCover(int index) {
    if (index >= 0 && index < selectedCoverMedia.length) {
      final removedMedia = selectedCoverMedia[index];
      selectedCoverMedia.removeAt(index);

      if (primaryCover.value?.id == removedMedia.id) {
        primaryCover.value = selectedCoverMedia.isEmpty
            ? null
            : selectedCoverMedia.first;
      }

      update();
    }
  }

  void setPrimaryLogo(int index) {
    if (index >= 0 && index < selectedLogoMedia.length) {
      primaryLogo.value = selectedLogoMedia[index];
      update();
    }
  }

  void setPrimaryCover(int index) {
    if (index >= 0 && index < selectedCoverMedia.length) {
      primaryCover.value = selectedCoverMedia[index];
      update();
    }
  }

  String? _extractRelativePath(String? url) {
    if (url == null || url.isEmpty) return null;

    if (url.contains('/storage/')) {
      final parts = url.split('/storage/');
      return parts.length > 1 ? parts[1] : null;
    }

    if (url.contains('images/') ||
        url.contains('gallery/') ||
        url.contains('avatar/')) {
      return url;
    }

    return url;
  }

  String? getPrimaryLogoPath() {
    if (primaryLogo.value != null) {
      final media = primaryLogo.value!;
      final path = media.fileName ?? media.path;
      final relativePath = _extractRelativePath(path);

      if (relativePath != null && relativePath.startsWith('http')) {
        return _extractRelativePath(relativePath);
      }

      return relativePath;
    }
    return null;
  }

  List<String> getAllLogoPaths() {
    final List<String> paths = [];

    for (var media in selectedLogoMedia) {
      final path = media.fileName ?? media.path;
      final relativePath = _extractRelativePath(path);

      String? finalPath = relativePath;
      if (finalPath != null && finalPath.startsWith('http')) {
        finalPath = _extractRelativePath(finalPath);
      }

      if (finalPath != null && finalPath.isNotEmpty) {
        paths.add(finalPath);
      }
    }

    return paths;
  }

  List<String> getAllCoverPaths() {
    final List<String> paths = [];

    for (var media in selectedCoverMedia) {
      final path = media.fileName ?? media.path;
      final relativePath = _extractRelativePath(path);

      String? finalPath = relativePath;
      if (finalPath != null && finalPath.startsWith('http')) {
        finalPath = _extractRelativePath(finalPath);
      }

      if (finalPath != null && finalPath.isNotEmpty) {
        paths.add(finalPath);
      }
    }

    return paths;
  }

  Future<void> createOrUpdateStore() async {
    await saveCompleteStore();
  }

  Future<void> submitStore() async {
    if (createStoreLoading.value) return;
    await createOrUpdateStore();
  }

  void resetData() {
    storeType.value = 'products';
    deliveryType.value = 'free';

    nameController.clear();
    descriptionController.clear();
    emailController.clear();
    cityIdController.clear();
    districtIdController.clear();
    addressController.clear();
    currencyIdController.clear();
    phoneController.clear();
    whatsappController.clear();
    facebookController.clear();
    instagramController.clear();
    tiktokController.clear();
    youtubeController.clear();
    twitterController.clear();
    linkedinController.clear();
    pinterestController.clear();
    latController.clear();
    lngController.clear();

    hidePhone.value = false;
    shippingCompanies.clear();
    locationCities.clear();
    serviceCities.clear();

    selectedLogoMedia.clear();
    selectedCoverMedia.clear();
    primaryLogo.value = null;
    primaryCover.value = null;
    logoUploadingStates.clear();
    coverUploadingStates.clear();

    isLoading.value = false;
    errorMessage.value = '';
    isUploadingLogo.value = false;
    isUploadingCover.value = false;
    isEditMode.value = false;
    editingStoreId.value = 0;

    cityIdController.text = "1";
    districtIdController.text = "1";
    currencyIdController.text = "2";

    update();
  }

  void printDataSummary() {
    print('''
📊 [STORE SUMMARY]:
   نوع المتجر: ${storeType.value}
   اسم المتجر: ${nameController.text}
   البريد الإلكتروني: ${emailController.text}
   المدينة: ${selectedCityName.value}
   الحي: ${selectedDistrictName.value}
   العملة: ${selectedCurrencyName.value}
   الهاتف: ${phoneController.text}
   إخفاء الهاتف: ${hidePhone.value}
   نوع التوصيل: ${deliveryType.value}
   عدد صور الشعار: ${selectedLogoMedia.length}
   عدد صور الغلاف: ${selectedCoverMedia.length}
   عدد شركات الشحن: ${shippingCompanies.length}
   وضع التعديل: ${isEditMode.value}
   معرف المتجر: ${editingStoreId.value}
''');
  }

  @override
  void onClose() {
    nameController.dispose();
    descriptionController.dispose();
    emailController.dispose();
    cityIdController.dispose();
    districtIdController.dispose();
    addressController.dispose();
    currencyIdController.dispose();
    phoneController.dispose();
    whatsappController.dispose();
    facebookController.dispose();
    instagramController.dispose();
    tiktokController.dispose();
    youtubeController.dispose();
    twitterController.dispose();
    linkedinController.dispose();
    pinterestController.dispose();
    latController.dispose();
    lngController.dispose();

    super.onClose();
  }
}
