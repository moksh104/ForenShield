import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_motion.dart';

class XPChip extends StatefulWidget {
  final int xp;
  final bool animate;

  const XPChip({super.key, required this.xp, this.animate = true});

  @override
  State<XPChip> createState() => _XPChipState();
}

class _XPChipState extends State<XPChip> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: AppMotion.slow);

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: AppMotion.bounce));

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
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.15),
          borderRadius: AppRadius.borderPill,
          border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_rounded, size: 16, color: primaryColor),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '${widget.xp} XP',
              style: theme.textTheme.labelMedium?.copyWith(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
