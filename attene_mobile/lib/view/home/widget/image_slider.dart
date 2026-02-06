import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home_controller.dart';
import 'dot.dart';

class ImageSlider extends StatelessWidget {
  const ImageSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();
    
    return SizedBox(
      height: 240,
      width: double.infinity,
      child: Stack(
        children: [
          // PageView بدون PageController (لتجنب المشاكل)
          PageView.builder(
            itemCount: controller.images.length,
            onPageChanged: controller.onImageSliderPageChanged,
            itemBuilder: (context, index) {
              return Obx(() => AnimatedOpacity(
                opacity: controller.imageSliderCurrentIndex.value == index ? 1.0 : 0.5,
                duration: const Duration(milliseconds: 300),
                child: Hero(
                  tag: controller.images[index],
                  child: Image.asset(
                    controller.images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 240,
                  ),
                ),
              ));
            },
          ),

          // النقاط الإرشادية
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  controller.images.length,
                  (index) => Dot(active: index == controller.imageSliderCurrentIndex.value),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}