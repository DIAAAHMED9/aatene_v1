import 'dart:convert';
import 'dart:io';
import 'package:attene_mobile/api/api_request.dart';
import 'package:attene_mobile/view/media_library/media_library_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:attene_mobile/my_app/may_app_controller.dart';
import 'package:attene_mobile/view/media_library/media_model.dart';

import '../utlis/colors/app_color.dart';

class CreateStoreController extends GetxController {
  final MyAppController myAppController = Get.find<MyAppController>();
  
  RxString storeType = 'products'.obs;
  
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityIdController = TextEditingController();
  TextEditingController districtIdController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController currencyIdController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController tiktokController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController pinterestController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();
  
  RxList<Map<String, dynamic>> cities = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> districts = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> currencies = <Map<String, dynamic>>[].obs;
  
  RxString selectedCityName = 'اختر المدينة'.obs;
  RxString selectedDistrictName = 'اختر الحي'.obs;
  RxString selectedCurrencyName = 'اختر العملة'.obs;
  
  RxBool hidePhone = false.obs;
  
  RxString deliveryType = 'free'.obs;
  RxList<Map<String, dynamic>> shippingCompanies = <Map<String, dynamic>>[].obs;
  RxList<int> locationCities = <int>[].obs;
  RxList<int> serviceCities = <int>[].obs;
  
  RxList<MediaItem> selectedLogoMedia = <MediaItem>[].obs;
  Rx<MediaItem?> primaryLogo = Rx<MediaItem?>(null);
  RxList<MediaItem> selectedCoverMedia = <MediaItem>[].obs;
  Rx<MediaItem?> primaryCover = Rx<MediaItem?>(null);
  
  RxBool isUploadingLogo = false.obs;
  RxBool isUploadingCover = false.obs;
  RxMap<String, bool> logoUploadingStates = <String, bool>{}.obs;
  RxMap<String, bool> coverUploadingStates = <String, bool>{}.obs;
  
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxBool createStoreLoading = false.obs;
  
  RxInt editingStoreId = 0.obs;
  RxBool isEditMode = false.obs;
  
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    storeType.value = 'products';
    deliveryType.value = 'shipping';
    
    if (cityIdController.text.isEmpty) cityIdController.text = "1";
    if (districtIdController.text.isEmpty) districtIdController.text = "1";
    if (currencyIdController.text.isEmpty) currencyIdController.text = "2";
    
    loadInitialData();
  }

