/// Forces a model to support serialization to and from JSON.
/// `<T>` is the type of the implementing class.
abstract interface class Serializable<T> {
  Map<String, dynamic> toJson();
  // Note: Dart interfaces cannot enforce static fromJson methods,
  // but implementing this signifies the class handles JSON gracefully.
}
