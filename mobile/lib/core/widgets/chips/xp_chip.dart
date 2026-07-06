import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_motion.dart';

/// A specialized gamification chip that displays the user's current Experience Points (XP).
/// 
/// Features an entrance animation mapping to [AppMotion.bounce].
class XPChip extends StatefulWidget {
  /// The amount of XP to display.
  final int xp;

  /// Whether to play a playful bounce animation on mount. Defaults to true.
  final bool animate;

  const XPChip({
    super.key,
    required this.xp,
    this.animate = true,
  });

  @override
  State<XPChip> createState() => _XPChipState();
}

class _XPChipState extends State<XPChip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppMotion.slow,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: AppMotion.bounce),
    );

    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(XPChip oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate && oldWidget.xp != widget.xp) {
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15),
          borderRadius: AppRadius.borderPill,
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star_rounded, size: 16, color: AppColors.primary),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '${widget.xp} XP',
              style: AppTypography.labelMedium.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
