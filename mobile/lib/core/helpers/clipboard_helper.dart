import 'package:flutter/services.dart';

/// Simplifies interactions with the device clipboard.
class ClipboardHelper {
  ClipboardHelper._();

  /// Copies text to the system clipboard.
  static Future<void> copyText(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Retrieves the current text from the system clipboard. Returns null if empty.
  static Future<String?> pasteText() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }
}
