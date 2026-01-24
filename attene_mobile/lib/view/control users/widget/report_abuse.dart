import '../../../general_index.dart';
import 'report_add_abuse.dart';

class ReportAbuseScreen extends StatefulWidget {
  const ReportAbuseScreen({super.key});

  @override
  State<ReportAbuseScreen> createState() => _ReportAbuseScreenState();
}

class _ReportAbuseScreenState extends State<ReportAbuseScreen> {
  int? selectedOption = 1;

  final List<String> options = [
    'الإبلاغ عن منتج',
    'الإبلاغ عن تاجر',
    'الإبلاغ عن زبون',
    'الإبلاغ عن خدمة',
    'أخرى',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "الشكاوى والاقتراحات",
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 500,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primary400),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  Text('الإبلاغ عن إساءة', style: getBold(fontSize: 18)),

                  Text(
                    'ما الذي تقدر أن نساعدك به ؟',
                    style: getRegular(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(height: 24),

                  ...List.generate(options.length, (index) {
                    return RadioListTile<int>(
                      value: index,
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                      activeColor: AppColors.primary400,
                      title: Text(options[index], style: getRegular()),
                      contentPadding: EdgeInsets.zero,
                    );
                  }),
                  SizedBox(height: 20),

                  AateneButton(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => ReportAddAbuse(),
                        ),
                      );
                    },
                    buttonText: "التالي",
                    color: AppColors.primary400,
                    textColor: AppColors.light1000,
                    borderColor: AppColors.primary400,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
