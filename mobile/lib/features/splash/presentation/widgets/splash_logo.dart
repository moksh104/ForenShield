import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import 'background_grid.dart';

/// ForenShield Enterprise Splash Branding & Logo Sequence.
/// Strictly aligned with the official light & dark splash specification:
/// 1. Logo Reveal (Shield Emblem + FORENSHIELD Title + Subtitle)
/// 2. Elements Animate (Orbit ring with 5 nodes: Search, Document, Lock, Monitor, Fingerprint)
/// 3. Tagline & World Map Fade In ("Uncover the truth. Protect the future.")
class SplashLogo extends StatelessWidget {
  const SplashLogo({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary; // #2563EB Cobalt Blue
    final textPrimary = isDark
        ? AppColors.textPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ------------------------------------------------------------
        // 1. Orbital Ring & Central 3D Shield Emblem (Steps 1 & 2)
        // ------------------------------------------------------------
        SizedBox(
          width: 240,
          height: 240,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Step 2: Dotted Orbital Ring (Fades & scales in)
              CustomPaint(
                    size: const Size(210, 210),
                    painter: _OrbitRingPainter(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.12)
                          : AppColors.lightBorderDefault,
                    ),
                  )
                  .animate()
                  .fadeIn(
                    delay: 300.ms,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  )
                  .scale(
                    begin: const Offset(0.85, 0.85),
                    end: const Offset(1.0, 1.0),
                    delay: 300.ms,
                    duration: 400.ms,
                    curve: Curves.easeOutCubic,
                  ),

              // Step 2: 5 Orbital Nodes (Search, Document, Lock, Monitor, Fingerprint)
              ..._buildNodes(primaryColor, isDark),

              // Step 1: Central 3D Shield Emblem (Soft scale-up & fade-in)
              const _ShieldEmblem()
                  .animate()
                  .fadeIn(duration: 400.ms, curve: Curves.easeOutCubic)
                  .scale(
                    begin: const Offset(0.85, 0.85),
                    end: const Offset(1.0, 1.0),
                    duration: 450.ms,
                    curve: Curves.easeOutBack,
                  ),
            ],
          ),
        ),

        const SizedBox(height: AppSpacing.lg),

        // ------------------------------------------------------------
        // 2. Brand Title: FOREN (textPrimary) + SHIELD (#2563EB)
        // ------------------------------------------------------------
        Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'FOREN',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                  ),
                ),
                Text(
                  'SHIELD',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 2.0,
                  ),
                ),
              ],
            )
            .animate()
            .fadeIn(delay: 150.ms, duration: 350.ms, curve: Curves.easeOutCubic)
            .slideY(begin: 0.1, end: 0),

        const SizedBox(height: 4),

        // Subtitle: Cybersecurity · Forensics · Simulation
        Text(
          'Cybersecurity  ·  Forensics  ·  Simulation',
          style: theme.textTheme.labelSmall?.copyWith(
            color: textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ).animate().fadeIn(
          delay: 250.ms,
          duration: 350.ms,
          curve: Curves.easeOutCubic,
        ),

        const SizedBox(height: AppSpacing.xxl),

        // ------------------------------------------------------------
        // 3. Step 3: Tagline & World Map Matrix Fade In
        // ------------------------------------------------------------
        Stack(
          alignment: Alignment.center,
          children: [
            // Background World Map Dot Matrix
            WorldMapWidget(
                  color: primaryColor.withValues(alpha: isDark ? 0.07 : 0.09),
                )
                .animate(delay: 600.ms)
                .fadeIn(duration: 500.ms, curve: Curves.easeOutCubic),

            // Tagline Lines
            Column(
                  children: [
                    Text(
                      'Uncover the truth.',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: textPrimary,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Protect the future.',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: primaryColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
                .animate(delay: 550.ms)
                .fadeIn(duration: 450.ms, curve: Curves.easeOutCubic)
                .slideY(begin: 0.08, end: 0),
          ],
        ),
      ],
    );
  }

  /// Builds the 5 orbital node icons per specification:
  /// 1. Top (Search)
  /// 2. Top-Left (Document)
  /// 3. Bottom-Left (Lock)
  /// 4. Bottom (Monitor)
  /// 5. Right (Fingerprint)
  List<Widget> _buildNodes(Color primaryColor, bool isDark) {
    const radius = 95.0;
    // Angles in radians: -90° (top), -150° (top-left), 150° (bottom-left), 90° (bottom), 0° (right)
    const angles = [
      -math.pi / 2,
      -math.pi * 5 / 6,
      math.pi * 5 / 6,
      math.pi / 2,
      0.0,
    ];

    const nodeIcons = [
      Icons.search,
      Icons.description_outlined,
      Icons.lock_outline,
      Icons.desktop_windows_outlined,
      Icons.fingerprint_outlined,
    ];

    return List.generate(5, (index) {
      final nodeAngle = angles[index];
      final dx = radius * math.cos(nodeAngle);
      final dy = radius * math.sin(nodeAngle);

      return Positioned(
            left: 120 + dx - 15,
            top: 120 + dy - 15,
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? AppColors.surface : AppColors.lightSurface,
                border: Border.all(
                  color: isDark
                      ? AppColors.borderDefault
                      : AppColors.lightBorderDefault,
                  width: 1.0,
                ),
                boxShadow: AppShadows.low,
              ),
              child: Center(
                child: Icon(nodeIcons[index], size: 15, color: primaryColor),
              ),
            ),
          )
          .animate()
          .fadeIn(
            delay: Duration(milliseconds: 350 + (index * 60)),
            duration: 350.ms,
            curve: Curves.easeOutCubic,
          )
          .scale(
            begin: const Offset(0.7, 0.7),
            end: const Offset(1.0, 1.0),
            delay: Duration(milliseconds: 350 + (index * 60)),
            duration: 350.ms,
            curve: Curves.easeOutCubic,
          );
    });
  }
}

/// Central 3D Shield Emblem Widget matching official spec image.
class _ShieldEmblem extends StatelessWidget {
  const _ShieldEmblem();

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primary;

    return Image.asset(
      'assets/logos/app_logo.png',
      width: 96,
      height: 96,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => Container(
        width: 96,
        height: 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: primaryColor.withValues(alpha: 0.1),
        ),
        child: Icon(Icons.shield_rounded, size: 48, color: primaryColor),
      ),
    );
  }
}

class _OrbitRingPainter extends CustomPainter {
  final Color color;

  _OrbitRingPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    canvas.drawCircle(center, 95.0, paint);
  }

  @override
  bool shouldRepaint(covariant _OrbitRingPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
