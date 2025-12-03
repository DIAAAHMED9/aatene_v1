import 'package:attene_mobile/component/BottomNavigationBar/main_screen.dart';
import 'package:attene_mobile/controller/product_controller.dart';
import 'package:attene_mobile/demo_stepper_screen.dart';
import 'package:attene_mobile/my_app/may_app_controller.dart'
    show MyAppController;
import 'package:attene_mobile/utlis/language/language_controller.dart';
import 'package:attene_mobile/utlis/responsive/responsive_service.dart';
import 'package:attene_mobile/utlis/sheet_controller.dart';
import 'package:attene_mobile/view/Control_Panal_Vendor/controler_vindor.dart';
import 'package:attene_mobile/view/Services/Services%20Detail/services_detail.dart';
import 'package:attene_mobile/view/advance_info/keyword_controller.dart';
import 'package:attene_mobile/view/login%20and%20start/Register/register.dart';
import 'package:attene_mobile/view/login%20and%20start/set_newPassword/set_new_password.dart';
import 'package:attene_mobile/view/media_library/media_library_controller.dart';
import 'package:attene_mobile/view/media_library/media_library_screen.dart';
import 'package:attene_mobile/view/product_variations/product_variation_controller.dart';
import 'package:attene_mobile/view/related_products/related_products_screen.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/add_product_controller.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'view/Splash/splash.dart';
import 'view/login and start/forget_password/forget_password.dart';
import 'view/login and start/login/login.dart';
import 'view/login and start/start_page.dart';
import 'view/login and start/verfication/verfication.dart';
import 'view/onboarding/onbording.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

// في main.dart - التأكد من تسجيل الـ Controllers
class AppBindings extends Bindings {
  @override
  void dependencies() {
    print('🔄 [APP BINDINGS] Registering controllers...');
    
    // ✅ Services الأساسية
    Get.put(ResponsiveService(), permanent: true);
    Get.put(MyAppController(), permanent: true);
    Get.put(LanguageController(), permanent: true);
    
    // ✅ الـ Controllers الرئيسية - بدون تحميل بيانات تلقائي
    Get.put(BottomSheetController(), permanent: true);
    Get.put(ProductCentralController(), permanent: true);
    Get.put(ProductVariationController(), permanent: true);
    Get.put(KeywordController(), permanent: true);
    Get.put(AddProductController(), permanent: true);
    Get.put(MediaLibraryController(), permanent: true);
    
    print('✅ [APP BINDINGS] All controllers registered successfully');
  }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Aatene App',
      initialBinding: AppBindings(),
      locale: const Locale('ar', 'AE'),
      supportedLocales: const [Locale('en', 'US'), Locale('ar', 'AE')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(

        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const ServicesDetail()),
        // GetPage(name: '/onboarding', page: () => const Onbording()),
        // GetPage(name: '/start_login', page: () => const StartLogin()),
        // GetPage(name: '/login', page: () => Login()),
        // GetPage(name: '/register', page: () => Register()),
        // GetPage(name: '/forget_password', page: () => ForgetPassword()),
        // GetPage(name: '/verification', page: () => Verification()),
        // GetPage(name: '/set_new_password', page: () => SetNewPassword()),
        // GetPage(name: '/mainScreen', page: () => MainScreen()),
        // GetPage(name: '/media_library', page: () => MediaLibraryScreen()),
        // GetPage(name: '/related-products', page: () => RelatedProductsScreen()),
        // GetPage(name: '/stepper-screen', page: () => DemoStepperScreen()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}