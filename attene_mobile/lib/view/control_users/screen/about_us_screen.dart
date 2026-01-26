import '../../../general_index.dart';
import '../widget/card.dart';
import '../widget/section_card3.dart';
import '../widget/section_items2.dart';
import '../widget/section_title.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "عن  أعطيني",
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
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 15,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 20,
                children: [
                  Text(
                    '"أعطيني" هي منصة إلكترونية وسّطية، تربط بين مزوّدي الخدمات وبائعي المنتجات المحليين مع الزبائن ، عبر واجهة بسيطة وسريعة، نمنح كل شخص عنده خدمة أو منتج فرصة للظهور الرقمي، والوصول لجمهور مهتم بدون عمولات أو تعقيدات.',
                    style: getRegular(
                      fontSize: 14,
                      color: AppColors.neutral600,
                    ),
                  ),
                  Text('من نحن؟', style: getBold()),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/png/mainus.png',
                        height: 300,
                        width: 320,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    'في قلب الناصرة، بين شوارعها القديمة وأحلام شبابها وبناتها، انطلقت فكرة أعطيني. نحن مجموعة شباب وصبايا من الناصرة، كبرنا وسط تحديات السوق المحلي، وشفنا كيف التجار الصغار ومزوّدي الخدمات عم بواجهوا صعوبة يوصلوا لزبائنهم… وشفنا كمان الزبون، اللي دايمًا بيدوّر على خدمةموثوقة أو منتج مضمون، ومش دايمًا بلاقيهم بسهولة.',
                    style: getBold(fontSize: 12),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: AppColors.colorAboutUsScreen,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "رؤيتنا ورسالتنا نحو دعم المشاريع المحلية",
                      style: getBold(),
                    ),
                    Text(
                      "نعمل على تمكين المشاريع الصغيرة من التوسع والظهور الرقمي، ونمنح كل مستخدم مساحة ذكية وسهلة للوصول إلى الخدمات والمنتجات المحلية بسرعة وثقة.",
                      style: getRegular(
                        fontSize: 12,
                        color: AppColors.neutral600,
                      ),
                    ),
                    SectionTitle(
                      title: "رؤيتنا",
                      subtitle:
                          "أن نكون المنصة الرائدة في ربط الناس بخدمات ومنتجات محلية تعزز الاقتصاد المجتمعي في كل حي ومدينة.",
                    ),
                    SectionTitle(
                      title: "رسالتنا",
                      subtitle:
                          "توفير مساحة رقمية لكل مزوّد خدمة أو منتج محلي لعرض أعماله، ومنح المستخدم طريقة ذكية وسريعة للحصول على احتياجاته.",
                    ),
                    SectionTitle(
                      title: "أهدافنا",
                      subtitle:
                          "تمكين المشاريع الصغيرة، تسهيل عملية البيع، وخلق فرص دخل إضافية لأصحاب المهارات والمشاريع الفردية.",
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      CircleAvatar(
                        backgroundColor: AppColors.neutral100,
                        radius: 3,
                      ),
                      Text("لماذا نحن؟", style: getBold()),
                    ],
                  ),
                  Text(
                    'في "أعطيني"، نؤمن بأن البيع والشراء يجب أن يكون سهلاً، سريعاً، وخالياً من التعقيدات. لذلك نوفر لك منصة موثوقة تربطك مباشرة بأهل منطقتك، بدون عمولات، مع دعم مستمر وتنوع كبير في الخدمات والمنتجات.',
                    style: getRegular(fontSize: 14, letterSpacin: -0.5),
                  ),
                  SizedBox(height: 20),
                  SectionItems2(
                    title: "بدون عمولة على المبيعات",
                    subtitle:
                        "احتفظ بكامل أرباحك دون اقتطاعات، وركز على تنمية عملك وزيادة دخلك.",
                    icon: Image.asset('assets/images/png/section1.png'),
                  ),
                  SectionItems2(
                    title: "سهولة استخدام من جميع الأجهزة",
                    subtitle:
                        "تصفح وبيع واشتري بسهولة من الهاتف أو الكمبيوتر، أينما كنت وفي أي وقت.",
                    icon: Image.asset('assets/images/png/section2.png'),
                  ),
                  SectionItems2(
                    title: "دعم مستمر وتدريب للتجار",
                    subtitle:
                        "نقدم إرشادًا ومتابعة دورية لتطوير مهاراتك وتحقيق أفضل النتائج في تجارتك.",
                    icon: Image.asset('assets/images/png/section3.png'),
                  ),
                  SectionItems2(
                    title: "مجتمع محلي حقيقي",
                    subtitle:
                        "نقدم إرشادًا ومتابعة دورية لتطوير مهاراتك وتحقيق أفضل النتائج في تجارتك.",
                    icon: Image.asset('assets/images/png/section4.png'),
                  ),
                  SectionItems2(
                    title: "خدمات ومنتجات متنوعة بمكان واحد",
                    subtitle:
                        "وفر وقتك وجهدك، وابحث عن كل ما تحتاجه بسهولة في منصة واحدة.",
                    icon: Image.asset('assets/images/png/section5.png'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: AppColors.colorAboutUsScreen,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "عندك خدمة أو منتج؟ خلّي الناس القريبين يشتروا منك بسهولة!",
                      style: getBold(),
                    ),
                    Text(
                      "منصة مخصصة لأصحاب المشاريع الصغيرة، الحرفيين، وبائعي المنتجات والخدمات. نوصلك مباشرةً بعملاء منطقتك بطريقة سهلة وسريعة، مع دعم مستمر وأدوات تساعدك على عرض منتجاتك وزيادة مبيعاتك.",
                      style: getRegular(
                        fontSize: 12,
                        color: AppColors.neutral600,
                      ),
                    ),
                    AateneButton(
                      buttonText: "انضم اليوم، وخلّي الناس تشتري منك بسهولة",
                      color: AppColors.primary500,
                      borderColor: AppColors.primary500,
                      textColor: AppColors.light1000,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 10,
                        children: [
                          CardWidget(
                            title: "الخدمات",
                            subtitle:
                                "خدمة الحلاقة في البيت، تصوير مناسباتك، صيانة أجهزة المنزل، تصميم جرافيك لمشروعك، أو حتى تنظيف المنازل والمكاتب.",
                            icon: Icon(
                              Icons.drive_file_move_sharp,
                              color: AppColors.light1000,
                            ),
                          ),
                          CardWidget(
                            title: "المنتجات",
                            subtitle:
                                "بيع المخبوزات الطازجة، الملابس العصرية، الإكسسوارات اليدوية، المنتجات الغذائية المحلية، أو التحف والهدايا.",
                            icon: Icon(
                              Icons.shopping_basket_rounded,
                              color: AppColors.light1000,
                            ),
                          ),
                          CardWidget(
                            title: "المنتجات المستعملة",
                            subtitle:
                                "إعادة بيع الأجهزة الكهربائية بحالة ممتازة، الأثاث المستعمل، الأدوات المنزلية الزائدة، أو الملابس التي لم تعد تستخدمها.",
                            icon: Icon(
                              Icons.museum_sharp,
                              color: AppColors.light1000,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text("بدك تشتري من أهل بلدك؟", style: getBold()),
                    Text(
                      "في أعطيني  تلاقي كل احتياجاتك في مكان واحد، من منتجات وخدمات محلية موثوقة. تقدر تتواصل مباشرة مع البائع، تطلب بسهولة، وتستلم بسرعة وبأسعار تناسب ميزانيتك.",
                      style: getRegular(
                        fontSize: 12,
                        color: AppColors.neutral600,
                      ),
                    ),
                    Row(
                      spacing: 10,
                      children: [
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.light1000,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.customColor01,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "تصفح العروض الآن",
                                style: getMedium(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.light1000,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: AppColors.customColor01,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                "ابحث عن خدمة أو منتج",
                                style: getMedium(fontSize: 14),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SectionCard3(
                      title: "منتجات محلية وخدمات موثوقة",
                      subtitle:
                          "اكتشف أفضل المنتجات والخدمات من مزوّدين موثوقين في منطقتك.",
                      icon: Icon(
                        Icons.verified,
                        size: 16,
                        color: AppColors.light1000,
                      ),
                    ),
                    SectionCard3(
                      title: "كل شيء بمكان واحد",
                      subtitle:
                          "وفّر وقتك وجهدك بالوصول لكل ما تحتاجه من مكان واحد.",
                      icon: Icon(
                        Icons.storefront_rounded,
                        size: 16,
                        color: AppColors.light1000,
                      ),
                    ),
                    SectionCard3(
                      title: "تواصل مباشر وسريع",
                      subtitle:
                          "تحدث مع المزوّدين مباشرة واحصل على ردود فورية.",
                      icon: Icon(
                        Icons.call,
                        size: 16,
                        color: AppColors.light1000,
                      ),
                    ),
                    SectionCard3(
                      title: "أسعار تناسب الكل",
                      subtitle:
                          "استمتع بخيارات متنوعة بأسعار تناسب مختلف الميزانيات.",
                      icon: Icon(
                        Icons.attach_money,
                        size: 16,
                        color: AppColors.light1000,
                      ),
                    ),
                    SectionCard3(
                      title: "دعم المشاريع الصغيرة بمجتمعك",
                      subtitle:
                          "ساهم في نمو المشاريع المحلية وكن جزءًا من دعم مجتمعك.",
                      icon: Icon(
                        Icons.support_agent,
                        size: 16,
                        color: AppColors.light1000,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        spacing: 10,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "ابدأ الآن بإضافة رسالتك",
                            style: getBold(
                              fontSize: 12,
                              color: AppColors.primary400,
                            ),
                          ),
                          Text(
                            "تواصل معنا، نحن هنا لمساعدتك.",
                            style: getBold(),
                          ),
                          Text(
                            "فريقنا جاهز يرد على كل استفساراتك ويساعدك بخطوات واضحة وسريعة، سواء كنت حابب تعرف أكثر عن خدماتنا أو تحتاج دعم في طلبك. لا تتردد، رسالتك تهمنا.",
                            style: getBold(
                              fontSize: 12,
                              color: AppColors.neutral600,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.light1000,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  SizedBox(height: 20),

                                  Text(
                                    "نحن هنا للاستماع، اكتب ما ترغب بمشاركته معنا 🤗",
                                    style: getBold(fontSize: 14),
                                  ),
                                  const SizedBox(height: 10),
                                  _buildTextField(hint: "الاسم"),
                                  const SizedBox(height: 20),
                                  _buildTextField(
                                    hint: "البريد الإلكتروني",
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  const SizedBox(height: 20),
                                  _buildTextField(hint: "الرسالة", maxLines: 8),
                                  SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: AppColors.primary500,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        spacing: 10,
                                        children: [
                                          Text(
                                            "إرسال الرسالة",
                                            style: getBold(
                                              color: AppColors.light1000,
                                            ),
                                          ),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: AppColors.light1000,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 10,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary500,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: IconButton(
                                      onPressed: () {
                                        UrlHelper.open(
                                          "https://www.facebook.com/aateneofficial/",
                                        );
                                      },
                                      icon: Image.asset(
                                        'assets/images/png/facebook.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary500,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: IconButton(
                                      onPressed: () {
                                        UrlHelper.open(
                                          "https://www.instagram.com/aatene_official/",
                                        );
                                      },
                                      icon: Image.asset(
                                        'assets/images/png/instagram.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primary500,
                                    borderRadius: BorderRadius.circular(100),
                                  ),

                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: IconButton(
                                      onPressed: () {
                                        _showMyDialog(context);
                                      },
                                      icon: Image.asset(
                                        'assets/images/png/whatsapp.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
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

  Widget _buildTextField({
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      textDirection: TextDirection.rtl,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintTextDirection: TextDirection.rtl,
        hintStyle: getRegular(color: AppColors.neutral600, fontSize: 14),
        border: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.neutral900, width: 2),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.neutral900, width: 2),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary400),
        ),
      ),
    );
  }

  Future<void> _showMyDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('اختر الواتساب الذي تحتاجه'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Column(
                  spacing: 15,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.primary500,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextButton(
                        onPressed: () {
                          UrlHelper.open("https://wa.me/+972526213879");
                        },
                        child: Text('واتس خدمة العملاء'),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        UrlHelper.open("https://wa.me/+972559390851");
                      },
                      child: Text('واتس لاستعلام عن الخدمات والمنتجات'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('الغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
