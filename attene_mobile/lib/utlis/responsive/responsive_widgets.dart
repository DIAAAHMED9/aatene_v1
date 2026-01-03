import 'package:flutter/material.dart';

/// Canonical responsive helpers used across the app.
///
/// Keep this API stable: multiple legacy screens/widgets depend on it.
///
/// Historically, some feature folders shipped their own `ResponsiveWidgets`.
/// Those feature-local files should now `export` this canonical implementation
/// to avoid duplicate-class import conflicts.
class ResponsiveWidgets {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return w >= 600 && w < 1200;
  }

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1200;

  static int getGridCrossAxisCount(BuildContext context) {
    if (isMobile(context)) return 2;
    if (isTablet(context)) return 3;
    return 4;
  }

  static EdgeInsets getContentPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.symmetric(horizontal: 16);
    if (isTablet(context)) return const EdgeInsets.symmetric(horizontal: 24);
    return const EdgeInsets.symmetric(horizontal: 32);
  }

  static EdgeInsets getSectionPadding(BuildContext context) {
    if (isMobile(context)) return const EdgeInsets.fromLTRB(16, 20, 16, 12);
    if (isTablet(context)) return const EdgeInsets.fromLTRB(24, 24, 24, 16);
    return const EdgeInsets.fromLTRB(32, 28, 32, 20);
  }

  static double getProductImageSize(BuildContext context) {
    if (isMobile(context)) return 80.0;
    if (isTablet(context)) return 100.0;
    return 120.0;
  }

  static double getFontSize(BuildContext context, {required double baseSize}) {
    if (isMobile(context)) return baseSize;
    if (isTablet(context)) return baseSize * 1.1;
    return baseSize * 1.2;
  }

  // Extra helpers used in some product screens (kept for compatibility)
  static double getButtonHeight(BuildContext context) {
    if (isMobile(context)) return 48.0;
    if (isTablet(context)) return 52.0;
    return 56.0;
  }

  static double getTextFieldHeight(BuildContext context) {
    if (isMobile(context)) return 50.0;
    if (isTablet(context)) return 54.0;
    return 58.0;
  }

  static double getIconSize(BuildContext context) {
    if (isMobile(context)) return 20.0;
    if (isTablet(context)) return 22.0;
    return 24.0;
  }
}
