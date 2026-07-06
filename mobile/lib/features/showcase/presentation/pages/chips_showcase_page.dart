import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/chips/app_chip.dart';
import '../../../../core/widgets/chips/status_chip.dart';
import '../../../../core/widgets/chips/difficulty_chip.dart';
import '../../../../core/widgets/chips/category_chip.dart';
import '../../../../core/widgets/chips/xp_chip.dart';
import '../../../../core/widgets/badges/rank_badge.dart';
import '../../../../core/widgets/progress/linear_progress_card.dart';
import '../../../../core/widgets/progress/circular_progress_card.dart';
import '../../../../core/widgets/progress/lesson_progress_bar.dart';
import '../../../../core/widgets/progress/xp_progress_bar.dart';

class ChipsShowcasePage extends StatelessWidget {
  const ChipsShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Chips & Progress Showcase'),
        backgroundColor: AppColors.surface,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('AppChip Variants'),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                const AppChip(label: 'Filled', type: AppChipType.filled),
                const AppChip(label: 'Outlined', type: AppChipType.outlined),
                const AppChip(label: 'Tonal', type: AppChipType.tonal),
                const AppChip(label: 'Selectable', isSelected: true),
                const AppChip(label: 'Removable', isRemovable: true),
                const AppChip(label: 'Disabled', isEnabled: false),
                const AppChip(label: 'With Icon', icon: Icons.star),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),
            _buildSectionTitle('Status Chips'),
            const Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                StatusChip(state: StatusChipState.active),
                StatusChip(state: StatusChipState.pending),
                StatusChip(state: StatusChipState.completed),
                StatusChip(state: StatusChipState.failed),
                StatusChip(state: StatusChipState.locked),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),
            _buildSectionTitle('Difficulty Chips'),
            const Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                DifficultyChip(level: DifficultyLevel.beginner),
                DifficultyChip(level: DifficultyLevel.intermediate),
                DifficultyChip(level: DifficultyLevel.advanced),
                DifficultyChip(level: DifficultyLevel.expert),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),
            _buildSectionTitle('Category & XP Chips'),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                const CategoryChip(label: 'Forensics', color: AppColors.info, icon: Icons.search),
                const CategoryChip(label: 'Network', color: AppColors.warning, icon: Icons.wifi),
                const XPChip(xp: 250),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),
            _buildSectionTitle('Rank Badges'),
            const Wrap(
              spacing: AppSpacing.lg,
              runSpacing: AppSpacing.lg,
              alignment: WrapAlignment.center,
              children: [
                RankBadge(rank: RankTier.bronze),
                RankBadge(rank: RankTier.silver),
                RankBadge(rank: RankTier.gold),
                RankBadge(rank: RankTier.platinum),
                RankBadge(rank: RankTier.diamond, size: 48),
              ],
            ),

            const SizedBox(height: AppSpacing.xl),
            _buildSectionTitle('Progress Components'),
            const LinearProgressCard(
              title: 'Module 1: Intro to Forensics',
              subtitle: '2 of 5 lessons completed',
              progress: 0.4,
              progressText: '40%',
            ),
            const SizedBox(height: AppSpacing.lg),
            const CircularProgressCard(
              title: 'Overall Accuracy',
              subtitle: 'Based on your last 10 cases',
              progress: 0.85,
              centerWidget: Text('85%', style: TextStyle(fontWeight: FontWeight.bold)),
              color: AppColors.success,
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('Lesson Progress', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.sm),
            const LessonProgressBar(totalSteps: 5, completedSteps: 3),
            const SizedBox(height: AppSpacing.lg),
            const XPProgressBar(currentXP: 850, targetXP: 1000, currentLevel: 4),
            
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
      ),
    );
  }
}
