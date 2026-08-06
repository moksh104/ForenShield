import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';
import '../../domain/entities/simulation_scenario.dart';

/// Glassmorphic Objective Checklist Widget for Simulation Scenarios.
class ObjectiveChecklistWidget extends StatelessWidget {
  final List<SimulationObjective> objectives;
  final ValueChanged<String> onQuickCommandTap;

  const ObjectiveChecklistWidget({
    super.key,
    required this.objectives,
    required this.onQuickCommandTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    return GlassEffect(
      border: Border.all(
        color: primaryColor.withValues(alpha: 0.35),
        width: 1.0,
      ),
      borderRadius: AppRadius.borderRadiusLg,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.assignment_turned_in_outlined,
                  size: 20,
                  color: primaryColor,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Objectives',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Objective Cards List
            ...objectives.map((obj) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: obj.isCompleted
                        ? foren.success.t500.withValues(alpha: 0.12)
                        : foren.surfaceRaised1.withValues(alpha: 0.5),
                    borderRadius: AppRadius.borderRadiusMd,
                    border: Border.all(
                      color: obj.isCompleted
                          ? foren.success.t500.withValues(alpha: 0.4)
                          : foren.borderSubtle.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            obj.isCompleted
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            size: 18,
                            color: obj.isCompleted
                                ? foren.success.t500
                                : foren.textSecondary,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              obj.title,
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                decoration: obj.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Padding(
                        padding: const EdgeInsets.only(left: 26),
                        child: Text(
                          obj.description,
                          style: TextStyle(
                            color: foren.textSecondary,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: AppSpacing.md),
            const Divider(),
            const SizedBox(height: AppSpacing.xs),

            // Command Assist Section
            Text(
              'Quick command helper',
              style: theme.textTheme.labelSmall?.copyWith(
                color: foren.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _CommandChip(
                  label: 'help',
                  onTap: () => onQuickCommandTap('help'),
                ),
                _CommandChip(
                  label: 'netstat -an',
                  onTap: () => onQuickCommandTap('netstat -an'),
                ),
                _CommandChip(
                  label: 'pkill -f ransomware',
                  onTap: () => onQuickCommandTap('pkill -f ransomware_agent'),
                ),
                _CommandChip(
                  label: 'iptables block 4444',
                  onTap: () => onQuickCommandTap(
                    'iptables -A INPUT -p tcp --dport 4444 -j DROP',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CommandChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _CommandChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.borderRadiusSm,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.15),
          borderRadius: AppRadius.borderRadiusSm,
          border: Border.all(color: primaryColor.withValues(alpha: 0.35)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.terminal, size: 12, color: primaryColor),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: TextStyle(
                color: primaryColor,
                fontSize: 11,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
