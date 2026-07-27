/// Ensures a domain model possesses a unique identifier.
abstract interface class Identifiable<T> {
  /// The unique identifier for this entity.
  T get id;
}
