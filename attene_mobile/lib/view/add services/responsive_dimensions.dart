import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ResponsiveDimensions {
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  static const double baseWidth = 390;
  static const double baseHeight = 844;

  static bool get isMobile {
    final context = Get.context;
    if (context == null) return true;
    final width = MediaQuery.of(context).size.width;
    return width < mobileBreakpoint;
  }

  static bool get isTablet {
    final context = Get.context;
    if (context == null) return false;
    final width = MediaQuery.of(context).size.width;
    return width >= mobileBreakpoint && width < tabletBreakpoint;
  }

  static bool get isDesktop {
    final context = Get.context;
    if (context == null) return false;
    final width = MediaQuery.of(context).size.width;
    return width >= tabletBreakpoint;
  }

  static double responsiveWidth(
    double mobile, [
    double? tablet,
    double? desktop,
  ]) {
    final context = Get.context;
    if (context == null) return mobile;

    final width = MediaQuery.of(context).size.width;
    final double scaleFactor = width / baseWidth;

    if (width >= tabletBreakpoint && desktop != null) {
      return desktop * (width / 1440);
    }
    if (width >= mobileBreakpoint && tablet != null) {
      return tablet * (width / 768);
    }
    return mobile * scaleFactor;
  }

  static double responsiveHeight(
    double mobile, [
    double? tablet,
    double? desktop,
  ]) {
    final context = Get.context;
    if (context == null) return mobile;

    final height = MediaQuery.of(context).size.height;
    final double scaleFactor = height / baseHeight;

    if (height >= 900 && desktop != null) return desktop;
    if (height >= 700 && tablet != null) return tablet;
    return mobile * scaleFactor;
  }

  static double responsiveFontSize(
    double mobile, [
    double? tablet,
    double? desktop,
  ]) {
    final context = Get.context;
    if (context == null) return mobile;

    final width = MediaQuery.of(context).size.width;
    final double scaleFactor = width / baseWidth;

    if (width >= tabletBreakpoint && desktop != null) {
      return desktop * 1.1;
    }
    if (width >= mobileBreakpoint && tablet != null) {
      return tablet;
    }
    return mobile * scaleFactor;
  }

  static EdgeInsets responsivePadding({
    double mobile = 16,
    double? tablet,
    double? desktop,
  }) {
    final value = responsiveWidth(mobile, tablet, desktop);
    return EdgeInsets.symmetric(horizontal: value);
  }

  static double responsiveRadius(
    double mobile, [
    double? tablet,
    double? desktop,
  ]) {
    return responsiveWidth(mobile, tablet, desktop);
  }

  static double responsiveSpace(
    double mobile, [
    double? tablet,
    double? desktop,
  ]) {
    return responsiveHeight(mobile, tablet, desktop);
  }

  static Size get screenSize {
    final context = Get.context;
    if (context == null) return const Size(baseWidth, baseHeight);
    return MediaQuery.of(context).size;
  }

  static bool get isRTL {
    final context = Get.context;
    if (context == null) return true;
    return Directionality.of(context) == TextDirection.rtl;
  }

  static double responsivePercentWidth(double percent) {
    final context = Get.context;
    if (context == null) return 0;
    final width = MediaQuery.of(context).size.width;
    return width * percent / 100;
  }

  static double responsivePercentHeight(double percent) {
    final context = Get.context;
    if (context == null) return 0;
    final height = MediaQuery.of(context).size.height;
    return height * percent / 100;
  }
}