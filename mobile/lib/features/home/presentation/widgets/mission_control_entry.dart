import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../routes/route_constants.dart';

class MissionControlEntry extends StatelessWidget {
  const MissionControlEntry({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final isDark = theme.brightness == Brightness.dark;
    final missionControlColor = foren.forFeature(ForenFeature.missionControl);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: InkWell(
        onTap: () => context.go(RouteConstants.missionControl),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          decoration: BoxDecoration(
            color: foren.surfaceRaised1,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: isDark
                  ? missionControlColor.t700
                  : missionControlColor.t300,
              width: 1,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: (missionControlColor.t500).withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color:
                      (isDark
                              ? missionControlColor.t700
                              : missionControlColor.t300)
                          .withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.dashboard_rounded,
                  color: isDark
                      ? missionControlColor.t300
                      : missionControlColor.t700,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mission Control',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Threats, cases & progress',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: foren.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: foren.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
