

import 'package:notatnik/features/notes/domain/entities/note.dart';

abstract class NotesRepository {
  Future<void> addNote(Note newNote);
  Future<void> removeNote(String id);
  Future<List<Note>> getAllNotes();
  Future<void> editNote(Note note, String id, String newTitle, String newContent);
}