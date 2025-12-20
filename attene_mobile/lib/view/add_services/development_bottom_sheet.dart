import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';

import 'time_unit_bottom_sheet.dart';
import 'responsive_dimensions.dart';
import 'service_controller.dart';

class DevelopmentBottomSheet extends StatelessWidget {
  const DevelopmentBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ServiceController>();

    return Container(
      height: ResponsiveDimensions.responsiveHeight(500),
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
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.responsiveFontSize(18),
                    fontWeight: FontWeight.bold,
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
                  Text(
                    'تفاصيل التطوير',
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.responsiveFontSize(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

                  Text(
                    'السعر',
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.responsiveFontSize(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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

                  Text(
                    'مدة التنفيذ',
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.responsiveFontSize(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(25),
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
                                padding: EdgeInsets.all(
                                  ResponsiveDimensions.responsiveWidth(12),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      controller.developmentTimeUnit.value,
                                      style: TextStyle(
                                        fontSize:
                                            ResponsiveDimensions.responsiveFontSize(
                                              14,
                                            ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_drop_down,
                                      size:
                                          ResponsiveDimensions.responsiveFontSize(
                                            24,
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

                  // SizedBox(height: ResponsiveDimensions.responsiveHeight(40)),
                ],
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
            child: Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.canAddDevelopment
                      ? () {
                          controller.addDevelopment();
                          Get.back();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: controller.developmentButtonColor,
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveDimensions.responsiveHeight(16),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: Text(
                    'إضافة التطوير',
                    style: TextStyle(
                      fontSize: ResponsiveDimensions.responsiveFontSize(16),
                      fontWeight: FontWeight.w600,
                      color: controller.canAddDevelopment
                          ? Colors.white
                          : Colors.grey[600],
                    ),
                  ),
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
