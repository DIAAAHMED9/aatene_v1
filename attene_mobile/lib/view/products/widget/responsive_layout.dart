import 'package:flutter/material.dart';



class ResponsiveLayout {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1200;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static int getGridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) return 1;
    if (isTablet(context)) return 2;
    return 3;
  }

  static double getProductImageSize(BuildContext context) {
    if (isMobile(context)) return 80.0;
    if (isTablet(context)) return 100.0;
    return 120.0;
  }

  static EdgeInsets getContentPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.symmetric(horizontal: 16);
    if (isTablet(context)) return const EdgeInsets.symmetric(horizontal: 32);
    return const EdgeInsets.symmetric(horizontal: 64);
  }

  static EdgeInsets getSectionPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.fromLTRB(16, 20, 16, 12);
    if (isTablet(context)) return const EdgeInsets.fromLTRB(24, 24, 24, 16);
    return const EdgeInsets.fromLTRB(32, 28, 32, 20);
  }

  static double getFontSize(BuildContext context, {required double baseSize}) {
    if (isMobile(context)) return baseSize;
    if (isTablet(context)) return baseSize * 1.1;
    return baseSize * 1.2;
  }

  static double getCardElevation(BuildContext context) {
    if (isMobile(context)) return 2.0;
    if (isTablet(context)) return 4.0;
    return 6.0;
  }
}