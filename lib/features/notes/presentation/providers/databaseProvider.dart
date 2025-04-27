import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notatnik/features/notes/data/repositories/databaseHelper.dart';
import 'package:notatnik/features/notes/domain/repositories/notesRepository.dart';

final databaseProvider = StateProvider<NotesRepository>((ref) {
  return DatabaseHelper();
});