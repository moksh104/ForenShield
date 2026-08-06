import 'package:equatable/equatable.dart';
import 'network/api_exception.dart';

/// Generic result wrapper used across repositories.
///
/// Use [Success] for successful results and [Failure] for errors.
abstract class Result<T> extends Equatable {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  R when<R>({required R Function(T value) success, required R Function(ApiException error) failure}) {
    if (this is Success<T>) {
      return success((this as Success<T>).value);
    }
    return failure((this as Failure<T>).error);
  }

  @override
  List<Object?> get props => [];
}

/// Successful result
class Success<T> extends Result<T> {
  final T value;
  const Success(this.value);

  @override
  List<Object?> get props => [value];
}

/// Failure result with an [ApiException]
class Failure<T> extends Result<T> {
  final ApiException error;
  const Failure(this.error);

  @override
  List<Object?> get props => [error];
}
