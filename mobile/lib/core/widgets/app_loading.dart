import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/foren_theme.dart';

class AppLoading extends StatelessWidget {
  final String? message;
  final bool isOverlay;

  const AppLoading({super.key, this.message, this.isOverlay = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    Widget content = Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
        ),
        if (message != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            message!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: foren.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );

    if (isOverlay) {
      return Container(
        color: theme.scaffoldBackgroundColor.withValues(alpha: 0.7),
        alignment: Alignment.center,
        child: content,
      );
    }

    return Center(child: content);
  }
}
