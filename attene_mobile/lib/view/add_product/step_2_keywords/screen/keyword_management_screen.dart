

import '../../../../general_index.dart';
import '../../../../utils/responsive/index.dart';

class KeywordManagementScreen extends StatefulWidget {
  const KeywordManagementScreen({super.key});

  @override
  State<KeywordManagementScreen> createState() =>
      _KeywordManagementScreenState();
}

class _KeywordManagementScreenState extends State<KeywordManagementScreen> {
  late KeywordController controller;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  void _initializeScreen() async {
    try {
      controller = Get.put(KeywordController());

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await controller.loadStoresOnOpen();
        setState(() {
          _isInitialized = true;
        });
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'خطأ في تحميل البيانات: $e';
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;

    if (!_isInitialized) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: AppColors.primary400),
              SizedBox(height: ResponsiveDimensions.f(20)),
              Text(
                'جاري تحضير البيانات...',
                style: getRegular(
                  fontSize: ResponsiveDimensions.f(16),
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(ResponsiveDimensions.f(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: ResponsiveDimensions.f(60),
                  color: Colors.red,
                ),
                SizedBox(height: ResponsiveDimensions.f(20)),
                Text(
                  _errorMessage!,
                  textAlign: TextAlign.center,
                  style: getRegular(
                    fontSize: ResponsiveDimensions.f(16),
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: ResponsiveDimensions.f(20)),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary400,
                    foregroundColor: Colors.white,
                  ),
                  child: Text('العودة'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(ResponsiveDimensions.f(16)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    KeywordHeaderWidget(),
                    SizedBox(height: ResponsiveDimensions.f(20)),
                    StoreSelectorWidget(),
                    SizedBox(height: ResponsiveDimensions.f(16)),
                    KeywordSearchBoxWidget(),
                    SizedBox(height: ResponsiveDimensions.f(20)),
                    AvailableKeywordsWidget(),
                    SizedBox(height: ResponsiveDimensions.f(20)),
                    SelectedKeywordsWidget(),
                    SizedBox(height: ResponsiveDimensions.f(40)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}