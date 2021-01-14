import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnector {
  static Database _database;
  static Future<void> _initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'courses_database.db'),
      onCreate: (db, version) {
        db.execute("CREATE TABLE courses("
            "id TEXT PRIMARY KEY,"
            "data TEXT"
            ")");
        db.execute("CREATE TABLE videos("
            "id TEXT PRIMARY KEY,"
            "videoPath TEXT"
            ")");
        db.execute("CREATE TABLE lastWatchLesson("
            "courseId TEXT PRIMARY KEY,"
            "data TEXT"
            ")");
        db.execute("CREATE TABLE images("
            "courseId TEXT PRIMARY KEY,"
            "imagePath TEXT"
            ")");
      },
      version: 1,
    );
  }

  static Future<Database> get database async {
    if (_database == null) {
      await _initDatabase();
    }
    return _database;
  }
}
