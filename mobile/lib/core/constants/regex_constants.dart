/// Shared Regular Expressions used for validation and parsing.
class RegexConstants {
  RegexConstants._();

  static final RegExp email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static final RegExp hasUppercase = RegExp(r'[A-Z]');

  static final RegExp hasLowercase = RegExp(r'[a-z]');

  static final RegExp hasNumber = RegExp(r'[0-9]');

  static final RegExp hasSpecialCharacter = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

  static final RegExp url = RegExp(
    r'^https?:\/\/(?:www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b(?:[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)$',
  );

  static final RegExp numericOnly = RegExp(r'^[0-9]+$');

  static final RegExp alphaNumeric = RegExp(r'^[a-zA-Z0-9]+$');

  // Custom Investigation Code (e.g. FS-1234)
  static final RegExp investigationCode = RegExp(r'^FS-[0-9]{4}$');
}
