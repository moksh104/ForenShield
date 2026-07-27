import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;

/// Safe platform checks that don't crash when running on Web.
class AppPlatformUtils {
  AppPlatformUtils._();

  static bool get isWeb => kIsWeb;

  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  static bool get isIOS => !kIsWeb && Platform.isIOS;

  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  static bool get isWindows => !kIsWeb && Platform.isWindows;

  static bool get isLinux => !kIsWeb && Platform.isLinux;

  static bool get isDesktop => isMacOS || isWindows || isLinux;

  static bool get isMobile => isAndroid || isIOS;
}
