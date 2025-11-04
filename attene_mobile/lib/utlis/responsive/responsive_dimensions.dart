import 'package:attene_mobile/utlis/responsive/responsive_service.dart';
import 'package:flutter/material.dart';
class ResponsiveDimensions {
  static ResponsiveService get _responsive => ResponsiveService.instance;
  static double w(double figmaWidth) => _responsive.getWidth(figmaWidth);
  static double h(double figmaHeight) => _responsive.getHeight(figmaHeight);
  static double f(double figmaFontSize) => _responsive.getFontSize(figmaFontSize);
  static EdgeInsets p(double padding) => _responsive.getPadding(padding);
  static EdgeInsets sp(double horizontal, double vertical) => 
      _responsive.getSymetricPadding(horizontal, vertical);
  static bool get isMobile => _responsive.isMobile;
  static bool get isTablet => _responsive.isTablet;
  static bool get isLaptop => _responsive.isLaptop;
  static DeviceType get deviceType => _responsive.deviceType;
}