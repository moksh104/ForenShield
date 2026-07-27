import 'package:equatable/equatable.dart';

/// A Domain-Driven Design Value Object representing a validated Phone number.
class Phone extends Equatable {
  final String value;

  // Basic E.164-ish validation allowing optional +, spaces, hyphens and digits.
  static final RegExp _phoneRegExp = RegExp(r'^\+?[0-9\s\-()]{7,15}$');

  const Phone._(this.value);

  /// Creates a Phone object. Throws [ArgumentError] if the format is invalid.
  factory Phone(String input) {
    final cleanInput = input.trim();
    if (!_phoneRegExp.hasMatch(cleanInput)) {
      throw ArgumentError('Invalid phone number format');
    }

    // Normalize string: keep only + and digits for internal representation.
    final normalized = cleanInput.replaceAll(RegExp(r'[^\+0-9]'), '');
    return Phone._(normalized);
  }

  /// Attempts to create a Phone object. Returns null if invalid.
  static Phone? tryParse(String input) {
    try {
      return Phone(input);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}
