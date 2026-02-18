import '../../../general_index.dart';

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Center(
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/png/no_favorite.png",
              width: 250,
              height: 250,
              fit: BoxFit.cover,
            ),
            Text(
              "لا توجد منتجات مفضلة",
              style: getBold(fontSize: 20, color: AppColors.primary400),
            ),
            Text(
              "يمكنك إضافة عنصر إلى مفضلاتك عن طريق النقر فوق (رمز القلب)",
                textAlign: TextAlign.center,
              style: getMedium(color: AppColors.neutral500),
            ),
          ],
        ),
      ),
    );
  }
}
