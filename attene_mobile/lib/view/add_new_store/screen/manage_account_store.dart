import '../../../general_index.dart';

class ManageAccountStore extends StatelessWidget {
  const ManageAccountStore({super.key});

  @override
  Widget build(BuildContext context) {
    final MyAppController myAppController = Get.find<MyAppController>();

    return Scaffold(
      body: GetBuilder<ManageAccountStoreController>(
        // ✅ Defensive init to avoid "Unexpected null value" if bindings order changes.
        init: Get.isRegistered<ManageAccountStoreController>()
            ? Get.find<ManageAccountStoreController>()
            : ManageAccountStoreController(),
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
        },
      ),
    );
  }
}
