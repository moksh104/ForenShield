import 'package:flutter/material.dart';

/// Defines the color palette for the ForenShield application.
/// Grounded in the ForenShield logo (Cyan #00E5FF, Gold #C98A2E, Deep Teal #0F766E, Royal Blue #0052D4)
/// with a dark-first SOC control-room aesthetic and full dark-theme support.
abstract class AppColors {
  // ============================================================
  // 1. BRAND (Logo & Identity)
  // ============================================================
  static const Color primary = Color(0xFF00E5FF); // Electric Cyan (Logo Core)
  static const Color primaryDark = Color(0xFF00B8D4);
  static const Color secondary = Color(0xFF7C4DFF); // Deep Purple
  static const Color secondaryDark = Color(0xFF651FFF);
  static const Color accent = Color(0xFF39FF14); // Neon Green

  // Logo Specific Accents
  static const Color logoGold = Color(0xFFC98A2E); // Shield Emblem Gold
  static const Color logoTeal = Color(0xFF0F766E); // Cyber Teal Accent
  static const Color logoBlue = Color(0xFF0052D4); // Deep Royal Blue

  // Feature Pillars
  static const Color investigation = Color(0xFFE040FB); // Forensics Purple
  static const Color academy = Color(0xFFFF9100); // Learning Amber
  static const Color simulation = Color(0xFF00E5FF); // Practice Cyan

  // ============================================================
  // 2. SURFACE (Dark-First Control Center Scale)
  // ============================================================
  static const Color background = Color(0xFF0A0E17); // Deep dark blue/black
  static const Color bgBase = Color(0xFF0A0E14); // App background base
  static const Color surface = Color(0xFF151A23); // Default surface
  static const Color surfaceHighlight = Color(0xFF1E2532);
  static const Color surfaceVariant = Color(0xFF1E2532);
  static const Color surfaceElevated = Color(0xFF232B3A);
  static const Color surfaceRaised1 = Color(0xFF141C28);
  static const Color surfaceRaised2 = Color(0xFF1B2531);
  static const Color surfaceRaised3 = Color(0xFF24303D);

  // Light Theme Surfaces (Dual theme support)
  static const Color lightBackground = Color(0xFFF5F7FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceRaised = Color(0xFFF0F3F7);

  // ============================================================
  // 3. TEXT
  // ============================================================
  static const Color textPrimary = Color(0xFFF8F9FA); // High contrast primary text
  static const Color textSecondary = Color(0xFFADB5BD); // Supporting text
  static const Color textDisabled = Color(0xFF6C757D); // Disabled / placeholder
  static const Color textTertiary = textDisabled;

  // Light Theme Text
  static const Color lightTextPrimary = Color(0xFF111820);
  static const Color lightTextSecondary = Color(0xFF48545F);

  // ============================================================
  // 4. BORDER & DIVIDER
  // ============================================================
  static const Color divider = Color(0xFF2C323F);
  static const Color outline = Color(0xFF3F485B);
  static const Color borderSubtle = Color(0xFF232E3B);
  static const Color borderDefault = Color(0xFF374557);

  // ============================================================
  // 5. STATUS
  // ============================================================
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF1744);
  static const Color critical = Color(0xFFEF4444);
  static const Color info = Color(0xFF2979FF);
  static const Color streakFlame = warning;

  // ============================================================
  // 6. GRADIENT
  // ============================================================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient logoGradient = LinearGradient(
    colors: [primary, logoBlue],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0A0E17), Color(0xFF151A23)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const RadialGradient cyberGlowGradient = RadialGradient(
    colors: [Color(0x3300E5FF), Colors.transparent],
    radius: 0.8,
  );
}
