import 'package:flutter/material.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/effects/scanner_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// The ForenShield animated logo + cybersecurity command center header.
class AuthLogo extends StatefulWidget {
  final bool compact;

  const AuthLogo({super.key, this.compact = false});

  @override
  State<AuthLogo> createState() => _AuthLogoState();
}

class _AuthLogoState extends State<AuthLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _floatAnimation = Tween<double>(begin: -3.0, end: 3.0).animate(
      CurvedAnimation(
        parent: _floatController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    return Column(
      children: [
        // Security Command Center Telemetry Tag
        if (!widget.compact) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.12),
              borderRadius: AppRadius.borderRadiusSm,
              border: Border.all(
                color: primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: foren.success.t500,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  'CYBER OPS CENTER · SECURE AUTH 4.0',
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'monospace',
                    letterSpacing: 1.0,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // Floating Animated Shield icon with Scanner & Glow
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: GlowEffect(
                glowColor: primaryColor,
                blurRadius: widget.compact ? 16.0 : 28.0,
                spreadRadius: widget.compact ? 2.0 : 4.0,
                animate: true,
                borderRadius: BorderRadius.circular(
                  widget.compact ? AppRadius.medium : AppRadius.large,
                ),
                child: SizedBox(
                  width: widget.compact ? 64 : 84,
                  height: widget.compact ? 64 : 84,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Scanner radar sweep
                      ScannerEffect(
                        size: widget.compact ? 64 : 84,
                        color: primaryColor,
                        duration: const Duration(milliseconds: 2500),
                      ),
                      // Shield emblem container
                      Container(
                        width: widget.compact ? 56 : 72,
                        height: widget.compact ? 56 : 72,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [primaryColor, AppColors.logoBlue],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(
                            widget.compact ? AppRadius.medium : AppRadius.large,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.shield_outlined,
                            color: theme.scaffoldBackgroundColor,
                            size: widget.compact ? 28 : 38,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        SizedBox(height: widget.compact ? AppSpacing.sm : AppSpacing.md),

        // Brand Name
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Foren',
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontSize: widget.compact ? 22 : 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Shield',
              style: TextStyle(
                color: primaryColor,
                fontSize: widget.compact ? 22 : 28,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),

        if (!widget.compact) ...[
          const SizedBox(height: AppSpacing.xxs),
          Text(
            'Learn. Investigate. Defend.',
            style: TextStyle(
              color: foren.textDisabled,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ],
    );
  }
}
