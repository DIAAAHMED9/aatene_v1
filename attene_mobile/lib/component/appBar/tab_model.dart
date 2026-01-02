import 'package:flutter/material.dart';



class TabData {
  final String label;
  final String viewName;
  final IconData? icon;
  final int? sectionId;

  TabData({
    required this.label,
    required this.viewName,
    this.icon,
    this.sectionId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TabData &&
          runtimeType == other.runtimeType &&
          label == other.label &&
          viewName == other.viewName &&
          sectionId == other.sectionId;

  @override
  int get hashCode =>
      label.hashCode ^ viewName.hashCode ^ (sectionId?.hashCode ?? 0);
}

class AppBarConfig {
  final String title;
  final String actionText;
  final VoidCallback? onActionPressed;
  final List<TabData>? tabs;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onFilterPressed;
  final VoidCallback? onSortPressed;
  final TabController? tabController;
  final ValueChanged<int>? onTabChanged;
  final bool showSearch;
  final bool showTabs;

  AppBarConfig({
    required this.title,
    required this.actionText,
    this.onActionPressed,
    this.tabs,
    this.searchController,
    this.onSearchChanged,
    this.onFilterPressed,
    this.onSortPressed,
    this.tabController,
    this.onTabChanged,
    this.showSearch = true,
    this.showTabs = true,
  });
}