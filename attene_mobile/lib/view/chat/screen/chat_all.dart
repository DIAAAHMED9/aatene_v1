
import '../../../general_index.dart';
import 'package:flutter/material.dart';



class ChatAll extends StatefulWidget {
  const ChatAll({super.key});

  @override
  State<ChatAll> createState() => _ChatAllState();
}

class _ChatAllState extends State<ChatAll> {
  final ChatController c = Get.find<ChatController>();
  final TextEditingController _search = TextEditingController();

  @override
  void initState() {
    super.initState();
    c.refreshConversations();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = c.filteredConversations;
      final cs = Theme.of(context).colorScheme;

      return Scaffold(
        appBar: AppBar(
          title: const Text('المحادثات'),
          centerTitle: false,
          actions: [
          // IconButton(onPressed: ()=>Get.to(BlockScreen()), icon: Icon(Icons.block_rounded)),
            IconButton(
              tooltip: 'تحديث',
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () => c.refreshConversations(),
            ),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 40),
          child: FloatingActionButton.extended(
            backgroundColor: AppColors.primary400,
            onPressed: _openNewChatSheet,
            icon: const Icon(Icons.add_comment_rounded,color: AppColors.light1000,),
            label:  Text('محادثة', style: getMedium(color: AppColors.light1000),),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                child: TextField(
                  controller: _search,
                  onChanged: c.setSearch,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن محادثة أو اسم...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    filled: true,
                    fillColor: cs.surfaceContainerHighest.withOpacity(0.55),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TabsRow(controller: c),
              ),
              Expanded(
                child: Stack(
                  children: [
                    if (c.isLoading.value && list.isEmpty)
                      const Center(child: CircularProgressIndicator())
                    else if (list.isEmpty)
                      EmptyState(
                        onNewChat: _openNewChatSheet,
                      )
                    else
                      RefreshIndicator(
                        onRefresh: () async => c.refreshConversations(),
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(12, 6, 12, 96),
                          itemCount: list.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 10),
                          itemBuilder: (context, index) => ConversationCard(
                            conversation: list[index],
                            controller: c,
                          ),
                        ),
                      ),
                    if (c.isLoading.value && list.isNotEmpty)
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 0,
                        child: LinearProgressIndicator(minHeight: 2, color: cs.primary),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

Future<void> _openNewChatSheet() async {
  if (!mounted) return;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => NewChatSheet(controller: c),
  );

  c.loadPreviousParticipants();
}

}
