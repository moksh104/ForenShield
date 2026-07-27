import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Defines the elevation and shadow/glow system for the ForenShield application.
/// Includes both standard shadows and cyber-themed glows.
abstract class AppShadows {
  /// Very subtle shadow for small cards or buttons
  static const List<BoxShadow> low = [
    BoxShadow(
      color: Color(0x33000000), // 20% opacity black
      blurRadius: 4.0,
      offset: Offset(0, 2),
    ),
  ];

  /// Medium shadow for dialogs, modals, and raised surfaces
  static const List<BoxShadow> medium = [
    BoxShadow(
      color: Color(0x40000000), // 25% opacity black
      blurRadius: 8.0,
      offset: Offset(0, 4),
    ),
  ];

  /// High shadow for floating action buttons or extreme elevation
  static const List<BoxShadow> high = [
    BoxShadow(
      color: Color(0x66000000), // 40% opacity black
      blurRadius: 16.0,
      offset: Offset(0, 8),
    ),
  ];

  // Backwards compatibility aliases
  static const List<BoxShadow> none = [];
  static const List<BoxShadow> subtle = low;
  static const List<BoxShadow> small = low;
  static const List<BoxShadow> large = high;

  /// Cyber glow effect using primary color
  static List<BoxShadow> cyberGlowPrimary = [
    BoxShadow(
      color: AppColors.primary.withValues(alpha: 0.3),
      blurRadius: 12.0,
      spreadRadius: 2.0,
      offset: Offset.zero,
    ),
  ];

  /// Cyber glow effect using secondary color
  static List<BoxShadow> cyberGlowSecondary = [
    BoxShadow(
      color: AppColors.secondary.withValues(alpha: 0.3),
      blurRadius: 12.0,
      spreadRadius: 2.0,
      offset: Offset.zero,
    ),
  ];

  /// Cyber glow effect for critical/alert states
  static List<BoxShadow> cyberGlowError = [
    BoxShadow(
      color: AppColors.error.withValues(alpha: 0.4),
      blurRadius: 12.0,
      spreadRadius: 2.0,
      offset: Offset.zero,
    ),
  ];
}
