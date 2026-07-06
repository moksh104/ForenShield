import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the currently active category filter in the catalog.
/// Null indicates "All Categories".
final catalogCategoryFilterProvider = StateProvider<String?>((ref) => null);
