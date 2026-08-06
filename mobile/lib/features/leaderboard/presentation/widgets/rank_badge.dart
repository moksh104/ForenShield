import 'package:flutter/material.dart';

/// Circular badge showing rank position with gold/silver/bronze for top 3.
class RankBadge extends StatelessWidget {
  final int rank;
  final double size;

  const RankBadge({
    super.key,
    required this.rank,
    this.size = 32,
  });

  Color _badgeColor() {
    switch (rank) {
      case 1:
        return const Color(0xFFFFD700); // Gold
      case 2:
        return const Color(0xFFC0C0C0); // Silver
      case 3:
        return const Color(0xFFCD7F32); // Bronze
      default:
        return const Color(0xFF475569); // Slate
    }
  }

  String _badgeText() {
    if (rank <= 3 && rank >= 1) {
      return ['🥇', '🥈', '🥉'][rank - 1];
    }
    return '#$rank';
  }

  @override
  Widget build(BuildContext context) {
    final isTopThree = rank >= 1 && rank <= 3;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isTopThree
            ? _badgeColor().withValues(alpha: 0.2)
            : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: _badgeColor(),
          width: isTopThree ? 2 : 1,
        ),
        boxShadow: isTopThree
            ? [
                BoxShadow(
                  color: _badgeColor().withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: Center(
        child: isTopThree
            ? Text(
                _badgeText(),
                style: TextStyle(fontSize: size * 0.5),
              )
            : Text(
                _badgeText(),
                style: TextStyle(
                  color: _badgeColor(),
                  fontSize: rank < 100 ? 11 : 9,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}
