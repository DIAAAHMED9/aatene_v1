import 'dart:async';
import 'package:flutter/material.dart';
import '../dummy/story_vendor_dummy.dart' as demo;

class StoryViewerScreen extends StatefulWidget {
  final List<demo.StoryVendorDemoModel> vendors;
  final int initialVendorIndex;

  const StoryViewerScreen({
    super.key,
    required this.vendors,
    this.initialVendorIndex = 0,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen> {
  late PageController _page;
  int vendorIndex = 0;
  int storyIndex = 0;

  Timer? _timer;
  double progress = 0;

  static const storyDuration = Duration(seconds: 6);

  @override
  void initState() {
    super.initState();

    if (widget.vendors.isEmpty) {
      vendorIndex = 0;
    } else {
      vendorIndex = widget.initialVendorIndex.clamp(0, widget.vendors.length - 1);
    }

    _page = PageController(initialPage: vendorIndex);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _page.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    progress = 0;

    const tick = Duration(milliseconds: 30);
    final totalTicks = storyDuration.inMilliseconds / tick.inMilliseconds;

    _timer = Timer.periodic(tick, (t) {
      if (!mounted) return;
      setState(() {
        progress += 1 / totalTicks;
        if (progress >= 1) _next();
      });
    });
  }

  demo.StoryVendorDemoModel? get currentVendor {
    if (widget.vendors.isEmpty) return null;
    return widget.vendors[vendorIndex];
  }

  List<demo.StoryMediaItem> get currentStoryItems {
    final v = currentVendor;
    if (v == null) return const [];
    if (v.groups.isEmpty) return const [];
    return v.groups.first.items;
  }

  void _next() {
    final media = currentStoryItems;
    if (media.isEmpty) {
      Navigator.pop(context);
      return;
    }

    if (storyIndex < media.length - 1) {
      setState(() => storyIndex++);
      _startTimer();
      return;
    }

    if (vendorIndex < widget.vendors.length - 1) {
      setState(() {
        vendorIndex++;
        storyIndex = 0;
      });
      _page.animateToPage(
        vendorIndex,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
      _startTimer();
      return;
    }

    Navigator.pop(context);
  }

  void _prev() {
    final media = currentStoryItems;
    if (media.isEmpty) {
      Navigator.pop(context);
      return;
    }

    if (storyIndex > 0) {
      setState(() => storyIndex--);
      _startTimer();
      return;
    }

    if (vendorIndex > 0) {
      setState(() {
        vendorIndex--;
        storyIndex = 0;
      });
      _page.animateToPage(
        vendorIndex,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
      _startTimer();
      return;
    }

    Navigator.pop(context);
  }

  /// ✅ دعم قصة المنتج: product://title|imageUrl
  ({bool isProduct, String title, String imageUrl}) _parseProductStory(String raw) {
    if (!raw.startsWith('product://')) {
      return (isProduct: false, title: '', imageUrl: '');
    }

    final payload = raw.replaceFirst('product://', '');
    final parts = payload.split('|');

    final title = parts.isNotEmpty ? parts[0].trim() : '';
    final imageUrl = parts.length > 1 ? parts[1].trim() : '';

    return (isProduct: true, title: title, imageUrl: imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vendors.isEmpty) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: Text(
              'لا يوجد قصص',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragUpdate: (d) {
          if (d.delta.dy > 10) Navigator.pop(context);
        },
        onTapUp: (details) {
          final w = MediaQuery.of(context).size.width;
          final x = details.globalPosition.dx;
          if (x < w * 0.35) {
            _prev();
          } else {
            _next();
          }
        },
        child: SafeArea(
          child: PageView.builder(
            controller: _page,
            itemCount: widget.vendors.length,
            onPageChanged: (i) {
              setState(() {
                vendorIndex = i;
                storyIndex = 0;
              });
              _startTimer();
            },
            itemBuilder: (_, i) {
              final vendor = widget.vendors[i];
              final items = vendor.groups.isNotEmpty ? vendor.groups.first.items : <demo.StoryMediaItem>[];

              final demo.StoryMediaItem item = items.isEmpty
                  ? const demo.StoryMediaItem(url: '')
                  : items[(i == vendorIndex) ? storyIndex.clamp(0, items.length - 1) : 0];

              final parsed = _parseProductStory(item.url);
              final bool isProductStory = parsed.isProduct;
              final bool isApiStoryWithText = !isProductStory && (item.text ?? '').trim().isNotEmpty;

              // الخلفية: صورة المنتج أو الميديا العادية
              final String bgUrl = isProductStory ? parsed.imageUrl : item.url;
              final Color? storyColor = (item.color == null) ? null : Color(item.color!);

              return Stack(
                children: [
                  // الخلفية
                  Positioned.fill(
                    child: bgUrl.isEmpty
                        ? Container(color: Colors.black)
                        : Image.network(
                            bgUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.black,
                              child: const Center(
                                child: Icon(Icons.broken_image, color: Colors.white),
                              ),
                            ),
                          ),
                  ),

                  // تدرج سفلي (لتوضيح كرت المنتج)
                  if (isProductStory)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 260,
                      child: IgnorePointer(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black54,
                                Colors.black87,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // progress
                  Positioned(
                    left: 12,
                    right: 12,
                    top: 10,
                    child: Row(
                      children: List.generate(items.length, (idx) {
                        final double v = (idx < storyIndex)
                            ? 1.0
                            : (idx == storyIndex)
                                ? progress.clamp(0.0, 1.0)
                                : 0.0;

                        return Expanded(
                          child: Container(
                            height: 3,
                            margin: EdgeInsets.only(right: idx == items.length - 1 ? 0 : 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: v,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(99),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),

                  // ✅ نص القصة (من API) + لون الخلفية
                  if (isApiStoryWithText)
                    Positioned.fill(
                      child: Container(
                        color: (storyColor ?? Colors.transparent).withOpacity(0.35),
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Text(
                          item.text!.trim(),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            height: 1.2,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                  // top info
                  Positioned(
                    left: 12,
                    right: 12,
                    top: 26,
                    child: Row(
                      children: [
                        // ✅ Avatar آمن (بدون crashes على web)
                        ClipOval(
                          child: SizedBox(
                            width: 36,
                            height: 36,
                            child: Image.network(
                              vendor.avatarUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                color: Colors.white10,
                                alignment: Alignment.center,
                                child: Text(
                                  vendor.storeName.isNotEmpty ? vendor.storeName.characters.first : 'S',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            vendor.storeName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),

                  // ✅ كرت المنتج + زر معاينة (مثل التصميم)
                  if (isProductStory)
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 18,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.35),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.white.withOpacity(0.12)),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    width: 46,
                                    height: 46,
                                    child: Image.network(
                                      parsed.imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: Colors.white10,
                                        child: const Icon(Icons.image, color: Colors.white24),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    parsed.title.isEmpty ? 'منتج' : parsed.title,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: () {
                                // لاحقاً: افتح صفحة المنتج
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.15),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(26),
                                ),
                              ),
                              child: const Text(
                                'معاينة',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
