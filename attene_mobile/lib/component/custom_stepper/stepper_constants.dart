import '../../utils/colors/index.dart';
import 'package:flutter/material.dart';



import '../../utils/colors/app_color.dart';

class StepperConstants {
  static const Color primaryColor = AppColors.primary400;
  static const Color successColor = Colors.green;
  static const Color errorColor = Colors.red;
  static const Color warningColor = Colors.orange;
  static const Color disabledColor = Colors.grey;

  static const double mobileStepHeight = 100.0;
  static const double tabletStepHeight = 80.0;
  static const double desktopStepHeight = 60.0;

  static const double stepCircleSizeMobile = 40.0;
  static const double stepCircleSizeTablet = 36.0;
  static const double stepCircleSizeDesktop = 32.0;

  static const Duration stepTransitionDuration = Duration(milliseconds: 300);
  static const Duration buttonAnimationDuration = Duration(milliseconds: 200);

  static const EdgeInsets stepPaddingMobile = EdgeInsets.all(12.0);
  static const EdgeInsets stepPaddingTablet = EdgeInsets.all(10.0);
  static const EdgeInsets stepPaddingDesktop = EdgeInsets.all(8.0);
}