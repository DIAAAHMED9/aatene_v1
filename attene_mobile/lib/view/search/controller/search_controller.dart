import 'package:flutter/material.dart';

class UserAccountTypeWidget extends StatefulWidget {
  const UserAccountTypeWidget({super.key});

  @override
  State<UserAccountTypeWidget> createState() => _UserAccountTypeWidgetState();
}

class _UserAccountTypeWidgetState extends State<UserAccountTypeWidget> {
  bool isVerified = true;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            'حساب المستخدم',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          /// Radio Item
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'حساب موثّق',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Radio<bool>(
                value: true,
                groupValue: isVerified,
                activeColor: Colors.blue,
                onChanged: (value) {
                  setState(() {
                    isVerified = value!;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
