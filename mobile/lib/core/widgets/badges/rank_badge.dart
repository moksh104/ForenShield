import 'package:flutter/material.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';

/// Predefined ranks for the ForenShield gamification system.
enum RankTier { bronze, silver, gold, platinum, diamond }

/// A highly visual badge representing a user's achieved rank.
/// 
/// Can be configured to show just the icon, or the icon with the rank title.
class RankBadge extends StatelessWidget {
  /// The rank tier to display.
  final RankTier rank;

  /// Whether to display the text label of the rank. Defaults to true.
  final bool showLabel;

  /// The size of the badge icon. Defaults to 32.0.
  final double size;

  const RankBadge({
    super.key,
    required this.rank,
    this.showLabel = true,
    this.size = 32.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: size * 1.5,
          height: size * 1.5,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colors.light,
                colors.base,
                colors.dark,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: colors.base.withValues(alpha: 0.3),
                blurRadius: size / 4,
                offset: Offset(0, size / 8),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              _getIcon(),
              color: Colors.white.withValues(alpha: 0.9),
              size: size,
            ),
          ),
        ),
        if (showLabel) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            _getLabel(),
            style: AppTypography.labelMedium.copyWith(
              color: colors.base,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }

  String _getLabel() {
    switch (rank) {
      case RankTier.bronze: return 'Bronze';
      case RankTier.silver: return 'Silver';
      case RankTier.gold: return 'Gold';
      case RankTier.platinum: return 'Platinum';
      case RankTier.diamond: return 'Diamond';
    }
  }

  IconData _getIcon() {
    switch (rank) {
      case RankTier.bronze: return Icons.shield_outlined;
      case RankTier.silver: return Icons.security;
      case RankTier.gold: return Icons.admin_panel_settings;
      case RankTier.platinum: return Icons.local_police;
      case RankTier.diamond: return Icons.diamond;
    }
  }

  _RankColors _getColors() {
    switch (rank) {
      case RankTier.bronze:
        return _RankColors(
          light: const Color(0xFFCD7F32),
          base: const Color(0xFF8C5420),
          dark: const Color(0xFF4A2C11),
        );
      case RankTier.silver:
        return _RankColors(
          light: const Color(0xFFE0E0E0),
          base: const Color(0xFF9E9E9E),
          dark: const Color(0xFF616161),
        );
      case RankTier.gold:
        return _RankColors(
          light: const Color(0xFFFFD700),
          base: const Color(0xFFDAA520),
          dark: const Color(0xFFB8860B),
        );
      case RankTier.platinum:
        return _RankColors(
          light: const Color(0xFFE5E4E2),
          base: const Color(0xFF7CB9E8),
          dark: const Color(0xFF00308F),
        );
      case RankTier.diamond:
        return _RankColors(
          light: const Color(0xFFB9F2FF),
          base: const Color(0xFF00E5FF),
          dark: const Color(0xFF00B8D4),
        );
    }
  }
}

class _RankColors {
  final Color light;
  final Color base;
  final Color dark;

  _RankColors({required this.light, required this.base, required this.dark});
}
