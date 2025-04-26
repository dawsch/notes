import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notatnik/databaseHelper.dart';

final databaseProvider = StateProvider<DatabaseHelper>((ref) {
  return DatabaseHelper();
});