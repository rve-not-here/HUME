import 'package:flutter/material.dart';

class AppShadows {
  // Prevent instantiation
  AppShadows._();

  // Standard card shadow
  static List<BoxShadow> get card => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ];

  // Elevated component shadow
  static List<BoxShadow> get elevated => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.08),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ];

  // Subtle shadow for less prominent elements
  static List<BoxShadow> get subtle => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.03),
          blurRadius: 12,
          offset: const Offset(0, 2),
        ),
      ];

  // Primary colored shadow (for buttons, etc)
  static List<BoxShadow> primaryShadow(Color color) => [
        BoxShadow(
          color: color.withValues(alpha: 0.3),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ];

  // Strong shadow for modals/dialogs
  static List<BoxShadow> get modal => [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 24,
          offset: const Offset(0, 12),
        ),
      ];
}
