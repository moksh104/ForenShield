/// A mixin that enforces resource cleanup boundaries outside of standard Flutter widgets.
/// Ideal for ViewModels, Blocs, or complex Notifiers.
mixin DisposableMixin {
  bool _isDisposed = false;

  bool get isDisposed => _isDisposed;

  /// Marks this object as disposed and triggers the subclass cleanup.
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    onDispose();
  }

  /// Subclasses must implement this to clean up resources (e.g. Streams, Controllers).
  void onDispose();
}
