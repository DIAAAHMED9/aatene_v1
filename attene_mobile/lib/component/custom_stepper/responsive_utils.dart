import 'package:flutter/material.dart';



class DeviceType {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static double getStepperHeight(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600) return 100;
    if (width < 1024) return 80;
    return 60;
  }

  static int getMaxVisibleSteps(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 400) return 2;
    if (width < 600) return 3;
    if (width < 800) return 4;
    if (width < 1024) return 5;
    return 6;
  }
}