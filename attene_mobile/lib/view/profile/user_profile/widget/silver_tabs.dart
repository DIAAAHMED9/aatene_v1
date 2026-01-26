import '../../../../general_index.dart';
import 'package:attene_mobile/view/profile/common/profile_controller_base.dart';

class SilverTabs extends SliverPersistentHeaderDelegate {
  final BaseProfileController controller;

  SilverTabs(this.controller);

  @override
  double get minExtent => 56;

  @override
  double get maxExtent => 56;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      width: double.infinity,
      height: 100,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Obx(
        () => Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.neutral900),
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: List.generate(3, (index) {
              final titles = ['نظرة عامة', 'تقييمات', 'المفضلة'];
              final isActive = controller.currentTab.value == index;

              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.changeTab(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary50
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      titles[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: isActive ? AppColors.primary400 : Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
