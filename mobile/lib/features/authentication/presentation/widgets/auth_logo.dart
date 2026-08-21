import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

import 'package:flutter_animate/flutter_animate.dart';

/// The ForenShield logo + brand header matching the official design spec.
class AuthLogo extends StatelessWidget {
  final bool compact;

  const AuthLogo({super.key, this.compact = false});

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
            // Official 3D Shield App Logo Emblem
            Image.asset(
              'assets/logos/app_logo.png',
              width: compact ? 64 : 80,
              height: compact ? 64 : 80,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Container(
                width: compact ? 64 : 80,
                height: compact ? 64 : 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withValues(alpha: 0.1),
                ),
                child: Icon(
                  Icons.shield_rounded,
                  size: compact ? 28 : 36,
                  color: primaryColor,
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.xs),

            // Brand Name
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'FOREN',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: textPrimary,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
                Text(
                  'SHIELD',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 2),

            Text(
              'LEARN • INVESTIGATE • DEFEND',
              style: theme.textTheme.labelSmall?.copyWith(
                color: textSecondary,
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        )
        .animate()
        .fade(duration: 800.ms)
        .slideY(
          begin: 0.2,
          end: 0,
          duration: 800.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
