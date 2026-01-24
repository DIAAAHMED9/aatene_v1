import '../../../general_index.dart';

class ShowReport extends StatelessWidget {
  const ShowReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "الشكاوى والاقتراحات",
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Container(
            height: 500,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary400, width: 2),
              boxShadow: [
                BoxShadow(
                  color: AppColors.neutral700.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: Offset(4, 5),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("تفاصيل الشكوي", style: getBold(fontSize: 18)),
                    Row(
                      children: [
                        Text("رقم الشكوي", style: getRegular()),
                        Spacer(),
                        Text(
                          "C-2020-001",
                          style: getBold(color: AppColors.primary400),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text("الحالة"),
                        Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppColors.colorShowReport,
                            border: Border.all(color: AppColors.customColor02),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            child: Center(
                              child: Text(
                                "قيد المعالجة",
                                style: getRegular(
                                  fontSize: 10,
                                  color: AppColors.customColor03,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text("تاريخ التقديم"),
                        Spacer(),
                        Text(
                          "2025-10-22",
                          style: getBold(color: AppColors.primary400),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text("العنوان"),
                        Spacer(),
                        Text(
                          "شكوي خاصة بالتوصيل",
                          style: getRegular(color: Colors.grey),
                        ),
                      ],
                    ),
                    Divider(),
                    Row(
                      children: [
                        Text("الوصف"),
                        Spacer(),
                        Text(
                          "التوصيل لم يتم في ميعادة",
                          style: getRegular(color: Colors.grey),
                        ),
                      ],
                    ),
                    Divider(),
                    AateneButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => HomeControl(),
                          ),
                        );
                      },
                      buttonText: "إغلاق",
                      color: AppColors.primary400,
                      borderColor: AppColors.primary400,
                      textColor: AppColors.light1000,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
