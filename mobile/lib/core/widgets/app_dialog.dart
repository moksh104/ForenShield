import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_radius.dart';
import 'app_button.dart';

class AppDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required Widget content,
    String? primaryActionLabel,
    VoidCallback? onPrimaryAction,
    String? secondaryActionLabel,
    VoidCallback? onSecondaryAction,
  }) {
    final theme = Theme.of(context);
    return showDialog<T>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusLg,
          ),
          backgroundColor: theme.colorScheme.surface,
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(title, style: theme.textTheme.headlineSmall),
                const SizedBox(height: AppSpacing.md),
                content,
                const SizedBox(height: AppSpacing.xl),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (secondaryActionLabel != null) ...[
                      AppButton(
                        text: secondaryActionLabel,
                        type: AppButtonType.tertiary,
                        onPressed:
                            onSecondaryAction ??
                            () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    if (primaryActionLabel != null)
                      AppButton(
                        text: primaryActionLabel,
                        type: AppButtonType.primary,
                        onPressed:
                            onPrimaryAction ??
                            () => Navigator.of(context).pop(),
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
