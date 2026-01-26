import '../../../general_index.dart';

class AddNewStore extends StatelessWidget {
 const AddNewStore({super.key});

  @override
  Widget build(BuildContext context) {
    final CreateStoreController controller = Get.find<CreateStoreController>();
    final isRTL = LanguageUtils.isRTL;
    final arguments = Get.arguments;
    final int? storeId = arguments != null ? arguments['storeId'] : null;

    if (storeId != null && !controller.isEditMode.value) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.loadStoreForEdit(storeId);
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "البيانات الاساسية",
          style: getBold(color: AppColors.neutral100, fontSize: 20),
        ),
        centerTitle: false,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.grey[100],
            ),
            child: Icon(Icons.arrow_back, color: AppColors.neutral100),
          ),
        ),

      ),
      body: AddNewStoreForm(controller: controller, isRTL: isRTL),
    );
  }
}
