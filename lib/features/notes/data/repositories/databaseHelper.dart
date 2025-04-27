import 'package:notatnik/features/notes/domain/entities/note.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:notatnik/features/notes/domain/repositories/notesRepository.dart';

class DatabaseHelper implements NotesRepository{
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  @override
  Future<void> addNote(Note newNote) async {
    final db = await database;
    await db.insert('notes', newNote.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  @override
  Future<void> removeNote(String id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<void> editNote(Note note, String id, String newTitle, String newContent) async {
    final db = await database;
    await db.update('notes', note.copyWith(title: newTitle, content: newContent, modifyTime: DateTime.now()).toMap(), where: 'id = ?', whereArgs: [note.id]);
  }

  @override
  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final notesData = await db.query('notes', orderBy: 'createTime DESC');
    return notesData.map((note) => Note.fromMap(note)).toList();
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE notes(
      idi INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      id TEXT NOT NULL,
      content TEXT NOT NULL,
      createTime TEXT NOT NULL,
      modifyTime TEXT NOT NULL
      )

      ''');
  }
}
