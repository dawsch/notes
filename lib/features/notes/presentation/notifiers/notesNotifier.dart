import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notatnik/features/notes/presentation/providers/databaseProvider.dart';
import 'package:notatnik/features/notes/domain/useCases/useCases.dart';
import 'package:notatnik/features/notes/presentation/providers/noreProviders.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/note.dart';

const uuid = Uuid();

class NotesNotifier extends StateNotifier<List<Note>> {
  final AddNoteUseCase addNoteUseCase;
  final GetAllNotesUseCase getAllNotesUseCase;
  final EditNoteUseCase editNoteUseCase;
  final DeleteNoteUseCase deleteNoteUseCase;

  NotesNotifier(this.addNoteUseCase, this.deleteNoteUseCase, this.editNoteUseCase, this.getAllNotesUseCase) : super([]){
    loadNotes();
  }


  // Dodawanie notatki
  void addNote(String title, String content) async{
    final newNote = Note(id: uuid.v4(), title: title, content: content, createTime: DateTime.now(), modifyTime: DateTime.now());
    state = [...state, newNote];

    addNoteUseCase.execute(newNote);
  }

  // Usuwanie notatki
  void removeNote(String id) async {
    state = state.where((note) => note.id != id).toList();

    deleteNoteUseCase.execute(id);
  }

  // Edycja notatki z copyWith()
  void editNote(String id, String newTitle, String newContent) async {
    for (Note note in state){
      if (note.id == id) {
        editNoteUseCase.execute(note, id, newTitle, newContent);
      }

    }
    state = state.map((note) {
      if (note.id == id) {
        note = note.copyWith(title: newTitle, content: newContent, modifyTime: DateTime.now());
      }
      return note;
    }).toList();

  }

  void loadNotes() async {
    state = await getAllNotesUseCase.execute();
  }
}

final notesNotifierProvider = StateNotifierProvider<NotesNotifier, List<Note>>((ref) {
  final getAllNotes = ref.read(getAllNotesUseCaseProvider);
  final addNote = ref.read(addNoteUseCaseProvider);
  final deleteNote = ref.read(deleteNoteUseCaseProvider);
  final editNote = ref.read(editNoteUseCaseProvider);
  return NotesNotifier(addNote, deleteNote, editNote, getAllNotes);
});
