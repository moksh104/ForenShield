import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Learning Progress Overview Screen for Cyber Academy.
class LearningProgressScreen extends ConsumerWidget {
  const LearningProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final academyColor = foren.academy.t500;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          color: theme.colorScheme.onSurface,
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Learning Analytics & Progress',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // XP & Completion Summary Card
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: AppRadius.borderRadiusLg,
                  border: Border.all(
                    color: academyColor.withValues(alpha: 0.35),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Overall Completion',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          '68%',
                          style: TextStyle(
                            color: academyColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: AppRadius.borderRadiusXs,
                      child: LinearProgressIndicator(
                        value: 0.68,
                        minHeight: 8,
                        backgroundColor: foren.surfaceRaised1,
                        valueColor: AlwaysStoppedAnimation<Color>(academyColor),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatItem(label: 'Completed', value: '4 Courses'),
                        _StatItem(label: 'Total XP', value: '1,450 XP'),
                        _StatItem(label: 'Certificates', value: '2 Earned'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'Certificates Earned',
                style: TextStyle(
                  color: theme.colorScheme.onSurface,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),

              const _CertificateTile(
                title: 'Certified Memory Forensics Specialist',
                issuedDate: 'Issued Jun 14, 2026',
              ),
              const SizedBox(height: AppSpacing.xs),
              const _CertificateTile(
                title: 'Network Traffic Defense Fundamentals',
                issuedDate: 'Issued May 02, 2026',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 15,
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: foren.textDisabled, fontSize: 11)),
      ],
    );
  }
}

class _CertificateTile extends StatelessWidget {
  final String title;
  final String issuedDate;

  const _CertificateTile({required this.title, required this.issuedDate});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final warningColor = foren.warning.t500;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.borderRadiusMd,
        border: Border.all(color: foren.borderSubtle.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: warningColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.card_membership, color: warningColor, size: 20),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  issuedDate,
                  style: TextStyle(color: foren.textDisabled, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
