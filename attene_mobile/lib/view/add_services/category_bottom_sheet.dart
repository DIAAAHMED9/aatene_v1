import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/view/add_services/responsive_dimensions.dart';
import 'package:attene_mobile/view/add_services/service_controller.dart';

class CategoryBottomSheet extends StatelessWidget {
  const CategoryBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final ServiceController controller = Get.find<ServiceController>();

    return Container(
      height: ResponsiveDimensions.responsiveHeight(600),
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
                  'اختر الفئة',
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

          if (controller.selectedMainCategory.value.isNotEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveDimensions.responsiveWidth(16),
              ),
              child: Container(
                padding: EdgeInsets.all(
                  ResponsiveDimensions.responsiveWidth(12),
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.primary100),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.category,
                      color: AppColors.primary500,
                      size: ResponsiveDimensions.responsiveFontSize(20),
                    ),
                    SizedBox(width: ResponsiveDimensions.responsiveWidth(8)),
                    Expanded(
                      child: Text(
                        'القسم: ${controller.selectedMainCategory.value}',
                        style: TextStyle(
                          fontSize: ResponsiveDimensions.responsiveFontSize(14),
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          SizedBox(height: ResponsiveDimensions.responsiveHeight(12)),

          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: ResponsiveDimensions.responsiveWidth(16),
            ),
            child: TextField(
              onChanged: controller.searchCategories,
              decoration: InputDecoration(
                hintText: 'ابحث عن فئة...',
                hintStyle: TextStyle(
                  fontSize: ResponsiveDimensions.responsiveFontSize(14),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: ResponsiveDimensions.responsiveFontSize(20),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          SizedBox(height: ResponsiveDimensions.responsiveHeight(16)),

          Expanded(
            child: GetBuilder<ServiceController>(
              id: 'categories_list',
              builder: (controller) {
                if (controller.selectedSectionId.value == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: ResponsiveDimensions.responsiveFontSize(48),
                          color: Colors.grey[400],
                        ),
                        SizedBox(
                          height: ResponsiveDimensions.responsiveHeight(16),
                        ),
                        Text(
                          'يرجى اختيار قسم أولاً',
                          style: TextStyle(
                            fontSize: ResponsiveDimensions.responsiveFontSize(
                              16,
                            ),
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.isLoadingCategories.value) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: AppColors.primary400),
                        SizedBox(
                          height: ResponsiveDimensions.responsiveHeight(16),
                        ),
                        Text(
                          'جاري تحميل الفئات...',
                          style: TextStyle(
                            fontSize: ResponsiveDimensions.responsiveFontSize(
                              14,
                            ),
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.categoriesError.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: ResponsiveDimensions.responsiveFontSize(40),
                          color: Colors.red,
                        ),
                        SizedBox(
                          height: ResponsiveDimensions.responsiveHeight(16),
                        ),
                        Text(
                          controller.categoriesError.value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: ResponsiveDimensions.responsiveFontSize(
                              14,
                            ),
                            color: Colors.red,
                          ),
                        ),
                        SizedBox(
                          height: ResponsiveDimensions.responsiveHeight(16),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.loadCategories();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary400,
                          ),
                          child: Text('إعادة المحاولة'),
                        ),
                      ],
                    ),
                  );
                }

                if (controller.filteredCategories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category,
                          size: ResponsiveDimensions.responsiveFontSize(48),
                          color: Colors.grey[400],
                        ),
                        SizedBox(
                          height: ResponsiveDimensions.responsiveHeight(16),
                        ),
                        Text(
                          'لا توجد فئات',
                          style: TextStyle(
                            fontSize: ResponsiveDimensions.responsiveFontSize(
                              16,
                            ),
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: controller.filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = controller.filteredCategories[index];
                    final categoryId =
                        int.tryParse(category['id'].toString()) ?? 0;
                    final categoryName = (category['name'] ?? '').toString();

                    return ListTile(
                      title: Text(
                        categoryName,
                        style: TextStyle(
                          fontSize: ResponsiveDimensions.responsiveFontSize(14),
                        ),
                      ),
                      trailing:
                          controller.tempSelectedCategoryId.value == categoryId
                          ? Icon(
                              Icons.check,
                              color: AppColors.primary400,
                              size: ResponsiveDimensions.responsiveFontSize(20),
                            )
                          : null,
                      onTap: () {
                        controller.selectTempCategory(categoryId, categoryName);
                      },
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(ResponsiveDimensions.responsiveWidth(16)),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.tempSelectedCategoryId.value > 0 &&
                      controller.tempSelectedCategory.value.isNotEmpty) {
                    controller.saveSelectedCategory();
                    Get.back();
                  } else {
                    Get.snackbar(
                      'تنبيه',
                      'يرجى اختيار فئة',
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
                ),
                child: Text(
                  'حفظ',
                  style: TextStyle(
                    fontSize: ResponsiveDimensions.responsiveFontSize(16),
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
