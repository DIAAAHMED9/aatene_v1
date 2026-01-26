import 'package:flutter/material.dart';
import '../../../component/text/aatene_custom_text.dart';

class GenericTabs extends StatelessWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTap;
  final Color selectedColor;
  final Color unSelectedColor;

  const GenericTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
    required this.selectedColor,
    required this.unSelectedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          spacing: 5,
          children: List.generate(
            tabs.length,
            (index) => Expanded(
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Container(
                  height: 42,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? selectedColor
                        : unSelectedColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Text(
                    tabs[index],
                    style: getMedium(
                      color: selectedIndex == index
                          ? Colors.white
                          : selectedColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        // AnimatedAlign(
        //   duration: const Duration(milliseconds: 300),
        //   alignment: Alignment(
        //     -1 + (2 / (tabs.length - 1)) * selectedIndex,
        //     0,
        //   ),
        //   child: Container(
        //     height: 3,
        //     width:
        //     MediaQuery.of(context).size.width / tabs.length - 30,
        //     decoration: BoxDecoration(
        //       color: selectedColor,
        //       borderRadius: BorderRadius.circular(4),
        //     ),
        //   ),
        // ),
      ],
    );
  }
}
