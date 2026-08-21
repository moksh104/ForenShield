import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../shared/widgets/foren_lottie.dart';
import '../../data/models/achievement_model.dart';
import 'achievement_progress_widget.dart';
import 'package:intl/intl.dart';

class AchievementCard extends StatefulWidget {
  final AchievementModel achievement;

  const AchievementCard({super.key, required this.achievement});

  @override
  State<AchievementCard> createState() => _AchievementCardState();
}

class _AchievementCardState extends State<AchievementCard> {
  bool _justUnlocked = false;
  late bool _wasLocked;

  @override
  void initState() {
    super.initState();
    _wasLocked = !widget.achievement.isCompleted;
  }

  @override
  void didUpdateWidget(covariant AchievementCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentlyLocked = !widget.achievement.isCompleted;
    if (_wasLocked && !currentlyLocked) {
      _justUnlocked = true;
    }
    _wasLocked = currentlyLocked;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    final isLocked = !widget.achievement.isCompleted;

    Widget card = Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isLocked
            ? theme.colorScheme.surface.withValues(alpha: 0.5)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLocked
              ? foren.borderSubtle.withValues(alpha: 0.2)
              : widget.achievement.getRarityColor().withValues(alpha: 0.5),
          width: 1.5,
        ),
        boxShadow: isLocked
            ? []
            : [
                BoxShadow(
                  color: widget.achievement.getRarityColor().withValues(
                    alpha: 0.1,
                  ),
                  blurRadius: 10,
                  spreadRadius: 0,
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: isLocked
                      ? theme.colorScheme.surfaceContainerHighest
                      : widget.achievement.getRarityColor().withValues(
                          alpha: 0.1,
                        ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isLocked
                        ? Colors.transparent
                        : widget.achievement.getRarityColor().withValues(
                            alpha: 0.3,
                          ),
                  ),
                ),
                child: Center(
                  child: isLocked
                      ? Icon(
                          Icons.lock_outline_rounded,
                          color: foren.textDisabled,
                        )
                      : Text(
                          widget.achievement.icon,
                          style: const TextStyle(fontSize: 32),
                        ),
                ),
              ),
              if (_justUnlocked)
                Positioned.fill(
                  child: ForenLottie(
                    assetPath: 'assets/lottie/achievement_unlock.json',
                    repeat: false,
                    fallbackWidget:
                        Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.achievement
                                        .getRarityColor()
                                        .withValues(alpha: 0.6),
                                    blurRadius: 20,
                                    spreadRadius: 5,
                                  ),
                                ],
                              ),
                            )
                            .animate()
                            .fadeOut(duration: 800.ms, delay: 400.ms)
                            .scale(
                              begin: const Offset(1, 1),
                              end: const Offset(1.5, 1.5),
                              duration: 600.ms,
                            ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.achievement.title,
                        style: TextStyle(
                          color: isLocked
                              ? foren.textSecondary
                              : theme.colorScheme.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (widget.achievement.xpReward > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: foren.success.t300.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '+${widget.achievement.xpReward} XP',
                          style: TextStyle(
                            color: foren.success.t300,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  widget.achievement.description,
                  style: TextStyle(color: foren.textSecondary, fontSize: 13),
                ),
                const SizedBox(height: AppSpacing.md),
                if (!isLocked && widget.achievement.unlockedAt != null)
                  Text(
                    'Unlocked ${DateFormat.yMMMd().format(widget.achievement.unlockedAt!)}',
                    style: TextStyle(
                      color: foren.success.t300,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else
                  AchievementProgressWidget(
                    progress: widget.achievement.progress,
                    threshold: widget.achievement.threshold,
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    if (_justUnlocked) {
      card = card
          .animate()
          .scale(
            begin: const Offset(0.95, 0.95),
            end: const Offset(1, 1),
            duration: 600.ms,
            curve: Curves.easeOutBack,
          )
          .shimmer(
            duration: 800.ms,
            color: widget.achievement.getRarityColor().withValues(alpha: 0.3),
          );
    }

    return card;
  }
}
