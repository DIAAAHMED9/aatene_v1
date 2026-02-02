import 'package:flutter/material.dart';

class SearchHistory extends StatefulWidget {
  const SearchHistory({super.key});

  @override
  State<SearchHistory> createState() => _SearchHistoryState();
}

class _SearchHistoryState extends State<SearchHistory> {
  final List<String> _history = [
    'ملابس أطفال',
    'براند',
    'ديكور منزلي',
    'ملابس أطفال',
    'براند',
    'ديكور منزلي',
  ];

  String? _lastRemovedItem;
  int? _lastRemovedIndex;

  void _removeItem(int index) {
    setState(() {
      _lastRemovedItem = _history[index];
      _lastRemovedIndex = index;
      _history.removeAt(index);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('تم حذف العنصر'),
        action: SnackBarAction(
          label: 'تراجع',
          onPressed: () {
            if (_lastRemovedItem != null && _lastRemovedIndex != null) {
              setState(() {
                _history.insert(
                  _lastRemovedIndex!,
                  _lastRemovedItem!,
                );
              });
            }
          },
        ),
      ),
    );
  }

  void _clearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('مسح الكل'),
        content: const Text('هل أنت متأكد من مسح جميع عمليات البحث؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _history.clear();
              });
              Navigator.pop(context);
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'البحث الأخير',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextButton(
                      onPressed: _history.isEmpty ? null : _clearAll,
                      child: const Text(
                        'امسح الكل',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(
                    _history.length,
                        (index) => Chip(
                      backgroundColor: const Color(0xFFF1F4F8),
                      label: Text(_history[index]),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => _removeItem(index),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}