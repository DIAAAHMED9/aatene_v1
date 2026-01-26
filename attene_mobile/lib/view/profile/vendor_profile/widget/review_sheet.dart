import 'package:attene_mobile/general_index.dart';
import 'package:attene_mobile/view/profile/user_profile/screen/user_profile.dart';
import 'package:flutter/material.dart';

class ReviewSheet extends StatefulWidget {
  final String userName;
  final String date;
  final String originalComment;
  final double initialRating;

  const ReviewSheet({
    super.key,
    this.userName = 'لويس فاندسون',
    this.date = '20 أكتوبر 2022 - 09:00',
    this.originalComment =
        'واه ، مشروعك يبدو رائعاً ! منذ متى وأنت ترميز؟ . ما زلت جديداً ، لكن أعتقد أنني أريد الغوص في رد الفعل ...',
    this.initialRating = 4.2,
  });

  @override
  State<ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends State<ReviewSheet> {
  int _userRating = 0; // التقييم الذي يختاره المستخدم الآن
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // // مقبض السحب
            // Container(
            //   width: 40,
            //   height: 4,
            //   decoration: BoxDecoration(
            //     color: Colors.grey[300],
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            // ),
            const SizedBox(height: 15),
            const Text(
              'رد على',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),

            // --- الجزء الذي يحتوي على الاسم والتفاصيل ---
            Row(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // الصورة الشخصية
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?u=12',
                  ),
                ),
                // الاسم والتاريخ والنص (في المنتصف واليمين)
                Expanded(
                  flex: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        widget.date,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.originalComment,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Spacer(),

                // التقييم الأصلي (على اليسار)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    children: [
                      Text(
                        '${widget.initialRating}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(Icons.star, color: Colors.orange, size: 20),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),

            // --- نظام التقييم التفاعلي بالنجوم ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'ما هو تقديرك؟',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(width: 15),
                Row(
                  children: List.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() => _userRating = index + 1);
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => SizedBox(
                            height: 250,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  spacing: 15,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.check_circle_rounded,
                                      color: Colors.green,
                                      size: 80,
                                    ),
                                    Text(
                                      "تمت العملية بنجاح",
                                      textAlign: TextAlign.center,
                                      style: getBlack(fontSize: 18),
                                    ),
                                    Text(
                                      "تم اضافة تعليك بنجاح",
                                      textAlign: TextAlign.center,
                                      style: getMedium(
                                        fontSize: 14,
                                        color: AppColors.primary400.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                    ),
                                    AateneButton(
                                      buttonText: "عودة للرئيسية",
                                      color: AppColors.primary400,
                                      borderColor: AppColors.primary400,
                                      textColor: AppColors.light1000,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute<void>(
                                            builder: (context) => ProfilePage(),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        index < _userRating
                            ? Icons.star_rounded
                            : Icons.star_outline_rounded,
                        color: Colors.orange,
                        size: 38,
                      ),
                    );
                  }),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // --- هوية المعلق الحالي (أبانوب أشرف) ---
            Row(
              spacing: 5,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?u=5',
                  ),
                ),
                const Text(
                  'أبانوب أشرف',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // صندوق النص
            TextField(
              controller: _controller,
              maxLines: 4,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: 'I\'m super happy with these!...',
                filled: true,
                fillColor: Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(color: Colors.grey.shade200),
                ),
              ),
            ),
            const SizedBox(height: 15),

            // رفع الصور
            Row(
              children: [
                _buildAddButton(),
                const SizedBox(width: 10),
                _buildPreviewImage(),
                const SizedBox(width: 10),
                _buildPreviewImage(),
              ],
            ),
            const SizedBox(height: 25),

            // زر الإرسال
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _userRating > 0
                    ? () => Navigator.pop(context)
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF325A9E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'أضف التعليق',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        'assets/images/png/mainus.png',

        width: 70,
        height: 70,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: 75,
      height: 75,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F5FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary400.withOpacity(0.2)),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_circle, color: AppColors.primary400),
          Text(
            'أضف صورة',
            style: TextStyle(fontSize: 10, color: AppColors.primary400),
          ),
        ],
      ),
    );
  }
}
