/// Enforces the immutability pattern by requiring a copyWith method.
/// `<T>` is the type of the implementing class.
abstract interface class Copyable<T> {
  /// Returns a new instance of [T] with the specified fields replaced.
  T copyWith();
}
