import 'package:flutter/material.dart';

import '../api/merchant_stories_api.dart';
import '../dummy/story_vendor_dummy.dart' as demo;
import '../screens/story_create_sheet.dart';
import '../screens/story_viewer_screen.dart';
import '../theme/story_vendor_theme.dart';

/// Highlights row (Instagram-like circles)
///
/// - (+) opens create sheet
/// - Other circles open viewer
///
/// This widget fetches merchant stories from API:
/// GET /merchants/stories
/// and injects them as a single vendor named "قصتي" (multiple frames).
class StoryHighlightsRow extends StatefulWidget {
  /// Other vendors (dummy or from another source). We keep this so UI stays as-is.
  final List<demo.StoryVendorDemoModel> vendors;

  const StoryHighlightsRow({super.key, required this.vendors});

  @override
  State<StoryHighlightsRow> createState() => _StoryHighlightsRowState();
}

class _StoryHighlightsRowState extends State<StoryHighlightsRow> {
  bool _loading = false;
  List<MerchantStoryModel> _myStories = const [];
  late List<demo.StoryVendorDemoModel> _others;

  @override
  void initState() {
    super.initState();
    _others = List<demo.StoryVendorDemoModel>.from(widget.vendors);
    _loadMyStories();
  }

  @override
  void didUpdateWidget(covariant StoryHighlightsRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.vendors != widget.vendors) {
      _others = List<demo.StoryVendorDemoModel>.from(widget.vendors);
    }
  }

  Future<void> _loadMyStories() async {
    setState(() => _loading = true);
    try {
      final list = await MerchantStoriesApi.fetchAll();
      setState(() => _myStories = list);
    } catch (_) {
      // Silent: if API fails, we just show the other vendors.
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  demo.StoryVendorDemoModel? _buildMyVendor() {
    if (_myStories.isEmpty) return null;
    final items = _myStories
        .map(
          (s) => demo.StoryMediaItem(
            url: (s.imageUrl ?? '').trim(),
            text: s.text,
            color: s.color,
            id: s.id,
            createdAt: s.createdAt,
          ),
        )
        .toList(growable: false);

    return demo.StoryVendorDemoModel(
      storeName: 'قصتي',
      avatarUrl: _myStories.first.imageUrl ?? 'https://picsum.photos/200?random=99',
      storeId: 'me',
      groups: [
        demo.StoryVendorGroupModel(
          title: 'قصصي',
          items: items,
        ),
      ],
    );
  }

  List<demo.StoryVendorDemoModel> get _allVendors {
    final my = _buildMyVendor();
    if (my == null) return _others;
    // Put "قصتي" first so it's easy to open.
    return [my, ..._others];
  }

  @override
  Widget build(BuildContext context) {
    final vendors = _allVendors;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'ابرز القصص و العروض',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              if (_loading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 98,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              reverse: true,
              itemCount: vendors.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                // (+)
                if (i == 0) {
                  return _AddCircle(
                    onTap: () async {
                      final bool? created = await StoryCreateSheet.open(context);
                      if (created == true) {
                        await _loadMyStories();
                      }
                    },
                  );
                }

                final v = vendors[i - 1];
                return _StoryCircle(
                  title: v.storeName,
                  avatarUrl: v.avatarUrl,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StoryViewerScreen(
                          vendors: vendors,
                          initialVendorIndex: i - 1,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AddCircle extends StatelessWidget {
  final VoidCallback onTap;
  const _AddCircle({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: StoryVendorTheme.primaryBlue, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.add, color: StoryVendorTheme.primaryBlue, size: 26),
            ),
          ),
          const SizedBox(height: 6),
          const SizedBox(
            width: 76,
            child: Text(
              'جديدة',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _StoryCircle extends StatelessWidget {
  final String title;
  final String avatarUrl;
  final VoidCallback onTap;

  const _StoryCircle({
    required this.title,
    required this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF8A3FFC), Color(0xFFF45D22)],
              ),
            ),
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: NetworkImage(avatarUrl),
                onBackgroundImageError: (_, __) {},
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 76,
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
