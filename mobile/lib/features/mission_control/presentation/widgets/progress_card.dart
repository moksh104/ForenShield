import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Continue Learning Progress Card.
/// Refined: clean surface card, no glass/glow/hover overload.
class ProgressCard extends StatefulWidget {
  final String courseTitle;
  final String moduleTitle;
  final double completionPercentage;
  final String timeRemaining;
  final VoidCallback? onResumeTap;

  const ProgressCard({
    super.key,
    required this.courseTitle,
    required this.moduleTitle,
    required this.completionPercentage,
    required this.timeRemaining,
    this.onResumeTap,
  });

  @override
  State<ProgressCard> createState() => _ProgressCardState();
}

class _ProgressCardState extends State<ProgressCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final academyColor = foren.academy.t500;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusLg,
        border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.4)),
        boxShadow: AppShadows.forBrightness(
          brightness: theme.brightness,
          level: ElevationLevel.low,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: academyColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.school_outlined, size: 12, color: academyColor),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'CONTINUE LEARNING',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: academyColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                widget.timeRemaining,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: foren.textDisabled,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            widget.courseTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 2),
          Text(
            widget.moduleTitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: foren.textSecondary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TweenAnimationBuilder<double>(
                      tween: Tween<double>(
                        begin: 0,
                        end: widget.completionPercentage,
                      ),
                      duration: const Duration(milliseconds: 1000),
                      curve: Curves.easeOutCubic,
                      builder: (context, val, child) {
                        return Text(
                          '${(val * 100).toInt()}% Course Progress',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: foren.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(
                          begin: 0,
                          end: widget.completionPercentage,
                        ),
                        duration: const Duration(milliseconds: 1000),
                        curve: Curves.easeOutCubic,
                        builder: (context, val, child) {
                          return LinearProgressIndicator(
                            value: val,
                            minHeight: 5,
                            borderRadius: BorderRadius.circular(100),
                            backgroundColor: foren.surfaceRaised1,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              academyColor,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              OutlinedButton(
                onPressed: widget.onResumeTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: academyColor,
                  side: BorderSide(color: academyColor, width: 1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: 8,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: AppRadius.borderRadiusMd,
                  ),
                ),
                child: const Text(
                  'Resume',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
