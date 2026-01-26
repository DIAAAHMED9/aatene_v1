import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class LayoutUtils {
  static EdgeInsets directionSensitivePadding({
    double start = 0,
    double end = 0,
    double top = 0,
    double bottom = 0,
  }) {
    final isRTL = _isRTL();
    return isRTL
        ? EdgeInsets.fromLTRB(end, top, start, bottom)
        : EdgeInsets.fromLTRB(start, top, end, bottom);
  }

  static EdgeInsets directionSensitiveMargin({
    double start = 0,
    double end = 0,
    double top = 0,
    double bottom = 0,
  }) {
    return directionSensitivePadding(
      start: start,
      end: end,
      top: top,
      bottom: bottom,
    );
  }

  static Widget directionAwareIcon(
    IconData icon, {
    double size = 24,
    Color? color,
  }) {
    final isRTL = _isRTL();
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.rotationY(isRTL ? pi : 0),
      child: Icon(icon, size: size, color: color),
    );
  }

  static Row directionAwareRow({
    List<Widget> children = const [],
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
  }) {
    final isRTL = _isRTL();
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      children: isRTL ? children.reversed.toList() : children,
    );
  }

  static List<Widget> directionAwareExpanded(List<Widget> children) {
    final isRTL = _isRTL();
    return isRTL ? children.reversed.toList() : children;
  }

  static bool _isRTL() {
    try {
      final locale = Get.locale;
      if (locale == null) return false;
      const rtlLanguages = ['ar', 'he', 'fa', 'ur'];
      return rtlLanguages.contains(locale.languageCode);
    } catch (e) {
      return false;
    }
  }
}