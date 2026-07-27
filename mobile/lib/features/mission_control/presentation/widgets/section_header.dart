import 'package:flutter/material.dart';
import '../../../../core/theme/foren_theme.dart';

/// Reusable section header with optional trailing action.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              color: foren.textDisabled,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          if (actionLabel != null)
            InkWell(
              onTap: onActionTap,
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  actionLabel!,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
