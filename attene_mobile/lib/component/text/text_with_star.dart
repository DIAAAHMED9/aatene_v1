

import '../../general_index.dart';

class TextWithStar extends StatelessWidget {
  const TextWithStar({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 5,
      children: [
        Text(text, style: getMedium()),
        Text('*', style: getRegular(color: Colors.red)),
      ],
    );
  }
}