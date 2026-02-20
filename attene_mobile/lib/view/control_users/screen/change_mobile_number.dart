import '../../../general_index.dart';
import '../controller/profile_controller.dart';

class ChangeMobileNumber extends StatefulWidget {
  const ChangeMobileNumber({super.key});

  @override
  State<ChangeMobileNumber> createState() => _ChangeMobileNumberState();
}

class _ChangeMobileNumberState extends State<ChangeMobileNumber> {
  final ProfileCotrolController controller = Get.put(ProfileCotrolController());

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
          children: [
            Text("رقم الهاتف", style: getMedium(fontSize: 14)),
            const SizedBox(height: 8),
            TextFiledAatene(
              isRTL: isRTL,
              hintText: "01289022985",
              controller: controller.phoneController,
              textInputType: TextInputType.phone,
              heightTextFiled: 45,
              prefixIcon: Icon(Icons.phone_outlined),
              textInputAction: TextInputAction.done,
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: AateneButton(
                onTap: () async {
                  final phone = controller.phoneController.text.trim();

                  if (phone.isEmpty || phone.length < 9) {
                    Get.snackbar(
                      'تنبيه',
                      'الرجاء إدخال رقم هاتف صالح',
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  Get.dialog(
                    const Center(child: CircularProgressIndicator()),
                    barrierDismissible: false,
                  );

                  final success = await controller.updatePhone(phone);

                  if (Get.isDialogOpen == true) Get.back();

                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SizedBox(
                      height: 300,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle_rounded,

                                color: Colors.green,
                                size: 80,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "تمت العملية بنجاح",
                                style: getBold(fontSize: 24),
                              ),
                              const SizedBox(height: 8),
                              if (success)
                                Text(
                                  "تم حفظ التغييرات بنجاح",
                                  style: getMedium(
                                    fontSize: 12,
                                    color: AppColors.neutral400,
                                  ),
                                ),
                              const SizedBox(height: 16),
                              AateneButton(
                                buttonText: "العودة للإعدادات",
                                color: AppColors.primary400,
                                borderColor: AppColors.primary400,
                                textColor: AppColors.light1000,
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