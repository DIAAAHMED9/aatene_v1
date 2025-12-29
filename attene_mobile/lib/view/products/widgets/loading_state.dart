import 'package:attene_mobile/component/text/aatene_custom_text.dart';
import 'package:flutter/material.dart';

class LoadingStateWidget extends StatelessWidget {
  final String message;

  const LoadingStateWidget({Key? key, this.message = 'جاري التحميل...'})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 16),
          Text(message, style: getRegular(color: Colors.grey)),
        ],
      ),
    );
  }
}