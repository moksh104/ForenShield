import 'package:flutter/material.dart';
import '../theme/app_spacing.dart';
import '../theme/app_motion.dart';
import '../theme/foren_theme.dart';
import 'app_text_field.dart';

/// A specialized text field for entering passwords securely.
class PasswordField extends StatefulWidget {
  final String? label;
  final String? hint;
  final String? helperText;
  final bool enabled;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final bool showStrengthIndicator;
  final double? strength; // 0.0 to 1.0
  final List<String> requirements;

  const PasswordField({
    super.key,
    this.label = 'Password',
    this.hint = 'Enter your password',
    this.helperText,
    this.enabled = true,
    this.controller,
    this.focusNode,
    this.validator,
    this.onChanged,
    this.onSubmitted,
    this.showStrengthIndicator = false,
    this.strength,
    this.requirements = const [],
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AppTextField(
          label: widget.label,
          hint: widget.hint,
          helperText: widget.helperText,
          enabled: widget.enabled,
          controller: widget.controller,
          focusNode: widget.focusNode,
          validator: widget.validator,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          obscureText: _obscureText,
          keyboardType: TextInputType.visiblePassword,
          maxLines: 1,
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureText
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: foren.textSecondary,
            ),
            onPressed: widget.enabled ? _toggleVisibility : null,
            splashRadius: 24,
          ),
        ),
        if (widget.showStrengthIndicator || widget.requirements.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: AppSpacing.sm),
            child: _buildStrengthAndRequirements(theme, foren),
          ),
      ],
    );
  }

  Widget _buildStrengthAndRequirements(ThemeData theme, ForenColors foren) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showStrengthIndicator && widget.strength != null) ...[
          _buildStrengthBar(foren, widget.strength!),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (widget.requirements.isNotEmpty)
          ...widget.requirements.map(
            (req) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
              child: Row(
                children: [
                  Icon(Icons.circle, size: 4, color: foren.textSecondary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      req,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: foren.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStrengthBar(ForenColors foren, double strength) {
    Color color;
    if (strength < 0.33) {
      color = foren.critical.t500;
    } else if (strength < 0.66) {
      color = foren.warning.t500;
    } else {
      color = foren.success.t500;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          height: 4,
          width: constraints.maxWidth,
          decoration: BoxDecoration(
            color: foren.surfaceRaised1,
            borderRadius: BorderRadius.circular(2),
          ),
          child: AnimatedContainer(
            duration: AppMotion.fast,
            curve: AppMotion.standard,
            alignment: Alignment.centerLeft,
            child: Container(
              width: constraints.maxWidth * strength.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      },
    );
  }
}
