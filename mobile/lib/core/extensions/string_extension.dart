/// Safely manipulate and query strings across the application.
extension StringExtension on String {
  /// Capitalizes the first letter of the string.
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitalizes the first letter of each word in a string.
  String titleCase() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Limits the string to [maxLength] characters, appending an ellipsis if truncated.
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }

  /// Evaluates whether the string is a valid integer.
  bool get isNumeric {
    if (isEmpty) return false;
    return int.tryParse(this) != null;
  }

  /// Returns true if the string is empty or contains only whitespace.
  bool get isBlank => trim().isEmpty;

  /// Returns true if the string contains non-whitespace characters.
  bool get isNotBlank => !isBlank;
}

/// Null-safe extension on nullable strings.
extension NullableStringExtension on String? {
  /// Returns the string, or an empty string if null.
  String get orEmpty => this ?? '';
}
