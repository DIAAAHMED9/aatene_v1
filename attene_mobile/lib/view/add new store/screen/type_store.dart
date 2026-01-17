import '../../../general_index.dart';

class TypeStore extends GetView<CreateStoreController> {
  const TypeStore({super.key});

  @override
  Widget build(BuildContext context) {
    final MyAppController myAppController = Get.find<MyAppController>();

    return GetBuilder<CreateStoreController>(
      builder: (CreateStoreController controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            title: Text('نوع المتجر', style: getRegular()),
            centerTitle: false,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () => Get.back(),
                child: const CircleAvatar(
                  backgroundColor: Color(0XFF1F29370D),
                  child: Icon(Icons.arrow_back, color: Colors.black),
                ),
              ),
            ),
          ),
          body: TypeStoreBody(
            controller: controller,
            myAppController: myAppController,
          ),
        );
      },
    );
  }
}
