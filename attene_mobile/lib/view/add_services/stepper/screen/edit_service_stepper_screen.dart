import '../../../../general_index.dart';
import '../index.dart';

class EditServiceStepperScreen extends StatelessWidget {
  final String serviceId;

  const EditServiceStepperScreen({super.key, required this.serviceId});

  @override
  Widget build(BuildContext context) {
    return ServiceStepperScreen(isEditMode: true, serviceId: serviceId);
  }
}
