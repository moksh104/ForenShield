import 'package:flutter/material.dart';

/// Circular badge with emoji icon and colored border ring for achievements.
class AchievementBadge extends StatelessWidget {
  final String badge;
  final bool unlocked;
  final double size;

  const AchievementBadge({
    super.key,
    required this.badge,
    required this.unlocked,
    this.size = 56,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: unlocked
            ? theme.colorScheme.primary.withValues(alpha: 0.15)
            : Colors.grey.withValues(alpha: 0.1),
        border: Border.all(
          color: unlocked
              ? theme.colorScheme.primary
              : Colors.grey.withValues(alpha: 0.4),
          width: 2.5,
        ),
        boxShadow: unlocked
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Center(
        child: unlocked
            ? Text(
                badge,
                style: TextStyle(fontSize: size * 0.45),
              )
            : Icon(
                Icons.lock_outline_rounded,
                color: Colors.grey.withValues(alpha: 0.5),
                size: size * 0.4,
              ),
      ),
    );
  }
}
