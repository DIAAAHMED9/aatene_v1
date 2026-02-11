import 'package:attene_mobile/general_index.dart';

class NotificationEmptyState extends StatelessWidget {
  final bool isReadTab;
  const NotificationEmptyState({super.key, this.isReadTab = false});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/png/no_notification.png',
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Text(
            isReadTab ? 'لا توجد إشعارات مقروءة' : 'لا توجد أي إشعارات',
            style: getBold(fontSize: 24),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              isReadTab
                  ? 'عندما تقرأ الإشعارات، ستظهر هنا'
                  : 'عندما تتلقى إشعارات، ستظهر هنا',
              style: getMedium(color: AppColors.neutral500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
