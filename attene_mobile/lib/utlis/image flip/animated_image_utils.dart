import 'package:flutter/material.dart';
import 'dart:math' as math;



class AnimatedImageUtils {
  static Widget animatedFlip(
    String imagePath, {
    required AnimationController controller,
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Axis axis = Axis.horizontal,
  }) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: axis == Axis.horizontal
              ? Matrix4.rotationY(controller.value * math.pi)
              : Matrix4.rotationX(controller.value * math.pi),
          child: Image.asset(imagePath, width: width, height: height, fit: fit),
        );
      },
    );
  }
}