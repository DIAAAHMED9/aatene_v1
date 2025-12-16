import 'package:flutter/material.dart';

class TextWithStar extends StatelessWidget {
  const TextWithStar({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Text(text, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold , color: Colors.black)),
        Text('*', style: TextStyle(color: Colors.red)),
      ],
    );
  }
}