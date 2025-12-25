import 'package:attene_mobile/view/support/about%20us/widgets/section_items2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utlis/colors/app_color.dart';
import 'widgets/section_title.dart';
import 'widgets/info_card.dart';
import 'widgets/feature_item.dart';
import 'widgets/contact_form.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "عن  أعطيني",
          style: TextStyle(
            color: AppColors.neutral100,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
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
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.neutral600,
                    ),
                  ),
                  Text(
                    'من نحن؟',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/png/mainus.png',
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Text(
                    'في قلب الناصرة، بين شوارعها القديمة وأحلام شبابها وبناتها، انطلقت فكرة أعطيني. نحن مجموعة شباب وصبايا من الناصرة، كبرنا وسط تحديات السوق المحلي، وشفنا كيف التجار الصغار ومزوّدي الخدمات عم بواجهوا صعوبة يوصلوا لزبائنهم… وشفنا كمان الزبون، اللي دايمًا بيدوّر على خدمةموثوقة أو منتج مضمون، ومش دايمًا بلاقيهم بسهولة.',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              color: Color(0xFFf6f6f6),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "رؤيتنا ورسالتنا نحو دعم المشاريع المحلية",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "نعمل على تمكين المشاريع الصغيرة من التوسع والظهور الرقمي، ونمنح كل مستخدم مساحة ذكية وسهلة للوصول إلى الخدمات والمنتجات المحلية بسرعة وثقة.",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
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
                      Text(
                        "لماذا نحن؟",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Text(
                    'في "أعطيني"، نؤمن بأن البيع والشراء يجب أن يكون سهلاً، سريعاً، وخالياً من التعقيدات. لذلك نوفر لك منصة موثوقة تربطك مباشرة بأهل منطقتك، بدون عمولات، مع دعم مستمر وتنوع كبير في الخدمات والمنتجات.',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                      letterSpacing: -0.5,
                    ),
                  ),
                  SizedBox(height: 20),
                  SectionItems2(
                    title: "بدون عمولة على المبيعات",
                    subtitle: "احتفظ بكامل أرباحك دون اقتطاعات، وركز على تنمية عملك وزيادة دخلك.",
                    icon: Image.asset('assets/images/png/section1.png'),
                  ),
                  SectionItems2(
                    title: "سهولة استخدام من جميع الأجهزة",
                    subtitle: "تصفح وبيع واشتري بسهولة من الهاتف أو الكمبيوتر، أينما كنت وفي أي وقت.",
                    icon: Image.asset('assets/images/png/section2.png'),
                  ),
                  SectionItems2(
                    title: "دعم مستمر وتدريب للتجار",
                    subtitle: "نقدم إرشادًا ومتابعة دورية لتطوير مهاراتك وتحقيق أفضل النتائج في تجارتك.",
                    icon: Image.asset('assets/images/png/section3.png'),
                  ),
                  SectionItems2(
                    title: "مجتمع محلي حقيقي",
                    subtitle: "نقدم إرشادًا ومتابعة دورية لتطوير مهاراتك وتحقيق أفضل النتائج في تجارتك.",
                    icon: Image.asset('assets/images/png/section4.png'),
                  ),
                  SectionItems2(
                    title: "خدمات ومنتجات متنوعة بمكان واحد",
                    subtitle: "وفر وقتك وجهدك، وابحث عن كل ما تحتاجه بسهولة في منصة واحدة.",
                    icon: Image.asset('assets/images/png/section5.png'),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
