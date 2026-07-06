import 'package:flutter/material.dart';
import '../../models/component_definition.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/widgets/chips/app_chip.dart';

/// The Inspector renders the deep documentation details for a component.
class ComponentInspector extends StatelessWidget {
  final ComponentDefinition component;

  const ComponentInspector({super.key, required this.component});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: AppSpacing.lg),
        _buildSection('Purpose', component.purpose),
        _buildSection('When to use', component.whenToUse),
        _buildSection('When NOT to use', component.whenNotToUse),
        _buildDependencies(),
        _buildSection('Accessibility Notes', component.accessibilityNotes),
        _buildSection('Performance Notes', component.performanceNotes),
        _buildCodeExample(),
      ],
    );
  }

  Widget _buildHeader() {
    Color statusColor = AppColors.info;
    switch (component.status) {
      case ComponentStatus.stable: statusColor = AppColors.success; break;
      case ComponentStatus.experimental: statusColor = AppColors.warning; break;
      case ComponentStatus.deprecated: statusColor = AppColors.error; break;
      case ComponentStatus.internal: statusColor = AppColors.info; break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(component.name, style: AppTypography.headlineMedium),
            const SizedBox(width: AppSpacing.md),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: statusColor.withValues(alpha: 0.3)),
              ),
              child: Text(
                component.status.name.toUpperCase(),
                style: AppTypography.labelSmall.copyWith(color: statusColor, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(component.description, style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(content, style: AppTypography.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildDependencies() {
    if (component.dependencies.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dependencies', style: AppTypography.titleMedium),
          const SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: component.dependencies.map((dep) {
              return AppChip(
                label: dep,
                type: AppChipType.tonal,
                icon: Icons.account_tree_outlined,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeExample() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Code Example', style: AppTypography.titleMedium),
        const SizedBox(height: AppSpacing.xs),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E), // Classic code editor dark
            borderRadius: BorderRadius.circular(8),
          ),
          child: SelectableText(
            component.codeExample,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 14,
              color: Color(0xFFD4D4D4),
            ),
          ),
        ),
      ],
    );
  }
}
