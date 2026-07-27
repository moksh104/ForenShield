/// Null-safe operators for iterables and lists.
extension IterableExtension<T> on Iterable<T> {
  /// Safely returns the first element, or null if the iterable is empty.
  T? get firstOrNull => isEmpty ? null : first;

  /// Safely returns the last element, or null if the iterable is empty.
  T? get lastOrNull => isEmpty ? null : last;

  /// Maps each element along with its index.
  Iterable<R> mapIndexed<R>(R Function(int index, T item) mapper) sync* {
    var index = 0;
    for (final item in this) {
      yield mapper(index++, item);
    }
  }

  /// Separates elements using a builder function.
  /// Highly useful for injecting dividers or padding between widgets in a Row/Column.
  Iterable<T> separateWith(T Function(int index) separatorBuilder) sync* {
    var index = 0;
    final iterator = this.iterator;
    if (iterator.moveNext()) {
      yield iterator.current;
      while (iterator.moveNext()) {
        yield separatorBuilder(index++);
        yield iterator.current;
      }
    }
  }
}
