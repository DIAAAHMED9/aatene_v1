
import '../../../../general_index.dart';

class JobAdvertisementCard extends StatefulWidget {
  const JobAdvertisementCard({super.key});

  @override
  State<JobAdvertisementCard> createState() => _JobAdvertisementCardState();
}

class _JobAdvertisementCardState extends State<JobAdvertisementCard> {
  // bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    // الأبعاد المطلوبة: العرض 160، الارتفاع 250
    const double width = double.infinity;
    const double height = 250.0;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // 1. الصورة الخلفية
            Image.network(
              "https://images.unsplash.com/photo-1498050108023-c5249f4df085?w=400",
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),

            // 2. طبقة تعتيم (Gradient Overlay) لجعل النص مقروءاً
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
            // 3. المحتوى النصي والأزرار
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Row(
                      spacing: 5,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.red,
                          child: Icon(
                            Icons.flash_on,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "اسم الشركة",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "90% تقييم",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 7,
                              ),
                            ),
                            Text(
                              "مطلوب مطور php للعمل \nلدى شركة dah Technology",
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              softWrap: true,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 100,
                      height: 50,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary400,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        "عرض المزيد",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
