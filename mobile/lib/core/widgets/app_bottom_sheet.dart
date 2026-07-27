import 'package:flutter/material.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/foren_theme.dart';

class AppBottomSheet {
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isScrollControlled = false,
  }) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: foren.surfaceRaised1,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.xl),
            ),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: AppSpacing.sm),
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: foren.borderSubtle,
                    borderRadius: AppRadius.borderRadiusCircular,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (isScrollControlled) Flexible(child: child) else child,
              ],
            ),
          ),
        );
      },
    );
  }
}
