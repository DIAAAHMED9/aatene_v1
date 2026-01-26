import 'dart:ui';
import 'package:get/get.dart';



class LanguageController extends GetxController {
  var appLocale = 'ar'.obs;

  void changeLanguage(String languageCode) {
    appLocale.value = languageCode;
    Get.updateLocale(Locale(languageCode));
  }

  String get currentLanguage => Get.locale?.languageCode ?? 'en';
}