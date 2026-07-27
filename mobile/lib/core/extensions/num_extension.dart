import 'package:flutter/material.dart';

/// Spacing and formatting shortcuts for numerical values.
extension NumExtension on num {
  /// Returns a SizedBox with width corresponding to this number.
  SizedBox get w => SizedBox(width: toDouble());

  /// Returns a SizedBox with height corresponding to this number.
  SizedBox get h => SizedBox(height: toDouble());

  /// Formats bytes into a human-readable file size (e.g., 2.5 MB).
  String toFileSize() {
    if (this <= 0) return '0 B';
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var value = toDouble();
    int suffixIndex = 0;
    while (value >= 1024 && suffixIndex < suffixes.length - 1) {
      value /= 1024;
      suffixIndex++;
    }
    return '${value.toStringAsFixed(1)} ${suffixes[suffixIndex]}';
  }
}
