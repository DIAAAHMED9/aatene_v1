import '../../../general_index.dart';


class AddStoryScreen extends StatefulWidget {
  const AddStoryScreen({super.key});

  @override
  State<AddStoryScreen> createState() => _AddStoryScreenState();
}

class _AddStoryScreenState extends State<AddStoryScreen> {
  final StoriesController controller = Get.find<StoriesController>();
  final TextEditingController textController = TextEditingController();

  List<MediaItem> selectedMediaItems = [];
  Color selectedColor = Colors.black;

  Future<void> openMediaLibrary() async {
    final result = await Get.to<List<MediaItem>>(
      () => const MediaLibraryScreen(
        isSelectionMode: true,
        maxSelectionCount: 4,
      ),
    );

    if (result == null || result.isEmpty) return;

    setState(() {
      selectedMediaItems = result.take(4).toList();
    });
  }

  Future<void> submit() async {
    if (selectedMediaItems.isEmpty) {
      Get.snackbar('تنبيه', 'اختر صورة/صور من مكتبة الوسائط أولاً');
      return;
    }

    try {
      await controller.addStoriesUsingUploadedMediaBulk(
        mediaItems: selectedMediaItems,
        text: textController.text,
        color: selectedColor,
      );

      // Return true so the previous screen can refresh instantly.
      Get.back(result: true);
      Get.snackbar('تم', 'تم نشر القصة بنجاح');
    } catch (e) {
      Get.snackbar('خطأ', e.toString());
    }
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  Widget _previewGrid() {
    if (selectedMediaItems.isEmpty) {
      return const Center(child: Text('اضغط لاختيار صورة/صور من مكتبة الوسائط'));
    }

    // Simple preview grid for up to 4 selected items
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: selectedMediaItems.length.clamp(0, 4),
      itemBuilder: (_, i) {
        final m = selectedMediaItems[i];
        // Try url first (usually available), otherwise placeholder with name
        final url = (m.fileUrl ?? '').trim();
        if (url.isNotEmpty) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(url, fit: BoxFit.cover),
          );
        }
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                m.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('إضافة قصة')),
      body: Obx(() {
        final loading = controller.isLoading.value;

        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              InkWell(
                onTap: loading ? null : openMediaLibrary,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: _previewGrid(),
                ),
              ),

              const SizedBox(height: 14),

              TextField(
                controller: textController,
                minLines: 2,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'نص القصة (اختياري)',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  const Text('لون الخلفية:'),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: loading
                        ? null
                        : () async {
                            final colors = <Color>[
                              Colors.black,
                              Colors.white,
                              Colors.red,
                              Colors.pink,
                              Colors.purple,
                              Colors.deepPurple,
                              Colors.indigo,
                              Colors.blue,
                              Colors.lightBlue,
                              Colors.cyan,
                              Colors.teal,
                              Colors.green,
                              Colors.lightGreen,
                              Colors.lime,
                              Colors.yellow,
                              Colors.amber,
                              Colors.orange,
                              Colors.deepOrange,
                              Colors.brown,
                              Colors.grey,
                            ];

                            final Color? picked = await showDialog<Color>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text('اختر لون'),
                                content: SizedBox(
                                  width: double.maxFinite,
                                  child: Wrap(
                                    spacing: 10,
                                    runSpacing: 10,
                                    children: colors.map((c) {
                                      return InkWell(
                                        onTap: () => Navigator.pop(context, c),
                                        child: Container(
                                          width: 34,
                                          height: 34,
                                          decoration: BoxDecoration(
                                            color: c,
                                            shape: BoxShape.circle,
                                            border: Border.all(color: Colors.black12),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            );

                            if (picked != null) {
                              setState(() => selectedColor = picked);
                            }
                          },
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: selectedColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black12),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    selectedColor.value.toString(),
                    style: const TextStyle(color: Colors.grey),
                    textDirection: TextDirection.ltr,
                  ),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: loading ? null : submit,
                  child: loading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(selectedMediaItems.length <= 1 ? 'نشر القصة' : 'نشر ${selectedMediaItems.length} قصص'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
