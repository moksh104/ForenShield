import 'package:flutter/material.dart';
import '../../domain/entities/feature_entity.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/theme/app_spacing.dart';

/// A reusable card component for displaying a [FeatureEntity].
class FeatureCard extends StatelessWidget {
  final FeatureEntity entity;

  const FeatureCard({super.key, required this.entity});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(entity.name, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              entity.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
}
