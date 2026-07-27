/// Formats standard durations into human-readable chronometer or text strings.
extension DurationExtension on Duration {
  /// Formats the duration into `MM:SS` (e.g., "05:30").
  /// Useful for video players, audio bars, or countdowns.
  String toMmSs() {
    final minutes = inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  /// Formats the duration into `HH:MM:SS` if it exceeds an hour, otherwise `MM:SS`.
  String toHhMmSs() {
    if (inHours == 0) return toMmSs();
    final hours = inHours.toString().padLeft(2, '0');
    return '$hours:${toMmSs()}';
  }
}
