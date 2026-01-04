import '../../general_index.dart';

class DropdownTextField extends StatelessWidget {
  final String hint;
  final List<String> items;
  final ValueChanged<String?> onChanged;

// // //
  const DropdownTextField({
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

// // //
  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      hint: Text(hint),
      icon: const Icon(Icons.keyboard_arrow_down),
      items: items
          .map(
            (e) =>
            DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
      )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}