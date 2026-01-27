import '../../../general_index.dart';

class LoginRequiredScreen extends StatelessWidget {
  final String? message;
  const LoginRequiredScreen({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل الدخول مطلوب', style: getMedium()),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 80, color: AppColors.primary400),
              const SizedBox(height: 16),
              Text(
                message ?? 'هذه الصفحة تحتاج إلى تسجيل دخول.',
                textAlign: TextAlign.center,
                style: getMedium(fontSize: 16),
              ),
              const SizedBox(height: 20),
              AateneButton(
                buttonText: 'تسجيل الدخول',
                onTap: () => Get.offAllNamed('/login'),
                color: AppColors.primary400,
                borderColor: AppColors.primary400,
                textColor: AppColors.light1000,
              ),
              const SizedBox(height: 10),
              AateneButton(
                buttonText: 'رجوع',
                onTap: () => Get.back(),
                color: AppColors.primary100,
                borderColor: AppColors.primary100,
                textColor: AppColors.primary400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
