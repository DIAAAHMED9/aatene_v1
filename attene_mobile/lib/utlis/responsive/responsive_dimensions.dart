import 'package:flutter/material.dart';
import 'package:attene_mobile/utlis/responsive/responsive_service.dart';

class ResponsiveDimensions {
  static ResponsiveService get _responsive => ResponsiveService.instance;

  static double w(double figmaWidth) => _responsive.getWidth(figmaWidth);

  static double h(double figmaHeight) => _responsive.getHeight(figmaHeight);

  static double f(double figmaFontSize) =>
      _responsive.getFontSize(figmaFontSize);

  static EdgeInsets p(double padding) => _responsive.getPadding(padding);

  static EdgeInsets sp(double horizontal, double vertical) =>
      _responsive.getSymetricPadding(horizontal, vertical);

  static bool get isMobile => _responsive.isMobile;

  static bool get isTablet => _responsive.isTablet;

  static bool get isLaptop => _responsive.isLaptop;

  static DeviceType get deviceType => _responsive.deviceType;

  static EdgeInsets getContentPadding(BuildContext context) {
    if (isMobile) return const EdgeInsets.symmetric(horizontal: 16);
    if (isTablet) return const EdgeInsets.symmetric(horizontal: 24);
    return const EdgeInsets.symmetric(horizontal: 32);
  }

  static EdgeInsets getSectionPadding(BuildContext context) {
    if (isMobile) return const EdgeInsets.fromLTRB(16, 20, 16, 12);
    if (isTablet) return const EdgeInsets.fromLTRB(24, 24, 24, 16);
    return const EdgeInsets.fromLTRB(32, 28, 32, 20);
  }

  static double getProductImageSize(BuildContext context) {
    if (isMobile) return 80.0;
    if (isTablet) return 100.0;
    return 120.0;
  }

  static double getFontSize(BuildContext context, {required double baseSize}) {
    if (isMobile) return baseSize;
    if (isTablet) return baseSize * 1.1;
    return baseSize * 1.2;
  }

  static double getButtonHeight(BuildContext context) {
    if (isMobile) return 48.0;
    if (isTablet) return 52.0;
    return 56.0;
  }

  static double getTextFieldHeight(BuildContext context) {
    if (isMobile) return 50.0;
    if (isTablet) return 54.0;
    return 58.0;
  }

  static double getIconSize(BuildContext context) {
    if (isMobile) return 20.0;
    if (isTablet) return 22.0;
    return 24.0;
  }

  static int getGridCrossAxisCount(BuildContext context) {
    if (isMobile) return 2;
    if (isTablet) return 3;
    return 4;
  }
}
