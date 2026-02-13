import 'package:animated_custom_dropdown/custom_dropdown.dart';
import '../../../general_index.dart';

class CityModel {
  final int id;
  final String name;

  CityModel({required this.id, required this.name});

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CityModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DistrictModel {
  final int id;
  final String name;

  DistrictModel({required this.id, required this.name});

  @override
  String toString() => name;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DistrictModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

//                      CONTROLLER
class PersonalInfoController extends GetxController {
  final fullNameController = TextEditingController();

  final bioController = TextEditingController();

  final RxString _selectedGenderApi = "".obs;

  String get selectedGenderApi => _selectedGenderApi.value;

  set selectedGenderApi(String value) => _selectedGenderApi.value = value;

  String get selectedGenderDisplay {
    if (_selectedGenderApi.value == 'male') return 'ذكر';
    if (_selectedGenderApi.value == 'female') return 'انثى';
    return '';
  }

  final RxString _dateOfBirthApi = "".obs;

  String get dateOfBirthApi => _dateOfBirthApi.value;

  set dateOfBirthApi(String value) => _dateOfBirthApi.value = value;

  final int maxBioLength = 100;
  RxInt remainingBio = 100.obs;
  RxBool isBioLimitExceeded = false.obs;

  final Rx<CityModel?> _selectedCity = Rx<CityModel?>(null);

  CityModel? get selectedCity => _selectedCity.value;

  set selectedCity(CityModel? value) => _selectedCity.value = value;

  final Rx<DistrictModel?> _selectedDistrict = Rx<DistrictModel?>(null);

  DistrictModel? get selectedDistrict => _selectedDistrict.value;

  set selectedDistrict(DistrictModel? value) => _selectedDistrict.value = value;

  final RxList<CityModel> cities = <CityModel>[].obs;
  final RxList<DistrictModel> districts = <DistrictModel>[].obs;

  final RxBool isLoadingPage = true.obs;
  final RxBool isLoadingCities = false.obs;
  final RxBool isLoadingDistricts = false.obs;

  // كاش المدن
  static List<CityModel>? _citiesCache;

  // دالة مساعدة للبحث
  E? firstWhereOrNull<E>(List<E> list, bool Function(E) test) {
    for (final element in list) {
      if (test(element)) return element;
    }
    return null;
  }

  @override
  void onInit() {
    super.onInit();

    bioController.addListener(() {
      final length = bioController.text.length;
      remainingBio.value = maxBioLength - length;
      isBioLimitExceeded.value = length >= maxBioLength;
    });

    loadInitialData();
  }

  // ============================================================
  // ✅ تحميل المدن أولاً ثم بيانات المستخدم
  Future<void> loadInitialData() async {
    isLoadingPage.value = true;

    // 1️⃣ أولاً: تحميل قائمة المدن
    await getCities();

    // 2️⃣ ثانياً: تحميل بيانات المستخدم (الآن المدن متوفرة)
    await getUserData();

    isLoadingPage.value = false;
  }

  // ============================================================
  // جلب بيانات المستخدم من API
  Future<void> getUserData() async {
    try {
      final response = await ApiHelper.get(path: '/auth/account/profile');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final user = data['user'];

          final firstName = user['first_name'] ?? '';
          final lastName = user['last_name'] ?? '';
          final fullname = user['fullname'] ?? '';
          fullNameController.text = user['fullname'] ?? '';

          bioController.text = user['bio'] ?? '';

          _selectedGenderApi.value = user['gender'] ?? '';

          _dateOfBirthApi.value = user['date_of_birth'] ?? '';

          final cityId = int.tryParse(user['city_id']?.toString() ?? '0') ?? 0;
          if (cityId != 0 && cities.isNotEmpty) {
            _selectedCity.value = firstWhereOrNull(
              cities,
              (c) => c.id == cityId,
            );
            debugPrint("✅ Selected city: ${_selectedCity.value?.name}");
          }

          if (cityId != 0) {
            await getDistricts(cityId);
            final districtId =
                int.tryParse(user['district_id']?.toString() ?? '0') ?? 0;
            if (districtId != 0 && districts.isNotEmpty) {
              _selectedDistrict.value = firstWhereOrNull(
                districts,
                (d) => d.id == districtId,
              );
              debugPrint(
                "✅ Selected district: ${_selectedDistrict.value?.name}",
              );
            }
          }
        }
      } else {
        debugPrint("❌ getUserData failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ getUserData error: $e");
    }
  }

  // ============================================================
  // جلب قائمة المدن
  Future<void> getCities() async {
    if (_citiesCache != null) {
      cities.value = _citiesCache!;
      debugPrint("✅ Cities loaded from cache: ${cities.length}");
      return;
    }

    try {
      isLoadingCities.value = true;
      final response = await ApiHelper.get(path: '/cities');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final List<dynamic> rawCities = data['cities'] ?? [];
          final citiesList = rawCities.map<CityModel>((city) {
            return CityModel(
              id: city['id'] is int
                  ? city['id']
                  : int.parse(city['id'].toString()),
              name: city['name'] ?? '',
            );
          }).toList();

          cities.value = citiesList;
          _citiesCache = citiesList;
          debugPrint("✅ Cities loaded from API: ${cities.length}");
        }
      } else {
        debugPrint("❌ getCities failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ getCities error: $e");
    } finally {
      isLoadingCities.value = false;
    }
  }

