import 'package:flutter/material.dart';
import '../../../../core/effects/glass_effect.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/foren_theme.dart';

/// Reusable 6-digit OTP Verification Field with clear focus states.
class AuthOtpField extends StatefulWidget {
  final int length;
  final ValueChanged<String>? onCompleted;

  const AuthOtpField({super.key, this.length = 6, this.onCompleted});

  @override
  State<AuthOtpField> createState() => _AuthOtpFieldState();
}

class _AuthOtpFieldState extends State<AuthOtpField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;
  int _focusedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _focusNodes = List.generate(widget.length, (index) {
      final node = FocusNode();
      node.addListener(() {
        if (node.hasFocus) {
          setState(() => _focusedIndex = index);
        }
      });
      return node;
    });
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _onChanged(int index, String value) {
    if (value.isNotEmpty) {
      if (index < widget.length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _checkComplete();
      }
    } else {
      if (index > 0) {
        _focusNodes[index - 1].requestFocus();
      }
    }
    setState(() {});
  }

  void _checkComplete() {
    final code = _controllers.map((c) => c.text).join();
    if (code.length == widget.length && widget.onCompleted != null) {
      widget.onCompleted!(code);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foren = theme.extension<ForenColors>()!;
    final primaryColor = theme.colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (index) {
        final isFocused = _focusedIndex == index && _focusNodes[index].hasFocus;
        final hasValue = _controllers[index].text.isNotEmpty;

        final Color borderColor = isFocused
            ? primaryColor
            : (hasValue
                  ? foren.success.t500
                  : foren.borderSubtle.withValues(alpha: 0.4));

        return SizedBox(
          width: 48,
          height: 56,
          child: GlassEffect(
            borderRadius: AppRadius.borderRadiusMd,
            border: Border.all(
              color: borderColor,
              width: isFocused || hasValue ? 1.5 : 1.0,
            ),
            child: Center(
              child: TextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: hasValue ? primaryColor : theme.colorScheme.onSurface,
                  fontWeight: FontWeight.w800,
                ),
                decoration: const InputDecoration(
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (val) => _onChanged(index, val),
              ),
            ),
          ),
        );
      }),
    );
  }
}
