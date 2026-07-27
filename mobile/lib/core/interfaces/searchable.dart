/// Allows an entity to evaluate if it matches a given search query.
abstract interface class Searchable {
  /// Returns true if the entity's properties match the [query].
  bool matchesSearch(String query);
}
