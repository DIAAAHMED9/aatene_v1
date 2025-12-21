
import 'package:attene_mobile/view/add%20new%20store/choose%20type%20store/manage_account_store_controller.dart';
import 'package:attene_mobile/view/add%20services/service_controller.dart';
import 'package:attene_mobile/view/advance%20info/keyword_controller.dart';
import 'package:attene_mobile/view/login%20and%20start/set%20new%20password/set_new_password.dart';
import 'package:attene_mobile/view/product%20variations/product_variation_controller.dart';
import 'package:attene_mobile/view/products/product_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:attene_mobile/controller/chat_controller.dart';
import 'package:attene_mobile/controller/create_store_controller.dart';
import 'package:attene_mobile/controller/product_controller.dart';
import 'package:attene_mobile/controller/section_controller.dart';
import 'package:attene_mobile/my_app/my_app_controller.dart';
import 'package:attene_mobile/utlis/app_lifecycle_manager.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:attene_mobile/utlis/language/language_controller.dart';
import 'package:attene_mobile/utlis/responsive/responsive_service.dart';
import 'package:attene_mobile/utlis/sheet_controller.dart';
import 'package:attene_mobile/view/Services/data_lnitializer_service.dart';
import 'package:attene_mobile/view/Services/data_sync_service.dart'
    show DataSyncService;
import 'package:attene_mobile/view/media_library/media_library_controller.dart';
import 'package:attene_mobile/view/products/product_controller.dart';
import 'package:attene_mobile/view/related_products/related_products_controller.dart';
import 'package:attene_mobile/view/screens_navigator_bottom_bar/product/add_product_controller.dart';

import 'package:attene_mobile/view/Splash/splash.dart';
import 'package:attene_mobile/view/login and start/forget_password/forget_password.dart';
import 'package:attene_mobile/view/login and start/login/login.dart';
import 'package:attene_mobile/view/login and start/Register/register.dart';
import 'package:attene_mobile/view/login and start/start_page.dart';
import 'package:attene_mobile/view/login and start/verfication/verfication.dart';
import 'package:attene_mobile/view/media_library/media_library_screen.dart';
import 'package:attene_mobile/view/onboarding/onbording.dart';
import 'package:attene_mobile/component/BottomNavigationBar/main_screen.dart';
import 'package:attene_mobile/add_product_stepper_screen.dart';

import 'view/related_products/related_products_screen.dart';

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
    Get.lazyPut(() => DataSyncService(), fenix: true);
    Get.lazyPut(() => ChatController(), fenix: true);

    Get.lazyPut(() => ManageAccountStoreController(), fenix: true);
    Get.lazyPut(() => ProductCentralController(), fenix: true);
    Get.lazyPut(() => ProductVariationController(), fenix: true);
    Get.lazyPut(() => KeywordController(), fenix: true);
    Get.lazyPut(() => AddProductController(), fenix: true);
    Get.lazyPut(() => MediaLibraryController(), fenix: true);
    Get.lazyPut(() => RelatedProductsController(), fenix: true);
    Get.lazyPut(() => ProductController(), fenix: true);
    Get.lazyPut(() => ProductService(), fenix: true);
    Get.lazyPut(() => SectionController(), fenix: true);
    Get.lazyPut(() => ServiceController(), fenix: true);

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
        FlutterQuillLocalizations.delegate,
      ],
      color: AppColors.primary400,
      theme: ThemeData(
        // الألوان الأساسية
        primaryColor: AppColors.primary500,
        scaffoldBackgroundColor: AppColors.light1000,
        // لون الخلفية العام

        // الحوارات (Dialogs)
        dialogBackgroundColor: AppColors.light1000,
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.light1000,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),

        // الـ Bottom Sheets
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.light1000,
          elevation: 8.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          modalBackgroundColor: AppColors.light1000,
          modalElevation: 8.0,
        ),

        // البطاقات (Cards)
        cardTheme: CardThemeData(
          color: AppColors.light1000,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),

        // AppBar
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.light1000,
          elevation: 0,
          centerTitle: true,
          foregroundColor: AppColors.neutral200,
          titleTextStyle: TextStyle(
            color: AppColors.neutral200,
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
          ),
        ),

        // الأزرار
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary500,
            foregroundColor: AppColors.light1000,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 24.0,
            ),
          ),
        ),

        // text Buttons
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.primary500),
        ),

        // Input Fields
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.light1000,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: AppColors.neutral900),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: AppColors.neutral900),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: AppColors.primary500),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25),
            borderSide: BorderSide(color: AppColors.error200),
          ),
        ),

        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: false,
        colorScheme:
        ColorScheme.light(
          primary: AppColors.primary500,
          secondary: AppColors.primary200,
          background: AppColors.light1000,
          surface: AppColors.light1000,
          onBackground: AppColors.neutral200,
          onSurface: AppColors.neutral200,
          error: AppColors.error200,
          onError: AppColors.light1000,
        ).copyWith(
          primary: AppColors.primary300,
          surface: AppColors.light1000,
        ), // يمكنك تغيير هذا إلى true إذا كنت تستخدم Material 3
      ),

      // Dark Theme (اختياري)
      darkTheme: ThemeData(
        primaryColor: AppColors.primary500,
        scaffoldBackgroundColor: AppColors.neutral200,
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.neutral300,
        ),
        colorScheme:
        ColorScheme.dark(
          primary: AppColors.primary500,
          secondary: AppColors.primary200,
          background: AppColors.neutral200,
          surface: AppColors.neutral300,
        ).copyWith(
          primary: AppColors.primary400,
          surface: AppColors.neutral200,
        ),
        dialogTheme: DialogThemeData(backgroundColor: AppColors.neutral300),
      ),

      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const SplashScreen()),
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

  // تفعيل التحسينات للرسومات
  // Paint.enableDithering = true;

  // تهيئة مدير دورة حياة التطبيق
  Get.put(AppLifecycleManager());

  runApp(const MyApp());
}
