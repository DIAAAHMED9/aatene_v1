import '../../../../general_index.dart';
import '../index.dart';

/// شاشة إضافة خدمة جديدة (Wrapper) بنفس أسلوب المنتجات.
///
/// الهدف من هذا الملف هو توفير اسم شاشة واضح مثل AddProductStepperScreen
/// وكذلك تسهيل الربط مع الـ Routes إن وُجدت.
class AddServiceStepperScreen extends StatelessWidget {
  const AddServiceStepperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ServiceStepperScreen(isEditMode: false);
  }
}
