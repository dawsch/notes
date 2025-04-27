import 'package:notatnik/features/notes/domain/entities/note.dart';
import 'package:notatnik/features/notes/domain/repositories/notesRepository.dart';

class AddNoteUseCase {
  final NotesRepository repository;

  AddNoteUseCase(this.repository);

  Future<void> execute(Note note) {
    return repository.addNote(note);
  }
}

class GetAllNotesUseCase {
  final NotesRepository repository;

  GetAllNotesUseCase(this.repository);

  Future<List<Note>> execute() {
    return repository.getAllNotes();
  }
}

class EditNoteUseCase {
  final NotesRepository repository;

  EditNoteUseCase(this.repository);

  Future<void> execute(Note note, String id, String newTitle, String newContent) {
    return repository.editNote(note, id, newTitle, newContent);
  }
}

class DeleteNoteUseCase {
  final NotesRepository repository;

  DeleteNoteUseCase(this.repository);

  Future<void> execute(String id) {
    return repository.removeNote(id);
  }
}

