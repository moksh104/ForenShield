import 'app_validator.dart';
import 'email_validator.dart';
import 'password_validator.dart';

/// Aggregates all authentication-related validators.
class AuthValidator {
  AuthValidator._();

  static String? email(String? value) {
    return const MultiValidator([
      RequiredValidator(errorText: 'Email is required'),
      EmailValidator(),
    ]).validate(value);
  }

  static String? password(String? value) {
    return const MultiValidator([
      RequiredValidator(errorText: 'Password is required'),
      PasswordValidator(),
    ]).validate(value);
  }

  static String? confirmPassword(String? value, String original) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != original) {
      return 'Passwords do not match';
    }
    return null;
  }

  static String? username(String? value) {
    return const RequiredValidator(
      errorText: 'Username is required',
    ).validate(value);
  }
}
