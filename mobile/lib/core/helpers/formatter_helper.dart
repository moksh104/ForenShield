import 'package:flutter/services.dart';

/// Custom TextInputFormatters for UI Input.
class FormatterHelper {
  FormatterHelper._();

  /// Forces all input to be strictly uppercase.
  static final TextInputFormatter uppercase = TextInputFormatter.withFunction(
    (oldValue, newValue) => TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    ),
  );

  /// Forces all input to be strictly lowercase.
  static final TextInputFormatter lowercase = TextInputFormatter.withFunction(
    (oldValue, newValue) => TextEditingValue(
      text: newValue.text.toLowerCase(),
      selection: newValue.selection,
    ),
  );

  /// Restricts input to only numbers.
  static final TextInputFormatter numericOnly =
      FilteringTextInputFormatter.digitsOnly;
}
