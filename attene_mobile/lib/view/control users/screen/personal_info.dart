import '../../../general_index.dart';

class PersonalInfo extends StatefulWidget {
  PersonalInfo({super.key});

  @override
  State<PersonalInfo> createState() => _PersonalInfoState();
}

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
              Text("الاسم الكامل", style: getRegular(fontSize: 14)),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "الاسم الكامل",
                textInputType: TextInputType.name,
                heightTextFiled: 45,
                textInputAction: TextInputAction.next,
              ),
              TextWithStar(text: "الجنس"),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  fillColor: Colors.grey[50],
                  isDense: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(),
                    borderRadius: BorderRadius.circular((50)),
                  ),
                ),
                dropdownColor: AppColors.primary50,
                icon: Icon(Icons.arrow_forward_ios, size: 15),
                value: selectedLanguage,
                hint: Text("اختر اللغة"),
                items: [
                  DropdownMenuItem<String>(
                    value: 'ar',
                    child: Text('ذكر', style: getRegular(fontSize: 14)),
                  ),
                  DropdownMenuItem<String>(
                    value: 'he',
                    child: Text('انتى', style: getRegular(fontSize: 14)),
                  ),
                ],
                onChanged: (value) {
                  selectedLanguage = value;

                  Get.updateLocale(Locale(value!));
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
                suffixIcon: Image.asset(
                  'assets/images/png/Calendar.png',
                  width: 24,
                  height: 24,
                ),
                textInputAction: TextInputAction.next, textInputType: TextInputType.name,
              ),
              TextWithStar(text: "المدينة"),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  fillColor: Colors.grey[50],
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular((50)),
                  ),
                ),
                dropdownColor: AppColors.primary50,
                value: selectedLanguage,
                icon: Icon(Icons.arrow_forward_ios, size: 15),
                hint: Text("اختر اللغة"),
                items: [
                  DropdownMenuItem<String>(
                    value: 'ar',
                    child: Text('الناصرة', style: getRegular(fontSize: 14)),
                  ),
                  DropdownMenuItem<String>(
                    value: 'he',
                    child: Text('القدس', style: getRegular(fontSize: 14)),
                  ),
                ],
                onChanged: (value) {
                  selectedLanguage = value;
                  Get.updateLocale(Locale(value!));
                },
              ),

              TextWithStar(text: "الحي"),
              DropdownButtonFormField(
                decoration: InputDecoration(
                  fillColor: Colors.grey[50],
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular((50)),
                  ),
                ),
                dropdownColor: AppColors.primary50,
                icon: Icon(Icons.arrow_forward_ios, size: 15),
                value: selectedLanguage,
                hint: Text("اختر اللغة"),
                items: [
                  DropdownMenuItem<String>(
                    value: 'ar',
                    child: Text('الناصرة', style: getRegular(fontSize: 14)),
                  ),
                  DropdownMenuItem<String>(
                    value: 'he',
                    child: Text('القدس', style: getRegular(fontSize: 14)),
                  ),
                ],
                onChanged: (value) {
                  selectedLanguage = value;

                  Get.updateLocale(Locale(value!));
                },
              ),
              Text("النبذة الشخصية", style: getRegular(fontSize: 14)),
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
                  Text(
                    "لا بأس إن تجاوز النص 300 كلمة.يسمح بمرونة في \n عدد الكلمات حسب الحاجة.",
                    style: getRegular(
                      fontSize: 10,
                      color: AppColors.neutral400,
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
                                style: getBlack(fontSize: 25),
                              ),
                              Text(
                                "تم حفظ التغييرات بنجاح",
                                style: getRegular(
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                      builder: (context) => HomeControl(),
                                    ),
                                  );
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
