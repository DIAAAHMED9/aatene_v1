import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/component/aatene_button/aatene_button.dart';
import 'package:attene_mobile/component/aatene_text_filed.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_utils.dart';
import 'package:attene_mobile/view/Services/data_lnitializer_service.dart';
import 'package:attene_mobile/view/Services/unified_loading_screen.dart';

import '../../../controller/create_store_controller.dart';
import 'add_shipping_method.dart';

class AddNewShippingCompany extends StatefulWidget {
  const AddNewShippingCompany({super.key});

  @override
  State<AddNewShippingCompany> createState() => _AddNewShippingCompanyState();
}

class _AddNewShippingCompanyState extends State<AddNewShippingCompany> {
  final CreateStoreController controller = Get.find<CreateStoreController>();
  final DataInitializerService dataService = Get.find<DataInitializerService>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final List<Map<String, String>> countryCodes = [
    {'code': '+970', 'country': 'فلسطين'},
    {'code': '+966', 'country': 'السعودية'},
    {'code': '+971', 'country': 'الإمارات'},
    {'code': '+962', 'country': 'الأردن'},
    {'code': '+963', 'country': 'سوريا'},
    {'code': '+974', 'country': 'قطر'},
    {'code': '+965', 'country': 'الكويت'},
    {'code': '+968', 'country': 'عمان'},
    {'code': '+973', 'country': 'البحرين'},
    {'code': '+20', 'country': 'مصر'},
  ];

  final List<Map<String, dynamic>> predefinedCities = [
    {'id': 1, 'name': 'القدس وضواحيها', 'selected': false},
    {'id': 2, 'name': 'مناطق الداخل', 'selected': false},
    {'id': 3, 'name': 'الضفة الغربية', 'selected': false},
  ];

  final List<String> citiesList = [
    'القدس',
    'رام الله',
    'بيت لحم',
    'الخليل',
    'نابلس',
    'أريحا',
    'غزة',
    'خان يونس',
    'رفح',
    'طولكرم',
    'قلقيلية',
    'سلفيت',
    'طوباس',
    'جنين',
  ];

  String selectedCountryCode = '+970';
  String? selectedCity;
  List<Map<String, dynamic>> selectedCities = [];
  bool showAddCityField = false;

  @override
  void initState() {
    super.initState();
    // تحميل المدن من التخزين المحلي
    _loadCitiesFromCache();
  }

  void _loadCitiesFromCache() {
    final cachedCities = dataService.getCities();
    if (cachedCities.isNotEmpty) {
      // يمكن استخدام البيانات المخزنة هنا
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "إضافة شركة شحن جديدة",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppColors.neutral100,
            ),
            child: Icon(Icons.arrow_back_ios_new_rounded,
                size: 18,
                color: AppColors.neutral700),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "اسم شركة الشحن",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "اكتب اسم الشركة هنا",
                controller: nameController,
              ),
              SizedBox(height: 20),
              
