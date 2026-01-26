import '../../../general_index.dart';
import '../../../utils/responsive/responsive_dimensions.dart';

class DevelopmentBottomSheet extends StatelessWidget {
  const DevelopmentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceController>();

    return Container(
      height: ResponsiveDimensions.responsiveHeight(620),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'إضافة تطوير جديد',
                  style: getBold(
                    fontSize: ResponsiveDimensions.responsiveFontSize(18),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    size: ResponsiveDimensions.responsiveFontSize(24),
                  ),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveDimensions.responsiveWidth(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('تفاصيل التطوير', style: getBold()),
                  SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
                  Obx(
                    () => TextField(
                      onChanged: controller.updateDevelopmentTitle,
                      controller:
                          TextEditingController(
                              text: controller.developmentTitle.value,
                            )
                            ..selection = TextSelection.collapsed(
                              offset: controller.developmentTitle.value.length,
                            ),
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'أدخل تفاصيل التطوير',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(
                          ResponsiveDimensions.responsiveWidth(12),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),

                  Text('السعر', style: getBold()),
                  SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
                  Obx(
                    () => TextField(
                      onChanged: controller.updateDevelopmentPrice,
                      controller:
                          TextEditingController(
                              text: controller.developmentPrice.value,
                            )
                            ..selection = TextSelection.collapsed(
                              offset: controller.developmentPrice.value.length,
                            ),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'أدخل السعر',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(
                          ResponsiveDimensions.responsiveWidth(12),
                        ),
                        suffixIcon: Padding(
                          padding: EdgeInsets.all(
                            ResponsiveDimensions.responsiveWidth(12),
                          ),
                          child: Text(
                            '₪',
                            style: TextStyle(
                              fontSize: ResponsiveDimensions.responsiveFontSize(
                                16,
                              ),
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),

                  Text('مدة التنفيذ', style: getBold()),
                  SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Obx(
                          () => TextField(
                            onChanged: controller.updateDevelopmentTimeValue,
                            controller:
                                TextEditingController(
                                    text: controller.developmentTimeValue.value,
                                  )
                                  ..selection = TextSelection.collapsed(
                                    offset: controller
                                        .developmentTimeValue
                                        .value
                                        .length,
                                  ),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'أدخل المدة',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.all(
                                ResponsiveDimensions.responsiveWidth(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
                      Expanded(
                        flex: 1,
                        child: Obx(
                          () => Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: InkWell(
                              onTap: () {
                                Get.bottomSheet(
                                  const TimeUnitBottomSheet(
                                    isForDevelopment: true,
                                  ),
                                  isScrollControlled: true,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.only(right: 5, left: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.developmentTimeUnit.value,
                                      style: getRegular(
                                        fontSize:
                                            ResponsiveDimensions.responsiveFontSize(
                                              12,
                                            ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size:
                                          ResponsiveDimensions.responsiveFontSize(
                                            15,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
            child: Obx(
              () => SizedBox(
                width: double.infinity,
                child: AateneButton(
                  onTap: controller.canAddDevelopment
                      ? () {
                          controller.addDevelopment();
                          Get.back();
                        }
                      : null,
                  buttonText: 'إضافة التطوير',
                  color: controller.canAddDevelopment
                      ? AppColors.primary400
                      : Colors.grey[300],
                  textColor: controller.canAddDevelopment
                      ? Colors.white
                      : Colors.grey[600],
                  borderColor: controller.canAddDevelopment
                      ? AppColors.primary400
                      : Colors.grey[300],
                ),
              ),
            ),
          ),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(40)),
        ],
      ),
    );
  }
}
