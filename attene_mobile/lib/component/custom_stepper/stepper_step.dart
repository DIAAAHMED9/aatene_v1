import 'package:flutter/material.dart';

class StepperStep {
  final String title;
  final String subtitle;
  final IconData? icon;

  final bool isOptional;
  final bool isCompleted;

  const StepperStep({
    required this.title,
    this.subtitle = '',
    this.icon,
    this.isOptional = false,
    this.isCompleted = false,
  });
}