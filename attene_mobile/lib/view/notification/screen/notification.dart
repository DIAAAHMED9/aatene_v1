import 'package:attene_mobile/general_index.dart';


/// MODEL
class NotificationModel {
  final String title;
  final String body;
  final String time;
  final String? image;
  final bool isRead;

  NotificationModel({
    required this.title,
    required this.body,
    required this.time,
    this.image,
    required this.isRead,
  });

  NotificationModel copyWith({bool? isRead}) {
    return NotificationModel(
      title: title,
      body: body,
      time: time,
      image: image,
      isRead: isRead ?? this.isRead,
    );
  }
}

/// CONTROLLER
class NotificationController extends GetxController {
  final pageController = PageController();
  final currentIndex = 0.obs;

  final notifications = <NotificationModel>[
    NotificationModel(
      title: 'عاد المنتج المفضل لديك للتوفر الآن!',
      body: 'تحقق من الكمية المتوفرة قبل انتهاء العرض',
      time: 'منذ ساعة',
      image: 'assets/images/user1.png',
      isRead: false,
    ),
    NotificationModel(
      title: 'خصم جديد على متجرك المفضل!',
      body: 'المنتج الذي أضفته لمفضلاتك عاد للتخزين',
      time: 'منذ ساعة',
      image: 'assets/images/user1.png',
      isRead: false,
    ),
  ].obs;

  NotificationModel? _lastRemoved;
  int? _lastRemovedIndex;

  List<NotificationModel> get unreadList =>
      notifications.where((e) => !e.isRead).toList();

  List<NotificationModel> get readList =>
      notifications.where((e) => e.isRead).toList();

  void changePage(int index) {
    currentIndex.value = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
    );
  }

  void markAsRead(NotificationModel model) {
    final index = notifications.indexOf(model);
    if (index != -1) {
      notifications[index] = model.copyWith(isRead: true);
    }
  }

  void removeWithUndo(NotificationModel model) {
    _lastRemovedIndex = notifications.indexOf(model);
    _lastRemoved = model;
    notifications.remove(model);

    Get.snackbar(
      'تم حذف الإشعار',
      '',
      snackPosition: SnackPosition.BOTTOM,
      mainButton: TextButton(
        onPressed: undoDelete,
        child: const Text(
            'تراجع', style: TextStyle(color: AppColors.neutral100)),
      ),
      backgroundColor: AppColors.primary50,
      colorText: AppColors.primary400,
      duration: const Duration(seconds: 4),
    );
  }

  void undoDelete() {
    if (_lastRemoved != null && _lastRemovedIndex != null) {
      notifications.insert(_lastRemovedIndex!, _lastRemoved!);
      _lastRemoved = null;
      _lastRemovedIndex = null;
    }
  }
}

/// PAGE
class NotificationPage extends StatelessWidget {
  NotificationPage({super.key});

  final controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),
      body: Column(
        spacing: 10,
        children: [
          const SizedBox(height: 10),
          _tabs(),
          const SizedBox(height: 10),
          Expanded(
            child: PageView(
              controller: controller.pageController,
              onPageChanged: controller.changePage,
              children: const [
                NotificationList(isRead: false),
                NotificationList(isRead: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _appBar() {
    return
      AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "الإشعارات",
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
        actions: [
          IconButton(onPressed: () {
            ///NotificationFeed
            Get.to(NotificationFeed());
          },
              icon: SvgPicture.asset(
                "assets/images/svg_images/setting2.svg", height: 25,
                width: 25,
                fit: BoxFit.cover,)),

        ],
      );
  }

  Widget _tabs() {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _TabButton(
              title: 'غير مقروءة',
              active: controller.currentIndex.value == 0,
              onTap: () => controller.changePage(0),
            ),
            const SizedBox(width: 12),
            _TabButton(
              title: 'مقروءة',
              active: controller.currentIndex.value == 1,
              onTap: () => controller.changePage(1),
            ),
          ],
        ),
      );
    });
  }
}

