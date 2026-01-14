import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import 'dot.dart';

class ImageSlider extends GetView<HomeController> {
  const ImageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: Stack(
        children: [
          /// PageView (Slider)
          PageView.builder(
            controller: controller.pageController,
            itemCount: controller.images.length,
            onPageChanged: controller.onPageChanged,
            itemBuilder: (context, index) {
              return Hero(
                tag: controller.images[index],
                child: Image.network(
                  controller.images[index],
                  fit: BoxFit.contain,
                  width: double.infinity,
                  height: 240,
                ),
              );
            },
          ),

          /// Dots Indicator (Bottom Left)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.images.length,
                  (index) =>
                      Dot(active: index == controller.currentIndex.value),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
