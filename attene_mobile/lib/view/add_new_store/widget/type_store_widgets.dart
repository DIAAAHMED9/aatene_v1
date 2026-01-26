import '../../../general_index.dart';

class TypeStoreBody extends StatelessWidget {
  final CreateStoreController controller;
  final MyAppController myAppController;

  const TypeStoreBody({
    super.key,
    required this.controller,
    required this.myAppController,
  });

  @override
  Widget build(BuildContext context) {
    if (!myAppController.isLoggedIn.value) {
      return const LoginRequiredView();
    }

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          spacing: 30,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            TypeStoreHeader(),
            StoreTypeOptions(),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: TypeStoreNextButton(),
            ),
          ],
        ),
      ),
    );
  }
}

class TypeStoreHeader extends StatelessWidget {
  const TypeStoreHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'قم باختيار نوع المتجر الذي تريده (تقديم خدمات / بيع منتجات)',
      style: getRegular(fontSize: 18),
    );
  }
}

class StoreTypeOptions extends GetView<CreateStoreController> {
  const StoreTypeOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CreateStoreController>(
      builder: (CreateStoreController controller) {
        return Column(
          children: [
            StoreTypeCard(
              type: 'products',
              title: 'متجر بيع المنتجات',
              description:
                  'بيع المنتجات المادية مثل الملابس، الإلكترونيات، الأثاث، وغيرها',
              icon: Icons.store,
              isSelected: controller.storeType.value == 'products',
            ),
            const SizedBox(height: 15),
            StoreTypeCard(
              type: 'services',
              title: 'متجر تقديم الخدمات',
              description:
                  'تقديم الخدمات مثل التصميم، البرمجة، الاستشارات، التعليم، وغيرها',
              icon: Icons.home_repair_service,
              isSelected: controller.storeType.value == 'services',
            ),
          ],
        );
      },
    );
  }
}

class StoreTypeCard extends GetView<CreateStoreController> {
  final String type;
  final String title;
  final String description;
  final IconData icon;
  final bool isSelected;

  const StoreTypeCard({
    super.key,
    required this.type,
    required this.title,
    required this.description,
    required this.icon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.setStoreType(type),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary400 : const Color(0XFFAAAAAA),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primary400
                  : const Color(0XFF393939),
              size: 30,
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: getRegular(
                fontSize: 18,
                color: isSelected
                    ? AppColors.primary400
                    : const Color(0XFF393939),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TypeStoreNextButton extends GetView<CreateStoreController> {
  const TypeStoreNextButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AateneButton(
      buttonText: 'التالي',
      textColor: Colors.white,
      color: AppColors.primary400,
      borderColor: AppColors.primary400,
      onTap: () {
        if (controller.storeType.value.isEmpty) {
          Get.snackbar(
            'تنبيه',
            'يرجى اختيار نوع المتجر',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
          );
          return;
        }
        Get.to(() => AddNewStore());
      },
    );
  }
}

class LoginRequiredView extends StatelessWidget {
  const LoginRequiredView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login_rounded, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'يجب تسجيل الدخول',
              style: getBold(fontSize: 24, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            Text(
              'يرجى تسجيل الدخول للوصول إلى إضافة المتاجر',
              style: getRegular(fontSize: 16, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            AateneButton(
              buttonText: 'تسجيل الدخول',
              textColor: Colors.white,
              color: AppColors.primary400,
              borderColor: AppColors.primary400,
              raduis: 10,
              onTap: () => Get.toNamed('/login'),
            ),
            const SizedBox(height: 16),
            AateneButton(
              buttonText: 'إنشاء حساب جديد',
              textColor: AppColors.primary400,
              color: Colors.white,
              borderColor: AppColors.primary400,
              raduis: 10,
              onTap: () => Get.toNamed('/register'),
            ),
          ],
        ),
      ),
    );
  }
}
