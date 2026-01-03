import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/followers_controller.dart';

class FollowersTabBar extends StatelessWidget {
  const FollowersTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FollowersController>();

    return Obx(
          () => Row(
            spacing: 10,
        children: [
          _TabItem(
            title: 'المتابعين',
            isSelected: controller.selectedTab.value == 0,
            onTap: () => controller.selectedTab.value = 0,
          ),
          _TabItem(
            title: 'أشخاص تتابعهم',
            isSelected: controller.selectedTab.value == 1,
            onTap: () => controller.selectedTab.value = 1,
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabItem({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary400 : AppColors.primary50,
            borderRadius: BorderRadius.circular(50),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style:getBold(  color: isSelected ? Colors.white : Colors.black,) ,
          ),
        ),
      ),
    );
  }
}
