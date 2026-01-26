import 'package:flutter/material.dart';


/// ---------------- ENUMS ----------------
enum StoreStatus { closed, tempClosed, open }

enum DayStatus { open, tempClosed, closed, inactive }

/// ---------------- APP ----------------
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: StoreStatusPage(status: StoreStatus.open),
//     );
//   }
// }

/// ---------------- PAGE ----------------
class StoreStatusPage extends StatelessWidget {
  final StoreStatus status;

  const StoreStatusPage({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final config = StoreStatusConfig.fromStatus(status);

    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Center(
        child: Container(
          height: 600,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child:

          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// -------- Image --------
                Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: config.bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Image.asset(config.imagePath, fit: BoxFit.contain),
                  ),
                ),
            
                const SizedBox(height: 16),
            
                /// -------- TITLE --------
                Text(
                  config.title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: config.titleColor,
                  ),
                ),
            
                const SizedBox(height: 6),
            
                /// -------- DESCRIPTION --------
                Text(
                  config.description,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
            
                const SizedBox(height: 22),
            
                /// -------- DAYS LIST --------
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(days.length, (index) {
                    final dayStatus = config.dayStatuses[index];
                    final isLast = index == days.length - 1;
            
                    return Row(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// -------- INDICATOR --------
            
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 14),
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: _dayStatusColor(dayStatus),
                                shape: BoxShape.circle,
                              ),
                            ),
                            if (!isLast)
                              Container(
                                width: 2,
                                height: 30,
                                color: _dayStatusColor(
                                  dayStatus,
                                ).withOpacity(0.4),
                              ),
                          ],
                        ),
                        const SizedBox(width: 10),
            
                        /// (TIME + DAY)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dayStatus == DayStatus.open
                                    ? '05:00PM - 07:00AM'
                                    : 'عطلة',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: dayStatus == DayStatus.open
                                      ? Colors.grey
                                      : Colors.red,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                days[index],
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
            
            
                        /// -------- STATUS TEXT --------
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(top: 14),
                          child: Text(
                            _statusText(dayStatus),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: _dayStatusColor(dayStatus),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ],
            ),
          ),


        ),
      ),
    );
  }
}

/// ---------------- HELPERS ----------------
Color _dayStatusColor(DayStatus status) {
  switch (status) {
    case DayStatus.open:
      return Colors.green;
    case DayStatus.tempClosed:
      return Colors.orange;
    case DayStatus.closed:
      return Colors.red;
    case DayStatus.inactive:
      return Colors.grey.shade300;
  }
}

String _statusText(DayStatus status) {
  switch (status) {
    case DayStatus.open:
      return 'يعمل';
    case DayStatus.tempClosed:
      return 'مغلق مؤقتًا';
    case DayStatus.closed:
      return 'لا يعمل';
    case DayStatus.inactive:
      return '';
  }
}

/// ---------------- CONFIG MODEL ----------------
class StoreStatusConfig {
  final String title;
  final String description;
  final String imagePath;
  final Color bgColor;
  final Color titleColor;
  final List<DayStatus> dayStatuses;

  StoreStatusConfig({
    required this.title,
    required this.description,
    required this.imagePath,
    required this.bgColor,
    required this.titleColor,
    required this.dayStatuses,
  });

  factory StoreStatusConfig.fromStatus(StoreStatus status) {
    switch (status) {
      case StoreStatus.closed:
        return StoreStatusConfig(
          title: 'المتجر مغلق حالياًَ',
          description: 'ان كنت متابع لهذا المتجر و مفعل الاشعارات سيتم اعلامك بكل الانشطة الخاصه بيه',
          imagePath: 'assets/images/png/closed-store.png',
          bgColor: Colors.red.shade50,
          titleColor: Colors.red,
          dayStatuses: List.generate(7, (_) => DayStatus.closed),
        );

      case StoreStatus.tempClosed:
        return StoreStatusConfig(
          title: 'المتجر مغلق مؤقتًا',
          description: 'ان كنت متابع لهذا المتجر و مفعل الاشعارات سيتم اعلامك بكل الانشطة الخاصه بيه',
          imagePath: 'assets/images/png/temp-closed-store.png',
          bgColor: Colors.orange.shade50,
          titleColor: Colors.orange,
          dayStatuses: [
            DayStatus.open,
            DayStatus.open,
            DayStatus.tempClosed,
            DayStatus.open,
            DayStatus.open,
            DayStatus.open,
            DayStatus.closed,
          ],
        );

      case StoreStatus.open:
        return StoreStatusConfig(
          title: 'المتجر يعمل',
          description: 'ان كنت متابع لهذا المتجر و مفعل الاشعارات سيتم اعلامك بكل الانشطة الخاصه بيه',
          imagePath: 'assets/images/png/open-store.png',
          bgColor: Colors.green.shade50,
          titleColor: Colors.green,
          dayStatuses: [
            DayStatus.open,
            DayStatus.open,
            DayStatus.open,
            DayStatus.open,
            DayStatus.open,
            DayStatus.open,
            DayStatus.closed,
          ],
        );
    }
  }
}

/// ---------------- DATA ----------------
const days = [
  'السبت',
  'الأحد',
  'الاثنين',
  'الثلاثاء',
  'الأربعاء',
  'الخميس',
  'الجمعة',
];
