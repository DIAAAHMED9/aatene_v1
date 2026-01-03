import 'package:flutter/material.dart';
import 'app_color.dart';



class ColorExamples extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.light1000,
      appBar: AppBar(
        title:  Text(
          'Color System Examples',
          style: TextStyle(color: AppColors.neutral100),
        ),
        backgroundColor: AppColors.light1000,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildColorSection('Alpha Variants', [
              _buildColorBox(AppColors.warning200Alpha10, 'warning200Alpha10'),
              _buildColorBox(AppColors.success300Alpha10, 'success300Alpha10'),
              _buildColorBox(AppColors.error200Alpha10, 'error200Alpha10'),
              _buildColorBox(AppColors.primary300Alpha10, 'primary300Alpha10'),
              _buildColorBox(AppColors.primary300Alpha20, 'primary300Alpha20'),
              _buildColorBox(AppColors.primary300Alpha50, 'primary300Alpha50'),
            ]),
            _buildAlphaComponentExamples(),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSection(String title, List<Widget> colorBoxes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.neutral200,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(spacing: 8, runSpacing: 8, children: colorBoxes),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildColorBox(Color color, String label) {
    return Container(
      width: 120,
      height: 80,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.neutral800),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.neutral600),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: AppColors.neutral400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAlphaComponentExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Alpha Component Examples',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.neutral200,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary100, AppColors.secondary100],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.primary300Alpha10,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'Primary Alpha Overlay',
                style: TextStyle(
                  color: AppColors.neutral100,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.success300Alpha10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Success\nAlpha',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.success300,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.warning200Alpha10,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Warning\nAlpha',
                    textAlign: TextAlign.center,
                    style:  TextStyle(
                      color: AppColors.warning300,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}