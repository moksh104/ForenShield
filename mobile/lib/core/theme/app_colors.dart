import 'package:flutter/material.dart';

/// Defines the clean, enterprise-grade color palette for ForenShield.
/// Inspired by Linear, Notion, GitHub, and Stripe:
/// Single primary accent color (Cobalt Blue #2563EB), generous whitespace,
/// simple neutral slate dark/light themes, and clear visual contrast.
abstract class AppColors {
  // ============================================================
  // 1. BRAND (Single Primary Accent & Logo Identity)
  // ============================================================
  static const Color primary = Color(
    0xFF2563EB,
  ); // Royal Cobalt Blue (Single Primary Accent)
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color secondary = Color(0xFF475569); // Slate Gray Secondary
  static const Color secondaryDark = Color(0xFF334155);
  static const Color accent = Color(0xFF2563EB); // Anchored to primary accent

  // Logo Specific Accents (Mobbin Specification Parity)
  static const Color logoBlue = Color(0xFF2563EB);
  static const Color logoGold = Color(
    0xFF2563EB,
  ); // Mapped to primary for single-accent cohesion
  static const Color logoTeal = Color(0xFF2563EB);

  // Feature Pillars (Clean unified corporate slate tones)
  static const Color investigation = Color(0xFF2563EB);
  static const Color academy = Color(0xFF2563EB);
  static const Color simulation = Color(0xFF2563EB);

  // ============================================================
  // 2. SURFACE (Dark & Light Enterprise Scale)
  // ============================================================
  // Dark Theme Surfaces
  static const Color background = Color(
    0xFF0B1220,
  ); // Dark navy base (#0B1220 from spec)
  static const Color bgBase = Color(0xFF0B1220);
  static const Color surface = Color(0xFF0F172A); // Elevated slate surface
  static const Color surfaceHighlight = Color(0xFF1E293B);
  static const Color surfaceVariant = Color(0xFF1E293B);
  static const Color surfaceElevated = Color(0xFF1E293B);
  static const Color surfaceRaised1 = Color(0xFF1E293B);
  static const Color surfaceRaised2 = Color(0xFF334155);
  static const Color surfaceRaised3 = Color(0xFF475569);

  // Light Theme Surfaces (#F8FAFC, #FFFFFF from spec)
  static const Color lightBackground = Color(0xFFF8FAFC);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceRaised = Color(0xFFE2E8F0);

  // ============================================================
  // 3. TEXT
  // ============================================================
  // Dark Theme Text
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFF64748B);
  static const Color textTertiary = textDisabled;

  // Light Theme Text
  static const Color lightTextPrimary = Color(0xFF0F172A);
  static const Color lightTextSecondary = Color(0xFF64748B);

  // ============================================================
  // 4. BORDER & DIVIDER
  // ============================================================
  static const Color divider = Color(0xFF1E293B);
  static const Color outline = Color(0xFF334155);
  static const Color borderSubtle = Color(0xFF1E293B);
  static const Color borderDefault = Color(0xFF334155);
  static const Color lightBorderDefault = Color(0xFFE2E8F0);

  // ============================================================
  // 5. STATUS (Clean, muted indicators)
  // ============================================================
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color critical = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);
  static const Color streakFlame = warning;

  // ============================================================
  // 6. GRADIENT (Subtle single-hue & background blends)
  // ============================================================
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient logoGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0B1220), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const RadialGradient cyberGlowGradient = RadialGradient(
    colors: [Color(0x1A2563EB), Colors.transparent],
    radius: 0.8,
  );
}