  // ============================================================
  // جلب الأحياء حسب المدينة
  Future<void> getDistricts(int cityId) async {
    try {
      isLoadingDistricts.value = true;
      final response = await ApiHelper.get(
        path: '/districts',
        queryParameters: {'city_id': cityId},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['status'] == true) {
          final List<dynamic> rawDistricts = data['districts'] ?? [];
          final districtsList = rawDistricts.map<DistrictModel>((district) {
            return DistrictModel(
              id: district['id'] is int
                  ? district['id']
                  : int.parse(district['id'].toString()),
              name: district['name'] ?? '',
            );
          }).toList();

          districts.value = districtsList;
          debugPrint(
            "✅ Districts loaded for city $cityId: ${districts.length}",
          );
        }
      } else {
        debugPrint("❌ getDistricts failed: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ getDistricts error: $e");
    } finally {
      isLoadingDistricts.value = false;
    }
  }

  // ============================================================
  // تغيير المدينة المحددة
  void changeCity(CityModel city) {
    _selectedCity.value = city;
    _selectedDistrict.value = null;
    districts.clear();
    getDistricts(city.id);
  }

  // ============================================================
  // تحديث بيانات الحساب
  Future<bool> updateAccount() async {
    try {
      final nameParts = fullNameController.text.trim().split(' ');
      final firstName = nameParts.isNotEmpty ? nameParts.first : "";
      final lastName = nameParts.length > 1
          ? nameParts.sublist(1).join(' ')
          : "";

      final formData = FormData.fromMap({
        'first_name': firstName,
        'last_name': lastName,
        'gender': _selectedGenderApi.value,
        'date_of_birth': _dateOfBirthApi.value,
        'bio': bioController.text,
        'city_id': _selectedCity.value?.id.toString() ?? '',
        'district_id': _selectedDistrict.value?.id.toString() ?? '',
      });

      final response = await ApiHelper.post(
        path: '/auth/account/update_account',
        body: formData,
      );

      return response.statusCode == 200;
    } catch (e) {
      debugPrint("❌ updateAccount error: $e");
      return false;
    }
  }

  // ============================================================
  @override
  void onClose() {
    fullNameController.dispose();
    bioController.dispose();
    super.onClose();
  }
}

