import 'package:animated_custom_dropdown/custom_dropdown.dart';

import '../../../general_index.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

const List<String> _listGeral = ['ذكر', 'انثى'];
const List<String> _listCity = ['الناصرة ', 'القدس', 'خليل'];
const List<String> _listCountry = ['الناصرة ', 'القدس', 'خليل'];

class _PersonalInfoState extends State<PersonalInfo> {
  TextEditingController dateController = TextEditingController();

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("الاسم الكامل", style: getMedium(fontSize: 14)),
              TextFiledAatene(
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
                  // listItemStyle: getMedium(color: AppColors.primary400),
                ),
                items: _listGeral,
                initialItem: _listGeral[0],
                onChanged: (value) {
                  print('changing value to: $value');
                },
              ),
              TextWithStar(text: "تاريخ الميلاد"),
              TextFiledAatene(
                controller: dateController,
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
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
                  // listItemStyle: getMedium(color: AppColors.primary400),
                ),
                items: _listCity,
                initialItem: _listCity[0],
                onChanged: (value) {
                  print('changing value to: $value');
                },
              ),
              TextWithStar(text: "الحي"),
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
                  // listItemStyle: getMedium(color: AppColors.primary400),
                ),
                items: _listCountry,
                initialItem: _listCountry[0],
                onChanged: (value) {
                  print('changing value to: $value');
                },
              ),
              // DropdownButtonFormField(
              //   decoration: InputDecoration(
              //     fillColor: Colors.grey[50],
              //     isDense: true,
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular((50)),
              //     ),
              //   ),
              //   dropdownColor: AppColors.primary50,
              //   icon: Icon(Icons.arrow_forward_ios, size: 15),
              //   value: selectedLanguage,
              //   hint: Text("اختر اللغة"),
              //   items: [
              //     DropdownMenuItem<String>(
              //       value: 'ar',
              //       child: Text('الناصرة', style: getRegular(fontSize: 14)),
              //     ),
              //     DropdownMenuItem<String>(
              //       value: 'he',
              //       child: Text('القدس', style: getRegular(fontSize: 14)),
              //     ),
              //   ],
              //   onChanged: (value) {
              //     selectedLanguage = value;
              //
              //     Get.updateLocale(Locale(value!));
              //   },
              // ),
              Text("النبذة الشخصية", style: getMedium(fontSize: 14)),
              TextField(
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
                      "لا بأس إن تجاوز النص 300 كلمة.يسمح بمرونة في عدد الكلمات حسب الحاجة.",
                      style: getMedium(
                        fontSize: 10,
                        color: AppColors.neutral400,
                      ),
                    ),
                  ),
                  Text("0/50"),
                ],
              ),
              SizedBox(height: 10),
              AateneButton(
                onTap: () {
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
                                  Get.to(HomeControl());
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                buttonText: "حفظ",
                color: AppColors.primary400,
                borderColor: AppColors.primary400,
                textColor: AppColors.light1000,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }
}
