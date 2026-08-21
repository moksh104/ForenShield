import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/states/empty_state.dart';

class RecentActivitySection extends StatelessWidget {
  const RecentActivitySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          // TODO: Integrate actual recent activity from ActivityProvider/LeaderboardProvider once available
          const EmptyState(
            icon: Icons.history,
            title: 'No recent activity',
            message:
                'Your recent courses, simulations, and investigations will appear here.',
          ),
        ],
      ),
    );
  }
}
