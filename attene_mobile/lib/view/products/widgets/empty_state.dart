import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:flutter/material.dart';
import 'package:attene_mobile/utlis/colors/app_color.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final String? imageAsset;

  const EmptyStateWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.onButtonPressed,
    this.imageAsset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            imageAsset != null
                ? Image.asset(imageAsset!, height: 150, fit: BoxFit.contain)
                : Icon(
                    Icons.inventory_2_outlined,
                    size: 100,
                    color: Colors.grey[300],
                  ),
            const SizedBox(height: 24),
            Text(title, style: getBold(fontSize: 22, color: Color(0xFF555555))),
            const SizedBox(height: 12),
            SizedBox(
              width: 280,
              child: Text(
                description,
                style: getRegular(fontSize: 14, color: Color(0xFFAAAAAA)),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              child: ElevatedButton(
                onPressed: onButtonPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(buttonText, style: getRegular(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}