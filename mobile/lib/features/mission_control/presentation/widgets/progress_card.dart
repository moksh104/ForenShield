import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Continue Learning Progress Card.
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
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final academyColor = foren.academy.t500;

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
                  ? academyColor.withValues(alpha: 0.5)
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
                        color: academyColor.withValues(alpha: 0.15),
                        borderRadius: AppRadius.borderRadiusXs,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school_outlined,
                              size: 12, color: academyColor),
                          const SizedBox(width: 4),
                          Text(
                            'CONTINUE LEARNING',
                            style: TextStyle(
                              color: academyColor,
                              fontSize: 10,
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
                      style: TextStyle(
                        color: foren.textDisabled,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  widget.courseTitle,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  widget.moduleTitle,
                  style: TextStyle(
                    color: foren.textSecondary,
                    fontSize: 12,
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
                    GlowEffect(
                      glowColor: academyColor,
                      blurRadius: _isHovered ? 12.0 : 6.0,
                      spreadRadius: _isHovered ? 2.0 : 0.0,
                      animate: _isHovered,
                      borderRadius: AppRadius.borderRadiusMd,
                      child: OutlinedButton(
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
                          style: TextStyle(
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
}
