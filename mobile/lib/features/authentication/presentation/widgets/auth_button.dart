import 'package:flutter/material.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/foren_theme.dart';

/// A premium full-width button used on authentication screens.
class AuthButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;

  const AuthButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    if (isOutlined) {
      return _OutlinedVariant(
        label: label,
        onPressed: onPressed,
        isLoading: isLoading,
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: onPressed != null && !isLoading
              ? AppGradients.brand
              : null,
          color: onPressed == null || isLoading
              ? foren.surfaceRaised1
              : null,
          borderRadius: AppRadius.borderRadiusMd,
        ),
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: const RoundedRectangleBorder(
              borderRadius: AppRadius.borderRadiusMd,
            ),
            padding: EdgeInsets.zero,
          ),
          child: isLoading
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: theme.colorScheme.onSurface,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    color: onPressed != null
                        ? theme.scaffoldBackgroundColor
                        : foren.textDisabled,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }
}

class _OutlinedVariant extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _OutlinedVariant({
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: foren.borderSubtle.withValues(alpha: 0.7),
            width: 1,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: foren.textSecondary,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  color: foren.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }
}
