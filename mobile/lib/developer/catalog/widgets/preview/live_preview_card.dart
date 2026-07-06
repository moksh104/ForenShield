import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/component_definition.dart';
import '../../providers/playground_state_provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_spacing.dart';
import '../../../../../core/theme/app_radius.dart';

/// Hosts the Live Preview, passing the active state map to the component's builder.
/// Includes a local light/dark theme toggle that only affects the preview box.
class LivePreviewCard extends ConsumerStatefulWidget {
  final ComponentDefinition component;

  const LivePreviewCard({super.key, required this.component});

  @override
  ConsumerState<LivePreviewCard> createState() => _LivePreviewCardState();
}

class _LivePreviewCardState extends ConsumerState<LivePreviewCard> {
  bool _isDark = true; // ForenShield defaults to dark

  @override
  Widget build(BuildContext context) {
    final activeState = ref.watch(playgroundStateProvider(widget.component.name));

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.borderLg,
        border: Border.all(color: AppColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.outline)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Live Preview', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textSecondary)),
                IconButton(
                  icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode, size: 20),
                  tooltip: 'Toggle Preview Theme',
                  onPressed: () => setState(() => _isDark = !_isDark),
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
          
          // Preview Area
          Container(
            padding: const EdgeInsets.all(AppSpacing.xxl),
            decoration: BoxDecoration(
              color: _isDark ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
            ),
            alignment: Alignment.center,
            // Override the theme locally for this specific preview box
            child: Theme(
              data: _isDark ? ThemeData.dark() : ThemeData.light(),
              child: widget.component.builder(context, activeState),
            ),
          ),
        ],
      ),
    );
  }
}
