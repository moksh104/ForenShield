import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Today's Mission Card displaying mission title, estimated time, difficulty, progress, count-up animation, and action button.
class MissionCard extends StatefulWidget {
  final String title;
  final int estimatedMinutes;
  final String difficulty;
  final double progress;
  final bool isCompleted;
  final VoidCallback? onContinueTap;

  const MissionCard({
    super.key,
    required this.title,
    required this.estimatedMinutes,
    required this.difficulty,
    required this.progress,
    this.isCompleted = false,
    this.onContinueTap,
  });

  @override
  State<MissionCard> createState() => _MissionCardState();
}

class _MissionCardState extends State<MissionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;
    final diffColor = _getDifficultyColor(foren, widget.difficulty);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.translationValues(0, _isHovered ? -3 : 0, 0),
          child: GlassEffect(
            blurX: 16.0,
            blurY: 16.0,
            opacity: _isHovered ? 0.16 : 0.12,
            borderRadius: AppRadius.borderRadiusLg,
            border: Border.all(
              color: _isHovered
                  ? primaryColor.withValues(alpha: 0.5)
                  : foren.borderSubtle.withValues(alpha: 0.4),
              width: _isHovered ? 1.5 : 1.0,
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: 0.15),
                        borderRadius: AppRadius.borderRadiusXs,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.flag_outlined,
                              size: 12, color: primaryColor),
                          const SizedBox(width: 4),
                          Text(
                            'TODAY\'S MISSION',
                            style: TextStyle(
                              color: primaryColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: diffColor.withValues(alpha: 0.15),
                        borderRadius: AppRadius.borderRadiusXs,
                      ),
                      child: Text(
                        widget.difficulty.toUpperCase(),
                        style: TextStyle(
                          color: diffColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 13,
                      color: foren.textDisabled,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.estimatedMinutes} min estimated',
                      style: TextStyle(
                        color: foren.textDisabled,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                // Progress Bar & Action Button
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: widget.progress),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeOutCubic,
                            builder: (context, val, child) {
                              return Text(
                                '${(val * 100).toInt()}% Completed',
                                style: TextStyle(
                                  color: foren.textSecondary,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: AppRadius.borderRadiusXs,
                            child: TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0, end: widget.progress),
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.easeOutCubic,
                              builder: (context, val, child) {
                                return LinearProgressIndicator(
                                  value: val,
                                  minHeight: 5,
                                  backgroundColor: foren.surfaceRaised1,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    primaryColor,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    GlowEffect(
                      glowColor: primaryColor,
                      blurRadius: _isHovered ? 12.0 : 6.0,
                      spreadRadius: _isHovered ? 2.0 : 0.0,
                      animate: _isHovered,
                      borderRadius: AppRadius.borderRadiusMd,
                      child: ElevatedButton(
                        onPressed: widget.onContinueTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: theme.scaffoldBackgroundColor,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: 8,
                          ),
                          shape: const RoundedRectangleBorder(
                            borderRadius: AppRadius.borderRadiusMd,
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          widget.isCompleted ? 'Review' : 'Continue',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(ForenColors foren, String diff) {
    switch (diff.toLowerCase()) {
      case 'hard':
      case 'expert':
        return foren.critical.t500;
      case 'medium':
        return foren.warning.t500;
      case 'easy':
      default:
        return foren.success.t500;
    }
  }
}
