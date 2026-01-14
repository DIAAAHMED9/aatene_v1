
import '../../../general_index.dart';


class DrawerControllerX extends GetxController {
  final accounts = <DrawerAccount>[
    DrawerAccount(
      name: 'Cody Fisher',
      avatar: 'https://i.pravatar.cc/150?img=3',
    ),
    DrawerAccount(
      name: 'Rahaf Store',
      avatar: 'https://i.pravatar.cc/150?img=5',
    ),
    DrawerAccount(
      name: 'Makeup Provider store',
      avatar: 'https://i.pravatar.cc/150?img=8',
    ),
  ].obs;

  final selectedAccountIndex = 0.obs;

  void switchAccount(int index) {
    selectedAccountIndex.value = index;
    // هنا يمكنك تنفيذ API / Token / Navigation
  }

  void addAccount() {
    // فتح Dialog أو BottomSheet
  }
}
