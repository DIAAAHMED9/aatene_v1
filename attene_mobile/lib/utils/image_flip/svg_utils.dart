import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:math' as math;



class SvgUtils {
  static Widget flipSvgHorizontal(
    String assetName, {
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
  }) {
    return Transform(
      alignment: alignment,
      transform: Matrix4.rotationY(math.pi),
      child: SvgPicture.asset(
        assetName,
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
        fit: fit,
      ),
    );
  }

  static Widget flipSvgVertical(
    String assetName, {
    double? width,
    double? height,
    Color? color,
    BoxFit fit = BoxFit.contain,
    Alignment alignment = Alignment.center,
  }) {
    return Transform(
      alignment: alignment,
      transform: Matrix4.rotationX(math.pi),
      child: SvgPicture.asset(
        assetName,
        width: width,
        height: height,
        colorFilter: color != null
            ? ColorFilter.mode(color, BlendMode.srcIn)
            : null,
        fit: fit,
      ),
    );
  }
}