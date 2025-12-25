import 'package:flutter/material.dart';

class ContactForm extends StatelessWidget {
  const ContactForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _Input(hint: 'الاسم'),
        _Input(hint: 'البريد الإلكتروني'),
        _Input(hint: 'الرسالة', maxLines: 4),
      ],
    );
  }
}

class _Input extends StatelessWidget {
  final String hint;
  final int maxLines;

  const _Input({required this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
