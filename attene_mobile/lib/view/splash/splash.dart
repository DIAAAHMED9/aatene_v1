import 'package:attene_mobile/utlis/services/app_initialization_service.dart';
import 'package:flutter/material.dart';
import '../../utlis/colors/app_color.dart';
import '../../utlis/responsive/responsive_dimensions.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeAnimation();
    _startApp();
  }

  void _initializeAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 7),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  void _startApp() async {
    try {
      await Future.wait<void>([
        Future.delayed(_controller.duration!),
        AppInitializationService.initialize(),
      ]);
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/onboarding');
      }
    } catch (error) {
      print('❌ Error during app initialization: $error');
      if (mounted) {
        _showErrorDialog(error.toString());
      }
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Initialization Error'),
        content: Text('Failed to start app: $error'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _startApp();
            },
            child: const Text('Retry'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            colors: [Color(0xFF6394CB), Color(0xFF38587B)],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _animation,
            child: ScaleTransition(
              scale: _animation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/gif/aatene.gif',
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
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
            ),
          ),
        ),
      ),
    );
  }
}