// ============================================================
//                      الواجهة (UI)
// ============================================================
class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  final controller = Get.put(PersonalInfoController());
  final TextEditingController dateDisplayController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ever(controller._dateOfBirthApi, (String value) {
      if (value.isNotEmpty) {
        final parts = value.split('-');
        if (parts.length == 3) {
          dateDisplayController.text = "${parts[2]}/${parts[1]}/${parts[0]}";
        }
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      dateDisplayController.text =
          "${picked.day}/${picked.month}/${picked.year}";
      controller._dateOfBirthApi.value = picked
          .toIso8601String()
          .split('T')
          .first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "المعلومات الشخصية",
          style: getBold(color: AppColors.neutral100, fontSize: 20),
        ),
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
      body: Obx(() {
        if (controller.isLoadingPage.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("الاسم الكامل", style: getMedium(fontSize: 14)),
                TextFiledAatene(
                  controller: controller.fullNameController,
                  isRTL: isRTL,
                  hintText: "الاسم الكامل",
                  textInputType: TextInputType.name,
                  heightTextFiled: 45,
                  textInputAction: TextInputAction.next,
                ),

                TextWithStar(text: "الجنس"),
                CustomDropdown<String>(
                  hintText: 'اختر الجنس',
                  decoration: CustomDropdownDecoration(
                    closedBorder: Border.all(color: Colors.grey),
                    closedFillColor: Colors.grey[50],
                    closedBorderRadius: BorderRadius.circular(50),
                    hintStyle: getMedium(),
                    closedSuffixIcon: Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 15,
                      color: AppColors.neutral400,
                    ),
                  ),
                  items: const ['ذكر', 'انثى'],
                  initialItem: controller.selectedGenderDisplay.isEmpty
                      ? null
                      : controller.selectedGenderDisplay,
                  onChanged: (value) {
                    if (value == 'ذكر') {
                      controller.selectedGenderApi = 'male';
                    } else if (value == 'انثى') {
                      controller.selectedGenderApi = 'female';
                    }
                  },
                ),

                TextWithStar(text: "تاريخ الميلاد"),
                TextFiledAatene(
                  controller: dateDisplayController,
                  readOnly: true,
                  onTap: () => _selectDate(context),
                  isRTL: isRTL,
                  hintText: "4/11/1998",
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(7.0),
                    child: SvgPicture.asset(
                      'assets/images/svg_images/Calendar12.svg',
                      width: 13,
                      height: 13,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  textInputType: TextInputType.name,
                ),

                TextWithStar(text: "المدينة"),
                if (controller.isLoadingCities.value)
                  const LinearProgressIndicator()
                else if (controller.cities.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.red.shade200),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.red.shade50,
                    ),
                    child: const Text(
                      '⚠️ لا توجد مدن متوفرة حالياً',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  )
                else
                  CustomDropdown<String>(
                    hintText: 'اختر المدينة',
                    decoration: CustomDropdownDecoration(
                      closedBorder: Border.all(color: Colors.grey),
                      closedFillColor: Colors.grey[50],
                      closedBorderRadius: BorderRadius.circular(50),
                      hintStyle: getMedium(),
                      closedSuffixIcon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: 15,
                        color: AppColors.neutral400,
                      ),
                    ),
                    items: controller.cities.map((c) => c.name).toList(),
                    initialItem: controller.selectedCity?.name,
                    onChanged: (selectedName) {
                      if (selectedName != null) {
                        final city = controller.firstWhereOrNull(
                          controller.cities,
                          (c) => c.name == selectedName,
                        );
                        if (city != null) {
                          controller.changeCity(city);
                        }
                      }
                    },
                  ),

                TextWithStar(text: "الحي"),
                if (controller.isLoadingDistricts.value)
                  const LinearProgressIndicator()
                else if (controller.selectedCity == null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey.shade100,
                    ),
                    child: const Text(
                      'اختر المدينة أولاً',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                else if (controller.districts.isEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange.shade200),
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.orange.shade50,
                    ),
                    child: const Text(
                      '⚠️ لا توجد أحياء متوفرة لهذه المدينة',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.orange),
                    ),
                  )
                else
                  CustomDropdown<String>(
                    hintText: 'اختر الحي',
                    decoration: CustomDropdownDecoration(
                      closedBorder: Border.all(color: Colors.grey),
                      closedFillColor: Colors.grey[50],
                      closedBorderRadius: BorderRadius.circular(50),
                      hintStyle: getMedium(),
                      closedSuffixIcon: Icon(
                        Icons.arrow_forward_ios_sharp,
                        size: 15,
                        color: AppColors.neutral400,
                      ),
                    ),
                    items: controller.districts.map((d) => d.name).toList(),
                    initialItem: controller.selectedDistrict?.name,
                    onChanged: (selectedName) {
                      if (selectedName != null) {
                        final district = controller.firstWhereOrNull(
                          controller.districts,
                          (d) => d.name == selectedName,
                        );
                        if (district != null) {
                          controller.selectedDistrict = district;
                        }
                      }
                    },
                  ),

                Text("النبذة الشخصية", style: getMedium(fontSize: 14)),
                TextField(
                  controller: controller.bioController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    fillColor: Colors.grey[50],
                    hintText: "اكتب نبذة عن نفسك....",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                Row(
                  spacing: 5,
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.primary400,
                      size: 20,
                    ),
                    Expanded(
                      child: Text(
                        "لا بأس إن تجاوز النص 100 كلمة. يسمح بمرونة في عدد الكلمات حسب الحاجة.",
                        style: getMedium(
                          fontSize: 10,
                          color: AppColors.neutral400,
                        ),
                      ),
                    ),
                    Obx(() => Text("${controller.remainingBio.value}/100")),
                  ],
                ),
                const SizedBox(height: 10),

                AateneButton(
                  onTap: () async {
                    final success = await controller.updateAccount();
                    if (success) {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => SizedBox(
                          height: 300,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                spacing: 15,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green,
                                    size: 80,
                                  ),
                                  Text(
                                    "تمت العملية بنجاح",
                                    style: getBold(fontSize: 24),
                                  ),
                                  Text(
                                    "تم حفظ التغييرات بنجاح",
                                    style: getMedium(
                                      fontSize: 12,
                                      color: AppColors.neutral400,
                                    ),
                                  ),
                                  AateneButton(
                                    buttonText: "العودة للاعدادات",
                                    color: AppColors.primary400,
                                    borderColor: AppColors.primary400,
                                    textColor: AppColors.light1000,
                                    onTap: () {
                                      Get.to(() => const HomeControl());
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      Get.snackbar(
                        "خطأ",
                        "فشل تحديث البيانات",
                        backgroundColor: Colors.red,
                        colorText: Colors.white,
                      );
                    }
                  },
                  buttonText: "حفظ",
                  color: AppColors.primary400,
                  borderColor: AppColors.primary400,
                  textColor: AppColors.light1000,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
