import 'package:flutter/material.dart';

/// Shared model for stepper steps across custom/responsive steppers.
///
/// NOTE: This file exists to avoid having multiple StepperStep classes
/// defined in different files, which causes type-mismatch errors.
class StepperStep {
  final String title;
  final String subtitle;
  final IconData? icon;

  /// Optional flags used by some steppers (kept optional for backward compatibility).
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
