import 'package:equatable/equatable.dart';

/// A Domain-Driven Design Value Object representing a validated Password.
class Password extends Equatable {
  final String value;

  const Password._(this.value);

  /// Creates a Password object. Throws [ArgumentError] if the format is insecure.
  factory Password(String input, {int minLength = 8}) {
    if (input.length < minLength) {
      throw ArgumentError('Password must be at least $minLength characters');
    }
    if (!input.contains(RegExp(r'[A-Z]'))) {
      throw ArgumentError(
        'Password must contain at least one uppercase letter',
      );
    }
    if (!input.contains(RegExp(r'[0-9]'))) {
      throw ArgumentError('Password must contain at least one number');
    }
    return Password._(input);
  }

  /// Determines if a password string meets security constraints without throwing.
  static bool isValid(String input, {int minLength = 8}) {
    try {
      Password(input, minLength: minLength);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  List<Object?> get props => [value];

  /// Obfuscates the password output to prevent accidental logging.
  @override
  String toString() => '********';
}
