import 'package:flutter/material.dart';
import '../../theme/app_spacing.dart';
import '../../theme/foren_theme.dart';

class AchievementCertificateCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime issuedAt;
  final bool verified;

  const AchievementCertificateCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.issuedAt,
    required this.verified,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final secondaryColor = foren.simulation.t500;

    return Card(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: secondaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(Icons.badge, color: secondaryColor, size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: foren.textSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Issued ${_formatDate(issuedAt)}',
                    style: theme.textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            Icon(
              verified ? Icons.verified : Icons.hourglass_top,
              color: verified ? foren.success.t500 : foren.warning.t500,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}
