import 'package:flutter/material.dart';
import '../../domain/entities/feature_entity.dart';

/// A compact list tile for displaying a [FeatureEntity].
class FeatureTile extends StatelessWidget {
  final FeatureEntity entity;
  final VoidCallback? onTap;

  const FeatureTile({super.key, required this.entity, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(entity.name),
      subtitle: Text(entity.description),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
