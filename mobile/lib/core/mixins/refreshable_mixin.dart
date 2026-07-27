/// A mixin that enforces a standard contract for refreshable data sources.
mixin RefreshableMixin {
  /// Triggers a hard refresh of the underlying data.
  Future<void> refresh();
}
