import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/material.dart';
import '../models/dog.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    WidgetsFlutterBinding.ensureInitialized();
    
    _database = await _initDB('doggie_db.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE dogs(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)',
        );
      },
    );
  }

  Future<void> insertDog(Dog dog) async {
    final db = await database;
    await db.insert(
      'dogs',
      dog.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Dog>> getDogs() async {
    final db = await database;
    final List<Map<String, Object?>> queryResult = await db.query('dogs');
    
    return [
      for (final {'id': id as int, 'name': name as String, 'age': age as int} in queryResult)
        Dog(id: id, name: name, age: age),
    ];
  }
}
