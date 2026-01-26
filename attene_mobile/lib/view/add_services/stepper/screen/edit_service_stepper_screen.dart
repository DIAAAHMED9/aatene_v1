import '../../../../general_index.dart';
import '../index.dart';

/// شاشة تعديل خدمة (Wrapper) بنفس أسلوب تعديل المنتجات.
///
/// **ملاحظة مهمة**: هذا الاسم كان مطلوباً في بعض الأجزاء (Routes/Calls)
/// لذلك وجوده يحل خطأ: "EditServiceStepperScreen isn't defined".
class EditServiceStepperScreen extends StatelessWidget {
  final String serviceId;

  const EditServiceStepperScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return ServiceStepperScreen(isEditMode: true, serviceId: serviceId);
  }
}
