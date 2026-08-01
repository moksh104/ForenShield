import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Cybersecurity Domain Skill Badges & Mastery Matrix Section.
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
        level: 'MASTER',
        progress: 0.88,
        color: AppColors.primary,
        icon: Icons.memory_outlined,
      ),
      _SkillItemData(
        name: 'Network Traffic & Packet Inspection',
        level: 'EXPERT',
        progress: 0.94,
        color: AppColors.logoGold,
        icon: Icons.lan_outlined,
      ),
      _SkillItemData(
        name: 'Malware & Binary Disassembly',
        level: 'ADVANCED',
        progress: 0.82,
        color: AppColors.investigation,
        icon: Icons.bug_report_outlined,
      ),
      _SkillItemData(
        name: 'Incident Response & SOC Triage',
        level: 'EXPERT',
        progress: 0.90,
        color: AppColors.secondary,
        icon: Icons.shield_moon_outlined,
      ),
      _SkillItemData(
        name: 'Cryptography & Log Auditing',
        level: 'PROFICIENT',
        progress: 0.78,
        color: AppColors.academy,
        icon: Icons.vpn_key_outlined,
      ),
    ];

    return GlassEffect(
      blurX: 14.0,
      blurY: 14.0,
      opacity: 0.10,
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
                    Icon(Icons.workspace_premium_outlined, color: primaryColor, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'CYBERSECURITY SKILL MATRIX',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        fontFamily: 'monospace',
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.12),
                    borderRadius: AppRadius.borderRadiusSm,
                    border: Border.all(
                      color: primaryColor.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    '5 DOMAINS ACTIVE',
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
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
              separatorBuilder: (ctx, i) => const SizedBox(height: AppSpacing.sm),
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
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          '${skill.level} · $percentInt%',
                          style: TextStyle(
                            color: skill.color,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'monospace',
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
                                AppColors.logoGold,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                            boxShadow: [
                              BoxShadow(
                                color: skill.color.withValues(alpha: 0.5),
                                blurRadius: 6,
                              ),
                            ],
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
