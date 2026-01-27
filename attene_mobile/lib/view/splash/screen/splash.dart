
import '../../../general_index.dart';
import '../../../utils/responsive/index.dart';
import '../../../utils/services/index.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _isInitializing = false;
  bool _showError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _startApp();
      }
    });
  }

  void _startApp() async {
    if (_isInitializing) return;
    
    setState(() {
      _isInitializing = true;
      _showError = false;
    });

    try {
      await AppInitializationService.initialize();
      if (mounted) {
        final storage = GetStorage();
        final bool isGuest = storage.read('is_guest') == true;
        Navigator.pushReplacementNamed(
          context,
          isGuest ? '/mainScreen' : '/onboarding',
        );
      }
    } catch (error) {
      print('❌ Error during app initialization: $error');
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _showError = true;
          _errorMessage = error.toString();
        });
      }
    }
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('خطأ في التهيئة'),
        content: Text('فشل في بدء التطبيق: $_errorMessage'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startApp();
            },
            child: const Text('إعادة المحاولة'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_showError && mounted) {
        _showErrorDialog();
        setState(() {
          _showError = false;
        });
      }
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(color: Colors.white),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxH = constraints.maxHeight.isFinite
                ? constraints.maxHeight
                : MediaQuery.of(context).size.height;

            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: SizedBox(
                      height: maxH * 0.55,
                      child: Image.asset(
                        'assets/images/gif/aatene.gif',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_isInitializing)
                    SizedBox(
                      width: ResponsiveDimensions.w(40),
                      height: ResponsiveDimensions.h(40),
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.light1000,
                        ),
                        strokeWidth: 3,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}