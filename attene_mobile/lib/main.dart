import 'package:attene_mobile/component/BottomNavigationBar/main_screen.dart';
import 'package:attene_mobile/my_app/may_app_controller.dart'
    show MyAppController;
import 'package:attene_mobile/utlis/language/language_controller.dart';
import 'package:attene_mobile/utlis/responsive/responsive_service.dart';
import 'package:attene_mobile/view/Services/Home%20/home_services.dart';
import 'package:attene_mobile/view/Services/Services%20Detail/services_detail.dart';
import 'package:attene_mobile/view/add%20new%20store/add_new_store.dart';
import 'package:attene_mobile/view/add%20new%20store/shipping%20method/add_shipping_method.dart';
import 'package:attene_mobile/view/add%20new%20store/shipping%20method/edit_shipping_method.dart';
import 'package:attene_mobile/view/add%20new%20store/shipping%20method/edit_shipping_price.dart';
import 'package:attene_mobile/view/add%20new%20store/shipping%20method/shipping_method.dart';
import 'package:attene_mobile/view/login%20and%20start/Register/register.dart';
import 'package:attene_mobile/view/login%20and%20start/set_newPassword/set_new_password.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/chat/chat_all.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'utlis/sheet_controller.dart';
import 'view/login and start/forget_password/forget_password.dart';
import 'view/login and start/login/login.dart';
import 'view/login and start/start_page.dart';
import 'view/login and start/verfication/verfication.dart';
import 'view/onboarding/onbording.dart';

void main() {
  runApp(const MyApp());
}

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(ResponsiveService());
    Get.put(MyAppController());
    Get.put(LanguageController());
    Get.put(ProductController());
    Get.put(BottomSheetController());

    // Get.put(BottomNavigationController());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Aatene App',
      initialBinding: AppBindings(),
      locale: Locale('ar', 'AE'),
      supportedLocales: [Locale('en', 'US'), Locale('ar', 'AE')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => ChatAll(),
        '/onboarding': (context) => const Onbording(),
        '/start_login': (context) => const StartLogin(),
        '/login': (context) => Login(),
        '/register': (context) => Register(),
        '/forget_password': (context) => ForgetPassword(),
        '/verification': (context) => Verification(),
        '/set_new_password': (context) => SetNewPassword(),
        '/mainScreen': (context) => MainScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
