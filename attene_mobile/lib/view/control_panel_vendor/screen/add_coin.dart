import '../../../general_index.dart';

class AddCoin extends StatelessWidget {
  const AddCoin({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "شراء عملات",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text("اكتب عدد العملات", style: getMedium(fontSize: 14)),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "0",
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              Text(
                "كل 5 عملات ذهبية تساوي 1 شيكل",
                style: getMedium(fontSize: 12, color: AppColors.neutral500),
              ),
              Divider(color: AppColors.primary50, thickness: 1, height: 20),
              Text("أدخل بيانات الدفع", style: getMedium(fontSize: 18)),
              Text("رقم البطاقة الائتمانية", style: getMedium(fontSize: 14)),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "0000  0000 0000 0000",
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.next,
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Image.asset(
                    'assets/images/png/card.png',
                    width: 50,
                    height: 15,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("تاريخ الانتهاء", style: getMedium(fontSize: 14)),
                        TextFiledAatene(
                          isRTL: isRTL,
                          hintText: "MM/YY",
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("رمز CVV", style: getMedium(fontSize: 14)),
                        TextFiledAatene(
                          isRTL: isRTL,
                          hintText: "000",
                          textInputType: TextInputType.number,
                          textInputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text("الاسم الأول", style: getMedium(fontSize: 14)),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "الاسم كما يوجد في البطاقة",
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              Text("اسم العائلة", style: getMedium(fontSize: 14)),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "الاسم كما يوجد في البطاقة",
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.next,
              ),
              Text("رقم التليفون", style: getMedium(fontSize: 14)),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "50000000",
                textInputType: TextInputType.number,
                textInputAction: TextInputAction.next,
              ),
              Text("العنوان", style: getMedium(fontSize: 14)),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "العنوان",
                textInputType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
              Divider(height: 20, color: AppColors.primary50, thickness: 1),
              Text("ملخص الطلب", style: getBold(fontSize: 18)),
              Row(
                children: [
                  Text(
                    "عدد العملات",
                    style: getMedium(fontSize: 14, color: AppColors.neutral400),
                  ),
                  Spacer(),
                  Text("1000 عملة ذهبية", style: getBold(fontSize: 14)),
                ],
              ),
              Row(
                children: [
                  Text(
                    "السعر",
                    style: getMedium(fontSize: 14, color: AppColors.neutral400),
                  ),
                  Spacer(),
                  Text("1200.0 ₪", style: getBold(fontSize: 14)),
                ],
              ),
              Divider(height: 20, color: AppColors.primary50, thickness: 1),
              Row(
                children: [
                  Text(
                    "الاجمالي",
                    style: getMedium(fontSize: 14, color: AppColors.neutral400),
                  ),
                  Spacer(),
                  Text(
                    "1200.0 ₪",
                    style: getBold(fontSize: 14, color: AppColors.primary400),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(15),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Text(
                      "رصيدك بعد الشراء سيصبح",
                      style: getMedium(
                        fontSize: 14,
                        color: AppColors.neutral400,
                      ),
                    ),
                    Spacer(),
                    Text("1130 عملة ذهبية", style: getBold(fontSize: 14)),
                  ],
                ),
              ),
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
                                "تمت اضافة 1000 عملة ذهبية إلى حسابك",
                                style: getRegular(
                                  fontSize: 12,
                                  color: AppColors.neutral400,
                                ),
                              ),
                              AateneButton(
                                buttonText: "الذهاب الى إدارة الاعلانات",
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
                buttonText: "ادفع الآن",
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
}
