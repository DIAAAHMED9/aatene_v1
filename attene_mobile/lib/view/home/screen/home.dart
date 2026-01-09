import '../../../general_index.dart';
import '../widget/aatene_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  @override
  Widget build(BuildContext context) {
    final isRTL = LanguageUtils.isRTL;
    return Scaffold(
      drawer: AateneDrawer(),
      appBar: AppBar(
        actions: [
          Row(
            children: [
              Container(
                margin: const EdgeInsets.only(right: 5.0, left: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(color: AppColors.primary50),
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/svg_images/Heart.svg',
                    semanticsLabel: 'My SVG Image',
                    height: 22,
                    width: 22,
                  ),
                  onPressed: () {},
                ),
              ),
              Container(
                margin: const EdgeInsets.only(right: 5.0, left: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  border: Border.all(color: AppColors.primary50),
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/images/svg_images/Notification.svg',
                    semanticsLabel: 'My SVG Image',
                    height: 22,
                    width: 22,
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('أهلاً, 👋', style: getRegular(fontSize: 14)),
            Text('اسم المستخدم', style: getMedium()),
          ],
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Row(
            spacing: 5,
            children: [
              Container(
                width: 90,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(color: AppColors.primary400),
                ),
                child: Center(
                  child: Row(
                    spacing: 3,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "كل المدن",
                        style: getMedium(
                          color: AppColors.primary400,
                          fontSize: 14,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: AppColors.secondary400,
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: TextFiledAatene(
                  isRTL: isRTL,
                  hintText: 'بحث',
                  filled: true,
                  suffixIcon: Padding(
                    padding: const EdgeInsets.all(5),
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary400,
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                  ),
                  textInputAction: TextInputAction.done,
                ),
              ),
            ],
          ),
          Stack(
            children: [
              // Blue curved background
              Positioned(
                left: -60,
                top: -40,
                bottom: -40,
                child: Container(
                  width: 220,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2F6BFF),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(200),
                      bottomRight: Radius.circular(200),
                    ),
                  ),
                ),
              ),

              // Darker wave
              Positioned(
                left: -20,
                bottom: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFF1F4FD8),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Text Content
              Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  top: 32,
                  left: 160,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "بيع كبير",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "ما يصل إلى 50%",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      "يحدث الآن",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              // Image
              Positioned(
                right: 0,
                bottom: 0,
                top: 0,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    "assets/model.png", // replace with your image
                    width: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              // Page Indicator
              Positioned(
                bottom: 16,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _dot(active: true),
                    _dot(),
                    _dot(),
                  ],
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
  static Widget _dot({bool active = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: active ? 16 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white54,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

}
