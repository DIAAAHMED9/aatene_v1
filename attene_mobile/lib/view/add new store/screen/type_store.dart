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
          body: TypeStoreBody(
            controller: controller,
            myAppController: myAppController,
          ),
        );
      },
    );
  }
}
