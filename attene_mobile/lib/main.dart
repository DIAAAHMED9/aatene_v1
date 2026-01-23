import 'package:attene_mobile/view/favorite/screen/favorites.dart';
import 'package:attene_mobile/view/onboarding/screen/new_onboarding.dart';
import 'package:attene_mobile/view/onboarding/screen/onbording.dart';
import 'package:attene_mobile/view/profile/user%20profile/controller/user_controller.dart';
import 'package:attene_mobile/view/search/screen/search_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'general_index.dart';
import 'utlis/responsive/index.dart';
import 'utlis/services/device_name_service.dart';

import 'utlis/sheet_controller.dart';

class AppBindings extends Bindings {
  static bool _initialized = false;

  @override
  void dependencies() {
    if (_initialized) return;

    print('🔄 [APP BINDINGS] تسجيل المتحكمات الأساسية فقط...');

    Get.lazyPut(() => GetStorage(), fenix: true);
    // Keep MyAppController alive for the whole app lifecycle.
    // It owns auth/session state used by API headers.
    Get.put(MyAppController(), permanent: true);
    Get.lazyPut(() => ResponsiveService(), fenix: true);
    Get.lazyPut(() => LanguageController(), fenix: true);
    // نحتاجهما مبكراً (قبل/بعد تسجيل الدخول) لضمان عمل اختيار المتجر والتهيئة
    Get.lazyPut(() => DataInitializerService(), fenix: true);
    Get.lazyPut(() => StoreSelectionController(), fenix: true);
    // Get.lazyPut<HomeController>(() => HomeController());

    print('✅ [APP BINDINGS] تم تسجيل الأساسيات');

    _delayOtherBindings();

    _initialized = true;
  }

