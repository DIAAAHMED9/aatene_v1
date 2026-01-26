import '../../../../general_index.dart';

class StoryItem extends StatelessWidget {
  const StoryItem({super.key});

  // بيانات تجريبية لمحاكاة الصورة المرفقة
  final List<Map<String, String>> stories = const [
    {
      'username': 'johndoe',
      'image': 'assets/images/png/placeholder_bag_image_png.png',
    },
    {
      'username': 'x_ae-23b',
      'image': 'assets/images/png/placeholder_bag_image_png.png',
    },
    {
      'username': 'saylortwift',
      'image': 'assets/images/png/placeholder_bag_image_png.png',
    },
    {
      'username': 'maisenpai',
      'image': 'assets/images/png/placeholder_bag_image_png.png',
    },
    {
      'username': 'x_ae-23b',
      'image': 'assets/images/png/placeholder_bag_image_png.png',
    },
    {
      'username': 'johndoe',
      'image': 'assets/images/png/placeholder_bag_image_png.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        // لمحاذاة النص العربي لليمين
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Text(
              'ابرز القصص',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            width: double.infinity,
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: stories.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // إطار القصة المتدرج (Gradient Border)
                      Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue,
                              Colors.purpleAccent,
                              AppColors.primary400,
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: CircleAvatar(
                            radius: 22,
                            backgroundImage: AssetImage(
                              stories[index]['image']!,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        stories[index]['username']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4A5667),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
