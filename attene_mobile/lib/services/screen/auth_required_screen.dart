import '../../general_index.dart';

class AuthRequiredScreen extends StatelessWidget {
  const AuthRequiredScreen({
    super.key,
    this.featureName,
  });

  final String? featureName;

  @override
  Widget build(BuildContext context) {
    final argName = (Get.arguments is Map)
        ? (Get.arguments['featureName'] as String?)
        : null;
    final title = argName ?? featureName ?? 'هذه الصفحة';

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: getMedium(fontSize: 16)),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.lock_outline, size: 64),
              const SizedBox(height: 12),
              Text(
                'يجب تسجيل الدخول للوصول إلى هذه الشاشة',
                textAlign: TextAlign.center,
                style: getMedium(fontSize: 16),
              ),
              const SizedBox(height: 18),
              AateneButton(
                buttonText: 'تسجيل الدخول',
                onTap: () {
                  // Leave guest mode & go to login
                  try {
                    final storage = GetStorage();
                    storage.write('is_guest', false);
                  } catch (_) {}
                  Get.offAllNamed('/login');
                },
                color: AppColors.primary400,
                borderColor: AppColors.primary400,
                textColor: AppColors.light1000,
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () => Get.back(),
                child: Text('رجوع', style: getMedium()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
