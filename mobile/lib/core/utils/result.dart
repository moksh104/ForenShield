/// A discriminated union that represents a successful result with a value of type [T]
/// or a failure with an [Exception].
sealed class Result<T> {
  const Result();

  /// Execute a callback based on the outcome.
  R when<R>({
    required R Function(T data) success,
    required R Function(Exception exception) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else if (this is Failure<T>) {
      return failure((this as Failure<T>).exception);
    }
    throw StateError('Invalid Result state');
  }

  /// Optional helper for checking success
  bool get isSuccess => this is Success<T>;

  /// Optional helper for checking failure
  bool get isFailure => this is Failure<T>;
}

/// Represents a successful result.
class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);
}

/// Represents a failed result.
class Failure<T> extends Result<T> {
  final Exception exception;

  const Failure(this.exception);
}
