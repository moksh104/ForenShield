import 'package:equatable/equatable.dart';
import 'pagination.dart';

/// A generic wrapper for paginated API responses.
class PaginatedResponse<T> extends Equatable {
  /// The list of items for the current page.
  final List<T> data;

  /// The pagination metadata.
  final Pagination pagination;

  const PaginatedResponse({required this.data, required this.pagination});

  /// Creates a new [PaginatedResponse] by parsing JSON.
  /// [fromJsonT] must be provided to parse individual items of type [T].
  factory PaginatedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic) fromJsonT,
  ) {
    return PaginatedResponse<T>(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((item) => fromJsonT(item))
              .toList() ??
          [],
      pagination: Pagination.fromJson(
        json['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  /// Converts the [PaginatedResponse] to JSON.
  Map<String, dynamic> toJson(dynamic Function(T) toJsonT) {
    return {
      'data': data.map((item) => toJsonT(item)).toList(),
      'pagination': pagination.toJson(),
    };
  }

  /// Creates a copy of this [PaginatedResponse] with given fields replaced.
  PaginatedResponse<T> copyWith({List<T>? data, Pagination? pagination}) {
    return PaginatedResponse<T>(
      data: data ?? this.data,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object?> get props => [data, pagination];
}
