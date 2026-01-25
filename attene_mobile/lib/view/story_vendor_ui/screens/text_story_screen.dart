import 'package:flutter/material.dart';

import '../api/merchant_stories_api.dart';
import '../theme/story_vendor_theme.dart';

class TextStoryScreen extends StatefulWidget {
  const TextStoryScreen({super.key});

  @override
  State<TextStoryScreen> createState() => _TextStoryScreenState();
}

class _TextStoryScreenState extends State<TextStoryScreen> {
  final _controller = TextEditingController();
  Color bg = StoryVendorTheme.blueBg;
  bool _submitting = false;

  final colors = const [
    Color(0xFFE56B6B),
    Color(0xFFF2A7A7),
    Color(0xFF3F5F7A),
    Color(0xFFF2C98D),
    Color(0xFFA8E27B),
    Color(0xFF43C59E),
    Color(0xFF4ED2E2),
    Color(0xFF7A5CF1),
    Color(0xFFB84BE2),
  ];

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _submitPublish() async {
    if (_submitting) return;
    setState(() => _submitting = true);
    try {
      // TODO: replace with real selected image/background upload.
      const demoImagePath = 'images/QzuU8cxzP0pgRFit46Dh5LifmCrxSCm8eg49f10v.png';
      await MerchantStoriesApi.create(
        image: demoImagePath,
        text: _controller.text.trim(),
        color: bg.value,
      );
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) Navigator.pop(context, false);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: bg,
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      TextField(
                        controller: _controller,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              blurRadius: 4,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        maxLines: null,
                        cursorColor: Colors.white,
                        cursorWidth: 2,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedErrorBorder: InputBorder.none,
                          hintText: 'اكتب ما تريد',
                          hintStyle: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            color: Colors.white70,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                blurRadius: 4,
                                offset: Offset(1, 1),
                              ),
                            ],
                          ),
                          fillColor: Colors.transparent,
                          filled: true,
                          contentPadding: EdgeInsets.zero,
                          isCollapsed: true,
                          // إزالة أي تأثيرات للـ underline
                          isDense: true,
                          alignLabelWithHint: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Positioned(
                left: 16,
                right: 16,
                top: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // زر التم بدون خلفية بيضاء
                    InkWell(
                      onTap: _submitting ? null : _submitPublish,
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: _submitting
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(strokeWidth: 2.2),
                              )
                            : const Text(
                                'نشر',
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                              ),
                      ),
                    ),
                    // زر الإغلاق بدون خلفية بيضاء
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.12),
                        ),
                        child: const Icon(Icons.arrow_forward, color: Colors.white, size: 26),
                      ),
                    ),
                  ],
                ),
              ),

              Positioned(
                left: 14,
                right: 14,
                bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                child: SizedBox(
                  height: 44,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    reverse: true,
                    itemCount: colors.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                    itemBuilder: (_, i) {
                      final c = colors[i];
                      final selected = c.value == bg.value;
                      return InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => setState(() => bg = c),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: c,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: selected ? 3 : 1.5),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}