              Text(
                "رقم الهاتف",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 8),
              Container(
                height: 56,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.neutral300, width: 1.5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Icon(Icons.phone_outlined,
                          size: 20,
                          color: AppColors.neutral500),
                    ),
                    Expanded(
                      child: TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                        decoration: InputDecoration(
                          hintText: "0999988888",
                          hintStyle: TextStyle(
                            color: AppColors.neutral400,
                            fontSize: 15,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(right: 12),
                        ),
                      ),
                    ),
                    Container(
                      width: 110,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      margin: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primary100,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCountryCode,
                          icon: Icon(Icons.arrow_drop_down,
                              color: AppColors.primary500,
                              size: 24),
                          isExpanded: true,
                          style: TextStyle(
                            color: AppColors.primary400,
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCountryCode = newValue!;
                            });
                          },
                          items: countryCodes.map<DropdownMenuItem<String>>((Map<String, String> code) {
                            return DropdownMenuItem<String>(
                              value: code['code'],
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(code['code']!),
                                  SizedBox(width: 4),
                                  Icon(Icons.flag, size: 16,
                                      color: AppColors.primary400),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
              Divider(color: AppColors.neutral800, height: 1),
              SizedBox(height: 24),
              
              Text(
                "المدن التي ترسل لها المنتجات",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 16),
              
              Column(
                children: predefinedCities.map((city) {
                  return Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Checkbox(
                          value: city['selected'],
                          onChanged: (bool? value) {
                            setState(() {
                              city['selected'] = value!;
                              if (value) {
                                selectedCities.add({
                                  'city_id': city['id'],
                                  'name': city['name'],
                                  'type': 'predefined',
                                });
                              } else {
                                selectedCities.removeWhere((c) =>
                                    c['city_id'] == city['id'] &&
                                    c['type'] == 'predefined');
                              }
                            });
                          },
                          activeColor: AppColors.primary500,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          city['name'],
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                            fontWeight: city['selected']
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              
              SizedBox(height: 16),
              GestureDetector(
                onTap: () {
                  setState(() {
                    showAddCityField = !showAddCityField;
                    if (!showAddCityField) {
                      selectedCity = null;
                    }
                  });
                },
                child: Row(
                  children: [
                    Icon(
                      showAddCityField ? Icons.remove : Icons.add,
                      color: AppColors.primary500,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      "إضافة منطقة جديدة غير موجودة",
                      style: TextStyle(
                        color: AppColors.primary500,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              
              if (showAddCityField) ...[
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "المدينة",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neutral300),
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCity,
                          isExpanded: true,
                          hint: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "اختر المدينة",
                              style: TextStyle(
                                color: AppColors.neutral400,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Icon(Icons.arrow_drop_down,
                                color: AppColors.primary500,
                                size: 24),
                          ),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 15,
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedCity = newValue;
                            });
                          },
                          items: citiesList.map<DropdownMenuItem<String>>((String city) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(city),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showAddCityField = false;
                              selectedCity = null;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                          ),
                          child: Text(
                            "إلغاء",
                            style: TextStyle(
                              color: AppColors.neutral600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: selectedCity != null
                              ? () {
                                  if (!selectedCities.any((c) =>
                                      c['name'] == selectedCity)) {
                                    setState(() {
                                      selectedCities.add({
                                        'city_id': selectedCities.length + 10,
                                        'name': selectedCity!,
                                        'type': 'custom',
                                      });
                                      showAddCityField = false;
                                      selectedCity = null;
                                    });
                                  }
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary500,
                            padding: EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "إضافة المدينة",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
              
              if (selectedCities.isNotEmpty) ...[
                SizedBox(height: 24),
                Text(
                  "المدن المختارة",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 12),
                ...selectedCities.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> city = entry.value;
                  return Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: AppColors.primary500,
                        size: 20,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              city['name'],
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            if (city['type'] == 'custom')
                              Text(
                                "مدينة مضافة",
                                style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.neutral500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (city['type'] == 'custom') ...[
                        SizedBox(width: 8),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              selectedCities.removeAt(index);
                            });
                          },
                          icon: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.delete_outline,
                              color: Colors.red.shade500,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                }).toList(),
              ],
              
              SizedBox(height: 32),
              AateneButton(
                buttonText: 'التالي',
                textColor: Colors.white,
                color: AppColors.primary500,
                borderColor: AppColors.primary500,
                raduis: 12,
                onTap: () {
                  _validateAndGoToPricing();
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _validateAndGoToPricing() {
    if (nameController.text.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى إدخال اسم شركة الشحن',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade500,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    
    if (phoneController.text.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى إدخال رقم الهاتف',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade500,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    
    if (selectedCities.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار مدينة واحدة على الأقل',
        backgroundColor: Colors.red.shade50,
        colorText: Colors.red.shade500,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    
    Get.to(() => ShippingPricingSettings(
      companyName: nameController.text,
      companyPhone: '$selectedCountryCode${phoneController.text}',
      selectedCities: selectedCities,
    ));
  }
}