/// =======================================================
/// TAB BUTTON
/// =======================================================
class _TabButton extends StatelessWidget {
  final String title;
  final bool active;
  final VoidCallback onTap;

  const _TabButton({
    required this.title,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: active ? AppColors.primary400 : AppColors.primary50,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            title,
            style: getMedium(
                color: active ? AppColors.light1000 : AppColors.primary400),
          ),
        ),
      ),
    );
  }
}

/// LIST
class NotificationList extends StatelessWidget {
  final bool isRead;

  const NotificationList({super.key, required this.isRead});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Obx(() {
      final list = isRead ? controller.readList : controller.unreadList;

      if (list.isEmpty) return const _EmptyState();

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: list.length,
        itemBuilder: (_, index) {
          return AnimatedNotificationItem(
            model: list[index],
            onDelete: () => controller.removeWithUndo(list[index]),
            onMarkRead: () => controller.markAsRead(list[index]),
          );
        },
      );
    });
  }
}

/// ANIMATED ITEM (Swipe + Scale + Collapse)
class AnimatedNotificationItem extends StatefulWidget {
  final NotificationModel model;
  final VoidCallback onDelete;
  final VoidCallback onMarkRead;

  const AnimatedNotificationItem({
    super.key,
    required this.model,
    required this.onDelete,
    required this.onMarkRead,
  });

  @override
  State<AnimatedNotificationItem> createState() =>
      _AnimatedNotificationItemState();
}

class _AnimatedNotificationItemState extends State<AnimatedNotificationItem> {
  bool visible = true;

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: visible
          ? TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.95, end: 1),
        duration: const Duration(milliseconds: 300),
        builder: (_, value, child) {
          return Transform.scale(scale: value, child: child);
        },
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Dismissible(
            key: ValueKey(widget.model.hashCode),
            direction: DismissDirection.horizontal,
            background: _markReadBg(),
            secondaryBackground: _deleteBg(),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                widget.onMarkRead();
                return false;
              } else {
                setState(() => visible = false);
                Future.delayed(
                  const Duration(milliseconds: 300),
                  widget.onDelete,
                );
                return true;
              }
            },
            child: _NotificationItem(model: widget.model),
          ),
        ),
      )
          : const SizedBox.shrink(),
    );
  }

  Widget _deleteBg() =>
      Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 24),
        decoration: BoxDecoration(
          color: AppColors.error200,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          spacing: 5,
          children: [
            Text("حذف",
                style: getMedium(color: AppColors.light1000, fontSize: 13)),
            Icon(Icons.delete, color: AppColors.light1000),
          ],
        ),
      );

  Widget _markReadBg() =>
      Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppColors.primary400,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          spacing: 5,
          children: [
            Icon(Icons.remove_red_eye_rounded, color: AppColors.light1000),
            Text(
              "تحديد كمقروء",
              style: getMedium(color: AppColors.light1000, fontSize: 13),
            ),

          ],
        ),
      );
}

/// ITEM UI
class _NotificationItem extends StatelessWidget {
  final NotificationModel model;

  const _NotificationItem({required this.model});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: model.image != null
              ? AssetImage(model.image!)
              : null,
          backgroundColor: Colors.grey.shade200,
        ),
        Expanded(
          child: Column(
            spacing: 3,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(model.title, style: getBold()),
              Text(
                model.body,
                style: getMedium(color: AppColors.neutral500, fontSize: 14),
              ),
              Text(
                model.time,
                style: getMedium(fontSize: 12, color: AppColors.neutral500),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// =======================================================
/// EMPTY STATE
/// =======================================================
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        spacing: 10,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/png/no_notification.png',
            height: 200,
            fit: BoxFit.cover,
          ),
          Text('لا توجد أي إشعارات', style: getBold(fontSize: 24)),
          Text(
            'عندما تتلقى إشعارات، ستظهر هنا',
            style: getMedium(color: AppColors.neutral500),
          ),
        ],
      ),
    );
  }
}
