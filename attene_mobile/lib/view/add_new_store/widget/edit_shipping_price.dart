import '../../../general_index.dart';

class EditShippingPrice extends StatelessWidget {
  const EditShippingPrice({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "إضافة شركة شحن جديدة",
          style: getBold(color: AppColors.neutral100, fontSize: 20),
        ),
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
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 10,
            children: [
              Row(
                children: [
                  Text(
                    "المدن التي ترسل لها المنتجات؟",
                    style: getBold(fontSize: 18),
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Icon(Icons.add, color: AppColors.primary400),
                        Text(
                          "إضافة شركة شحن",
                          style: getBold(
                            color: AppColors.primary400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text("القدس وضواحيها", style: getBold(fontSize: 18)),
                  Spacer(),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      color: AppColors.error200,
                    ),
                  ),
                ],
              ),
              Text("موعد التسليم"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "٣",
                suffixIcon: Icon(Icons.keyboard_arrow_down, size: 30),
                textInputAction: TextInputAction.next, textInputType: TextInputType.number,
              ),
              Text("سعر التوصيل"),
              TextFiledAatene(
                isRTL: isRTL,
                hintText: "٣",
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    "₪",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                textInputAction: TextInputAction.done, textInputType: TextInputType.number,
              ),
              AateneButtonWithIcon(buttonText: "حفظ ملف التوصيل"),
            ],
          ),
        ),
      ),
    );
  }
}
