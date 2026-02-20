enum AppViewMode { user, merchantProducts, merchantServices }

extension AppViewModeX on AppViewMode {
  String get key {
    switch (this) {
      case AppViewMode.user:
        return 'user';
      case AppViewMode.merchantProducts:
        return 'merchant_products';
      case AppViewMode.merchantServices:
        return 'merchant_services';
    }
  }

  static AppViewMode fromKey(String? value) {
    switch (value) {
      case 'merchant_products':
        return AppViewMode.merchantProducts;
      case 'merchant_services':
        return AppViewMode.merchantServices;
      case 'user':
      default:
        return AppViewMode.user;
    }
  }

  bool get isMerchant => this != AppViewMode.user;
}
