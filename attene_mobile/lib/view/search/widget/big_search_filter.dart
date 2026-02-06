import 'package:attene_mobile/general_index.dart';

enum SearchType { products, stores, services, users }

class FilterBottomSheet extends StatelessWidget {
  final SearchType searchType;

  const FilterBottomSheet({super.key, required this.searchType});

  @override
  Widget build(BuildContext context) {
    final bool isVerified = true;
    return GetBuilder<FilterController>(
      init: FilterController(),
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                // عرض نوع البحث المختار
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getIconForSearchType(searchType),
                        color: AppColors.primary400,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _getTitleForSearchType(searchType),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // عرض المحتوى حسب نوع البحث
                _buildContentBySearchType(controller, searchType),

                const SizedBox(height: 24),

                AateneButton(
                  onTap: () {
                    // تطبيق الفلتر
                    _applyFilters(controller, searchType);
                    Get.back();
                  },
                  buttonText: "تطبيق الفلتر",
                  color: AppColors.primary400,
                  borderColor: AppColors.primary400,
                  textColor: AppColors.light1000,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // بناء المحتوى حسب نوع البحث
  Widget _buildContentBySearchType(
    FilterController controller,
    SearchType type,
  ) {
    switch (type) {
      case SearchType.products:
        return _buildProductsContent(controller);
      case SearchType.stores:
        return _buildStoresContent(controller);
      case SearchType.services:
        return _buildServicesContent(controller);
      case SearchType.users:
        return _buildUsersContent(controller);
    }
  }

  // محتوى فلتر المنتجات
  Widget _buildProductsContent(FilterController controller) {
    return Column(
      children: [
        // فلاتر المنتجات الأساسية
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildFilterItem(
                'فئات',
                'assets/images/svg_images/Category.svg',
                () {},
              ),
              _buildFilterItem(
                'التصنيفات',
                'assets/images/svg_images/filtter.svg',
                () {},
              ),
              _buildFilterItem(
                'العلامات',
                'assets/images/svg_images/tags.svg',
                () {},
              ),
              _buildFilterItem(
                'المدينة',
                'assets/images/svg_images/location.svg',
                () {},
              ),
              _buildFilterItem(
                'الألوان',
                'assets/images/svg_images/color.svg',
                () {},
              ),
              _buildFilterItem(
                'المقاسات',
                'assets/images/svg_images/size.svg',
                () {},
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // خيارات التبديل للمنتجات
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('عرض منتجات جديدة', style: TextStyle(fontSize: 14)),
                      Text(
                        '127 منتج',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Switch(
                    value: controller.newProducts,
                    activeColor: AppColors.primary300,
                    onChanged: controller.toggleNew,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'عرض المنتجات للبيع',
                        style: TextStyle(fontSize: 14),
                      ),
                      Text(
                        '68 منتجات',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  Switch(
                    value: controller.forSale,
                    activeColor: AppColors.primary300,
                    onChanged: controller.toggleSale,
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // النطاق السعري للمنتجات
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.category_outlined),
                  const SizedBox(width: 5),
                  Text('النطاق السعري', style: getMedium()),
                ],
              ),
              RangeSlider(
                min: 0,
                max: 300,
                values: controller.priceRange,
                activeColor: AppColors.primary300,
                onChanged: controller.changePrice,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${controller.priceRange.start.toInt()}',
                    style: getMedium(color: AppColors.primary400, fontSize: 14),
                  ),
                  Text(
                    '\$${controller.priceRange.end.toInt()}',
                    style: getMedium(color: AppColors.primary400, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // محتوى فلتر المتاجر
  Widget _buildStoresContent(FilterController controller) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildFilterItem(
                'فئات',
                'assets/images/svg_images/Category.svg',
                () {},
              ),
              _buildFilterItem(
                'المدينة',
                'assets/images/svg_images/location.svg',
                () {},
              ),
              _buildFilterItem(
                'التقييم',
                'assets/images/svg_images/Star.svg',
                () {},
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        //
        // // خيارات إضافية للمتاجر
        // Container(
        //   padding: const EdgeInsets.all(16),
        //   decoration: BoxDecoration(
        //     color: const Color(0xFFF6F6F6),
        //     borderRadius: BorderRadius.circular(16),
        //   ),
        //   child: Column(
        //     children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: const [
        //               Text(
        //                 'عرض المتاجر النشطة',
        //                 style: TextStyle(fontSize: 14),
        //               ),
        //               Text(
        //                 '45 متجر',
        //                 style: TextStyle(fontSize: 12, color: Colors.grey),
        //               ),
        //             ],
        //           ),
        //           Switch(
        //             value: controller.activeStores,
        //             activeColor: AppColors.primary300,
        //             onChanged: controller.toggleActiveStores,
        //           ),
        //         ],
        //       ),
        //       const SizedBox(height: 12),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: const [
        //               Text('المتاجر المميزة', style: TextStyle(fontSize: 14)),
        //               Text(
        //                 '12 متجر',
        //                 style: TextStyle(fontSize: 12, color: Colors.grey),
        //               ),
        //             ],
        //           ),
        //           Switch(
        //             value: controller.featuredStores,
        //             activeColor: AppColors.primary300,
        //             onChanged: controller.toggleFeaturedStores,
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  // محتوى فلتر الخدمات
  Widget _buildServicesContent(FilterController controller) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildFilterItem(
                'التصنيف',
                'assets/images/svg_images/filtter.svg',
                () {},
              ),
              _buildFilterItem(
                'المدينة',
                'assets/images/svg_images/location.svg',
                () {},
              ),
              _buildFilterItem(
                'التقييم',
                'assets/images/svg_images/Star.svg',
                () {},
              ),

              _buildFilterItem(
                'المراجعات',
                'assets/images/svg_images/Chat9.svg',
                () {},
              ),
              _buildFilterItem(
                'مستوى البائع',
                'assets/images/svg_images/Profile.svg',
                () {},
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // // خيارات إضافية للخدمات
        // Container(
        //   padding: const EdgeInsets.all(16),
        //   decoration: BoxDecoration(
        //     color: const Color(0xFFF6F6F6),
        //     borderRadius: BorderRadius.circular(16),
        //   ),
        //   child: Column(
        //     children: [
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: const [
        //               Text(
        //                 'الخدمات المتاحة الآن',
        //                 style: TextStyle(fontSize: 14),
        //               ),
        //               Text(
        //                 '89 خدمة',
        //                 style: TextStyle(fontSize: 12, color: Colors.grey),
        //               ),
        //             ],
        //           ),
        //           Switch(
        //             value: controller.availableServices,
        //             activeColor: AppColors.primary300,
        //             onChanged: controller.toggleAvailableServices,
        //           ),
        //         ],
        //       ),
        //       const SizedBox(height: 12),
        //       Row(
        //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //         children: [
        //           Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: const [
        //               Text('خدمات تحت الطلب', style: TextStyle(fontSize: 14)),
        //               Text(
        //                 '34 خدمة',
        //                 style: TextStyle(fontSize: 12, color: Colors.grey),
        //               ),
        //             ],
        //           ),
        //           Switch(
        //             value: controller.onDemandServices,
        //             activeColor: AppColors.primary300,
        //             onChanged: controller.toggleOnDemandServices,
        //           ),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        //
        // const SizedBox(height: 16),

        // النطاق السعري للخدمات
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.category_outlined),
                  const SizedBox(width: 5),
                  Text('النطاق السعري', style: getMedium()),
                ],
              ),
              RangeSlider(
                min: 0,
                max: 300,
                values: controller.priceRange,
                activeColor: AppColors.primary300,
                onChanged: controller.changePrice,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${controller.priceRange.start.toInt()}',
                    style: getMedium(color: AppColors.primary400, fontSize: 14),
                  ),
                  Text(
                    '\$${controller.priceRange.end.toInt()}',
                    style: getMedium(color: AppColors.primary400, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // محتوى فلتر المستخدمين
  Widget _buildUsersContent(FilterController controller) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              _buildFilterItem(
                'المدينة',
                'assets/images/svg_images/location.svg',
                () {},
              ),
              _buildFilterItem(
                'التقييم',
                'assets/images/svg_images/Star.svg',
                () {},
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // خيارات إضافية للمستخدمين
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text("حساب المستخدم", style: getMedium()),
              Row(
                children: [
                  Radio(value: true, activeColor: AppColors.primary400),

                  Text('حساب موثق', style: getMedium()),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // نطاق العمر للمستخدمين
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const Icon(Icons.category_outlined),
                  const SizedBox(width: 5),
                  Text('النطاق السعري', style: getMedium()),
                ],
              ),
              RangeSlider(
                min: 0,
                max: 300,
                values: controller.priceRange,
                activeColor: AppColors.primary300,
                onChanged: controller.changePrice,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${controller.priceRange.start.toInt()}',
                    style: getMedium(color: AppColors.primary400, fontSize: 14),
                  ),
                  Text(
                    '\$${controller.priceRange.end.toInt()}',
                    style: getMedium(color: AppColors.primary400, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // عنصر فلتر عام
  Widget _buildFilterItem(String title, String iconPath, Function() onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  iconPath,
                  width: 20,
                  height: 20,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 5),
                Text(title, style: getMedium()),
              ],
            ),
            Text(
              'الكل',
              style: getMedium(color: AppColors.neutral500, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }

  // الحصول على الأيقونة المناسبة حسب نوع البحث
  IconData _getIconForSearchType(SearchType type) {
    switch (type) {
      case SearchType.products:
        return Icons.shopping_bag;
      case SearchType.stores:
        return Icons.store;
      case SearchType.services:
        return Icons.handyman;
      case SearchType.users:
        return Icons.people;
    }
  }

  // الحصول على العنوان المناسب حسب نوع البحث
  String _getTitleForSearchType(SearchType type) {
    switch (type) {
      case SearchType.products:
        return 'منتجات';
      case SearchType.stores:
        return 'متاجر';
      case SearchType.services:
        return 'خدمات';
      case SearchType.users:
        return 'مستخدمين';
    }
  }

  void _applyFilters(FilterController controller, SearchType searchType) {
    // تطبيق الفلتر حسب نوع البحث
    switch (searchType) {
      case SearchType.products:
        Get.snackbar(
          'تم تطبيق فلتر المنتجات',
          'تم تطبيق الفلتر بنجاح',
          backgroundColor: AppColors.primary400,
          colorText: AppColors.light1000,
        );
        break;
      case SearchType.stores:
        Get.snackbar(
          'تم تطبيق فلتر المتاجر',
          'تم تطبيق الفلتر بنجاح',
          backgroundColor: AppColors.primary400,
          colorText: AppColors.light1000,
        );
        break;
      case SearchType.services:
        Get.snackbar(
          'تم تطبيق فلتر الخدمات',
          'تم تطبيق الفلتر بنجاح',
          backgroundColor: AppColors.primary400,
          colorText: AppColors.light1000,
        );
        break;
      case SearchType.users:
        Get.snackbar(
          'تم تطبيق فلتر المستخدمين',
          'تم تطبيق الفلتر بنجاح',
          backgroundColor: AppColors.primary400,
          colorText: AppColors.light1000,
        );
        break;
    }
  }
}

// Controller للفلاتر
class FilterController extends GetxController {
  // فلتر المنتجات
  bool newProducts = true;
  bool forSale = true;
  RangeValues priceRange = const RangeValues(0, 150);

  // فلتر المتاجر
  bool activeStores = true;
  bool featuredStores = false;

  // فلتر الخدمات
  bool availableServices = true;
  bool onDemandServices = false;
  RangeValues servicePriceRange = const RangeValues(100, 300);

  // فلتر المستخدمين
  bool activeUsers = true;
  bool featuredUsers = false;
  bool onlineUsers = false;
  RangeValues ageRange = const RangeValues(20, 40);

  // دوال التحكم بالمنتجات
  void toggleNew(bool value) {
    newProducts = value;
    update();
  }

  void toggleSale(bool value) {
    forSale = value;
    update();
  }

  void changePrice(RangeValues values) {
    priceRange = values;
    update();
  }

  // دوال التحكم بالمتاجر
  void toggleActiveStores(bool value) {
    activeStores = value;
    update();
  }

  void toggleFeaturedStores(bool value) {
    featuredStores = value;
    update();
  }

  // دوال التحكم بالخدمات
  void toggleAvailableServices(bool value) {
    availableServices = value;
    update();
  }

  void toggleOnDemandServices(bool value) {
    onDemandServices = value;
    update();
  }

  void changeServicePrice(RangeValues values) {
    servicePriceRange = values;
    update();
  }

  // دوال التحكم بالمستخدمين
  void toggleActiveUsers(bool value) {
    activeUsers = value;
    update();
  }

  void toggleFeaturedUsers(bool value) {
    featuredUsers = value;
    update();
  }

  void toggleOnlineUsers(bool value) {
    onlineUsers = value;
    update();
  }

  void changeAgeRange(RangeValues values) {
    ageRange = values;
    update();
  }
}

class FilterItem {
  final String title;
  final String svgAssetPath;

  const FilterItem(this.title, this.svgAssetPath);
}
