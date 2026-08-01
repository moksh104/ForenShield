import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';

/// Generic Skeleton loader widget utilizing the shimmer package.
/// Supports card, text line, avatar, and custom shape skeleton loaders with dark theme support.
class SkeletonState extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final ShapeBorder shapeBorder;
  final Color? baseColor;
  final Color? highlightColor;

  const SkeletonState({
    super.key,
    this.width,
    this.height,
    this.borderRadius,
    this.shapeBorder = const RoundedRectangleBorder(),
    this.baseColor,
    this.highlightColor,
  });

  /// Factory for a text line skeleton placeholder
  factory SkeletonState.text({
    Key? key,
    double width = double.infinity,
    double height = 16.0,
  }) {
    return SkeletonState(
      key: key,
      width: width,
      height: height,
      borderRadius: BorderRadius.circular(AppRadius.xs),
    );
  }

  /// Factory for a card skeleton placeholder
  factory SkeletonState.card({
    Key? key,
    double width = double.infinity,
    double height = 120.0,
  }) {
    return SkeletonState(
      key: key,
      width: width,
      height: height,
      borderRadius: AppRadius.cardRadius,
    );
  }

  /// Factory for a circular avatar skeleton placeholder
  factory SkeletonState.avatar({
    Key? key,
    double size = 48.0,
  }) {
    return SkeletonState(
      key: key,
      width: size,
      height: size,
      shapeBorder: const CircleBorder(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final defaultBaseColor = baseColor ??
        (isDark ? AppColors.surfaceHighlight : AppColors.borderSubtle);
    final defaultHighlightColor = highlightColor ??
        (isDark ? AppColors.surfaceElevated : AppColors.lightSurface);

    return Shimmer.fromColors(
      baseColor: defaultBaseColor,
      highlightColor: defaultHighlightColor,
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: defaultBaseColor,
          shape: borderRadius != null
              ? RoundedRectangleBorder(borderRadius: borderRadius!)
              : shapeBorder,
        ),
      ),
    );
  }
}

/// Generic List Skeleton Loader
class SkeletonListState extends StatelessWidget {
  final int itemCount;
  final double itemHeight;
  final EdgeInsets padding;

  const SkeletonListState({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80.0,
    this.padding = const EdgeInsets.all(AppSpacing.md),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      padding: padding,
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (_, _) => SkeletonState.card(height: itemHeight),
    );
  }
}
