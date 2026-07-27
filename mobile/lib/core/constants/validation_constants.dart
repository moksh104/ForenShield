/// Standardized validation lengths and thresholds used across the app.
class ValidationConstants {
  ValidationConstants._();

  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;

  static const int minUsernameLength = 3;
  static const int maxUsernameLength = 32;

  static const int maxEmailLength = 255;

  static const int minPhoneLength = 7;
  static const int maxPhoneLength = 15;

  static const int otpLength = 6;
}
