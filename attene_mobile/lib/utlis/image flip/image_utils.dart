import 'package:flutter/material.dart';
import 'dart:math' as math;



class ImageUtils {
  static Widget flipHorizontal(
    String imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    Alignment alignment = Alignment.center,
  }) {
    return Transform(
      alignment: alignment,
      transform: Matrix4.rotationY(math.pi),
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        color: color,
      ),
    );
  }

  static Widget flipVertical(
    String imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    Alignment alignment = Alignment.center,
  }) {
    return Transform(
      alignment: alignment,
      transform: Matrix4.rotationX(math.pi),
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        color: color,
      ),
    );
  }

  static Widget flipCustom(
    String imagePath, {
    double? width,
    double? height,
    BoxFit fit = BoxFit.contain,
    Color? color,
    double angle = math.pi,
    Axis axis = Axis.vertical,
  }) {
    return Transform(
      alignment: Alignment.center,
      transform: axis == Axis.horizontal
          ? Matrix4.rotationY(angle)
          : Matrix4.rotationX(angle),
      child: Image.asset(
        imagePath,
        width: width,
        height: height,
        fit: fit,
        color: color,
      ),
    );
  }
}