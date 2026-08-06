import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';

/// Progress line loader + live percentage counter + security notice matching spec.
class LoadingBar extends StatefulWidget {
  final VoidCallback? onComplete;

  const LoadingBar({super.key, this.onComplete});

  @override
  State<LoadingBar> createState() => _LoadingBarState();
}

class _LoadingBarState extends State<LoadingBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutCubic),
    );

    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        _controller.forward().then((_) {
          if (mounted) {
            widget.onComplete?.call();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final primaryColor = AppColors.primary; // #2563EB Cobalt Blue
    final trackColor = isDark
        ? AppColors.surfaceRaised1
        : AppColors.lightSurfaceRaised;
    final textSecondary = isDark
        ? AppColors.textSecondary
        : AppColors.lightTextSecondary;

    return AnimatedBuilder(
      animation: _progressAnimation,
      builder: (context, child) {
        final progressVal = _progressAnimation.value;
        final percentage = (progressVal * 100).toInt();

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Status text
            Text(
              'Initializing secure environment...',
              style: theme.textTheme.bodySmall?.copyWith(
                color: textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: AppSpacing.sm),

            // Row: Progress Bar + Live Percentage Text (e.g. 72%)
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Horizontal line progress loader
                Container(
                  width: 200,
                  height: 4,
                  decoration: BoxDecoration(
                    color: trackColor,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: progressVal,
                      child: Container(
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                // Live Percentage text counter
                SizedBox(
                  width: 36,
                  child: Text(
                    '$percentage%',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),

            // Footer Security Encryption Notice
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.shield_outlined, size: 15, color: primaryColor),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Enterprise-grade encryption and security',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
