import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

/// A Riverpod ProviderObserver that logs state transitions in debug mode.
class AppObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      debugPrint(
        '[Riverpod] ${provider.name ?? provider.runtimeType}\n'
        '  old: $previousValue\n'
        '  new: $newValue',
      );
    }
  }

  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      debugPrint(
        '[Riverpod Add] ${provider.name ?? provider.runtimeType} -> $value',
      );
    }
  }

  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      debugPrint('[Riverpod Dispose] ${provider.name ?? provider.runtimeType}');
    }
  }
}
