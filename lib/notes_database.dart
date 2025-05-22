import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'note.dart';

class NotesDatabase {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'notes.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            category TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }

  static Future<void> insertNote(Note note) async {
    final db = await database;
    await db.insert('notes', note.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<List<Note>> getNotes({String? category, String? searchQuery}) async {
    final db = await database;
    String whereString = '';
    List<dynamic> whereArgs = [];

    if ((category != null && category != 'All') || (searchQuery != null && searchQuery.isNotEmpty)) {
      if (category != null && category != 'All') {
        whereString += 'category = ?';
        whereArgs.add(category);
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        if (whereString.isNotEmpty) whereString += ' AND ';
        whereString += '(title LIKE ? OR content LIKE ?)';
        whereArgs.addAll(['%$searchQuery%', '%$searchQuery%']);
      }
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: whereString.isEmpty ? null : whereString,
      whereArgs: whereArgs,
    );

    return List.generate(maps.length, (i) {
      return Note.fromMap(maps[i]);
    });
  }

  static Future<void> deleteNote(int id) async {
    final db = await database;
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  static Future<void> updateNote(Note note) async {
    final db = await database;
    await db.update('notes', note.toMap(), where: 'id = ?', whereArgs: [note.id]);
  }
}
