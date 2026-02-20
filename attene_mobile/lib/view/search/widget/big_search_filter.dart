import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/search/controller/search_controller.dart' as app;
import 'package:attene_mobile/view/search/controller/search_filter_controller.dart';
import 'package:attene_mobile/view/search/controller/search_filter_options_controller.dart';

import 'filter_selection_sheet.dart';

import '../controller/search_controller.dart';

class FilterBottomSheet extends StatelessWidget {
  final app.SearchType searchType;

  const FilterBottomSheet({super.key, required this.searchType});

  @override
  Widget build(BuildContext context) {
    final filterController = Get.put(SearchFilterController(), permanent: false);
    final searchController = Get.find<app.SearchController>();
    final optionsController = Get.put(SearchFilterOptionsController(), permanent: true);

    optionsController.ensureLoaded(searchType);

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

            Obx(() {
              if (optionsController.isLoading.value && optionsController.categories.isEmpty && optionsController.cities.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                );
              }
              if (optionsController.error.value.isNotEmpty && optionsController.categories.isEmpty && optionsController.cities.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(optionsController.error.value, style: getMedium(color: Colors.red)),
                );
              }
              return _buildFilterContent(searchType, filterController, optionsController, context);
            }),

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

    searchController.applyFilters(filters);
  }

  Widget _buildFilterContent(
    SearchType type,
    SearchFilterController controller,
    SearchFilterOptionsController options,
    BuildContext context,
  ) {
    switch (type) {
      case SearchType.products:
        return _buildProductsFilter(controller, options, context);
      case SearchType.stores:
        return _buildStoresFilter(controller, options, context);
      case SearchType.services:
        return _buildServicesFilter(controller, options, context);
      case SearchType.users:
        return _buildUsersFilter(controller, options, context);
    }
  }

  Widget _buildProductsFilter(SearchFilterController controller, SearchFilterOptionsController options, BuildContext context) {
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
                  _buildFilterItem(
                    title: 'فئات',
                    iconPath: 'assets/images/svg_images/Category.svg',
                    valueText: _labelForId(options.categories, controller.selectedCategoryId),
                    onTap: () async {
                      final selected = await _pickSingle(context, title: 'اختيار فئة', items: options.categories);
                      controller.selectedCategoryId = selected;
                      controller.update();
                    },
                  ),
                  _buildFilterItem(
                    title: 'التصنيفات',
                    iconPath: 'assets/images/svg_images/filtter.svg',
                    valueText: _labelForId(options.sections, controller.selectedSectionId),
                    onTap: () async {
                      final selected = await _pickSingle(context, title: 'اختيار تصنيف', items: options.sections);
                      controller.selectedSectionId = selected;
                      controller.update();
                    },
                  ),
                  _buildFilterItem(
                    title: 'العلامات',
                    iconPath: 'assets/images/svg_images/tags.svg',
                    valueText: _multiLabel(options.tags, controller.selectedTagIds),
                    onTap: () async {
                      final selected = await _pickMulti(context, title: 'اختيار علامات', items: options.tags, current: controller.selectedTagIds);
                      controller.selectedTagIds
                        ..clear()
                        ..addAll(selected);
                      controller.update();
                    },
                  ),
                  _buildFilterItem(
                    title: 'المدينة',
                    iconPath: 'assets/images/svg_images/location.svg',
                    valueText: _labelForId(options.cities, controller.selectedCityId),
                    onTap: () async {
                      final selected = await _pickSingle(context, title: 'اختيار مدينة', items: options.cities);
                      controller.selectedCityId = selected;
                      controller.update();
                    },
                  ),
                  _buildFilterItem(
                    title: 'المقاسات/الخيارات',
                    iconPath: 'assets/images/svg_images/size.svg',
                    valueText: _multiLabel(options.variationOptions, controller.selectedVariationOptionIds, labelKey: 'name'),
                    onTap: () async {
                      final selected = await _pickMulti(
                        context,
                        title: 'اختيار المقاسات/الخيارات',
                        items: options.variationOptions,
                        current: controller.selectedVariationOptionIds,
                      );
                      controller.selectedVariationOptionIds
                        ..clear()
                        ..addAll(selected);
                      controller.update();
                    },
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

  Widget _buildStoresFilter(SearchFilterController controller, SearchFilterOptionsController options, BuildContext context) {
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
                  _buildFilterItem(
                    title: 'فئات',
                    iconPath: 'assets/images/svg_images/Category.svg',
                    valueText: _labelForId(options.categories, controller.selectedStoreCategoryId),
                    onTap: () async {
                      final selected = await _pickSingle(context, title: 'اختيار فئة', items: options.categories);
                      controller.selectedStoreCategoryId = selected;
                      controller.update();
                    },
                  ),
                  _buildFilterItem(
                    title: 'المدينة',
                    iconPath: 'assets/images/svg_images/location.svg',
                    valueText: _labelForId(options.cities, controller.selectedCityId),
                    onTap: () async {
                      final selected = await _pickSingle(context, title: 'اختيار مدينة', items: options.cities);
                      controller.selectedCityId = selected;
                      controller.update();
                    },
                  ),
                  _buildFilterItem(
                    title: 'التقييم (الحد الأدنى)',
                    iconPath: 'assets/images/svg_images/Star.svg',
                    valueText: controller.selectedReviewRateMin?.toString() ?? 'الكل',
                    onTap: () async {
                      final selected = await _pickRating(context, current: controller.selectedReviewRateMin);
                      controller.selectedReviewRateMin = selected;
                      controller.update();
                    },
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

  Widget _buildServicesFilter(SearchFilterController controller, SearchFilterOptionsController options, BuildContext context) {
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
                  _buildFilterItem(
                    title: 'التصنيف',
                    iconPath: 'assets/images/svg_images/filtter.svg',
                    valueText: _labelForId(options.categories, controller.selectedServiceCategoryId),
                    onTap: () async {
                      final selected = await _pickSingle(context, title: 'اختيار تصنيف', items: options.categories);
                      controller.selectedServiceCategoryId = selected;
                      controller.update();
                    },
                  ),
                  _buildFilterItem(
                    title: 'المدينة',
                    iconPath: 'assets/images/svg_images/location.svg',
                    valueText: _labelForId(options.cities, controller.selectedCityId),
                    onTap: () async {
                      final selected = await _pickSingle(context, title: 'اختيار مدينة', items: options.cities);
                      controller.selectedCityId = selected;
                      controller.update();
                    },
                  ),
                  _buildFilterItem(
                    title: 'التقييم (الحد الأدنى)',
                    iconPath: 'assets/images/svg_images/Star.svg',
                    valueText: controller.selectedReviewRateMin?.toString() ?? 'الكل',
                    onTap: () async {
                      final selected = await _pickRating(context, current: controller.selectedReviewRateMin);
                      controller.selectedReviewRateMin = selected;
                      controller.update();
                    },
                  ),
                  _buildFilterItem(
                    title: 'العلامات',
                    iconPath: 'assets/images/svg_images/tags.svg',
                    valueText: _multiLabel(options.tags, controller.selectedTagIds),
                    onTap: () async {
                      final selected = await _pickMulti(context, title: 'اختيار علامات', items: options.tags, current: controller.selectedTagIds);
                      controller.selectedTagIds
                        ..clear()
                        ..addAll(selected);
                      controller.update();
                    },
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

  Widget _buildUsersFilter(SearchFilterController controller, SearchFilterOptionsController options, BuildContext context) {
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
                  _buildFilterItem(
                    title: 'المدينة',
                    iconPath: 'assets/images/svg_images/location.svg',
                    valueText: _labelForId(options.cities, controller.selectedCityId),
                    onTap: () async {
                      final selected = await _pickSingle(context, title: 'اختيار مدينة', items: options.cities);
                      controller.selectedCityId = selected;
                      controller.update();
                    },
                  ),
                  _buildFilterItem(
                    title: 'التقييم',
                    iconPath: 'assets/images/svg_images/Star.svg',
                    valueText: controller.selectedReviewRate?.toString() ?? 'الكل',
                    onTap: () async {
                      final selected = await _pickRating(context, current: controller.selectedReviewRate);
                      controller.selectedReviewRate = selected;
                      controller.update();
                    },
                  ),
                  _buildFilterItem(
                    title: 'العلامات',
                    iconPath: 'assets/images/svg_images/tags.svg',
                    valueText: _multiLabel(options.tags, controller.selectedTagIds),
                    onTap: () async {
                      final selected = await _pickMulti(context, title: 'اختيار علامات', items: options.tags, current: controller.selectedTagIds);
                      controller.selectedTagIds
                        ..clear()
                        ..addAll(selected);
                      controller.update();
                    },
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

  Widget _buildFilterItem({
    required String title,
    required String iconPath,
    required String valueText,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
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
            Flexible(
              child: Text(
                valueText.isEmpty ? 'الكل' : valueText,
                textAlign: TextAlign.end,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: getMedium(color: AppColors.neutral500, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<int?> _pickSingle(
    BuildContext context, {
    required String title,
    required List<Map<String, dynamic>> items,
  }) async {
    final result = await showModalBottomSheet<List<int>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSelectionSheet(
        title: title,
        items: items,
        multi: false,
        selectedIds: <int>{},
        getId: (m) => int.tryParse(m['id'].toString()) ?? -1,
        getLabel: (m) => (m['name'] ?? m['title'] ?? m['label'] ?? '').toString(),
      ),
    );
    if (result == null || result.isEmpty) return null;
    return result.first;
  }

  Future<List<int>> _pickMulti(
    BuildContext context, {
    required String title,
    required List<Map<String, dynamic>> items,
    required List<int> current,
  }) async {
    final selected = <int>{...current};
    final result = await showModalBottomSheet<List<int>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSelectionSheet(
        title: title,
        items: items,
        multi: true,
        selectedIds: selected,
        getId: (m) => int.tryParse(m['id'].toString()) ?? -1,
        getLabel: (m) => (m['name'] ?? m['title'] ?? m['label'] ?? '').toString(),
      ),
    );
    if (result == null) return current;
    return result.where((e) => e > 0).toList();
  }

  Future<int?> _pickRating(BuildContext context, {int? current}) async {
    final items = List.generate(5, (i) => {'id': i + 1, 'name': '${i + 1}+'});
    final result = await showModalBottomSheet<List<int>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FilterSelectionSheet(
        title: 'اختيار التقييم',
        items: items,
        multi: false,
        selectedIds: current == null ? <int>{} : <int>{current},
        getId: (m) => m['id'] as int,
        getLabel: (m) => m['name'] as String,
      ),
    );
    if (result == null || result.isEmpty) return null;
    return result.first;
  }

  String _labelForId(List<Map<String, dynamic>> items, int? id) {
    if (id == null) return 'الكل';
    Map<String, dynamic>? found;
    for (final e in items) {
      if (int.tryParse(e['id'].toString()) == id) {
        found = e;
        break;
      }
    }
    return (found?['name'] ?? found?['title'] ?? 'الكل').toString();
  }

  String _multiLabel(
    List<Map<String, dynamic>> items,
    List<int> ids, {
    String labelKey = 'name',
  }) {
    if (ids.isEmpty) return 'الكل';
    final labels = <String>[];
    for (final id in ids) {
      Map<String, dynamic>? found;
      for (final e in items) {
        if (int.tryParse(e['id'].toString()) == id) {
          found = e;
          break;
        }
      }
      final label = (found?[labelKey] ?? found?['title'] ?? '').toString();
      if (label.isNotEmpty) labels.add(label);
    }
    if (labels.isEmpty) return 'مختار';
    if (labels.length <= 2) return labels.join(', ');
    return '${labels.take(2).join(', ')} (+${labels.length - 2})';
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