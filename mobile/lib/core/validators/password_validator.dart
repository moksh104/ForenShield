import 'app_validator.dart';
import '../constants/regex_constants.dart';
import '../constants/validation_constants.dart';

/// Validates that a password meets complexity requirements.
class PasswordValidator extends AppValidator<String> {
  final int minLength;

  const PasswordValidator({
    this.minLength = ValidationConstants.minPasswordLength,
  });

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Let RequiredValidator handle empty
    }

    if (value.length < minLength) {
      return 'Must be at least $minLength characters';
    }
    if (!RegexConstants.hasUppercase.hasMatch(value)) {
      return 'Must contain an uppercase letter';
    }
    if (!RegexConstants.hasLowercase.hasMatch(value)) {
      return 'Must contain a lowercase letter';
    }
    if (!RegexConstants.hasNumber.hasMatch(value)) {
      return 'Must contain a number';
    }
    return null;
  }
}
