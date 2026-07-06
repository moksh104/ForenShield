import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Manages the active deep search query across the catalog.
final catalogSearchQueryProvider = StateProvider<String>((ref) => '');
