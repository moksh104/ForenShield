import 'package:flutter/material.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/foren_theme.dart';

/// A clean full-width button for authentication forms.
class AuthButton extends StatefulWidget {
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
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    if (widget.isOutlined) {
      return _OutlinedVariant(
        label: widget.label,
        onPressed: widget.onPressed,
        isLoading: widget.isLoading,
      );
    }

    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: isEnabled
          ? (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.98 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOutCirc,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: isEnabled ? AppGradients.brand : null,
              color: !isEnabled ? foren.surfaceRaised1 : null,
              borderRadius: AppRadius.borderRadiusMd,
            ),
            child: ElevatedButton(
              onPressed: widget.isLoading ? null : widget.onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: AppRadius.borderRadiusMd,
                ),
                padding: EdgeInsets.zero,
              ),
              child: widget.isLoading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            color: theme.scaffoldBackgroundColor,
                            strokeWidth: 2.5,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Signing in...',
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: theme.scaffoldBackgroundColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      widget.label,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isEnabled
                            ? theme.scaffoldBackgroundColor
                            : foren.textDisabled,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlinedVariant extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  const _OutlinedVariant({
    required this.label,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  State<_OutlinedVariant> createState() => _OutlinedVariantState();
}

class _OutlinedVariantState extends State<_OutlinedVariant> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.transparent,
          side: BorderSide(color: foren.borderSubtle.withValues(alpha: 0.7)),
          shape: const RoundedRectangleBorder(
            borderRadius: AppRadius.borderRadiusMd,
          ),
        ),
        child: widget.isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: foren.textSecondary,
                  strokeWidth: 2.5,
                ),
              )
            : Text(
                widget.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }
}
