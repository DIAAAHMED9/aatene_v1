import '../../../general_index.dart';

class ChangeMobileNumber extends StatefulWidget {
  const ChangeMobileNumber({super.key});

  @override
  State<ChangeMobileNumber> createState() => _ChangeMobileNumberState();
}

String? selectedLanguage = 'ar';

class _ChangeMobileNumberState extends State<ChangeMobileNumber> {
  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "تغيير رقم الموبايل",
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
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10,
          children: [
            Text("ارقم الهاتف", style: getRegular(fontSize: 14)),
            TextFiledAatene(
              isRTL: isRTL,
              hintText: "01289022985",
              textInputType: TextInputType.phone,
              heightTextFiled: 45,
              prefixIcon: Icon(Icons.phone_outlined),
              textInputAction: TextInputAction.done,
            ),
            DropdownButtonFormField(
              value: selectedLanguage,
              hint: Text("اختر اللغة"),
              items: [
                DropdownMenuItem<String>(value: 'ar', child: Text('العربية')),
                DropdownMenuItem<String>(value: 'he', child: Text('عبري')),
                DropdownMenuItem<String>(value: 'en', child: Text('english')),
              ],
              onChanged: (value) {
                selectedLanguage = value;

                Get.updateLocale(Locale(value!));
              },
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: AateneButton(
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
            ),
          ],
        ),
      ),
    );
  }
}
