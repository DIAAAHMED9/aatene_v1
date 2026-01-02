


import '../../general_index.dart';

extension AppColorScheme on ColorScheme {
  Color get warning => AppColors.warning300;

  Color get success => AppColors.success300;

  Color get error => AppColors.error300;

  Color get neutral => AppColors.neutral500;

  Color get warningBackground => AppColors.warning100;

  Color get successBackground => AppColors.success100;

  Color get errorBackground => AppColors.error100;
}

class AppColorThemes {
  static ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primary300,
    primarySwatch: _createMaterialColor(AppColors.primary300),
    scaffoldBackgroundColor: AppColors.light1000,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.light1000,
      foregroundColor: AppColors.neutral100,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary300,
      secondary: AppColors.secondary300,
      background: AppColors.light1000,
      surface: AppColors.light1000,
      onBackground: AppColors.neutral100,
      onSurface: AppColors.neutral100,
    ),
    textTheme:  TextTheme(
      displayLarge:getRegular(color: AppColors.neutral100),
      displayMedium: getRegular(color: AppColors.neutral100),
      displaySmall:getRegular(color: AppColors.neutral100),
      bodyLarge: getRegular(color: AppColors.neutral200),
      bodyMedium: getRegular(color: AppColors.neutral300),
      bodySmall:getRegular(color: AppColors.neutral400),
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary200,
    scaffoldBackgroundColor: AppColors.neutral100,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.neutral100,
      foregroundColor: AppColors.light1000,
      elevation: 0,
    ),
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary200,
      secondary: AppColors.secondary200,
      background: AppColors.neutral100,
      surface: AppColors.neutral200,
      onBackground: AppColors.light1000,
      onSurface: AppColors.light1000,
    ),
  );

  static MaterialColor _createMaterialColor(Color color) {
    final Map<int, Color> swatch = {
      50: _withAlpha(color, 0.1),
      100: _withAlpha(color, 0.2),
      200: _withAlpha(color, 0.3),
      300: _withAlpha(color, 0.4),
      400: _withAlpha(color, 0.5),
      500: _withAlpha(color, 0.6),
      600: _withAlpha(color, 0.7),
      700: _withAlpha(color, 0.8),
      800: _withAlpha(color, 0.9),
      900: color,
    };
    return MaterialColor(color.value, swatch);
  }

  static Color _withAlpha(Color color, double opacity) {
    final alpha = (opacity * 255).round();
    return color.withAlpha(alpha);
  }
}