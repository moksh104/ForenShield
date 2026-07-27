enum TerminalLineType { prompt, input, output, success, error, system }

class TerminalLine {
  final String text;
  final TerminalLineType type;
  final DateTime timestamp;

  const TerminalLine({
    required this.text,
    required this.type,
    required this.timestamp,
  });
}
