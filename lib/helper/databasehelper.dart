import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    String path = join(await getDatabasesPath(), 'your_database_name.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create your database tables here
        await db.execute('''
         CREATE TABLE messages(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  message TEXT,
  timestamp INTEGER,
  isUserMessage BOOLEAN,
  userId TEXT
);
        ''');
      },
    );
  }

  Future<int> insertMessage(Map<String, dynamic> message) async {
    final db = await database;
    return await db.insert('messages', {
      'message': message['message'],
      'timestamp': message['timestamp'],
      'isUserMessage': message['isUserMessage'] == 1 ? true : false,
      'userId': message['userId'],
    });
  }

  Future<List<Map<String, dynamic>>> getMessages() async {
    final db = await database;
    return await db.query('messages');
  }
}
