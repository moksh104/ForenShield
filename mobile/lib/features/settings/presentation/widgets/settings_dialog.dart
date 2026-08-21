import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/foren_theme.dart';

/// Collection of reusable Material 3 settings dialogs.
class SettingsDialog {
  SettingsDialog._();

  /// Shows confirmation dialog with custom title, content, and actions.
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(
            color: isDestructive
                ? foren.critical.t300.withValues(alpha: 0.5)
                : foren.borderDefault,
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(color: foren.textSecondary, fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              cancelText,
              style: TextStyle(color: foren.textSecondary),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: isDestructive
                  ? foren.critical.t500
                  : theme.colorScheme.primary,
              foregroundColor: isDestructive
                  ? Colors.white
                  : theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Shows Single Select Option Dialog (for Theme, Session Timeout, Language, etc.).
  static Future<T?> showOptionPicker<T>({
    required BuildContext context,
    required String title,
    required List<Map<String, dynamic>> options,
    required T currentValue,
  }) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;

    return showDialog<T>(
      context: context,
      builder: (ctx) => SimpleDialog(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.card),
          side: BorderSide(color: foren.borderDefault),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        children: options.map((opt) {
          final label = opt['label'] as String;
          final value = opt['value'] as T;
          final subtitle = opt['subtitle'] as String?;
          final isSelected = value == currentValue;

          return SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, value),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: TextStyle(
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                            fontSize: 14,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              color: foren.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: theme.colorScheme.primary,
                      size: 20,
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  /// Shows Slider Picker for Font Scaling.
  static Future<double?> showFontScalePicker({
    required BuildContext context,
    required double currentScale,
  }) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>() ?? ForenColors.dark;
    double selected = currentScale;

    return showDialog<double>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.card),
            side: BorderSide(color: foren.borderDefault),
          ),
          title: Text(
            'Font Scaling',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Adjust relative text scaling for the application:',
                style: TextStyle(color: foren.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Sample Text (${(selected * 100).toInt()}%)',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 16 * selected,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Slider(
                value: selected,
                min: 0.8,
                max: 1.4,
                divisions: 6,
                label: '${(selected * 100).toInt()}%',
                activeColor: theme.colorScheme.primary,
                onChanged: (val) {
                  setState(
                    () => selected = double.parse(val.toStringAsFixed(2)),
                  );
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: Text(
                'Cancel',
                style: TextStyle(color: foren.textSecondary),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
              ),
              onPressed: () => Navigator.pop(ctx, selected),
              child: const Text('Apply'),
            ),
          ],
        ),
      ),
    );
  }
}
