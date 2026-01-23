import 'package:attene_mobile/general_index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<_FilterController>(
      init: _FilterController(),
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
                /// Indicator
                Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 20),

                /// Top Tabs
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.tabs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 3,
                  ),
                  itemBuilder: (_, index) {
                    final isSelected = controller.selectedTab == index;
                    return InkWell(
                      onTap: () => controller.changeTab(index),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFEAF1FF)
                              : const Color(0xFFF3F3F3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          controller.tabs[index],
                          style: getMedium(
                            color: isSelected
                                ? AppColors.primary400
                                : const Color(0xFF5F5F5F),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 16),

                /// Filters List (مع أيقونات)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F6F6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: List.generate(controller.filters.length, (index) {
                      final item = controller.filters[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              spacing: 5,
                              children: [
                                Icon(
                                  item.icon,
                                  size: 20,
                                  color: Colors.black87,
                                ),

                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            const Text(
                              'الكل',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),

                const SizedBox(height: 16),

                /// Switches
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
                              Text(
                                'عرض منتجات جديدة',
                                style: TextStyle(fontSize: 14),
                              ),
                              Text(
                                '127 منتج',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
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
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
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

                /// Price Range
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
                        spacing: 5,
                        children: [
                          Icon(Icons.category_outlined),
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
                            style: getMedium(
                              color: AppColors.primary400,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '\$${controller.priceRange.end.toInt()}',
                            style: getMedium(
                              color: AppColors.primary400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// Apply Button
                AateneButton(
                  onTap: () {
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
}

/// ================= CONTROLLER (داخل نفس الملف) =================
class _FilterController extends GetxController {
  int selectedTab = 3;

  bool newProducts = true;
  bool forSale = true;

  RangeValues priceRange = const RangeValues(0, 150);

  final List<String> tabs = ['خدمات', 'مستخدمين', 'متاجر', 'منتجات'];

  final List<_FilterItem> filters = [
    _FilterItem('فئات', Icons.grid_view_rounded),
    _FilterItem('التصنيفات', Icons.layers_outlined),
    _FilterItem('العلامات', Icons.local_offer_outlined),
    _FilterItem('المدينة', Icons.location_on_outlined),
    _FilterItem('الألوان', Icons.palette_outlined),
    _FilterItem('المقاسات', Icons.straighten_outlined),
  ];

  void changeTab(int index) {
    selectedTab = index;
    update();
  }

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
}

/// ================= MODEL =================
class _FilterItem {
  final String title;
  final IconData icon;

  const _FilterItem(this.title, this.icon);
}