Future<void> loadInitialData() async {
  try {
    isLoading.value = true;
    print('🔄 تحميل البيانات الأولية...');
    
    print('🏙️ جلب قائمة المدن...');
    final citiesResponse = await ApiHelper.getCities();
    if (citiesResponse != null && citiesResponse['status'] == true) {
      final citiesList = List<Map<String, dynamic>>.from(citiesResponse['data'] ?? []);
      cities.assignAll(citiesList);
      print('✅ تم تحميل ${cities.length} مدينة');
      
      if (cityIdController.text.isNotEmpty) {
        selectedCityName.value = getCityName(cityIdController.text);
      }
    } else {
      print('⚠️ فشل تحميل المدن: ${citiesResponse?['message']}');
    }
    
    print('📍 جلب قائمة المقاطعات...');
    final districtsResponse = await ApiHelper.getDistricts();
    if (districtsResponse != null && districtsResponse['status'] == true) {
      final districtsList = List<Map<String, dynamic>>.from(districtsResponse['data'] ?? []);
      districts.assignAll(districtsList);
      print('✅ تم تحميل ${districts.length} مقاطعة');
      
      if (districtIdController.text.isNotEmpty) {
        selectedDistrictName.value = getDistrictName(districtIdController.text);
      }
    } else {
      print('⚠️ فشل تحميل المقاطعات: ${districtsResponse?['message']}');
    }
    
    print('💰 جلب قائمة العملات...');
    final currenciesResponse = await ApiHelper.getCurrencies();
    if (currenciesResponse != null && currenciesResponse['status'] == true) {
      final currenciesList = List<Map<String, dynamic>>.from(currenciesResponse['data'] ?? []);
      currencies.assignAll(currenciesList);
      print('✅ تم تحميل ${currencies.length} عملة');
      
      if (currencyIdController.text.isNotEmpty) {
        selectedCurrencyName.value = getCurrencyName(currencyIdController.text);
      }
    } else {
      print('⚠️ فشل تحميل العملات: ${currenciesResponse?['message']}');
    }
  } catch (e) {
    print('❌ خطأ في تحميل البيانات الأولية: $e');
  } finally {
    isLoading.value = false;
    print('✅ انتهى تحميل البيانات الأولية');
    update();
  }
}
Future<bool> updateStoreBasicInfo() async {
  try {
    createStoreLoading.value = true;
    
    if (nameController.text.isEmpty || emailController.text.isEmpty ||
        phoneController.text.isEmpty || selectedLogoMedia.isEmpty ||
        selectedCoverMedia.isEmpty) {
      Get.snackbar('خطأ', 'يرجى تعبئة جميع الحقول الإلزامية');
      return false;
    }
    
    bool hasLocalImages = selectedLogoMedia.any((m) => m.isLocal == true) ||
                        selectedCoverMedia.any((m) => m.isLocal == true);
    
    if (hasLocalImages) {
      final uploadSuccess = await uploadLocalImages();
      if (!uploadSuccess) {
        Get.snackbar('خطأ', 'فشل في رفع الصور المحلية');
        return false;
      }
    }
    
    Map<String, dynamic> data = {
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
    data['address'] = addressController.text.trim().isEmpty ? "العنوان" : addressController.text.trim();
    data['currency_id'] = int.tryParse(currencyIdController.text.trim()) ?? 2;
    
    data.removeWhere((key, value) {
      if (value == null) return true;
      if (value is String && value.isEmpty) return true;
      return false;
    });
    
    print('📤 تحديث البيانات الأساسية للمتجر: ${jsonEncode(data)}');
    
    final response = await ApiHelper.updateStore(editingStoreId.value, data);
    
    if (response != null && response['status'] == true) {
      Get.snackbar('نجاح', 'تم تحديث البيانات الأساسية',
          backgroundColor: Colors.green, colorText: Colors.white);
      return true;
    } else {
      Get.snackbar('خطأ', response?['message'] ?? 'فشل التحديث',
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  } catch (e) {
    Get.snackbar('خطأ', 'حدث خطأ أثناء التحديث: $e',
        backgroundColor: Colors.red, colorText: Colors.white);
    return false;
  } finally {
    createStoreLoading.value = false;
  }
}

Future<bool> saveCompleteStore() async {
  try {
    createStoreLoading.value = true;
    
    if (deliveryType.value == 'shipping') {
      if (shippingCompanies.isEmpty) {
        Get.snackbar('خطأ', 'يرجى إضافة شركة شحن واحدة على الأقل',
            backgroundColor: Colors.red, colorText: Colors.white);
        return false;
      }
      
      for (int i = 0; i < shippingCompanies.length; i++) {
        final company = shippingCompanies[i];
        if (company['prices'] == null ||
            (company['prices'] is List && company['prices'].isEmpty)) {
          Get.snackbar('خطأ', 'يرجى تعبئة أسعار التوصيل لشركة ${company['name']}',
              backgroundColor: Colors.red, colorText: Colors.white);
          return false;
        }
      }
    }
    
    Map<String, dynamic> data = {
      'type': storeType.value,
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'email': emailController.text.trim(),
      'city_id': int.tryParse(cityIdController.text.trim()) ?? 1,
      'district_id': int.tryParse(districtIdController.text.trim()) ?? 1,
      'address': addressController.text.trim().isEmpty ? "العنوان" : addressController.text.trim(),
      'currency_id': int.tryParse(currencyIdController.text.trim()) ?? 2,
      'phone': phoneController.text.trim(),
      'hide_phone': hidePhone.value ? "1" : "0",
      'delivery_type': deliveryType.value == 'free' ? 'hand' : deliveryType.value,
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
    
    if (deliveryType.value == 'shipping' && shippingCompanies.isNotEmpty) {
      List<Map<String, dynamic>> formattedCompanies = [];
      
      for (var company in shippingCompanies) {
        Map<String, dynamic> formattedCompany = {
          'name': company['name']?.toString() ?? '',
          'phone': company['phone']?.toString() ?? '',
        };
        
        if (company['prices'] != null && company['prices'] is List) {
          formattedCompany['prices'] = (company['prices'] as List).map((price) {
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
      
      Set<dynamic> allCities = {};
      for (var company in shippingCompanies) {
        if (company['prices'] != null && company['prices'] is List) {
          for (var price in company['prices']) {
            if (price['city_id'] != null) {
              allCities.add(price['city_id']);
            }
          }
        }
      }
      
      data['locationCities'] = allCities.toList();
      data['serviceCities'] = allCities.toList();
      
      print('🔥 شركات الشحن المرسلة: ${jsonEncode(formattedCompanies)}');
      print('🔥 المدن المجمعة: $allCities');
    }
    
    print('📤 البيانات النهائية المرسلة للخادم:');
    print(jsonEncode(data));
    
    dynamic response;
    
    if (isEditMode.value && editingStoreId.value > 0) {
      response = await ApiHelper.updateStore(editingStoreId.value, data);
    } else {
      response = await ApiHelper.post(
        path: '/merchants/mobile/stores',
        body: data,
        withLoading: true,
        shouldShowMessage: true,
      );
    }
    
    if (response != null && response['status'] == true) {
      print('✅ استجابة الخادم: ${jsonEncode(response)}');
      
      if (response['data'] != null) {
        final savedData = response['data'];
        if (savedData['shipping_companies'] != null || savedData['shippingCompanies'] != null) {
          print('✅ تم حفظ شركات الشحن بنجاح');
        }
      }
      
      Get.snackbar(
        '🎉 نجاح',
        isEditMode.value ? 'تم تحديث المتجر بنجاح' : 'تم إنشاء المتجر بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: Duration(seconds: 3),
      );
      
      resetData();
      return true;
    } else {
      final errorMsg = response?['message'] ?? 'فشل العملية';
      Get.snackbar('❌ خطأ', errorMsg,
          backgroundColor: Colors.red, colorText: Colors.white);
      return false;
    }
  } catch (e, stackTrace) {
    print('❌ خطأ في حفظ المتجر: $e');
    print('📜 Stack trace: $stackTrace');
    Get.snackbar('❌ خطأ', 'حدث خطأ أثناء الحفظ: $e',
        backgroundColor: Colors.red, colorText: Colors.white);
    return false;
  } finally {
    createStoreLoading.value = false;
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
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary50,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'اختر المدينة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.neutral900,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: ListView.builder(
                itemCount: cities.length,
                itemBuilder: (context, index) {
                  final city = cities[index];
                  final isSelected = cityIdController.text == city['id'].toString();
                  
                  return ListTile(
                    title: Text(
                      city['name']?.toString() ?? 'مدينة',
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected ? AppColors.primary400 : AppColors.neutral800,
                      ),
                    ),
                    trailing: isSelected
                        ? Icon(Icons.check_circle, color: AppColors.primary400)
                        : null,
                    onTap: () {
                      cityIdController.text = city['id'].toString();
                      selectedCityName.value = city['name']?.toString() ?? 'اختر المدينة';
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
    print('❌ خطأ في فتح قائمة المدن: $e');
  }
}

  Future<void> openDistrictSelection() async {
    try {
      if (districts.isEmpty) {
        Get.snackbar('جاري التحميل', 'جاري تحميل قائمة الأحياء...');
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
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'اختر الحي',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral900,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView.builder(
                  itemCount: districts.length,
                  itemBuilder: (context, index) {
                    final district = districts[index];
                    final isSelected = districtIdController.text == district['id'].toString();
                    
                    return ListTile(
                      title: Text(
                        district['name']?.toString() ?? 'حي',
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? AppColors.primary400 : AppColors.neutral800,
                        ),
                      ),
                      subtitle: district['city_name'] != null
                          ? Text(
                              'مدينة: ${district['city_name']}',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          : null,
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: AppColors.primary400)
                          : null,
                      onTap: () {
                        districtIdController.text = district['id'].toString();
                        selectedDistrictName.value = district['name']?.toString() ?? 'اختر الحي';
                        
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
      print('❌ خطأ في فتح قائمة الأحياء: $e');
    }
  }

  Future<void> openCurrencySelection() async {
    try {
      if (currencies.isEmpty) {
        Get.snackbar('جاري التحميل', 'جاري تحميل قائمة العملات...');
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
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'اختر العملة',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.neutral900,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              
              Expanded(
                child: ListView.builder(
                  itemCount: currencies.length,
                  itemBuilder: (context, index) {
                    final currency = currencies[index];
                    final isSelected = currencyIdController.text == currency['id'].toString();
                    
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
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary500,
                                  ),
                                ),
                              ),
                            )
                          : null,
                      title: Text(
                        currency['name']?.toString() ?? 'عملة',
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? AppColors.primary400 : AppColors.neutral800,
                        ),
                      ),
                      subtitle: currency['code'] != null
                          ? Text(
                              'الرمز: ${currency['code']}',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            )
                          : null,
                      trailing: isSelected
                          ? Icon(Icons.check_circle, color: AppColors.primary400)
                          : null,
                      onTap: () {
                        currencyIdController.text = currency['id'].toString();
                        selectedCurrencyName.value = currency['name']?.toString() ?? 'اختر العملة';
                        
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
      print('❌ خطأ في فتح قائمة العملات: $e');
    }
  }
String getCityName(String cityId) {
  if (cityId.isEmpty) return 'اختر المدينة';
  
  try {
    final city = cities.firstWhereOrNull(
      (c) => c['id'].toString() == cityId,
    );
    
    return city != null ? city['name']?.toString() ?? 'اختر المدينة' : 'اختر المدينة';
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
    
    return district != null ? district['name']?.toString() ?? 'اختر الحي' : 'اختر الحي';
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
    
    return currency != null ? currency['name']?.toString() ?? 'اختر العملة' : 'اختر العملة';
  } catch (e) {
    return 'اختر العملة';
  }
}
Future<void> loadStoreForEdit(int storeId) async {
  try {
    isLoading.value = true;
    isEditMode.value = true;
    editingStoreId.value = storeId;
    
    print('🔄 تحميل بيانات المتجر للتعديل - ID: $storeId');
    
    await loadInitialData();
    
    final response = await ApiHelper.getStoreDetails(storeId);
    
    print('📥 استجابة تفاصيل المتجر: ${response != null}');
    if (response != null) {
      print('📊 حالة الاستجابة: ${response['status']}');
    }
    
    if (response != null && response['status'] == true) {
      final storeData = response['record'] ?? response['data'];
      
      print('📦 بيانات المتجر: ${storeData != null}');
      if (storeData == null) {
        Get.snackbar('خطأ', 'بيانات المتجر غير موجودة');
        return;
      }
      
      print('📝 اسم المتجر: ${storeData['name']}');
      
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
      hidePhone.value = storeData['hide_phone'] == "1" ||
                        storeData['hide_phone'] == 1 ||
                        storeData['hide_phone'] == true;
      
      final deliveryTypeValue = storeData['delivery_type']?.toString() ?? 'free';
      deliveryType.value = deliveryTypeValue == 'hand_delivery' ? 'hand' : deliveryTypeValue;
      
      print('✅ تم تحميل بيانات المتجر بنجاح');
      
      await _loadStoreImages(storeData);
      
      update();
    } else {
      final errorMsg = response?['message'] ?? 'فشل تحميل بيانات المتجر';
      Get.snackbar('خطأ', errorMsg);
    }
  } catch (e, stackTrace) {
    print('❌ خطأ في تحميل بيانات المتجر: $e\n$stackTrace');
    Get.snackbar('خطأ', 'فشل في تحميل بيانات المتجر');
  } finally {
    isLoading.value = false;
  }
}
  void setStoreType(String type) {
    storeType.value = type;
  }
  
  void setDeliveryType(String type) {
    deliveryType.value = type;
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
  
  Future<void> _loadStoreImages(Map<String, dynamic> storeData) async {
    try {
      final logoUrl = storeData['logo_url']?.toString();
      final logoPath = storeData['logo']?.toString();
      
      print('🖼️ رابط الشعار: $logoUrl');
      print('🖼️ مسار الشعار: $logoPath');
      
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
        print('✅ تم تحميل صورة الشعار');
      } else {
        selectedLogoMedia.clear();
        primaryLogo.value = null;
        print('⚠️ لا توجد صورة شعار');
      }
      
      final coverUrls = storeData['cover_urls'];
      final coverPaths = storeData['cover'];
      
      print('🖼️ روابط الغلاف: $coverUrls');
      print('🖼️ مسارات الغلاف: $coverPaths');
      
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
          print('✅ تم تحميل ${selectedCoverMedia.length} صورة غلاف');
        } else {
          primaryCover.value = null;
          print('⚠️ لا توجد صور غلاف');
        }
      } else {
        selectedCoverMedia.clear();
        primaryCover.value = null;
        print('⚠️ لا توجد صور غلاف');
      }
    } catch (e) {
      print('❌ خطأ في تحميل صور المتجر: $e');
    }
  }
  
  void addShippingCompany(Map<String, dynamic> company) {
    shippingCompanies.add(company);
    
    if (company['prices'] != null && company['prices'] is List) {
      for (var price in company['prices']) {
        if (price['city_id'] != null && !locationCities.contains(price['city_id'])) {
          locationCities.add(price['city_id']);
        }
        if (price['city_id'] != null && !serviceCities.contains(price['city_id'])) {
          serviceCities.add(price['city_id']);
        }
      }
    }
  }
  
  void removeShippingCompany(int index) {
    shippingCompanies.removeAt(index);
  }
  
  void addLocationCity(int cityId) {
    if (!locationCities.contains(cityId)) {
      locationCities.add(cityId);
    }
  }
  
  void removeLocationCity(int cityId) {
    locationCities.remove(cityId);
  }
  
  void addServiceCity(int cityId) {
    if (!serviceCities.contains(cityId)) {
      serviceCities.add(cityId);
    }
  }
  
  void removeServiceCity(int cityId) {
    serviceCities.remove(cityId);
  }
  
  List<MediaItem> get selectedMedia {
    return [...selectedLogoMedia, ...selectedCoverMedia];
  }
  
  bool isLogoUploading(String mediaId) => logoUploadingStates[mediaId] ?? false;
  bool isCoverUploading(String mediaId) => coverUploadingStates[mediaId] ?? false;
  
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
        () => MediaLibraryScreen(
          isSelectionMode: true,
        ),
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
      }
    } catch (e) {
      print('❌ خطأ في فتح مكتبة الوسائط للشعار: $e');
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
        () => MediaLibraryScreen(
          isSelectionMode: true,
        ),
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
      }
    } catch (e) {
      print('❌ خطأ في فتح مكتبة الوسائط للغلاف: $e');
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
        final file = File(image.path);
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
      }
    } catch (e) {
      print('❌ خطأ في اختيار صورة الشعار: $e');
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
        final file = File(image.path);
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
      }
    } catch (e) {
      print('❌ خطأ في اختيار صورة الغلاف: $e');
      Get.snackbar('خطأ', 'فشل في اختيار الصورة');
    }
  }
  
  void removeLogo(int index) {
    if (index >= 0 && index < selectedLogoMedia.length) {
      final removedMedia = selectedLogoMedia[index];
      selectedLogoMedia.removeAt(index);
      
      if (primaryLogo.value?.id == removedMedia.id) {
        primaryLogo.value = selectedLogoMedia.isEmpty ? null : selectedLogoMedia.first;
      }
    }
  }
  
  void removeCover(int index) {
    if (index >= 0 && index < selectedCoverMedia.length) {
      final removedMedia = selectedCoverMedia[index];
      selectedCoverMedia.removeAt(index);
      
      if (primaryCover.value?.id == removedMedia.id) {
        primaryCover.value = selectedCoverMedia.isEmpty ? null : selectedCoverMedia.first;
      }
    }
  }
  
  void setPrimaryLogo(int index) {
    if (index >= 0 && index < selectedLogoMedia.length) {
      primaryLogo.value = selectedLogoMedia[index];
    }
  }
  
  void setPrimaryCover(int index) {
    if (index >= 0 && index < selectedCoverMedia.length) {
      primaryCover.value = selectedCoverMedia[index];
    }
  }
  
  String? _extractRelativePath(String? url) {
    if (url == null || url.isEmpty) return null;
    
    if (url.contains('/storage/')) {
      final parts = url.split('/storage/');
      return parts.length > 1 ? parts[1] : null;
    }
    
    if (url.contains('images/') || url.contains('gallery/') || url.contains('avatar/')) {
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
  
  Future<bool> uploadLocalImages() async {
    try {
      isUploadingLogo.value = true;
      isUploadingCover.value = true;
      
      bool hasLocalImages = false;
      
      for (int i = 0; i < selectedLogoMedia.length; i++) {
        final media = selectedLogoMedia[i];
        if (media.isLocal == true && media.path.isNotEmpty) {
          hasLocalImages = true;
          await uploadLogoMedia(media, i);
        }
      }
      
      for (int i = 0; i < selectedCoverMedia.length; i++) {
        final media = selectedCoverMedia[i];
        if (media.isLocal == true && media.path.isNotEmpty) {
          hasLocalImages = true;
          await uploadCoverMedia(media, i);
        }
      }
      
      return true;
    } catch (e) {
      print('❌ خطأ في رفع الصور المحلية: $e');
      return false;
    } finally {
      isUploadingLogo.value = false;
      isUploadingCover.value = false;
    }
  }
  
  Future<void> uploadLogoMedia(MediaItem media, int index) async {
    try {
      logoUploadingStates[media.id] = true;
      isUploadingLogo.value = true;
      
      final file = File(media.path);
      final response = await ApiHelper.uploadMedia(
        file: file,
        type: 'images',
        withLoading: false,
      );
      
      if (response != null && response['status'] == true) {
        final path = response['path'];
        
        selectedLogoMedia[index] = MediaItem(
          id: media.id,
          path: path,
          type: media.type,
          name: media.name,
          dateAdded: media.dateAdded,
          size: media.size,
          isLocal: false,
          fileName: _extractRelativePath(path),
          fileUrl: path,
        );
      }
    } catch (e) {
      print('❌ خطأ في رفع صورة الشعار: $e');
    } finally {
      logoUploadingStates[media.id] = false;
      isUploadingLogo.value = logoUploadingStates.values.any((state) => state);
    }
  }
  
  Future<void> uploadCoverMedia(MediaItem media, int index) async {
    try {
      coverUploadingStates[media.id] = true;
      isUploadingCover.value = true;
      
      final file = File(media.path);
      final response = await ApiHelper.uploadMedia(
        file: file,
        type: 'images',
        withLoading: false,
      );
      
      if (response != null && response['status'] == true) {
        final path = response['path'];
        
        selectedCoverMedia[index] = MediaItem(
          id: media.id,
          path: path,
          type: media.type,
          name: media.name,
          dateAdded: media.dateAdded,
          size: media.size,
          isLocal: false,
          fileName: _extractRelativePath(path),
          fileUrl: path,
        );
      }
    } catch (e) {
      print('❌ خطأ في رفع صورة الغلاف: $e');
    } finally {
      coverUploadingStates[media.id] = false;
      isUploadingCover.value = coverUploadingStates.values.any((state) => state);
    }
  }
  
Future<bool> createOrUpdateStore() async {
  try {
    createStoreLoading.value = true;
    
    print('🔥🔥🔥 التحقق من شركات الشحن قبل الإرسال 🔥🔥🔥');
    print('📦 عدد شركات الشحن: ${shippingCompanies.length}');
    
    if (deliveryType.value == 'shipping') {
      if (shippingCompanies.isEmpty) {
        print('⚠️ تحذير: تم اختيار شركات الشحن لكن القائمة فارغة');
        Get.snackbar(
          'تحذير',
          'تم اختيار "من خلال شركة التوصيل" لكن لم تضف أي شركة شحن',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      } else {
        print('✅ تمت إضافة ${shippingCompanies.length} شركة شحن');
        
        for (int i = 0; i < shippingCompanies.length; i++) {
          print('--- شركة الشحن ${i + 1} ---');
          print('الاسم: ${shippingCompanies[i]['name']}');
          print('الهاتف: ${shippingCompanies[i]['phone']}');
          
          if (shippingCompanies[i]['prices'] != null &&
              shippingCompanies[i]['prices'] is List) {
            final prices = shippingCompanies[i]['prices'] as List;
            print('عدد المدن: ${prices.length}');
            
            for (int j = 0; j < prices.length; j++) {
              print('  المدينة ${j + 1}: ${prices[j]['name']}');
              print('  أيام التوصيل: ${prices[j]['days']}');
              print('  السعر: ${prices[j]['price']}');
            }
          } else {
            print('⚠️ تحذير: لا توجد أسعار لهذه الشركة');
          }
        }
      }
    } else {
      print('📦 نوع التوصيل: ${deliveryType.value} (لا يتطلب شركات شحن)');
    }
    
    Map<String, dynamic> data = {
      'type': storeType.value,
      'name': nameController.text.trim(),
      'description': descriptionController.text.trim(),
      'email': emailController.text.trim(),
      'phone': phoneController.text.trim(),
      'hide_phone': hidePhone.value ? "1" : "0",
      'delivery_type': deliveryType.value == 'free' ? 'hand' : deliveryType.value,
    };
    
    if (!isEditMode.value) {
      data['owner_id'] = myAppController.userData['id']?.toString() ?? '41';
    }
    
    final primaryLogoPath = getPrimaryLogoPath();
    if (primaryLogoPath != null && primaryLogoPath.isNotEmpty) {
      data['logo'] = primaryLogoPath;
      print('✅ logo path: $primaryLogoPath');
    }
    
    final coverPaths = getAllCoverPaths();
    if (coverPaths.isNotEmpty) {
      data['cover'] = coverPaths;
      print('✅ cover paths: $coverPaths');
    }
    
    data['city_id'] = int.tryParse(cityIdController.text.trim()) ?? 1;
    data['district_id'] = int.tryParse(districtIdController.text.trim()) ?? 1;
    data['address'] = addressController.text.trim().isEmpty ? "العنوان" : addressController.text.trim();
    data['currency_id'] = int.tryParse(currencyIdController.text.trim()) ?? 2;
    
    if (latController.text.isNotEmpty && lngController.text.isNotEmpty) {
      data['lat'] = latController.text.trim();
      data['lng'] = lngController.text.trim();
    }
    
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
    
    final allLogoPaths = getAllLogoPaths();
    if (allLogoPaths.isNotEmpty) {
      data['logo_images'] = allLogoPaths;
      print('✅ logo_images: $allLogoPaths');
    }
    
    if (deliveryType.value == 'shipping' && shippingCompanies.isNotEmpty) {
      final formattedCompanies = shippingCompanies.map((company) {
        Map<String, dynamic> formattedCompany = {
          'name': company['name']?.toString() ?? '',
          'phone': company['phone']?.toString() ?? '',
        };
        
        if (company['prices'] != null && company['prices'] is List) {
          formattedCompany['prices'] = (company['prices'] as List).map((price) {
            return {
              'city_id': price['city_id'] ?? 0,
              'name': price['name']?.toString() ?? '',
              'days': int.tryParse(price['days'].toString()) ?? 0,
              'price': double.tryParse(price['price'].toString()) ?? 0.0,
            };
          }).toList();
        } else {
          formattedCompany['prices'] = [];
        }
        
        return formattedCompany;
      }).toList();
      
      data['shipping_companies'] = formattedCompanies;
      print('📤 شركات الشحن المرسلة: ${jsonEncode(formattedCompanies)}');
    }
    
    print('📤 جميع البيانات المرسلة للخادم:');
    print(jsonEncode(data));
    
    dynamic response;
    
    if (isEditMode.value && editingStoreId.value > 0) {
      response = await ApiHelper.updateStore(editingStoreId.value, data);
    } else {
      response = await ApiHelper.post(
        path: '/merchants/mobile/stores',
        body: data,
        withLoading: true,
        shouldShowMessage: true,
      );
    }
    
    if (response != null) {
      print('📥 استجابة الخادم:');
      print(jsonEncode(response));
      
      if (response['status'] == true) {
        if (response['data'] != null) {
          final savedData = response['data'];
          if (savedData['shipping_companies'] != null) {
            print('✅ تم حفظ شركات الشحن بنجاح');
            print('📦 عدد شركات الشحن المحفوظة: ${savedData['shipping_companies'].length}');
          } else {
            print('ℹ️ لم يتم حفظ شركات الشحن في الاستجابة');
          }
        }
        
        Get.snackbar(
          '🎉 نجاح',
          isEditMode.value ? 'تم تحديث المتجر بنجاح' : 'تم إنشاء المتجر بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        
        resetData();
        return true;
      } else {
        final errorMsg = response['message'] ?? 'فشل العملية';
        final errors = response['errors'] ?? {};
        
        if (errors.isNotEmpty) {
          String errorDetails = '';
          errors.forEach((key, value) {
            if (value is List) {
              errorDetails += '${key}: ${value.join(', ')}\n';
            } else {
              errorDetails += '${key}: $value\n';
            }
          });
          
          Get.snackbar(
            '❌ خطأ في البيانات',
            errorDetails,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: Duration(seconds: 5),
          );
        } else {
          Get.snackbar(
            '❌ خطأ',
            errorMsg,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
        return false;
      }
    } else {
      Get.snackbar(
        '❌ خطأ',
        'لم يتم الحصول على استجابة من الخادم',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    }
    
  } catch (e, stackTrace) {
    print('❌ خطأ أثناء العملية: $e');
    print('📜 Stack trace: $stackTrace');
    Get.snackbar(
      '❌ خطأ',
      'حدث خطأ أثناء العملية: ${e.toString()}',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
    return false;
  } finally {
    createStoreLoading.value = false;
  }
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