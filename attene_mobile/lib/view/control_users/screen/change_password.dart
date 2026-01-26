import '../../../general_index.dart';

class ChangePassword extends StatelessWidget {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "تغيير كلمة المرور",
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("كلمة المرور القديمة", style: getRegular(fontSize: 12)),
            TextFiledAatene(
              isRTL: isRTL,
              hintText: isRTL ? 'كلمة المرور' : 'Password',
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 12),
            Divider(),
            SizedBox(height: 12),
            Text("كلمة المرور الجديدة", style: getRegular(fontSize: 12)),
            TextFiledAatene(
              isRTL: isRTL,
              hintText: isRTL ? 'كلمة المرور' : 'Password',
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: 12),
            Text("تأكيد كلمة المرور الجديدة", style: getRegular(fontSize: 12)),
            TextFiledAatene(
              isRTL: isRTL,
              hintText: isRTL ? 'كلمة المرور' : 'Password',
              textInputType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
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
                                "تم اعادة تعيين كلمة المرور بنجاح",
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
