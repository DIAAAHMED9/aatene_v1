import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/search/controller/search_controller.dart' as app;
import 'package:attene_mobile/view/search/controller/search_filter_controller.dart';

import '../controller/search_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  final app.SearchType searchType;

  const FilterBottomSheet({super.key, required this.searchType});

  @override
  Widget build(BuildContext context) {
    final filterController = Get.put(SearchFilterController(), permanent: false);
    final searchController = Get.find<app.SearchController>();

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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getIconForSearchType(searchType), color: AppColors.primary400),
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

            _buildFilterContent(searchType, filterController),

            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(
                  child: AateneButton(
                    onTap: () {
                      filterController.resetFilters(searchType);
                    },
                    buttonText: "إعادة تعيين",
                    color: AppColors.neutral100,
                    textColor: AppColors.neutral700,
                    borderColor: AppColors.neutral300,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AateneButton(
                    onTap: () {
                      _applyFiltersAndClose(context, searchController, filterController, searchType);
                    },
                    buttonText: "تطبيق الفلتر",
                    color: AppColors.primary400,
                    borderColor: AppColors.primary400,
                    textColor: AppColors.light1000,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _applyFiltersAndClose(
    BuildContext context,
    app.SearchController searchController,
    SearchFilterController filterController,
    app.SearchType searchType,
  ) {
    if (context.mounted) {
      Navigator.pop(context);
    }

    final filters = filterController.buildFilterQuery(searchType);

    if (searchController.searchQuery.value.isEmpty) {
      Get.snackbar(
        'تنبيه',
        'الرجاء كتابة كلمة البحث أولاً',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.warning100,
        colorText: AppColors.neutral900,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    searchController.applyFilters(filters);
  }

  Widget _buildFilterContent(SearchType type, SearchFilterController controller) {
    switch (type) {
      case SearchType.products:
        return _buildProductsFilter(controller);
      case SearchType.stores:
        return _buildStoresFilter(controller);
      case SearchType.services:
        return _buildServicesFilter(controller);
      case SearchType.users:
        return _buildUsersFilter(controller);
    }
  }

  Widget _buildProductsFilter(SearchFilterController controller) {
    return GetBuilder<SearchFilterController>(
      builder: (_) {
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
                  _buildFilterItem('فئات', 'assets/images/svg_images/Category.svg'),
                  _buildFilterItem('التصنيفات', 'assets/images/svg_images/filtter.svg'),
                  _buildFilterItem('العلامات', 'assets/images/svg_images/tags.svg'),
                  _buildFilterItem('المدينة', 'assets/images/svg_images/location.svg'),
                  _buildFilterItem('الألوان', 'assets/images/svg_images/color.svg'),
                  _buildFilterItem('المقاسات', 'assets/images/svg_images/size.svg'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildSwitchRow(
                    title: 'عرض منتجات جديدة',
                    subtitle: '127 منتج',
                    value: controller.newProducts,
                    onChanged: controller.toggleNew,
                  ),
                  const SizedBox(height: 12),
                  _buildSwitchRow(
                    title: 'عرض المنتجات للبيع',
                    subtitle: '68 منتجات',
                    value: controller.forSale,
                    onChanged: controller.toggleSale,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                      const Icon(Icons.attach_money),
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
                      Text('\$${controller.priceRange.start.toInt()}',
                          style: getMedium(color: AppColors.primary400, fontSize: 14)),
                      Text('\$${controller.priceRange.end.toInt()}',
                          style: getMedium(color: AppColors.primary400, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStoresFilter(SearchFilterController controller) {
    return GetBuilder<SearchFilterController>(
      builder: (_) {
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
                  _buildFilterItem('فئات', 'assets/images/svg_images/Category.svg'),
                  _buildFilterItem('المدينة', 'assets/images/svg_images/location.svg'),
                  _buildFilterItem('التقييم', 'assets/images/svg_images/Star.svg'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildSwitchRow(
                    title: 'عرض المتاجر النشطة',
                    subtitle: '45 متجر',
                    value: controller.activeStores,
                    onChanged: controller.toggleActiveStores,
                  ),
                  const SizedBox(height: 12),
                  _buildSwitchRow(
                    title: 'المتاجر المميزة',
                    subtitle: '12 متجر',
                    value: controller.featuredStores,
                    onChanged: controller.toggleFeaturedStores,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildServicesFilter(SearchFilterController controller) {
    return GetBuilder<SearchFilterController>(
      builder: (_) {
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
                  _buildFilterItem('التصنيف', 'assets/images/svg_images/filtter.svg'),
                  _buildFilterItem('المدينة', 'assets/images/svg_images/location.svg'),
                  _buildFilterItem('التقييم', 'assets/images/svg_images/Star.svg'),
                  _buildFilterItem('المراجعات', 'assets/images/svg_images/Chat9.svg'),
                  _buildFilterItem('مستوى البائع', 'assets/images/svg_images/Profile.svg'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildSwitchRow(
                    title: 'الخدمات المتاحة الآن',
                    subtitle: '89 خدمة',
                    value: controller.availableServices,
                    onChanged: controller.toggleAvailableServices,
                  ),
                  const SizedBox(height: 12),
                  _buildSwitchRow(
                    title: 'خدمات تحت الطلب',
                    subtitle: '34 خدمة',
                    value: controller.onDemandServices,
                    onChanged: controller.toggleOnDemandServices,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                      const Icon(Icons.attach_money),
                      const SizedBox(width: 5),
                      Text('النطاق السعري', style: getMedium()),
                    ],
                  ),
                  RangeSlider(
                    min: 0,
                    max: 300,
                    values: controller.servicePriceRange,
                    activeColor: AppColors.primary300,
                    onChanged: controller.changeServicePrice,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('\$${controller.servicePriceRange.start.toInt()}',
                          style: getMedium(color: AppColors.primary400, fontSize: 14)),
                      Text('\$${controller.servicePriceRange.end.toInt()}',
                          style: getMedium(color: AppColors.primary400, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildUsersFilter(SearchFilterController controller) {
    return GetBuilder<SearchFilterController>(
      builder: (_) {
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
                  _buildFilterItem('المدينة', 'assets/images/svg_images/location.svg'),
                  _buildFilterItem('التقييم', 'assets/images/svg_images/Star.svg'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildSwitchRow(
                    title: 'حساب موثق',
                    subtitle: '',
                    value: controller.activeUsers,
                    onChanged: controller.toggleActiveUsers,
                  ),
                  const SizedBox(height: 12),
                  _buildSwitchRow(
                    title: 'مستخدمين مميزين',
                    subtitle: '',
                    value: controller.featuredUsers,
                    onChanged: controller.toggleFeaturedUsers,
                  ),
                  const SizedBox(height: 12),
                  _buildSwitchRow(
                    title: 'متصل الآن',
                    subtitle: '',
                    value: controller.onlineUsers,
                    onChanged: controller.toggleOnlineUsers,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
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
                      const Icon(Icons.calendar_month),
                      const SizedBox(width: 5),
                      Text('نطاق العمر', style: getMedium()),
                    ],
                  ),
                  RangeSlider(
                    min: 18,
                    max: 80,
                    values: controller.ageRange,
                    activeColor: AppColors.primary300,
                    onChanged: controller.changeAgeRange,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${controller.ageRange.start.toInt()} سنة',
                          style: getMedium(color: AppColors.primary400, fontSize: 14)),
                      Text('${controller.ageRange.end.toInt()} سنة',
                          style: getMedium(color: AppColors.primary400, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterItem(String title, String iconPath) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(iconPath, width: 20, height: 20, fit: BoxFit.cover),
              const SizedBox(width: 5),
              Text(title, style: getMedium()),
            ],
          ),
          Text('الكل', style: getMedium(color: AppColors.neutral500, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildSwitchRow({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14)),
            if (subtitle.isNotEmpty)
              Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ),
        Switch(
          value: value,
          activeColor: AppColors.primary300,
          onChanged: onChanged,
        ),
      ],
    );
  }

  IconData _getIconForSearchType(app.SearchType type) {
    switch (type) {
      case app.SearchType.products:
        return Icons.shopping_bag;
      case app.SearchType.stores:
        return Icons.store;
      case app.SearchType.services:
        return Icons.handyman;
      case app.SearchType.users:
        return Icons.people;
    }
  }

  String _getTitleForSearchType(app.SearchType type) {
    switch (type) {
      case app.SearchType.products:
        return 'منتجات';
      case app.SearchType.stores:
        return 'متاجر';
      case app.SearchType.services:
        return 'خدمات';
      case app.SearchType.users:
        return 'مستخدمين';
    }
  }
}