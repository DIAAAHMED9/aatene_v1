import '../../../general_index.dart';
import 'menu_group.dart';

class GroupName extends StatelessWidget {
  const GroupName({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "اسم المجموعة",
              style: getBold(color: AppColors.neutral100, fontSize: 20),
            ),
            Text(
              "5 عناصر",
              style: getMedium(color: AppColors.primary400, fontSize: 14),
            ),
          ],
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
        actions: [CustomMenuWidget()],
      ),
      body: Center(child: Text("data")),
    );
  }
}
