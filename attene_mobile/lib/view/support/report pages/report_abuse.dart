import 'package:attene_mobile/utlis/colors/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            "الشكاوى والاقتراحات",
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

        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // Title
              const Text(
                'الإبلاغ عن إساءة',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              // Subtitle
              const Text(
                'ما الذي تقدر أن نساعدك به ؟',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // Radio options
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
                  title: Text(
                    options[index],
                    style: const TextStyle(fontSize: 16),
                  ),
                  contentPadding: EdgeInsets.zero,
                );
              }),

              const Spacer(),

              // Next Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3E5F83),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    // Next action
                  },
                  child: const Text(
                    'التالي',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
