import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Cybersecurity domain skill badges & mastery matrix section.
class SkillBadgesSection extends StatelessWidget {
  const SkillBadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    const skills = [
      _SkillItemData(
        name: 'Memory Forensics & Dump Analysis',
        level: 'Master',
        progress: 0.88,
        color: AppColors.primary,
        icon: Icons.memory_outlined,
      ),
      _SkillItemData(
        name: 'Network Traffic & Packet Inspection',
        level: 'Expert',
        progress: 0.94,
        color: AppColors.primary,
        icon: Icons.lan_outlined,
      ),
      _SkillItemData(
        name: 'Malware & Binary Disassembly',
        level: 'Advanced',
        progress: 0.82,
        color: AppColors.investigation,
        icon: Icons.bug_report_outlined,
      ),
      _SkillItemData(
        name: 'Incident Response & SOC Triage',
        level: 'Expert',
        progress: 0.90,
        color: AppColors.secondary,
        icon: Icons.shield_moon_outlined,
      ),
      _SkillItemData(
        name: 'Cryptography & Log Auditing',
        level: 'Proficient',
        progress: 0.78,
        color: AppColors.academy,
        icon: Icons.vpn_key_outlined,
      ),
    ];

    return GlassEffect(
      border: Border.all(
        color: primaryColor.withValues(alpha: 0.35),
        width: 1.0,
      ),
      borderRadius: AppRadius.borderRadiusXl,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.workspace_premium_outlined,
                      color: primaryColor,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Skills',
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: AppRadius.borderRadiusSm,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '${skills.length} domains',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: skills.length,
              separatorBuilder: (ctx, i) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final skill = skills[index];
                final percentInt = (skill.progress * 100).toInt();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(skill.icon, color: skill.color, size: 14),
                            const SizedBox(width: 6),
                            Text(
                              skill.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${skill.level} · $percentInt%',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: skill.color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Skill Bar Track
                    Container(
                      height: 5,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: foren.surfaceRaised2,
                        borderRadius: BorderRadius.circular(3),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: skill.progress,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                skill.color,
                                skill.color.withValues(alpha: 0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SkillItemData {
  final String name;
  final String level;
  final double progress;
  final Color color;
  final IconData icon;

  const _SkillItemData({
    required this.name,
    required this.level,
    required this.progress,
    required this.color,
    required this.icon,
  });
}
