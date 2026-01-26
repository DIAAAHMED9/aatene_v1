

import '../../../general_index.dart';
import '../../../utils/responsive/index.dart';

class ServiceScreen extends StatelessWidget {
  ServiceScreen({super.key});

  final ServiceController controller = Get.find<ServiceController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: ResponsiveDimensions.responsiveWidth(16, 30, 40),
        vertical: ResponsiveDimensions.responsiveHeight(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المعلومات الاساسية',
            style: getBold(
              fontSize: ResponsiveDimensions.responsiveFontSize(25),
            ),
          ),
          _buildServiceTitleField(),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(24)),

          _buildMainCategoryField(),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(24)),

          _buildCategoryField(),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(24)),

          _buildSpecializationsField(),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(24)),

          _buildKeywordsField(),
          SizedBox(height: ResponsiveDimensions.responsiveHeight(40)),
        ],
      ),
    );
  }

  Widget _buildServiceTitleField() {
    return GetBuilder<ServiceController>(
      id: 'service_title_field',
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWithStar(text: 'عنوان الخدمة'),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: controller.isServiceTitleError.value
                      ? Colors.red
                      : Colors.grey[300]!,
                  width: controller.isServiceTitleError.value ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                textInputAction: TextInputAction.next,

                onChanged: (value) {
                  controller.serviceTitle.value = value.trim();
                  controller.isServiceTitleError.value =
                      controller.serviceTitle.value.isEmpty;
                  controller.update(['service_title_field']);
                },
                maxLines: 3,
                maxLength: 140,
                decoration: InputDecoration(
                  hintText: 'اكتب اسم الخدمة',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(
                    ResponsiveDimensions.responsiveWidth(12),
                  ),
                  counterText: '',
                ),
                controller:
                    TextEditingController(text: controller.serviceTitle.value)
                      ..selection = TextSelection.collapsed(
                        offset: controller.serviceTitle.value.length,
                      ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: ResponsiveDimensions.responsiveHeight(4),
                right: ResponsiveDimensions.responsiveWidth(4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (controller.isServiceTitleError.value)
                    Text(
                      'هذا الحقل مطلوب',
                      style: getRegular(
                        color: Colors.red,
                        fontSize: ResponsiveDimensions.responsiveFontSize(12),
                      ),
                    )
                  else
                    const SizedBox(),
                  Text(
                    '${controller.serviceTitle.value.length}/100',
                    style: getRegular(
                      color: Color(0xFF757575),
                      fontSize: ResponsiveDimensions.responsiveFontSize(12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainCategoryField() {
    return GetBuilder<ServiceController>(
      id: 'main_category_field',
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWithStar(text: 'القسم الرئيسي'),

            SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: controller.isMainCategoryError.value
                      ? Colors.red
                      : Colors.grey[300]!,
                  width: controller.isMainCategoryError.value ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: InkWell(
                onTap: _showMainCategoryDialog,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.all(
                    ResponsiveDimensions.responsiveWidth(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          controller.selectedMainCategory.value.isEmpty
                              ? 'اختر القسم الرئيسي'
                              : controller.selectedMainCategory.value,
                          style: getRegular(
                            fontSize: ResponsiveDimensions.responsiveFontSize(
                              10,
                            ),
                            color: controller.selectedMainCategory.value.isEmpty
                                ? Colors.grey
                                : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
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
            if (controller.isMainCategoryError.value)
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
            SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
            Text(
              'يجب اختيار قسم رئيسي للخدمة (مثال: تصميم وبرمجة)',
              style: getRegular(
                fontSize: ResponsiveDimensions.responsiveFontSize(12),
                color: Color(0xFF757575),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryField() {
    return GetBuilder<ServiceController>(
      id: 'category_field',
      builder: (controller) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextWithStar(text: 'الفئة الفرعية'),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(
                  color: controller.isCategoryError.value
                      ? Colors.red
                      : Colors.grey[300]!,
                  width: controller.isCategoryError.value ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: InkWell(
                onTap: () {
                  if (controller.selectedSectionId.value == 0) {
                    Get.snackbar(
                      'تنبيه',
                      'يرجى اختيار قسم رئيسي أولاً',
                      backgroundColor: Colors.orange,
                      colorText: Colors.white,
                    );
                    return;
                  }

                  controller.tempSelectedCategory.value =
                      controller.selectedCategory.value;
                  Get.bottomSheet(
                    const CategoryBottomSheet(),
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: EdgeInsets.all(
                    ResponsiveDimensions.responsiveWidth(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          controller.selectedCategory.value.isEmpty
                              ? 'اختر الفئة الفرعية'
                              : controller.selectedCategory.value,
                          style: getRegular(
                            fontSize: ResponsiveDimensions.responsiveFontSize(
                              10,
                            ),
                            color: controller.selectedCategory.value.isEmpty
                                ? Colors.grey
                                : Colors.black,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Icon(
                          Icons.arrow_drop_down,
                          size: ResponsiveDimensions.responsiveFontSize(15),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (controller.isCategoryError.value)
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
            SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
            Text(
              'اختر فئة فرعية للخدمة (مثال: تصميم مواقع إلكترونية)',
              style: getRegular(
                fontSize: ResponsiveDimensions.responsiveFontSize(12),
                color: Color(0xFF757575),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSpecializationsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('التخصصات أو مجالات العمل', style: getBold()),
            SizedBox(width: ResponsiveDimensions.responsiveWidth(4)),
            GestureDetector(
              onTap: () {
                Get.defaultDialog(
                  buttonColor: AppColors.primary400,
                  backgroundColor: Colors.white,
                  title: 'ما هي التخصصات؟',
                  content: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      spacing: 10,
                      children: [
                        const Text(
                          'التخصصات هي مجالات العمل التي تتقنها في خدمتك. مثال: تصميم مواقع، برمجة تطبيقات، كتابة محتوى...',
                          textAlign: TextAlign.center,
                        ),
                        AateneButton(
                          onTap: () => Get.back(),
                          buttonText: "إلغاء",
                          color: AppColors.primary400,
                          textColor: AppColors.light1000,
                          borderColor: AppColors.primary400,
                        ),

                      ],
                    ),
                  ),
                  // onConfirm: () => Get.back(),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.question_mark,
                  size: ResponsiveDimensions.responsiveFontSize(14),
                  color: AppColors.primary500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),

        GetBuilder<ServiceController>(
          id: 'specialization_input',
          builder: (controller) {
            return SizedBox(
              height: ResponsiveDimensions.responsiveHeight(50),
              child: TextField(
                textInputAction: TextInputAction.next,
                controller: controller.specializationTextController,
                onSubmitted: (value) {
                  if (controller.canAddSpecialization) {
                    controller.addSpecialization();
                  }
                },
                decoration: InputDecoration(
                  hintText:
                      controller.specializations.length >=
                          ServiceController.maxSpecializations
                      ? 'تم الوصول للحد الأقصى'
                      : 'أدخل تخصصاً',
                  border: InputBorder.none,
                  hintStyle: getRegular(
                    color: Color(0xFF757575),
                    fontSize: ResponsiveDimensions.responsiveFontSize(14),
                  ),
                  suffixIcon: Tooltip(
                    message: controller.specializationTooltip,
                    child: InkWell(
                      onTap: controller.canAddSpecialization
                          ? () {
                              controller.addSpecialization();
                            }
                          : null,
                      borderRadius: BorderRadius.circular(25),
                      child: Container(
                        margin: EdgeInsets.symmetric(
                          horizontal: ResponsiveDimensions.responsiveWidth(2),
                        ),
                        padding: EdgeInsets.only(bottom: 2,top: 2),
                        width: ResponsiveDimensions.responsiveWidth(45),
                        height: ResponsiveDimensions.responsiveWidth(45),
                        decoration: BoxDecoration(
                          color: controller.specializationsButtonColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.add,
                          color: controller.canAddSpecialization
                              ? Colors.white
                              : Colors.grey[500],
                          size: ResponsiveDimensions.responsiveFontSize(20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
        GetBuilder<ServiceController>(
          builder: (controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'أدخل تخصصاً ثم اضغط زر الإضافة',
                  style: getRegular(
                    fontSize: ResponsiveDimensions.responsiveFontSize(11),
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${controller.specializations.length}/${ServiceController.maxSpecializations}',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.responsiveFontSize(12),
                    color:
                        controller.specializations.length >=
                            ServiceController.maxSpecializations
                        ? Colors.red
                        : Colors.grey[600],
                    fontFamily: "PingAR",
                  ),
                ),
              ],
            );
          },
        ),

        SizedBox(height: ResponsiveDimensions.responsiveHeight(12)),
        GetBuilder<ServiceController>(
          id: 'specializations_list',
          builder: (controller) {
            if (controller.specializations.isEmpty) {
              return _buildEmptyList(
                icon: Icons.work_outline,
                title: 'لا توجد تخصصات مضافة',
                subtitle: 'أدخل تخصصاً واضغط زر الإضافة',
              );
            }

            return Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: ResponsiveDimensions.responsiveHeight(100),
                  maxHeight: ResponsiveDimensions.responsiveHeight(250),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    ResponsiveDimensions.responsiveWidth(12),
                  ),
                  child: Wrap(
                    spacing: ResponsiveDimensions.responsiveWidth(8),
                    runSpacing: ResponsiveDimensions.responsiveHeight(8),
                    children: List.generate(controller.specializations.length, (
                      index,
                    ) {
                      return Chip(
                        label: Text(
                          controller.specializations[index],
                          style: getRegular(
                            fontSize: ResponsiveDimensions.responsiveFontSize(
                              14,
                            ),
                          ),
                        ),
                        backgroundColor: AppColors.primary50,
                        deleteIconColor: AppColors.primary400,
                        onDeleted: () => controller.removeSpecialization(index),
                        labelStyle: getRegular(color: AppColors.primary500),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: BorderSide(
                            color: AppColors.primary300,
                            width: 1.0,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildKeywordsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الكلمات المفتاحية', style: getBold()),
        SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),

        GetBuilder<ServiceController>(
          id: 'keyword_input',
          builder: (controller) {
            return SizedBox(
              height: ResponsiveDimensions.responsiveHeight(50),
              child: TextField(
                textInputAction: TextInputAction.done,
                controller: controller.keywordTextController,
                onSubmitted: (value) {
                  if (controller.canAddKeyword) {
                    controller.addKeyword();
                  }
                },
                decoration: InputDecoration(
                  hintText:
                      controller.keywords.length >=
                          ServiceController.maxKeywords
                      ? 'تم الوصول للحد الأقصى'
                      : 'أدخل كلمة مفتاحية',
                  border: InputBorder.none,
                  hintStyle: getRegular(
                    color: Color(0xFF757575),
                    fontSize: ResponsiveDimensions.responsiveFontSize(14),
                  ),
                  suffixIcon: Tooltip(
                    message: controller.keywordTooltip,
                    child: Container(
                      padding: EdgeInsets.only(bottom: 2,top: 2),
                      child: InkWell(
                        onTap: controller.canAddKeyword
                            ? () {
                                controller.addKeyword();
                              }
                            : null,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: ResponsiveDimensions.responsiveWidth(2),
                          ),
                          width: ResponsiveDimensions.responsiveWidth(45),
                          height: ResponsiveDimensions.responsiveWidth(45),
                          decoration: BoxDecoration(
                            color: controller.keywordsButtonColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.add,
                            color: controller.canAddKeyword
                                ? Colors.white
                                : Colors.grey[500],
                            size: ResponsiveDimensions.responsiveFontSize(20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),

        SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
        GetBuilder<ServiceController>(
          builder: (controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'أدخل كلمة مفتاحية ثم اضغط زر الإضافة',
                  style: getRegular(
                    fontSize: ResponsiveDimensions.responsiveFontSize(11),
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${controller.keywords.length}/${ServiceController.maxKeywords}',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.responsiveFontSize(12),
                    color:
                        controller.keywords.length >=
                            ServiceController.maxKeywords
                        ? Colors.red
                        : Colors.grey[600],
                    fontFamily: "PingAR",
                  ),
                ),
              ],
            );
          },
        ),

        SizedBox(height: ResponsiveDimensions.responsiveHeight(12)),
        GetBuilder<ServiceController>(
          id: 'keywords_list',
          builder: (controller) {
            if (controller.keywords.isEmpty) {
              return _buildEmptyList(
                icon: Icons.tag_outlined,
                title: 'لا توجد كلمات مفتاحية مضافة',
                subtitle: 'أدخل كلمة مفتاحية واضغط زر الإضافة',
              );
            }

            return Container(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: ResponsiveDimensions.responsiveHeight(100),
                  maxHeight: ResponsiveDimensions.responsiveHeight(250),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(
                    ResponsiveDimensions.responsiveWidth(12),
                  ),
                  child: Wrap(
                    spacing: ResponsiveDimensions.responsiveWidth(8),
                    runSpacing: ResponsiveDimensions.responsiveHeight(8),
                    children: List.generate(controller.keywords.length, (
                      index,
                    ) {
                      return Chip(
                        label: Text(
                          controller.keywords[index],
                          style: getRegular(
                            fontSize: ResponsiveDimensions.responsiveFontSize(
                              14,
                            ),
                          ),
                        ),
                        backgroundColor: AppColors.primary50,
                        deleteIconColor: AppColors.primary400,
                        onDeleted: () => controller.removeKeyword(index),
                        labelStyle: getRegular(color: AppColors.primary500),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0),
                          side: BorderSide(
                            color: AppColors.primary300,
                            width: 1.0,
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyList({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      height: ResponsiveDimensions.responsiveHeight(150),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: ResponsiveDimensions.responsiveFontSize(40),
              color: Colors.grey[300],
            ),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(8)),
            Text(
              title,
              style: getRegular(
                fontSize: ResponsiveDimensions.responsiveFontSize(14),
                color: Colors.grey,
              ),
            ),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(4)),
            Text(
              subtitle,
              style: getRegular(
                fontSize: ResponsiveDimensions.responsiveFontSize(12),
                color: Color(0xFFBDBDBD),
              ),
            ),
          ],
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
              child:
                  AateneButtonWithIcon(

                onTap: () {
                  if (controller.validateServiceForm()) {
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
                buttonText: 'التالي: السعر والتطويرات',
              ),

              // ElevatedButton(
              //   onPressed: () {
              //     if (controller.validateServiceForm()) {
              //       controller.goToNextStep();
              //     } else {
              //       Get.snackbar(
              //         'تنبيه',
              //         'يرجى ملء جميع الحقول المطلوبة',
              //         backgroundColor: Colors.orange,
              //         colorText: Colors.white,
              //       );
              //     }
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: AppColors.primary400,
              //     padding: EdgeInsets.symmetric(
              //       vertical: ResponsiveDimensions.responsiveHeight(16),
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //   ),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     children: [
              //       Text(
              //         'التالي: السعر والتطويرات',
              //         style: getMedium(color: Colors.white),
              //       ),
              //       SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
              //       Icon(
              //         Icons.arrow_forward,
              //         size: ResponsiveDimensions.responsiveFontSize(20),
              //         color: Colors.white,
              //       ),
              //     ],
              //   ),
              // ),
            ),
            SizedBox(height: ResponsiveDimensions.responsiveHeight(12)),
            SizedBox(
              width: double.infinity,
              child:
              AateneButton(
                onTap: () {
                  if (controller.serviceTitle.value.isNotEmpty ||
                      controller.selectedMainCategory.value.isNotEmpty ||
                      controller.selectedCategory.value.isNotEmpty ||
                      controller.specializations.isNotEmpty ||
                      controller.keywords.isNotEmpty) {
                    Get.defaultDialog(
                      title: 'حفظ مؤقت',
                      content: const Text('هل تريد حفظ البيانات الحالية؟'),
                      // textConfirm: 'نعم',
                      // textCancel: 'لا',
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

                      // onConfirm: () {
                      //   Get.back();
                      //   Get.snackbar(
                      //     'تم الحفظ',
                      //     'تم حفظ البيانات بنجاح',
                      //     backgroundColor: Colors.green,
                      //     colorText: Colors.white,
                      //   );
                      // },
                    );
                  }
                },
                buttonText: "حفظ مؤقت",
                color: AppColors.light1000,
                textColor: AppColors.primary400,
                borderColor: AppColors.primary400,
              ),

              // OutlinedButton(
              //   onPressed: () {
              //     if (controller.serviceTitle.value.isNotEmpty ||
              //         controller.selectedMainCategory.value.isNotEmpty ||
              //         controller.selectedCategory.value.isNotEmpty ||
              //         controller.specializations.isNotEmpty ||
              //         controller.keywords.isNotEmpty) {
              //       Get.defaultDialog(
              //         title: 'حفظ مؤقت',
              //         content: const Text('هل تريد حفظ البيانات الحالية؟'),
              //         textConfirm: 'نعم',
              //         textCancel: 'لا',
              //         onConfirm: () {
              //           Get.back();
              //           Get.snackbar(
              //             'تم الحفظ',
              //             'تم حفظ البيانات بنجاح',
              //             backgroundColor: Colors.green,
              //             colorText: Colors.white,
              //           );
              //         },
              //       );
              //     }
              //   },
              //   style: OutlinedButton.styleFrom(
              //     padding: EdgeInsets.symmetric(
              //       vertical: ResponsiveDimensions.responsiveHeight(16),
              //     ),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //     side: BorderSide(color: Colors.grey[300]!),
              //   ),
              //   child: Text(
              //     'حفظ مؤقت',
              //     style: getMedium(color: Color(0xFF757575)),
              //   ),
              // ),
            ),
          ],
        );
      },
    );
  }

  void _showMainCategoryDialog() {
    final ServiceController controller = Get.find<ServiceController>();

    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text(
          'اختر القسم الرئيسي',
          style: getBold(fontSize: ResponsiveDimensions.responsiveFontSize(18)),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: ResponsiveDimensions.responsiveWidth(300, 400, 500),
          child: GetBuilder<ServiceController>(
            builder: (controller) {
              if (controller.isLoadingCategories.value &&
                  controller.sections.isEmpty) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('جاري تحميل الأقسام...'),
                  ],
                );
              }

              if (controller.sections.isEmpty) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.category_outlined,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    SizedBox(height: 16),
                    Text(
                      'لا توجد أقسام متاحة',
                      style: getRegular(color: Color(0xFF757575)),
                    ),

                    SizedBox(height: 8),
                    if (controller.categoriesError.isNotEmpty)
                      Text(
                        controller.categoriesError.value,
                        style: getRegular(fontSize: 12, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                        controller.loadSections();
                        Get.snackbar(
                          'تحميل',
                          'جاري تحميل الأقسام...',
                          backgroundColor: Colors.blue,
                          colorText: Colors.white,
                        );
                      },
                      child: Text('إعادة المحاولة'),
                    ),
                  ],
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.sections.length,
                itemBuilder: (context, index) {
                  final section = controller.sections[index];
                  final sectionId = int.tryParse(section['id'].toString()) ?? 0;
                  final sectionName = (section['name'] ?? '').toString();

                  return ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: getBold(color: AppColors.primary500),
                        ),
                      ),
                    ),
                    title: Text(
                      sectionName,
                      style: getRegular(
                        fontSize: ResponsiveDimensions.responsiveFontSize(14),
                      ),
                    ),
                    // subtitle: section['status'] != null
                    //     ? Text(
                    //         'الحالة: ${section['status']}',
                    //         style: getRegular(
                    //           fontSize: ResponsiveDimensions.responsiveFontSize(
                    //             12,
                    //           ),
                    //           color: Color(0xFF757575),
                    //         ),
                    //       )
                    //     : null,
                    trailing: controller.selectedSectionId.value == sectionId
                        ? Icon(Icons.check, color: AppColors.primary400)
                        : null,
                    onTap: () {
                      controller.selectMainCategory(sectionName, sectionId);
                      Get.back();

                      // Get.snackbar(
                      //   'تم الاختيار',
                      //   'تم اختيار قسم: $sectionName',
                      //   backgroundColor: Colors.green,
                      //   colorText: Colors.white,
                      //   duration: Duration(seconds: 2),
                      // );
                    },
                  );
                },
              );
            },
          ),
        ),
        actions: [
          AateneButton(
            onTap: () => Get.back(),
            buttonText: "إلغاء",
            color: AppColors.primary400,
            textColor: AppColors.light1000,
            borderColor: AppColors.primary400,
          ),

          // TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
        ],
      ),
    );
  }
}