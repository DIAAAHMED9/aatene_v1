import '../../../general_index.dart';

class ShippingPricingSettings extends StatefulWidget {
  final String companyName;
  final String companyPhone;
  final List<Map<String, dynamic>> selectedCities;

  const ShippingPricingSettings({
    super.key,
    required this.companyName,
    required this.companyPhone,
    required this.selectedCities,
  });

  @override
  State<ShippingPricingSettings> createState() =>
      _ShippingPricingSettingsState();
}

class _ShippingPricingSettingsState extends State<ShippingPricingSettings> {
  final CreateStoreController controller = Get.find<CreateStoreController>();
  final DataInitializerService dataService = Get.find<DataInitializerService>();
  late List<TextEditingController> daysControllers;
  late List<TextEditingController> priceControllers;

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

  String? selectedNewCity;
  bool showAddCityField = false;
  List<Map<String, dynamic>> workingCities = [];

  @override
  void initState() {
    super.initState();

    workingCities = List.from(widget.selectedCities);

    daysControllers = List.generate(
      workingCities.length,
      (index) => TextEditingController(
        text: workingCities[index]['days']?.toString() ?? '',
      ),
    );

    priceControllers = List.generate(
      workingCities.length,
      (index) => TextEditingController(
        text: workingCities[index]['price']?.toString() ?? '',
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in daysControllers) {
      controller.dispose();
    }
    for (var controller in priceControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addCity(String cityName) {
    setState(() {
      final newCity = {
        'city_id': workingCities.length + 100,
        'name': cityName,
        'type': 'custom',
        'days': 0,
        'price': 0.0,
      };

      workingCities.add(newCity);
      daysControllers.add(TextEditingController(text: ''));
      priceControllers.add(TextEditingController(text: ''));
    });
  }

  void _removeCity(int index) {
    setState(() {
      workingCities.removeAt(index);
      daysControllers.removeAt(index).dispose();
      priceControllers.removeAt(index).dispose();
    });
  }

  void _updateCityData(int index, String days, String price) {
    setState(() {
      workingCities[index]['days'] = int.tryParse(days) ?? 0;
      workingCities[index]['price'] = double.tryParse(price) ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text("إعدادات التسعير", style: getBold(fontSize: 18)),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[100],
            ),
            child: Icon(Icons.arrow_back, color: AppColors.neutral100),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  Expanded(
                    child: Text(
                      "المدن التي ترسل لها المنتجات؟",
                      style: getBold(),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          showAddCityField = !showAddCityField;
                          if (!showAddCityField) {
                            selectedNewCity = null;
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
                          SizedBox(width: 4),
                          Text(
                            "إضافة منطقة جديدة",
                            style: getMedium(
                              color: AppColors.primary500,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              if (showAddCityField) ...[
                SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("المدينة", style: getMedium(fontSize: 14)),
                    SizedBox(height: 8),
                    Container(
                      height: 56,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.neutral300),
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedNewCity,
                          isExpanded: true,
                          hint: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "اختر المدينة",
                              style: getRegular(
                                color: AppColors.neutral400,
                                fontSize: 15,
                              ),
                            ),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: AppColors.primary500,
                              size: 15,
                            ),
                          ),
                          style: getRegular(fontSize: 15),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedNewCity = newValue;
                            });
                          },
                          items: citiesList.map<DropdownMenuItem<String>>((
                            String city,
                          ) {
                            return DropdownMenuItem<String>(
                              value: city,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(city),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              showAddCityField = false;
                              selectedNewCity = null;
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          child: Text(
                            "إلغاء",
                            style: getRegular(
                              color: AppColors.neutral600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        AateneButton(
                          onTap: selectedNewCity != null
                              ? () {
                                  _addCity(selectedNewCity!);
                                  setState(() {
                                    showAddCityField = false;
                                    selectedNewCity = null;
                                  });
                                }
                              : null,
                          buttonText: "إضافة",
                          color: AppColors.primary400,
                          borderColor: AppColors.primary400,
                          textColor: AppColors.light1000,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16),
              ],

              ...workingCities.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> city = entry.value;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: AppColors.primary500,
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(city['name'], style: getMedium()),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              _removeCity(index);
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
                      ),

                      SizedBox(height: 16),

                      Text("موعد التسليم", style: getMedium(fontSize: 14)),
                      SizedBox(height: 8),
                      TextFiledAatene(
                        textInputAction: TextInputAction.next,

                        isRTL: isRTL,
                        hintText: "عدد الأيام",
                        controller: daysControllers[index],
                        onChanged: (value) {
                          _updateCityData(
                            index,
                            value,
                            priceControllers[index].text,
                          );
                        }, textInputType: TextInputType.number,
                      ),

                      SizedBox(height: 16),

                      Text("سعر التوصيل", style: getMedium(fontSize: 14)),
                      SizedBox(height: 8),
                      TextFiledAatene(
                        textInputAction: TextInputAction.done,

                        isRTL: isRTL,
                        hintText: "السعر",
                        controller: priceControllers[index],
                        prefixIcon: Icon(
                          Icons.attach_money,
                          color: AppColors.neutral500,
                        ),
                        onChanged: (value) {
                          _updateCityData(
                            index,
                            daysControllers[index].text,
                            value,
                          );
                        }, textInputType: TextInputType.number,
                      ),
                    ],
                  ),
                );
              }).toList(),

              SizedBox(height: 32),
              AateneButton(
                buttonText: 'حفظ ملف التوصيل',
                textColor: Colors.white,
                color: AppColors.primary500,
                borderColor: AppColors.primary500,
                raduis: 12,
                onTap: () {
                  _saveShippingData();
                },
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveShippingData() {
    return UnifiedLoadingScreen.showWithFuture<void>(
      _saveShippingDataInternal(),
      message: 'جاري حفظ بيانات الشحن...',
    );
  }

  Future<void> _saveShippingDataInternal() async {
    for (int i = 0; i < workingCities.length; i++) {
      if (daysControllers[i].text.isEmpty) {
        Get.snackbar(
          'خطأ',
          'يرجى إدخال موعد التسليم لـ ${workingCities[i]['name']}',
          backgroundColor: Colors.red.shade500,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      if (priceControllers[i].text.isEmpty) {
        Get.snackbar(
          'خطأ',
          'يرجى إدخال سعر التوصيل لـ ${workingCities[i]['name']}',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade500,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      final days = int.tryParse(daysControllers[i].text);
      final price = double.tryParse(priceControllers[i].text);

      if (days == null || days <= 0) {
        Get.snackbar(
          'خطأ',
          'يرجى إدخال عدد أيام صحيح لـ ${workingCities[i]['name']}',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade500,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      if (price == null || price <= 0) {
        Get.snackbar(
          'خطأ',
          'يرجى إدخال سعر صحيح لـ ${workingCities[i]['name']}',
          backgroundColor: Colors.red.shade50,
          colorText: Colors.red.shade500,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }
    }

    final List<Map<String, dynamic>> prices = [];
    for (int i = 0; i < workingCities.length; i++) {
      prices.add({
        'city_id': workingCities[i]['city_id'],
        'name': workingCities[i]['name'],
        'days': int.parse(daysControllers[i].text),
        'price': double.parse(priceControllers[i].text),
      });
    }

    final company = {
      'name': widget.companyName,
      'phone': widget.companyPhone,
      'prices': prices,
    };

    controller.addShippingCompany(company);

    Get.back();
    Get.back();
    Get.snackbar(
      'نجاح',
      'تم إضافة شركة الشحن بنجاح',
      backgroundColor: Colors.green.shade50,
      colorText: Colors.green.shade700,
      snackPosition: SnackPosition.TOP,
    );
  }
}
