import '../../../../general_index.dart';

class FilterSelectionSheet extends StatelessWidget {
  const FilterSelectionSheet({
    super.key,
    required this.title,
    required this.items,
    required this.getId,
    required this.getLabel,
    required this.multi,
    required this.selectedIds,
  });

  final String title;
  final List<Map<String, dynamic>> items;
  final int Function(Map<String, dynamic>) getId;
  final String Function(Map<String, dynamic>) getLabel;
  final bool multi;
  final Set<int> selectedIds;

  @override
  Widget build(BuildContext context) {
    final search = TextEditingController();
    final filtered = items.obs;

    void applySearch(String q) {
      final qq = q.trim();
      if (qq.isEmpty) {
        filtered.assignAll(items);
      } else {
        filtered.assignAll(
          items.where((e) => getLabel(e).toLowerCase().contains(qq.toLowerCase())).toList(),
        );
      }
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 14),
          Text(title, style: getBold(fontSize: 16)),
          const SizedBox(height: 12),
          TextField(
            controller: search,
            onChanged: applySearch,
            decoration: InputDecoration(
              hintText: 'بحث...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF6F6F6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.55),
            child: Obx(
              () => ListView.separated(
                shrinkWrap: true,
                itemCount: filtered.length + 1,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  if (i == 0) {
                    final allSelected = selectedIds.isEmpty;
                    return ListTile(
                      title: const Text('الكل'),
                      trailing: multi
                          ? Checkbox(
                              value: allSelected,
                              onChanged: (_) {
                                selectedIds.clear();
                                Navigator.pop(context, selectedIds.toList());
                              },
                            )
                          : Radio<bool>(
                              value: true,
                              groupValue: allSelected,
                              onChanged: (_) {
                                selectedIds.clear();
                                Navigator.pop(context, selectedIds.toList());
                              },
                            ),
                      onTap: () {
                        selectedIds.clear();
                        Navigator.pop(context, selectedIds.toList());
                      },
                    );
                  }

                  final item = filtered[i - 1];
                  final id = getId(item);
                  final label = getLabel(item);
                  final checked = selectedIds.contains(id);

                  return ListTile(
                    title: Text(label),
                    trailing: multi
                        ? Checkbox(
                            value: checked,
                            onChanged: (_) {
                              if (checked) {
                                selectedIds.remove(id);
                              } else {
                                selectedIds.add(id);
                              }
                            },
                          )
                        : Radio<int>(
                            value: id,
                            groupValue: selectedIds.isEmpty ? -1 : selectedIds.first,
                            onChanged: (_) {
                              selectedIds
                                ..clear()
                                ..add(id);
                              Navigator.pop(context, selectedIds.toList());
                            },
                          ),
                    onTap: () {
                      if (multi) {
                        if (checked) {
                          selectedIds.remove(id);
                        } else {
                          selectedIds.add(id);
                        }
                      } else {
                        selectedIds
                          ..clear()
                          ..add(id);
                        Navigator.pop(context, selectedIds.toList());
                      }
                    },
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AateneButton(
                  onTap: () => Navigator.pop(context, selectedIds.toList()),
                  buttonText: 'تم',
                  color: AppColors.primary400,
                  borderColor: AppColors.primary400,
                  textColor: AppColors.light1000,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}