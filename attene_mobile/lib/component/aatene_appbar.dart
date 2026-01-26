import '../general_index.dart';

class AateneAppbar extends StatelessWidget {
  const AateneAppbar({super.key, required this.title});

  final dynamic title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,

        style: getBold(color: AppColors.neutral100, fontSize: 20),
      ),
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

      // leading: IconButton(
      //   onPressed: () {},
      //   icon: Container(
      //     width: 50,
      //     height: 50,
      //     decoration: BoxDecoration(
      //       borderRadius: BorderRadius.circular(100),
      //       color: Colors.grey[300],
      //     ),
      //     child: Icon(Icons.arrow_back, color: AppColors.primary500),
      //   ),
      // ),
    );
  }
}
