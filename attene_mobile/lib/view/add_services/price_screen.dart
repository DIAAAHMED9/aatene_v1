import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/view/add_services/development_bottom_sheet.dart';
import 'package:attene_mobile/view/add_services/time_unit_bottom_sheet.dart';
import 'package:attene_mobile/view/add_services/responsive_dimensions.dart';

import 'models/models.dart';
import 'service_controller.dart';

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
            Row(
              children: [
                Text(
                  'السعر الأساسي',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.responsiveFontSize(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: ResponsiveDimensions.responsiveWidth(4)),
                const Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
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
                      onChanged: controller.validatePrice,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      decoration: InputDecoration(
                        hintText: '0.00',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(12)),
                        suffixIcon:  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: ResponsiveDimensions.responsiveWidth(16),
                      vertical: ResponsiveDimensions.responsiveHeight(8),
                    ),
              
                    child: Text(
                      '₪',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.responsiveFontSize(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                      ),
                      controller: TextEditingController(text: controller.price.value)
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
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: ResponsiveDimensions.responsiveFontSize(12),
                  ),
                ),
              ),
       
          ],
        );
      }
    );
  }

  Widget _buildExecutionTimeField() {
    return GetBuilder<ServiceController>(
      id: 'execution_time_field',
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'مدة التنفيذ',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.responsiveFontSize(16),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: ResponsiveDimensions.responsiveWidth(4)),
                const Text(
                  '*',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
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
                      decoration: InputDecoration(
                        hintText: 'مثال: 3',
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(12)),
                      ),
                      controller: TextEditingController(text: controller.executionTimeValue.value)
                        ..selection = TextSelection.collapsed(
                          offset: controller.executionTimeValue.value.length,
                        ),
                    ),
                  ),
                ),
                SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
                
                Expanded(
                  flex: 1,
                  child: Container(
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
                          const TimeUnitBottomSheet(isForDevelopment: false),
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(12)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                controller.executionTimeUnit.value,
                                style: TextStyle(
                                  fontSize: ResponsiveDimensions.responsiveFontSize(14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            Icon(Icons.arrow_drop_down,
                                size: ResponsiveDimensions.responsiveFontSize(24)),
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
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: ResponsiveDimensions.responsiveFontSize(12),
                  ),
                ),
              ),

          ],
        );
      }
    );
  }

  Widget _buildDevelopmentsSection() {
    final controller = Get.find<ServiceController>();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'تطويرات الخدمة (اختياري)',
          style: TextStyle(
            fontSize: ResponsiveDimensions.responsiveFontSize(16),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
        Row(
          children: [
            Expanded(
              child: Text(
               'تطويرات الخدمة اختيارية بالكامل، ولا يجوز إلزام المشتري بطلبها. يُرجى التعرف على كيفية استخدامها بالشكل الصحيح.',
                style: TextStyle(
                  fontSize: ResponsiveDimensions.responsiveFontSize(11),
                  color: Colors.grey.shade500
              
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
                    borderRadius: BorderRadius.circular(8)
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
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.responsiveFontSize(16),
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary400,
                  ),
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

  Widget _buildDevelopmentItem(Development development, ServiceController controller) {
    return Dismissible(
      key: Key(development.id.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: ResponsiveDimensions.responsiveWidth(20)),
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
          textConfirm: 'نعم',
          textCancel: 'لا',
          onConfirm: () => Get.back(result: true),
          onCancel: () => Get.back(result: false),
        );
      },
      onDismissed: (direction) {
        controller.removeDevelopment(development.id);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: ResponsiveDimensions.responsiveHeight(12)),
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
                          style: TextStyle(
                            fontSize: ResponsiveDimensions.responsiveFontSize(14),
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: ResponsiveDimensions.responsiveHeight(4)),
                        Row(
                          children: [
                        Text(
                                '${development.price} ₪',
                                style: TextStyle(
                                  fontSize: ResponsiveDimensions.responsiveFontSize(12),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            
                            SizedBox(width: ResponsiveDimensions.responsiveWidth(13)),
                        
                             Text(
                                '${development.executionTime} ${development.timeUnit}',
                                style: TextStyle(
                                  fontSize: ResponsiveDimensions.responsiveFontSize(12),
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
              child: ElevatedButton(
                onPressed: () {
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary400,
                  padding: EdgeInsets.symmetric(
                    vertical: ResponsiveDimensions.responsiveHeight(16),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'التالي: الوصف والأسئلة الشائعة',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.responsiveFontSize(16),
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
                    Icon(
                      Icons.arrow_forward,
                      size: ResponsiveDimensions.responsiveFontSize(20),
                      color: Colors.white,
                    ),
                  ],
                ),
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
                        borderRadius: BorderRadius.circular(12),
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
                        SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
                        Text(
                          'السابق',
                          style: TextStyle(
                            fontSize: ResponsiveDimensions.responsiveFontSize(16),
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
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
                          textConfirm: 'نعم',
                          textCancel: 'لا',
                          onConfirm: () {
                            Get.back();
                            Get.snackbar(
                              'تم الحفظ',
                              'تم حفظ البيانات بنجاح',
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          },
                        );
                      }
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: ResponsiveDimensions.responsiveHeight(16),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      'حفظ مؤقت',
                      style: TextStyle(
                        fontSize: ResponsiveDimensions.responsiveFontSize(16),
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      }
    );
  }
}