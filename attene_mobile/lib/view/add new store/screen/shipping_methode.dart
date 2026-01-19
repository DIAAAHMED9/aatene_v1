import '../../../general_index.dart';

class AddShippingMethod extends StatelessWidget {
  AddShippingMethod({super.key});

  final CreateStoreController controller = Get.find<CreateStoreController>();
  final DataInitializerService dataService = Get.find<DataInitializerService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "طريقة الشحن",
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
      body: Column(
        children: [
          _buildShippingMethodSection(),

          Container(
            height: 1,
            color: Colors.grey[300],
            margin: EdgeInsets.symmetric(vertical: 20),
          ),

          _buildShippingCompaniesSection(),

          _buildSaveButton(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildShippingMethodSection() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "كيف توجد شحن المنتجات؟",
            style: getBold(fontSize: 18, color: AppColors.neutral100),
          ),
          SizedBox(height: 15),

          Obx(
            () => Column(
              children: [
                // _buildShippingOption(
                //   value: 'free',
                //   title: 'مجاني',
                //   subtitle: 'توصيل مجاني للمنتجات',
                //   icon: Icons.local_shipping,
                // ),
                SizedBox(height: 12),

                _buildShippingOption(
                  value: 'shipping',
                  title: 'من خلال شركة التوصيل',
                  subtitle: 'استخدام شركات الشحن المتاحة',
                  icon: Icons.business,
                ),

                SizedBox(height: 12),

                _buildShippingOption(
                  value: 'hand',
                  title: 'من يد ليد',
                  subtitle: 'دون شركة توصيل',
                  icon: Icons.handshake,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShippingOption({
    required String value,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        controller.setDeliveryType(value);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: controller.deliveryType.value == value
                      ? AppColors.primary400
                      : Colors.grey[400]!,
                  width: 2,
                ),
                color: controller.deliveryType.value == value
                    ? AppColors.primary400
                    : Colors.white,
              ),
              child: controller.deliveryType.value == value
                  ? Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            SizedBox(width: 12),

            Text(title, style: getMedium()),
          ],
        ),
      ),
    );
  }

  Widget _buildShippingCompaniesSection() {
    return Obx(() {
      if (controller.deliveryType.value != 'shipping') {
        return SizedBox();
      }

      return Expanded(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("شركات الشحن", style: getBold()),

                  GestureDetector(
                    onTap: () {
                      Get.to(() => AddNewShippingCompany());
                    },
                    child: Row(
                      children: [
                        Icon(Icons.add, color: AppColors.primary400, size: 18),
                        SizedBox(width: 6),
                        Text(
                          "إضافة شركة شحن",
                          style: getRegular(
                            color: AppColors.primary400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: controller.shippingCompanies.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.local_shipping,
                              size: 64,
                              color: Colors.grey[300],
                            ),
                            SizedBox(height: 16),
                            Text(
                              "لا توجد شركات شحن مضافة",
                              style: getRegular(color: Colors.grey),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "انقر على 'إضافة شركة شحن' لإضافة شركة",
                              style: getRegular(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: EdgeInsets.all(20),
                      itemCount: controller.shippingCompanies.length,
                      itemBuilder: (context, index) {
                        final company = controller.shippingCompanies[index];
                        return _buildShippingCompanyCard(company, index);
                      },
                    ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildShippingCompanyCard(Map<String, dynamic> company, int index) {
    final isPrimary = company['is_primary'] == true || index == 0;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPrimary ? AppColors.primary400 : Colors.grey[200]!,
          width: isPrimary ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isPrimary ? AppColors.primary400 : Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              isPrimary ? 'أساسي' : 'ثانوي',
              style: getBold(
                color: isPrimary ? Colors.white : Colors.grey,
                fontSize: 10,
              ),
            ),
          ),

          SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  company['name']?.toString() ?? 'شركة شحن',
                  style: getMedium(color: AppColors.neutral100),
                ),

                SizedBox(height: 4),

                if (company['prices'] != null && company['prices'] is List)
                  Text(
                    'المدن المغطاة: ${(company['prices'] as List).length} مدينة',
                    style: getRegular(
                      fontSize: 12,
                      color: AppColors.neutral100,
                    ),
                  ),

                if (company['created_at'] != null)
                  Text(
                    'مضافة بتاريخ: ${company['created_at']}',
                    style: getRegular(
                      fontSize: 10,
                      color: AppColors.neutral100,
                    ),
                  ),
              ],
            ),
          ),

          Row(
            children: [
              GestureDetector(
                onTap: () {
                  _editShippingCompany(company, index);
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.edit, size: 18, color: Colors.blue),
                ),
              ),

              SizedBox(width: 8),

              GestureDetector(
                onTap: () {
                  _deleteShippingCompany(index);
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.delete, size: 18, color: Colors.red),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _editShippingCompany(Map<String, dynamic> company, int index) {
    Get.to(() => AddNewShippingCompany());
  }

  void _deleteShippingCompany(int index) {
    Get.defaultDialog(
      title: 'تأكيد الحذف',
      middleText: 'هل أنت متأكد من حذف شركة الشحن هذه؟',
      // textConfirm: 'نعم، احذف',
      // textCancel: 'إلغاء',
      actions: [
        AateneButton(
          onTap: () {
            controller.removeShippingCompany(index);
            Get.back();
            Get.snackbar(
              'تم الحذف',
              'تم حذف شركة الشحن بنجاح',
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
          },
          buttonText: "نعم، احذف",
          color: AppColors.primary400,
          textColor: AppColors.light1000,
          borderColor: AppColors.primary400,
        ),
        SizedBox(height: 10),
        AateneButton(
          onTap: () => Get.back(),
          buttonText: "إلغاء",
          color: AppColors.light1000,
          textColor: AppColors.primary400,
          borderColor: AppColors.primary400,
        ),
      ],
      //
      // confirmTextColor: Colors.white,
      // cancelTextColor: AppColors.primary400,
      // buttonColor: Colors.red,
      // onConfirm: () {
      //   controller.removeShippingCompany(index);
      //   Get.back();
      //   Get.snackbar(
      //     'تم الحذف',
      //     'تم حذف شركة الشحن بنجاح',
      //     backgroundColor: Colors.green,
      //     colorText: Colors.white,
      //   );
      // },
      // onCancel: () {
      //   Get.back();
      // },
    );
  }

  Widget _buildSaveButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: AateneButton(
        buttonText: 'التالي',
        textColor: Colors.white,
        color: AppColors.primary400,
        borderColor: AppColors.primary400,
        onTap: () {
          _validateAndProceed();
        },
      ),
    );
  }

  void _validateAndProceed() {
    if (controller.deliveryType.value.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى اختيار طريقة الشحن',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (controller.deliveryType.value == 'shipping' &&
        controller.shippingCompanies.isEmpty) {
      Get.snackbar(
        'خطأ',
        'يرجى إضافة شركة شحن واحدة على الأقل',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.defaultDialog(
      title: 'حفظ المتجر',
      middleText: controller.isEditMode.value
          ? 'هل تريد تحديث المتجر بالبيانات الجديدة؟'
          : 'هل تريد إنشاء المتجر الآن؟',
      // textConfirm: 'نعم',
      // textCancel: 'لا',
      // confirmTextColor: Colors.white,
      // cancelTextColor: AppColors.primary400,
      // buttonColor: AppColors.primary400,
      actions: [
        AateneButton(
          onTap: () async {
            Get.back();
            final success = await controller.saveCompleteStore();
            if (success ?? false) {
              Get.until((route) => route.isFirst);
            }
          },
          buttonText: "نعم",
          color: AppColors.primary400,
          textColor: AppColors.light1000,
          borderColor: AppColors.primary400,
        ),
        SizedBox(height: 10),
        AateneButton(
          onTap: () => Get.back(),
          buttonText: "لا",
          color: AppColors.light1000,
          textColor: AppColors.primary400,
          borderColor: AppColors.primary400,
        ),
      ],
      //
      // onConfirm: () async {
      //   Get.back();
      //
      //   final success = await controller.saveCompleteStore();
      //   if (success ?? false) {
      //     Get.until((route) => route.isFirst);
      //   }
      // },
      // onCancel: () {
      //   Get.back();
      // },
    );
  }
}
