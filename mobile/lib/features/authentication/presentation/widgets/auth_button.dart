import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/effects/glow_effect.dart';
import '../../../../core/theme/app_gradients.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/foren_theme.dart';

/// A premium animated full-width button with hover & glow effects for authentication forms.
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
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    if (widget.isOutlined) {
      return _OutlinedVariant(
        label: widget.label,
        onPressed: widget.onPressed,
        isLoading: widget.isLoading,
      );
    }

    final isEnabled = widget.onPressed != null && !widget.isLoading;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, _isHovered && isEnabled ? -2 : 0, 0),
        child: GlowEffect(
          glowColor: primaryColor,
          blurRadius: _isHovered && isEnabled ? 16.0 : 8.0,
          spreadRadius: _isHovered && isEnabled ? 2.0 : 0.0,
          animate: _isHovered && isEnabled,
          borderRadius: AppRadius.borderRadiusMd,
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
                    ? Shimmer.fromColors(
                        baseColor: theme.scaffoldBackgroundColor,
                        highlightColor: primaryColor,
                        child: Row(
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
                              'AUTHENTICATING...',
                              style: TextStyle(
                                color: theme.scaffoldBackgroundColor,
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                fontFamily: 'monospace',
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Text(
                        widget.label,
                        style: TextStyle(
                          color: isEnabled
                              ? theme.scaffoldBackgroundColor
                              : foren.textDisabled,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
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
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        transform: Matrix4.translationValues(0, _isHovered ? -2 : 0, 0),
        width: double.infinity,
        height: 52,
        child: OutlinedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: OutlinedButton.styleFrom(
            backgroundColor: _isHovered
                ? primaryColor.withValues(alpha: 0.1)
                : Colors.transparent,
            side: BorderSide(
              color: _isHovered
                  ? primaryColor
                  : foren.borderSubtle.withValues(alpha: 0.7),
              width: _isHovered ? 1.5 : 1.0,
            ),
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
                  style: TextStyle(
                    color: _isHovered ? primaryColor : foren.textSecondary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }
}
