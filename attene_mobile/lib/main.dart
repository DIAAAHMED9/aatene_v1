import 'package:attene_mobile/controller/chat_controller.dart';
import 'package:attene_mobile/utlis/app_lifecycle_manager.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/view/Control_Panal_Vendor/controler_vindor.dart';
import 'package:attene_mobile/view/Control_Users/home_control.dart';
import 'package:attene_mobile/view/Services/Services%20Detail/services_detail.dart';
import 'package:attene_mobile/view/products/product%20details/product_details.dart';
import 'package:attene_mobile/view/products/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controller/create_store_controller.dart';
import 'controller/product_controller.dart';
import 'controller/section_controller.dart';

import 'my_app/my_app_controller.dart';
import 'utlis/language/language_controller.dart';
import 'utlis/responsive/responsive_service.dart';
import 'utlis/sheet_controller.dart';
import 'view/Services/data_lnitializer_service.dart';
import 'view/Services/data_sync_service.dart' show DataSyncService;
import 'view/advance_info/keyword_controller.dart';
import 'view/media_library/media_library_controller.dart';
import 'view/product_variations/product_variation_controller.dart';
import 'view/products/product_controller.dart';
import 'view/related_products/related_products_controller.dart';
import 'view/related_products/related_products_screen.dart';
import 'view/screens_navigator_bottom_bar/product/add_product_controller.dart';

import 'view/Splash/splash.dart';
import 'view/add new store/choose_type_store/manage_account_store_controller.dart';
import 'view/login and start/forget_password/forget_password.dart';
import 'view/login and start/login/login.dart';
import 'view/login and start/Register/register.dart';
import 'view/login and start/set_newPassword/set_new_password.dart';
import 'view/login and start/start_page.dart';
import 'view/login and start/verfication/verfication.dart';
import 'view/media_library/media_library_screen.dart';
import 'view/onboarding/onbording.dart';
import 'component/BottomNavigationBar/main_screen.dart';
import 'demo_stepper_screen.dart';

class AppBindings extends Bindings {
    static bool _initialized = false;

  @override
  void dependencies() {
    if (_initialized) return;
    print('🔄 [APP BINDINGS] تسجيل المتحكمات...');
    
    Get.lazyPut(() => GetStorage(), fenix: true);
    
    Get.lazyPut(() => MyAppController(), fenix: true);
    
    Get.lazyPut(() => ResponsiveService(), fenix: true);
    Get.lazyPut(() => LanguageController(), fenix: true);
    
    Get.lazyPut(() => DataInitializerService(), fenix: true);
    
    Get.lazyPut(() => BottomSheetController(), fenix: true);
    Get.lazyPut(() => CreateStoreController(), fenix: true);
    Get.lazyPut(()=> DataSyncService(), fenix: true);
      Get.lazyPut(()=>ChatController(), fenix: true);

    Get.lazyPut(() => ManageAccountStoreController(), fenix: true);
    Get.lazyPut(() => ProductCentralController(), fenix: true);
    Get.lazyPut(() => ProductVariationController(), fenix: true);
    Get.lazyPut(() => KeywordController(), fenix: true);
    Get.lazyPut(() => AddProductController(), fenix: true);
    Get.lazyPut(() => MediaLibraryController(), fenix: true);
    Get.lazyPut(()=>RelatedProductsController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => ProductService(), fenix: true);
    Get.lazyPut(() => SectionController(), fenix: true);
    
    print('✅ [APP BINDINGS] تم تسجيل جميع المتحكمات بنجاح');
     _initialized = true;
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
      color: AppColors.primary400,
      theme: ThemeData(
          primaryColor:AppColors.primary400,
          canvasColor: Colors.white,
          colorScheme: ColorScheme(
              brightness: Brightness.light,
              primary:AppColors.primary400,
              onPrimary: Colors.black,
              secondary: Colors.white,
              onSecondary: Colors.black12,
              error: Colors.redAccent,
              onError: Colors.red,
              surface: Colors.white,
              onSurface: AppColors.neutral200)),
      // theme: ThemeData(
      //   primaryColor: AppColors.primary500,
      //   primarySwatch: AppColors.secondary300,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      // ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const ControllerVendor()),
        GetPage(name: '/onboarding', page: () => const Onbording()),
        GetPage(name: '/start_login', page: () => const StartLogin()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/register', page: () => Register()),
        GetPage(name: '/forget_password', page: () => ForgetPassword()),
        GetPage(name: '/verification', page: () => Verification()),
        GetPage(name: '/set_new_password', page: () => SetNewPassword()),
        GetPage(name: '/mainScreen', page: () => MainScreen()),
        GetPage(name: '/media_library', page: () => MediaLibraryScreen()),
        GetPage(name: '/related-products', page: () => RelatedProductsScreen()),
        GetPage(name: '/stepper-screen', page: () => DemoStepperScreen()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await GetStorage.init();
  print('✅ [MAIN] تم تهيئة GetStorage بنجاح');
  Get.put(AppLifecycleManager());

  runApp(const MyApp());
}