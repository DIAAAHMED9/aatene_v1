import 'package:flutter/widgets.dart';

class AppLifecycleManager with WidgetsBindingObserver {
  AppLifecycleManager._();
  static final AppLifecycleManager I = AppLifecycleManager._();

  bool _registered = false;
  AppLifecycleState _state = AppLifecycleState.resumed;

  void register() {
    if (_registered) return;
    WidgetsBinding.instance.addObserver(this);
    _registered = true;
  }

  void unregister() {
    if (!_registered) return;
    WidgetsBinding.instance.removeObserver(this);
    _registered = false;
  }

  bool get isRegistered => _registered;

  /// ✅ يسمح بإظهار الديلوج فقط عندما يكون التطبيق نشط/ظاهر
  bool get canShowDialogs =>
      _state == AppLifecycleState.resumed || _state == AppLifecycleState.inactive;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _state = state;
  }
}
