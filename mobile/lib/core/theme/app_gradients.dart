import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Defines reusable gradients for a premium, enterprise cybersecurity feel.
/// All feature gradients use the ForenShield cobalt blue accent ramp.
abstract class AppGradients {
  /// Primary brand gradient (Cobalt Blue to Deep Blue)
  static const LinearGradient brand = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primary,
      Color(0xFF0052D4), // Deep custom blue for gradient end
    ],
  );

  /// Secondary brand gradient (Slate to Cobalt Blue)
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

  /// Feature gradient: Investigation
  static const LinearGradient investigation = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.primary, AppColors.primaryDark],
  );

  /// Feature gradient: Academy
  static const LinearGradient academy = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.primary, AppColors.primaryDark],
  );

  /// Feature gradient: Simulation
  static const LinearGradient simulation = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [AppColors.primary, AppColors.primaryLight],
  );
}
