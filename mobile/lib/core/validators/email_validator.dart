import 'app_validator.dart';
import '../constants/regex_constants.dart';

/// Validates email addresses using standard regular expressions.
class EmailValidator extends AppValidator<String> {
  const EmailValidator();

  @override
  String? validate(String? value) {
    if (value == null || value.isEmpty) return null;

    if (!RegexConstants.email.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
