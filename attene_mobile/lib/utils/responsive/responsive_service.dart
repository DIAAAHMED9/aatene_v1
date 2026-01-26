import 'package:flutter/material.dart';
import 'package:get/get.dart';



class ResponsiveService extends GetxService {
  static ResponsiveService get instance => Get.find<ResponsiveService>();
  final double mobileBreakpoint = 600;
  final double tabletBreakpoint = 1024;
  final double baseWidth = 375;
  final double baseHeight = 812;

  double get screenWidth => Get.width;

  double get screenHeight => Get.height;

  DeviceType get deviceType {
    if (screenWidth < mobileBreakpoint) return DeviceType.mobile;
    if (screenWidth < tabletBreakpoint) return DeviceType.tablet;
    return DeviceType.laptop;
  }

  bool get isMobile => deviceType == DeviceType.mobile;

  bool get isTablet => deviceType == DeviceType.tablet;

  bool get isLaptop => deviceType == DeviceType.laptop;

  double getResponsiveSize(double figmaSize, {bool useHeight = false}) {
    final double baseSize = useHeight ? baseHeight : baseWidth;
    final double currentSize = useHeight ? screenHeight : screenWidth;
    double scaleFactor = _getScaleFactor();
    double responsiveSize = (figmaSize / baseSize) * currentSize * scaleFactor;
    return responsiveSize;
  }

  double getWidth(double figmaWidth) {
    return getResponsiveSize(figmaWidth, useHeight: false);
  }

  double getHeight(double figmaHeight) {
    return getResponsiveSize(figmaHeight, useHeight: true);
  }

  double getFontSize(double figmaFontSize) {
    double baseFontSize = getResponsiveSize(figmaFontSize, useHeight: false);
    switch (deviceType) {
      case DeviceType.mobile:
        return baseFontSize;
      case DeviceType.tablet:
        return baseFontSize * 1.15;
      case DeviceType.laptop:
        return baseFontSize * 1.3;
    }
  }

  EdgeInsets getPadding(double figmaPadding) {
    double responsivePadding = getResponsiveSize(
      figmaPadding,
      useHeight: false,
    );
    return EdgeInsets.all(responsivePadding);
  }

  EdgeInsets getSymetricPadding(double horizontal, double vertical) {
    return EdgeInsets.symmetric(
      horizontal: getWidth(horizontal),
      vertical: getHeight(vertical),
    );
  }

  double _getScaleFactor() {
    switch (deviceType) {
      case DeviceType.mobile:
        return 1.0;
      case DeviceType.tablet:
        return 0.85;
      case DeviceType.laptop:
        return 0.7;
    }
  }

  Future<ResponsiveService> init() async {
    return this;
  }
}

enum DeviceType { mobile, tablet, laptop }