

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../general_index.dart';
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
  final double _fabSize = 60;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: _buildMainContent(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: widget.pages[_currentIndex],
        ),
        if (MediaQuery
            .of(context)
            .viewInsets
            .bottom == 0)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              color: Colors.transparent,
            ),
          ),
      ],
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    final double screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    final double containerWidth = screenWidth - 30;
    final double notchWidth = containerWidth * widget.notchWidthRatio;
    final double notchDepth = 68 * widget.notchDepthRatio;

    return Container(
      color: Colors.transparent,
      height: 100,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: 20,
            left: (screenWidth - containerWidth) / 2,
            child: Container(
              height: 68,
              width: containerWidth,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color:  AppColors.customBottomNavigation,
                    offset: const Offset(0, 4),
                    blurRadius: 16,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 20,
            left: (screenWidth - containerWidth) / 2,
            child: ClipPath(
              clipper: InwardTopNotchClipper(notchWidth, notchDepth),
              child: Container(
                height: 68,
                width: containerWidth,
                color: Colors.white,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(widget.icons.length + 1, (i) {
                    if (i == (widget.icons.length ~/ 2)) {
                      return SizedBox(
                        width: _fabSize + 20,
                      );
                    }
                    final actualIndex = i > (widget.icons.length ~/ 2)
                        ? i - 1
                        : i;
                    return _buildNavItem(
                      context,
                      icon: widget.icons[actualIndex],
                      index: actualIndex,
                      text: widget.pageName[actualIndex],
                    );
                  }),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 20 + 34,
            left: (screenWidth - _fabSize) / 2,
            child: _buildFloatingActionButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      elevation: 4,
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          FocusScope.of(context).unfocus();
          widget.onFabTap?.call();
        },
        child: Container(
          height: _fabSize,
          width: _fabSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.fabColor,
            boxShadow: [
              BoxShadow(
                color:  AppColors.customBottomNavigation,
                offset: const Offset(0, 4),
                blurRadius: 16,
              ),
            ],
          ),
          child: Icon(widget.fabIcon, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context,
      {required IconData icon, required int index, String? text}) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          setState(() => _currentIndex = index);
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              Icon(
              icon,
              size: 24,
              color: isSelected ? widget.selectedColor : widget.unselectedColor,
            ),
            SizedBox(height: 4),
            if (text != null)
        Text(
        text,
        style: getRegular(fontSize: 10,
          color: isSelected ? widget.selectedColor : widget.unselectedColor,)
    )
    else if (isSelected)
    Container(
    width: 6,
    height: 6,
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    color: widget.selectedColor,
    ),
    ),
    ],
    ),
    )
    ,
    );
  }
}