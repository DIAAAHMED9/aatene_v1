import '../../../general_index.dart';

class StoryViewerScreen extends StatefulWidget {
  final List<StoryItemModel> stories;
  final int initialIndex;

  const StoryViewerScreen({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  @override
  State<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends State<StoryViewerScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _progressController;

  int activeIndex = 0;
  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    activeIndex = widget.initialIndex.clamp(0, widget.stories.length - 1);
    _pageController = PageController(initialPage: activeIndex);

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    );

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _next();
      }
    });

    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _pause() {
    if (isPaused) return;
    setState(() => isPaused = true);
    _progressController.stop();
  }

  void _resume() {
    if (!isPaused) return;
    setState(() => isPaused = false);
    _progressController.forward();
  }

  void _next() {
    if (activeIndex >= widget.stories.length - 1) {
      Get.back();
      return;
    }
    setState(() => activeIndex++);
    _progressController.reset();
    _progressController.forward();
    _pageController.animateToPage(
      activeIndex,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  void _prev() {
    if (activeIndex <= 0) {
      _progressController.reset();
      _progressController.forward();
      return;
    }
    setState(() => activeIndex--);
    _progressController.reset();
    _progressController.forward();
    _pageController.animateToPage(
      activeIndex,
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[activeIndex];

    return GestureDetector(
      onVerticalDragUpdate: (d) {
        if (d.primaryDelta != null && d.primaryDelta! > 12) {
          Get.back();
        }
      },
      onLongPressStart: (_) => _pause(),
      onLongPressEnd: (_) => _resume(),
      onTapUp: (details) {
        final w = MediaQuery.of(context).size.width;
        final dx = details.globalPosition.dx;
        if (dx < w * 0.35) {
          _prev();
        } else {
          _next();
        }
      },
      child: Scaffold(
        backgroundColor: story.backgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.stories.length,
                itemBuilder: (_, i) {
                  final s = widget.stories[i];
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      _StoryMediaGrid(mediaUrls: s.mediaUrls),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withOpacity(0.55),
                              Colors.transparent,
                              Colors.black.withOpacity(0.25),
                            ],
                          ),
                        ),
                      ),
                      if ((s.text ?? '').trim().isNotEmpty)
                        Center(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.45),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              s.text!.trim(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                height: 1.3,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),

              Positioned(
                top: 10,
                left: 12,
                right: 12,
                child: AnimatedBuilder(
                  animation: _progressController,
                  builder: (_, __) => StoryProgressBar(
                    count: widget.stories.length,
                    activeIndex: activeIndex,
                    progress: _progressController.value,
                  ),
                ),
              ),

              Positioned(
                top: 6,
                right: 6,
                child: IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StoryMediaGrid extends StatelessWidget {
  final List<String> mediaUrls;

  const _StoryMediaGrid({required this.mediaUrls});

  @override
  Widget build(BuildContext context) {
    final urls = mediaUrls.where((e) => e.trim().isNotEmpty).toList();
    if (urls.isEmpty) {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.broken_image, color: Colors.white),
        ),
      );
    }

    Widget tile(String url) {
      return CachedNetworkImage(
        imageUrl: url,
        fit: BoxFit.cover,
        placeholder: (_, __) => Container(color: Colors.black),
        errorWidget: (_, __, ___) => Container(
          color: Colors.black,
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.white),
          ),
        ),
      );
    }

    // Instagram-like collage for up to 4 images
    if (urls.length == 1) {
      return tile(urls[0]);
    }

    if (urls.length == 2) {
      return Row(
        children: [
          Expanded(child: tile(urls[0])),
          const SizedBox(width: 2),
          Expanded(child: tile(urls[1])),
        ],
      );
    }

    if (urls.length == 3) {
      return Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Expanded(child: tile(urls[0])),
                const SizedBox(height: 2),
                Expanded(child: tile(urls[1])),
              ],
            ),
          ),
          const SizedBox(width: 2),
          Expanded(child: tile(urls[2])),
        ],
      );
    }

    // 4 or more: 2x2 grid (take first 4)
    final first4 = urls.take(4).toList();
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: tile(first4[0])),
              const SizedBox(width: 2),
              Expanded(child: tile(first4[1])),
            ],
          ),
        ),
        const SizedBox(height: 2),
        Expanded(
          child: Row(
            children: [
              Expanded(child: tile(first4[2])),
              const SizedBox(width: 2),
              Expanded(child: tile(first4[3])),
            ],
          ),
        ),
      ],
    );
  }
}