  void _delayOtherBindings() {
    Future.delayed(const Duration(seconds: 3), () {
      print('🔄 [APP BINDINGS] تسجيل المتحكمات المتبقية...');

      Get.lazyPut(() => BottomSheetController(), fenix: true);
      Get.lazyPut(() => CreateStoreController(), fenix: true);
      Get.lazyPut(() => DataSyncService(), fenix: true);
      Get.lazyPut(() => ChatController(), fenix: true);

      Future.delayed(const Duration(seconds: 2), () {
        Get.lazyPut(() => ManageAccountStoreController(), fenix: true);
        Get.lazyPut(() => ProductCentralController(), fenix: true);
        Get.lazyPut(() => ProductVariationController(), fenix: true);
        Get.lazyPut(() => KeywordController(), fenix: true);
        Get.lazyPut(() => AddProductController(), fenix: true);
        Get.lazyPut(() => MediaLibraryController(), fenix: true);
        Get.lazyPut(() => StoriesController(), fenix: true);
        Get.lazyPut(() => RelatedProductsController(), fenix: true);
        Get.lazyPut(() => ProductController(), fenix: true);
        Get.lazyPut(() => ProductService(), fenix: true);
        Get.lazyPut(() => SectionController(), fenix: true);
        Get.lazyPut(() => ServiceController(), fenix: true);
        Get.lazyPut(() => ProfileController(), fenix: true);
        Get.lazyPut(() => StoriesController(), fenix: true);
        print('✅ [APP BINDINGS] تم تسجيل جميع المتحكمات');
      });
    });
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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        FlutterQuillLocalizations.delegate,
      ],
      color: AppColors.primary400,
      theme: ThemeData(
        fontFamily: "PingAR",
        primaryColor: AppColors.primary500,
        scaffoldBackgroundColor: AppColors.light1000,
        dialogBackgroundColor: AppColors.light1000,
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.light1000,
          elevation: 8.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.light1000,
          elevation: 8.0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          modalBackgroundColor: AppColors.light1000,
          modalElevation: 8.0,
        ),
        cardTheme: CardThemeData(
          color: AppColors.light1000,
          elevation: 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.light1000,
          elevation: 0,
          centerTitle: false,
          foregroundColor: AppColors.neutral200,
          titleTextStyle: getMedium(
            color: AppColors.neutral200,
            fontSize: 18.0,
          ),
        ),
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
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(foregroundColor: AppColors.primary500),
        ),
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
        colorScheme: ColorScheme.light(
          primary: AppColors.primary500,
          secondary: AppColors.primary200,
          background: AppColors.light1000,
          surface: AppColors.light1000,
          onBackground: AppColors.neutral200,
          onSurface: AppColors.neutral200,
          error: AppColors.error200,
          onError: AppColors.light1000,
        ).copyWith(primary: AppColors.primary300, surface: AppColors.light1000),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => FavoritesScreen()),
        GetPage(name: '/onboarding', page: () => const Onboarding()),
        GetPage(name: '/start_login', page: () => const StartLogin()),
        GetPage(name: '/login', page: () => Login()),
        GetPage(name: '/register', page: () => Register()),
        GetPage(name: '/forget_password', page: () => ForgetPassword()),
        GetPage(name: '/verification', page: () => Verification()),
        GetPage(name: '/set_new_password', page: () => SetNewPassword()),
        GetPage(name: '/selectStore', page: () => const StoreSelectionScreen()),
        GetPage(name: '/mainScreen', page: () => MainScreen()),
        GetPage(name: '/media_library', page: () => MediaLibraryScreen()),
        GetPage(name: '/story-test', page: () => const StoryTestScreen()),
        GetPage(name: '/add-story', page: () => const AddStoryScreen()),
        GetPage(name: '/related-products', page: () => RelatedProductsScreen()),
        // Services add/edit (same flow as products)
        GetPage(
          name: '/add-service',
          page: () {
            final args = (Get.arguments is Map)
                ? Map<String, dynamic>.from(Get.arguments)
                : <String, dynamic>{};

            final bool isEditMode = args['isEditMode'] == true;
            final String? serviceId = args['serviceId']?.toString();

            return ServiceStepperScreen(
              isEditMode: isEditMode,
              serviceId: serviceId,
            );
          },
        ),
        GetPage(name: '/stepper-screen', page: () => DemoStepperScreen()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('🚀 بدء تشغيل التطبيق...');

  await _initializeEssentialServices();

  runApp(const MyApp());

  _initializeBackgroundServices();
}

Future<void> _initializeEssentialServices() async {
  print('🔄 تهيئة الخدمات الأساسية...');

  await GetStorage.init();

  print('✅ تم تهيئة الخدمات الأساسية');
}

void _initializeBackgroundServices() {
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final GetStorage storage = GetStorage();

    print('🔄 بدء الخدمات الخلفية...');
    await Future.delayed(const Duration(seconds: 2));

    try {
      String deviceName = await DeviceNameService.getDeviceName();
      storage.write('device_name', deviceName);
      print('📱 الجهاز المستخدم: $deviceName');

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      print('✅ تم تهيئة Firebase في الخلفية');

      await PushNotificationService().setupInteractedMessage();

      Get.put(AppLifecycleManager(), permanent: true);

      // ✅ Ensure notification permission (Android 13+/iOS) and never store a null token
      try {
        await FirebaseMessaging.instance.requestPermission();
      } catch (_) {}

      // Listen for token refresh updates
      FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
        if (newToken.trim().isNotEmpty) {
          storage.write('device_token', newToken);
          print('🔄 FCM Token refreshed: $newToken');
        }
      });

      final token = await FirebaseMessaging.instance.getToken();

      if (token != null) {
        storage.write('device_token', token);

        print('📱 FCM Token: $token');
      }

      final RemoteMessage? initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      if (initialMessage != null) {
        print('📨 تم تشغيل التطبيق من خلال إشعار');
      }

      print('✅ اكتملت الخدمات الخلفية');
    } catch (e) {
      print('⚠️ خطأ في الخدمات الخلفية: $e');
    }
  });
}
