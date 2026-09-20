import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('omni_search_fts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final Directory dbDir = await getApplicationDocumentsDirectory();
    final String path = join(dbDir.path, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Standard Metadata Table
    await db.execute('''
      CREATE TABLE files (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        path TEXT UNIQUE,
        name TEXT,
        extension TEXT,
        size INTEGER,
        last_modified INTEGER,
        mime_type TEXT
      )
    ''');

    // FTS5 Trigram Virtual Table for Instant Search
    await db.execute('''
      CREATE VIRTUAL TABLE files_fts USING fts5(
        name,
        path,
        content,
        tokenize = 'trigram'
      )
    ''');
  }

  Future<int> insertFile(Map<String, dynamic> row, String textContent) async {
    final db = await instance.database;
    final id = await db.insert('files', row, conflictAlgorithm: ConflictAlgorithm.replace);

    await db.insert('files_fts', {
      'name': row['name'],
      'path': row['path'],
      'content': textContent,
    });

    return id;
  }

  Future<List<Map<String, dynamic>>> searchFiles(String query) async {
    final db = await instance.database;
    return await db.rawQuery('''
      SELECT f.* FROM files f
      JOIN files_fts fts ON f.path = fts.path
      WHERE files_fts MATCH ?
      ORDER BY rank
      LIMIT 100
    ''', ['*$query*']);
  }

  Future<void> clearDatabase() async {
    final db = await instance.database;
    await db.delete('files');
    await db.execute('DELETE FROM files_fts');
  }
}