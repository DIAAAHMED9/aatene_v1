// // // // final RxString gender = ''.obs;
// // // //
// // // // Obx(() {
// // // // return DropdownButtonFormField<String>(
// // // // value: gender.value.isEmpty ? null : gender.value,
// // // // hint: const Text('الجنس'),
// // // // items: const [
// // // // DropdownMenuItem(value: 'male', child: Text('ذكر')),
// // // // DropdownMenuItem(value: 'female', child: Text('أنثى')),
// // // // ],
// // // // onChanged: (value) {
// // // // gender.value = value!;
// // // // },
// // // // );
// // // // });
// // //
// // // class DropdownTextField extends StatelessWidget {
// // //   final String hint;
// // //   final List<String> items;
// // //   final ValueChanged<String?> onChanged;
// // //
// // //   const DropdownTextField({
// // //     super.key,
// // //     required this.hint,
// // //     required this.items,
// // //     required this.onChanged,
// // //   });
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return DropdownButtonFormField<String>(
// // //       hint: Text(hint),
// // //       icon: const Icon(Icons.keyboard_arrow_down),
// // //       items: items
// // //           .map(
// // //             (e) => DropdownMenuItem(
// // //           value: e,
// // //           child: Text(e),
// // //         ),
// // //       )
// // //           .toList(),
// // //       onChanged: onChanged,
// // //       decoration: InputDecoration(
// // //         filled: true,
// // //         fillColor: Colors.grey.shade100,
// // //         border: OutlineInputBorder(
// // //           borderRadius: BorderRadius.circular(14),
// // //           borderSide: BorderSide.none,
// // //         ),
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// //
// // String? selectedLanguage = 'ar';
// //
// // DropdownButtonFormField<String>(
// // value: selectedLanguage,
// // hint: const Text('اختر اللغة'),
// // items: const [
// // DropdownMenuItem(
// // value: 'ar',
// // child: Text('العربية 🇸🇦'),
// // ),
// // DropdownMenuItem(
// // value: 'en',
// // child: Text('English 🇺🇸'),
// // ),
// // ],
// // onChanged: (value) {
// // selectedLanguage = value;
// //
// // // مثال ربط مع GetX
// // // Get.updateLocale(Locale(value!));
// // },
// // decoration: InputDecoration(
// // prefixIcon: const Icon(Icons.language),
// // border: OutlineInputBorder(
// // borderRadius: BorderRadius.circular(12),
// // ),
// // ),
// // );
// String selectedLanguage = 'ar';
//
// DropdownButtonFormField<String>(
// value: selectedLanguage,
// items: const [
// DropdownMenuItem(
// value: 'ar',
// child: Text('العربية'),
// ),
// DropdownMenuItem(
// value: 'en',
// child: Text('English'),
// ),
// ],
// onChanged: (value) {
// selectedLanguage = value!;
// // Get.updateLocale(Locale(value));
// },
// decoration: InputDecoration(
// prefixIcon: const Icon(Icons.language),
// border: OutlineInputBorder(
// borderRadius: BorderRadius.circular(12),
// ),
// ),
// );
