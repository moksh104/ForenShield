import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// The ForenShield logo + tagline block used at the top of auth screens.
class AuthLogo extends StatelessWidget {
  final bool compact;

  const AuthLogo({super.key, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    return Column(
      children: [
        // Shield icon with glow
        Container(
          width: compact ? 56 : 72,
          height: compact ? 56 : 72,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, const Color(0xFF0052D4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(compact ? 16 : 20),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: 0.25),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.shield_outlined,
            color: theme.scaffoldBackgroundColor,
            size: compact ? 28 : 36,
          ),
        ),
        SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
        Text(
          'ForenShield',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: compact ? 22 : 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        if (!compact) ...[
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
