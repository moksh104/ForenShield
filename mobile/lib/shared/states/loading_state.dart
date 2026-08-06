import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import 'skeleton_state.dart';

/// Reusable generic LoadingState widget.
/// Displays a progress spinner or optional shimmer skeleton loader.
class LoadingState extends StatelessWidget {
  final String? message;
  final bool useSkeleton;
  final double? width;
  final double? height;
  final Color? color;

  const LoadingState({
    super.key,
    this.message,
    this.useSkeleton = false,
    this.width,
    this.height,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    if (useSkeleton) {
      return SkeletonState.card(
        width: width ?? double.infinity,
        height: height ?? 160.0,
      );
    }

    final spinnerColor = color ?? AppColors.primary;

    return Center(
      child: Padding(
        padding: AppSpacing.pagePadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surfaceHighlight,
                borderRadius: AppRadius.cardRadius,
              ),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
                strokeWidth: 3,
              ),
            ),
            if (message != null) ...[
              const SizedBox(height: AppSpacing.md),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
