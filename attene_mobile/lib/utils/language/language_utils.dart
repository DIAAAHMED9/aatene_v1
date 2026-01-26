import 'package:flutter/material.dart';
import 'package:get/get.dart';



class LanguageUtils {
  static bool get isRTL {
    try {
      final locale = Get.locale;
      if (locale == null) return false;
      const rtlLanguages = ['ar', 'he', 'fa', 'ur', 'ps', 'ku'];
      return rtlLanguages.contains(locale.languageCode);
    } catch (e) {
      return false;
    }
  }

  static bool get isLTR => !isRTL;

  static TextDirection get textDirection =>
      isRTL ? TextDirection.rtl : TextDirection.ltr;

  static Alignment get textAlignment =>
      isRTL ? Alignment.centerRight : Alignment.centerLeft;

  static AlignmentGeometry get startAlignment =>
      isRTL ? Alignment.centerRight : Alignment.centerLeft;

  static AlignmentGeometry get endAlignment =>
      isRTL ? Alignment.centerLeft : Alignment.centerRight;

  static Widget directionAwareWidget(Widget child) {
    return Directionality(textDirection: textDirection, child: child);
  }
}