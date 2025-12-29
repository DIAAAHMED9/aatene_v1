class AppInitializationService {
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static Future<void> initialize() async {
    if (_isInitialized) return;
    try {
      print('🚀 Starting app initialization...');
      await _initializeFirebase();
      await _initializeApis();
      await _initializeDatabase();
      await _loadUserPreferences();
      await _checkAuthentication();
      _isInitialized = true;
      print('✅ App initialization completed successfully');
    } catch (error) {
      print('❌ App initialization failed: $error');
      rethrow;
    }
  }

  static Future<void> _initializeFirebase() async {
    print('📱 Initializing Firebase...');
    await Future.delayed(const Duration(milliseconds: 500));
  }

  static Future<void> _initializeApis() async {
    print('🌐 Initializing API clients...');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  static Future<void> _initializeDatabase() async {
    print('💾 Initializing database...');
    await Future.delayed(const Duration(milliseconds: 400));
  }

  static Future<void> _loadUserPreferences() async {
    print('⚙️ Loading user preferences...');
    await Future.delayed(const Duration(milliseconds: 200));
  }

  static Future<void> _checkAuthentication() async {
    print('🔐 Checking authentication...');
    await Future.delayed(const Duration(milliseconds: 300));
  }
}