import '../../../general_index.dart';
import '../../../utils/responsive/index.dart';

class PriceScreen extends StatelessWidget {
  const PriceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.responsiveWidth(16, 30, 40),
        vertical: ResponsiveDimensions.responsiveHeight(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPriceField(),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(24)),

          _buildExecutionTimeField(),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(24)),

          _buildDevelopmentsSection(),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(40)),
        ],
      ),
    );
  }

  Widget _buildPriceField() {
    return GetBuilder<ServiceController>(
      id: 'price_field',
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWithStar(text: 'السعر الأساسي'),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: controller.isPriceError.value
                      ? Colors.red
                      : Colors.grey[300]!,
                  width: controller.isPriceError.value ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.next,
                      onChanged: controller.validatePrice,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(
                          ResponsiveDimensions.responsiveWidth(12),
                        ),
                        suffixIcon: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: ResponsiveDimensions.responsiveWidth(
                              16,
                            ),
                            vertical: ResponsiveDimensions.responsiveHeight(8),
                          ),

                          child: Text(
                            '₪',
                            style: TextStyle(
                              fontSize: ResponsiveDimensions.responsiveFontSize(
                                16,
                              ),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      controller:
                          TextEditingController(text: controller.price.value)
                            ..selection = TextSelection.collapsed(
                              offset: controller.price.value.length,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            if (controller.isPriceError.value)
              Padding(
                padding: EdgeInsets.only(
                  top: ResponsiveDimensions.responsiveHeight(4),
                  right: ResponsiveDimensions.responsiveWidth(4),
                ),
                child: Text(
                  'هذا الحقل مطلوب',
                  style: getRegular(
                    color: Colors.red,
                    fontSize: ResponsiveDimensions.responsiveFontSize(12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildExecutionTimeField() {
    return GetBuilder<ServiceController>(
      id: 'execution_time_field',
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWithStar(text: 'مدة التنفيذ'),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: controller.isExecutionTimeError.value
                            ? Colors.red
                            : Colors.grey[300]!,
                        width: controller.isExecutionTimeError.value ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      onChanged: controller.updateExecutionTimeValue,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.done,

                      decoration: InputDecoration(
                        hintText: 'مثال: 3',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(
                          ResponsiveDimensions.responsiveWidth(12),
                        ),
                      ),
                      controller:
                          TextEditingController(
                              text: controller.executionTimeValue.value,
                            )
                            ..selection = TextSelection.collapsed(
                              offset:
                                  controller.executionTimeValue.value.length,
                            ),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),

                Expanded(
                  flex: 1,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!, width: 2),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: InkWell(
                      onTap: () {
                        Get.bottomSheet(
                          const TimeUnitBottomSheet(isForDevelopment: false),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 5,right: 5
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                controller.executionTimeUnit.value,
                                style: getRegular(
                                  fontSize:
                                      ResponsiveDimensions.responsiveFontSize(
                                        12,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.arrow_drop_down,
                              size: ResponsiveDimensions.responsiveFontSize(15),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (controller.isExecutionTimeError.value)
              Padding(
                padding: EdgeInsets.only(
                  top: ResponsiveDimensions.responsiveHeight(4),
                  right: ResponsiveDimensions.responsiveWidth(4),
                ),
                child: Text(
                  'هذا الحقل مطلوب',
                  style: getRegular(
                    color: Colors.red,
                    fontSize: ResponsiveDimensions.responsiveFontSize(12),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildDevelopmentsSection() {
    final controller = Get.find<ServiceController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('تطويرات الخدمة (اختياري)', style: getBold()),
        SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
        Row(
          children: [
            Expanded(
              child: Text(
                'تطويرات الخدمة اختيارية بالكامل، ولا يجوز إلزام المشتري بطلبها. يُرجى التعرف على كيفية استخدامها بالشكل الصحيح.',
                style: getRegular(
                  fontSize: ResponsiveDimensions.responsiveFontSize(11),
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),

        InkWell(
          onTap: () {
            Get.bottomSheet(
              const DevelopmentBottomSheet(),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            );
          },
          child: Container(
            padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: ResponsiveDimensions.responsiveWidth(24),
                  height: ResponsiveDimensions.responsiveWidth(24),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.add,
                    color: AppColors.primary400,
                    size: ResponsiveDimensions.responsiveFontSize(16),
                  ),
                ),
                SizedBox(width: ResponsiveDimensions.responsiveWidth(12)),
                Text(
                  'أضف تطوير جديد',
                  style: getMedium(color: AppColors.primary400),
                ),
              ],
            ),
          ),
        ),

        SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),
        GetBuilder<ServiceController>(
          id: 'developments_list',
          builder: (controller) {
            return Column(
              children: [
                ...controller.developments.map((development) {
                  return _buildDevelopmentItem(development, controller);
                }).toList(),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDevelopmentItem(
    Development development,
    ServiceController controller,
  ) {
    return Dismissible(
      key: Key(development.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(
          right: ResponsiveDimensions.responsiveWidth(20),
        ),
        child: Icon(
          Icons.delete,
          color: Colors.red[400],
          size: ResponsiveDimensions.responsiveFontSize(24),
        ),
      ),
      confirmDismiss: (direction) async {
        return await Get.defaultDialog(
          title: 'تأكيد الحذف',
          content: const Text('هل أنت متأكد من حذف هذا التطوير؟'),
          // textConfirm: 'نعم',
          // textCancel: 'لا',
          actions: [
            AateneButton(
              onTap: () => Get.back(result: true),
              buttonText: "نعم",
              color: AppColors.primary400,
              textColor: AppColors.light1000,
              borderColor: AppColors.primary400,
            ),
            SizedBox(height: 10),
            AateneButton(
              onTap: () => Get.back(result: false),
              buttonText: "لا",
              color: AppColors.light1000,
              textColor: AppColors.primary400,
              borderColor: AppColors.primary400,
            ),
          ],

          // onConfirm:
          // onCancel: () =>
        );
      },
      onDismissed: (direction) {
        controller.removeDevelopment(development.id??0);
      },
      child: Container(
        margin: EdgeInsets.only(
          bottom: ResponsiveDimensions.responsiveHeight(12),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.menu,
                    size: ResponsiveDimensions.responsiveFontSize(19),
                    color: AppColors.primary500,
                  ),

                  SizedBox(width: ResponsiveDimensions.responsiveWidth(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          development.title,
                          style: getMedium(
                            fontSize: ResponsiveDimensions.responsiveFontSize(
                              14,
                            ),
                            color: Color(0xFF424242),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(
                          height: ResponsiveDimensions.responsiveHeight(4),
                        ),
                        Row(
                          children: [
                            Text(
                              '${development.price} ₪',
                              style: TextStyle(
                                fontSize:
                                    ResponsiveDimensions.responsiveFontSize(14),
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(
                              width: ResponsiveDimensions.responsiveWidth(13),
                            ),

                            Text(
                              '${development.executionTime} ${development.timeUnit}',
                              style: getRegular(
                                fontSize:
                                    ResponsiveDimensions.responsiveFontSize(14),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return GetBuilder<ServiceController>(
      builder: (controller) {
        return Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: AateneButton(
                onTap: () {
                  if (controller.validatePriceForm()) {
                    controller.goToNextStep();
                  } else {
                    Get.snackbar(
                      'تنبيه',
                      'يرجى ملء جميع الحقول المطلوبة',
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                    );
                  }
                },
                buttonText: 'التالي: الوصف والأسئلة الشائعة',
                color: AppColors.primary400,
                borderColor: AppColors.primary400,
                textColor: AppColors.light1000,
              ),
            ),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(12)),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      controller.goToPreviousStep();
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveDimensions.responsiveHeight(16),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.arrow_back,
                          size: ResponsiveDimensions.responsiveFontSize(20),
                          color: Colors.grey[600],
                        ),
                        SizedBox(
                          width: ResponsiveDimensions.responsiveWidth(8),
                        ),
                        Text(
                          'السابق',
                          style: getMedium(color: Color(0xFF757575)),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveDimensions.responsiveWidth(12)),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      if (controller.price.value.isNotEmpty ||
                          controller.executionTimeValue.value.isNotEmpty ||
                          controller.developments.isNotEmpty) {
                        Get.defaultDialog(
                          title: 'حفظ مؤقت',
                          content: const Text('هل تريد حفظ البيانات الحالية؟'),

                          actions: [
                            AateneButton(
                              onTap: () {
                                Get.back();
                                Get.snackbar(
                                  'تم الحفظ',
                                  'تم حفظ البيانات بنجاح',
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              },
                              buttonText: 'نعم',
                              color: AppColors.primary400,
                              textColor: AppColors.light1000,
                              borderColor: AppColors.primary400,
                            ),
                            SizedBox(height: 10),
                            AateneButton(
                              onTap: () => Get.back(),
                              buttonText: 'لا',
                              color: AppColors.light1000,
                              textColor: AppColors.primary400,
                              borderColor: AppColors.primary400,
                            ),
                          ],
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveDimensions.responsiveHeight(16),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      'حفظ مؤقت',
                      style: getMedium(color: Color(0xFF757575)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
