import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/component_definition.dart';
import '../../providers/playground_state_provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_spacing.dart';

/// Renders dynamic property controls for the interactive Live Playground.
class PlaygroundControls extends ConsumerWidget {
  final ComponentDefinition component;

  const PlaygroundControls({super.key, required this.component});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (component.properties.isEmpty) {
      return const SizedBox.shrink();
    }

    final activeState = ref.watch(playgroundStateProvider(component.name));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Text('Interactive Controls', style: AppTypography.titleMedium),
        ),
        ...component.properties.map((prop) {
          final currentValue = activeState[prop.name] ?? prop.defaultValue;

          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Row(
              children: [
                SizedBox(
                  width: 140,
                  child: Text(
                    prop.name,
                    style: AppTypography.labelMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ),
                Expanded(child: _buildControl(ref, prop, currentValue, component.name)),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildControl(WidgetRef ref, ComponentProperty prop, dynamic currentValue, String componentName) {
    switch (prop.type) {
      case PropertyType.boolean:
        return Switch(
          value: currentValue as bool,
          onChanged: (val) {
            ref.read(playgroundStateProvider(componentName).notifier).updateProperty(prop.name, val);
          },
          activeColor: AppColors.primary,
        );
      case PropertyType.string:
        return TextField(
          controller: TextEditingController(text: currentValue as String)
            ..selection = TextSelection.collapsed(offset: (currentValue as String).length),
          onChanged: (val) {
            ref.read(playgroundStateProvider(componentName).notifier).updateProperty(prop.name, val);
          },
          decoration: const InputDecoration(
            isDense: true,
            border: OutlineInputBorder(),
            contentPadding: EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
          ),
          style: AppTypography.bodyMedium,
        );
      case PropertyType.number:
        return Slider(
          value: currentValue is double ? currentValue : (currentValue as num).toDouble(),
          min: 0,
          max: (currentValue is double && currentValue > 100) ? 5000 : 100, // naive scaling for demo
          onChanged: (val) {
            ref.read(playgroundStateProvider(componentName).notifier).updateProperty(prop.name, val);
          },
          activeColor: AppColors.primary,
        );
      case PropertyType.selection:
        return DropdownButton<dynamic>(
          value: currentValue,
          isExpanded: true,
          items: prop.options!.map((opt) {
            return DropdownMenuItem(
              value: opt,
              child: Text(opt.toString().split('.').last),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) {
              ref.read(playgroundStateProvider(componentName).notifier).updateProperty(prop.name, val);
            }
          },
        );
    }
    return const SizedBox();
  }
}
