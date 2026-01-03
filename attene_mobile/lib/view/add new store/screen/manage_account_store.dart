import '../../../general_index.dart';

class ManageAccountStore extends GetView<ManageAccountStoreController> {
  const ManageAccountStore({super.key});

  @override
  Widget build(BuildContext context) {

    final MyAppController myAppController = Get.find<MyAppController>();

    return GetBuilder<ManageAccountStoreController>(
      builder: (ManageAccountStoreController controller) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                const ManageAccountStoreHeader(),
                Expanded(
                  child: KeyboardDismissOnScroll(
                    child: ManageAccountStoreBody(
                        controller: controller,
                        myAppController: myAppController,
                      ),
                    
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}
