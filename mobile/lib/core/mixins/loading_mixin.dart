import 'package:flutter/material.dart';

/// A mixin that adds local loading state management to StatefulWidgets or Notifiers.
mixin LoadingMixin<T extends StatefulWidget> on State<T> {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  /// Sets the loading state and safely triggers a rebuild.
  void setLoading(bool loading) {
    if (!mounted) return;
    if (_isLoading != loading) {
      setState(() {
        _isLoading = loading;
      });
    }
  }

  /// Executes an asynchronous [action] while automatically managing the loading state.
  Future<R> runWithLoading<R>(Future<R> Function() action) async {
    setLoading(true);
    try {
      return await action();
    } finally {
      setLoading(false);
    }
  }
}
