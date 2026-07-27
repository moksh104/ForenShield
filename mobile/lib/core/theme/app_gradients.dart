import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Defines reusable gradients for a premium, enterprise cybersecurity feel.
abstract class AppGradients {
  /// Primary brand gradient (e.g., Cyan to Deep Blue)
  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      Color(0xFF0052D4), // Deep custom blue for gradient end
    ],
  );

  /// Secondary brand gradient (e.g., Purple to Neon Accent)
  static const LinearGradient secondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.secondary, AppColors.investigation],
  );

  /// Surface gradient to give depth to cards in dark mode
  static const LinearGradient surfaceDeep = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [AppColors.surfaceHighlight, AppColors.surface],
  );

  /// Status: Investigation specific gradient
  static const LinearGradient investigation = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.investigation, Color(0xFF7B1FA2)],
  );

  /// Status: Academy specific gradient
  static const LinearGradient academy = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.academy, Color(0xFFE65100)],
  );

  /// Status: Simulation specific gradient
  static const LinearGradient simulation = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.simulation, Color(0xFF00B0FF)],
  );
}
