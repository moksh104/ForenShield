import 'package:equatable/equatable.dart';

/// A Domain-Driven Design Value Object representing a validated Email.
class Email extends Equatable {
  final String value;

  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  const Email._(this.value);

  /// Creates an Email object. Throws [ArgumentError] if the format is invalid.
  factory Email(String input) {
    final cleanInput = input.trim();
    if (!_emailRegExp.hasMatch(cleanInput)) {
      throw ArgumentError('Invalid email format');
    }
    return Email._(cleanInput);
  }

  /// Attempts to create an Email object. Returns null if invalid.
  static Email? tryParse(String input) {
    try {
      return Email(input);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}
