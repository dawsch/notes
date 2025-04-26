import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notatnik/databaseProvider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import 'note.dart';

const uuid = Uuid();

class NotesNotifier extends StateNotifier<List<Note>> {
  NotesNotifier(this.ref) : super([]){
    loadNotes();
  }

  final Ref ref;


  // Dodawanie notatki
  void addNote(String title, String content) async{
    final newNote = Note(id: uuid.v4(), title: title, content: content, createTime: DateTime.now(), modifyTime: DateTime.now());
    state = [...state, newNote];

    final db = await ref.read(databaseProvider).database;
    await db.insert('notes', newNote.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    //loadNotes(); // Odśwież listę
  }

  // Usuwanie notatki
  void removeNote(String id) async {
    state = state.where((note) => note.id != id).toList();

    final db = await ref.read(databaseProvider).database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
    //loadNotes(); // Odśwież listę
  }

  // Edycja notatki z copyWith()
  void editNote(String id, String newTitle, String newContent) async {
    for (Note note in state){
      if (note.id == id) {
        final db = await ref.read(databaseProvider).database;
        await db.update('notes', note.copyWith(title: newTitle, content: newContent, modifyTime: DateTime.now()).toMap(), where: 'id = ?', whereArgs: [note.id]);

        note = note.copyWith(title: newTitle, content: newContent, modifyTime: DateTime.now());
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
    final db = await ref.read(databaseProvider).database;
    final notesData = await db.query('notes', orderBy: 'createTime DESC');
    state = notesData.map((note) => Note.fromMap(note)).toList();
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, List<Note>>(
  (ref) => NotesNotifier(ref),
);
