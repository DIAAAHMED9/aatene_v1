import 'package:flutter/material.dart';
import 'inward_top_notch_clipper.dart';

class CustomBottomNavigation extends StatefulWidget {
  final List<Widget> pages;
  final List<IconData> icons;
  final List<String> pageName;
  final VoidCallback? onFabTap;
  final IconData fabIcon;
  final Color fabColor;
  final Color selectedColor;
  final Color unselectedColor;
  final double notchWidthRatio;
  final double notchDepthRatio;

  const CustomBottomNavigation({
    super.key,
    required this.pages,
    required this.icons,
    required this.pageName,
    this.onFabTap,
    this.fabColor = Colors.blueGrey,
    this.fabIcon = Icons.add,
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.grey,
    this.notchWidthRatio = 0.3,
    this.notchDepthRatio = 0.35,
  }) : assert(
         pages.length == icons.length,
         'Pages and icons must be the same length',
       );

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    const double circleSize = 60;
    const double listUp = 20;

    final double screenWidth = MediaQuery.of(context).size.width;
    final double containerWidth = screenWidth - 30;
    final double notchWidth = containerWidth * widget.notchWidthRatio;
    final double notchDepth = 68 * widget.notchDepthRatio;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Stack(
        children: [
          widget.pages[_currentIndex],
          Positioned(
            bottom: listUp,
            left: (screenWidth - containerWidth) / 2,
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 68,
                  width: containerWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x26000000),
                        offset: const Offset(0, 4),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                ),
                ClipPath(
                  clipper: InwardTopNotchClipper(notchWidth, notchDepth),
                  child: Container(
                    height: 68,
                    width: containerWidth,
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(widget.icons.length + 1, (i) {
                        if (i == (widget.icons.length ~/ 2)) {
                          return const SizedBox(width: 10);
                        }
                        final actualIndex = i > (widget.icons.length ~/ 2)
                            ? i - 1
                            : i;
                        return navItem(
                          icon: widget.icons[actualIndex],
                          index: actualIndex,
                          text: widget.pageName![actualIndex],
                        );
                      }),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  child: Material(
                    shape: const CircleBorder(),
                    elevation: 0,
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: widget.onFabTap,
                      child: Container(
                        height: circleSize,
                        width: circleSize,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.fabColor,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x26000000),
                              offset: const Offset(0, 4),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                        child: Icon(widget.fabIcon, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget navItem({required IconData icon, required int index, String? text}) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? widget.selectedColor : widget.unselectedColor,
          ),
          const SizedBox(height: 4),
          text != null
              ? Text(
                  text,
                  style: TextStyle(
                    fontSize: 12,
                    color: isSelected
                        ? widget.selectedColor
                        : widget.unselectedColor,
                  ),
                )
              : (isSelected)
              ? Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.selectedColor,
                  ),
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
