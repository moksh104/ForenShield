import 'package:equatable/equatable.dart';

/// Represents metadata for paginated results (e.g., current page, total pages).
class Pagination extends Equatable {
  /// The current page number.
  final int currentPage;

  /// The total number of pages available.
  final int totalPages;

  /// The number of items per page.
  final int itemsPerPage;

  /// The absolute total number of items across all pages.
  final int totalItems;

  const Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.itemsPerPage,
    required this.totalItems,
  });

  /// Parses [Pagination] from a JSON map.
  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'] as int? ?? 1,
      totalPages: json['total_pages'] as int? ?? 1,
      itemsPerPage: json['items_per_page'] as int? ?? 10,
      totalItems: json['total_items'] as int? ?? 0,
    );
  }

  /// Converts [Pagination] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'total_pages': totalPages,
      'items_per_page': itemsPerPage,
      'total_items': totalItems,
    };
  }

  /// Creates a copy of this [Pagination] with given fields replaced.
  Pagination copyWith({
    int? currentPage,
    int? totalPages,
    int? itemsPerPage,
    int? totalItems,
  }) {
    return Pagination(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      itemsPerPage: itemsPerPage ?? this.itemsPerPage,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  /// Checks if there is a next page available.
  bool get hasNextPage => currentPage < totalPages;

  @override
  List<Object?> get props => [
    currentPage,
    totalPages,
    itemsPerPage,
    totalItems,
  ];
}
