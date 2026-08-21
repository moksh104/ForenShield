import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_tokens.dart';
import '../../../../core/components/foren_navigation.dart';
import '../../../../routes/route_constants.dart';

import '../widgets/home_header.dart';
import '../widgets/continue_learning_card.dart';
import '../widgets/core_experience_card.dart';
import '../widgets/recent_activity_section.dart';
import '../widgets/mission_control_entry.dart';

/// The main Home screen (dashboard) for ForenShield.
/// Provides greeting, quick actions, core experience entry points, and recent activity.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const HomeHeader(),
            const SizedBox(height: AppSpacing.lg),

            const ContinueLearningCard(),
            const SizedBox(height: AppSpacing.xl),

            const MissionControlEntry(),
            const SizedBox(height: AppSpacing.xl),

            _buildCoreExperiences(context),
            const SizedBox(height: AppSpacing.xl),

            const RecentActivitySection(),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
      bottomNavigationBar: ForenBottomNav(
        currentIndex: 0,
        onTap: (index) {
          switch (index) {
            case 0:
              // Already on home
              break;
            case 1:
              context.go(RouteConstants.academy);
              break;
            case 2:
              context.go(RouteConstants.simulation);
              break;
            case 3:
              context.go(RouteConstants.investigation);
              break;
            case 4:
              context.go(RouteConstants.profile);
              break;
          }
        },
      ),
    );
  }

  Widget _buildCoreExperiences(BuildContext context) {
    return Padding(
      padding: AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Core Experiences',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: CoreExperienceCard(
                  title: 'Cyber Academy',
                  description: 'Learn skills & techniques',
                  icon: Icons.menu_book_rounded,
                  feature: ForenFeature.academy,
                  onTap: () => context.push(RouteConstants.academy),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: CoreExperienceCard(
                  title: 'Simulation Lab',
                  description: 'Simulate real attacks',
                  icon: Icons.science_rounded,
                  feature: ForenFeature.simulation,
                  onTap: () => context.push(RouteConstants.simulation),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          CoreExperienceCard(
            title: 'Investigation Lab',
            description: 'Solve real-world cyber cases & extract evidence',
            icon: Icons.search_rounded,
            feature: ForenFeature.investigation,
            onTap: () => context.push(RouteConstants.investigation),
          ),
        ],
      ),
    );
  }
}
