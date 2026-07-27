import 'package:flutter/material.dart';

/// A mixin that manages infinite scrolling and pagination parameters.
mixin PaginationMixin<T extends StatefulWidget> on State<T> {
  int _currentPage = 1;
  final int pageSize = 20;
  bool _hasReachedMax = false;

  int get currentPage => _currentPage;
  bool get hasReachedMax => _hasReachedMax;

  /// Call this when new data is successfully fetched.
  void onDataFetched(int totalItemsFetched) {
    if (totalItemsFetched < pageSize) {
      _hasReachedMax = true;
    }
  }

  /// Increments the page count to fetch the next batch.
  void advancePage() {
    if (!_hasReachedMax) {
      _currentPage++;
    }
  }

  /// Resets the pagination state for a pull-to-refresh or new query.
  void resetPagination() {
    _currentPage = 1;
    _hasReachedMax = false;
  }
}
