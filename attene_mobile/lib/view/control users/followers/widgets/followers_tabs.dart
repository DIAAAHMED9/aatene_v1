import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../component/text/aatene_custom_text.dart';
import '../../../../utlis/colors/app_color.dart';
import '../controller/followers_controller.dart';

class FollowersTabs extends StatelessWidget {
  FollowersTabs({super.key});

  final controller = Get.find<FollowersController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Row(
            children: [
              _tab(
                text: 'أشخاص تتابعهم',
                index: 0,
                selected: controller.currentIndex.value == 0,
              ),
              const SizedBox(width: 12),
              _tab(
                text: 'المتابعين',
                index: 1,
                selected: controller.currentIndex.value == 1,
              ),
            ],
          ),

          const SizedBox(height: 6),

          AnimatedAlign(
            duration: const Duration(milliseconds: 300),
            alignment: controller.currentIndex.value == 0
                ? Alignment.centerLeft
                : Alignment.centerRight,
            child: Container(
              width: MediaQuery.of(context).size.width / 2 - 30,
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.primary500,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _tab({
    required String text,
    required int index,
    required bool selected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Container(
          height: 42,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xFF3E5C7F)
                : const Color(0xFFDCE6F3),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Text(
            text,
            style: getMedium(
              color: selected ? Colors.white : AppColors.primary400,
            ),
          ),
        ),
      ),
    );
  }
}