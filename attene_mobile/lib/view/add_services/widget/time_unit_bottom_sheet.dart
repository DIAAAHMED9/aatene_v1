import '../../../general_index.dart';
import '../../../utils/responsive/responsive_dimensions.dart';

class TimeUnitBottomSheet extends StatelessWidget {
  final bool isForDevelopment;

  const TimeUnitBottomSheet({super.key, this.isForDevelopment = false});

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
        children: [
          Padding(
            padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'اختر الوحدة الزمنية',
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

          // Padding(
          //   padding: EdgeInsets.symmetric(
          //     horizontal: ResponsiveDimensions.responsiveWidth(16),
          //   ),
          //   child: Container(
          //     decoration: BoxDecoration(
          //       color: Colors.grey[100],
          //       borderRadius: BorderRadius.circular(12),
          //     ),
          //     child: Padding(
          //       padding: EdgeInsets.symmetric(
          //         horizontal: ResponsiveDimensions.responsiveWidth(16),
          //       ),
          //       child: Row(
          //         children: [
          //           Icon(
          //             Icons.search,
          //             color: Colors.grey[500],
          //             size: ResponsiveDimensions.responsiveFontSize(20),
          //           ),
          //           SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
          //           Expanded(
          //             child: TextField(
          //               decoration: InputDecoration(
          //                 hintText: 'بحث...',
          //                 border: InputBorder.none,
          //                 hintStyle: getRegular(
          //                   fontSize: ResponsiveDimensions.responsiveFontSize(
          //                     14,
          //                   ),
          //                   color: Colors.grey,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),

          Expanded(
            child: ListView.separated(
              itemCount: controller.allTimeUnits.length,
              separatorBuilder: (context, index) =>
                  Divider(height: 1, color: Colors.grey[200]),
              itemBuilder: (context, index) {
                final unit = controller.allTimeUnits[index];
                return GetBuilder<ServiceController>(
                  builder: (controller) {
                    final isSelected = isForDevelopment
                        ? controller.developmentTimeUnit.value == unit
                        : controller.executionTimeUnit.value == unit;

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: ResponsiveDimensions.responsiveWidth(16),
                        vertical: ResponsiveDimensions.responsiveHeight(8),
                      ),
                      title: Text(
                        unit,
                        style: getRegular(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                      trailing: isSelected
                          ? Container(
                              width: ResponsiveDimensions.responsiveWidth(24),
                              height: ResponsiveDimensions.responsiveWidth(24),
                              decoration: BoxDecoration(
                                color: AppColors.primary400,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.check,
                                color: Colors.white,
                                size: ResponsiveDimensions.responsiveFontSize(
                                  16,
                                ),
                              ),
                            )
                          : null,
                      onTap: () {
                        if (isForDevelopment) {
                          controller.selectDevelopmentTimeUnit(unit);
                        } else {
                          controller.selectTimeUnit(unit);
                        }
                        Get.back();
                      },
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
            child: AateneButton(
              onTap: () => Get.back(),
              buttonText: "إلغاء",
              color: AppColors.primary400,
              textColor: AppColors.light1000,
              borderColor: AppColors.primary400,
            ),
          ),
        ],
      ),
    );
  }
}
