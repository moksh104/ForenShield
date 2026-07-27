import 'package:equatable/equatable.dart';

/// A Domain-Driven Design Value Object representing a validated UUIDv4.
class Uuid extends Equatable {
  final String value;

  static final RegExp _uuidRegExp = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$',
  );

  const Uuid._(this.value);

  /// Creates a Uuid object. Throws [ArgumentError] if it is not a valid UUIDv4.
  factory Uuid(String input) {
    final cleanInput = input.trim();
    if (!_uuidRegExp.hasMatch(cleanInput)) {
      throw ArgumentError('Invalid UUIDv4 format');
    }
    return Uuid._(cleanInput.toLowerCase());
  }

  /// Attempts to create a Uuid object. Returns null if invalid.
  static Uuid? tryParse(String input) {
    try {
      return Uuid(input);
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [value];

  @override
  String toString() => value;
}
