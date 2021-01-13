import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnector {
  static Database _database;
  static void initDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'courses_database.db'),
      onCreate: (db, version) {
        db.execute("CREATE TABLE courses("
            "id TEXT PRIMARY KEY,"
            "data TEXT"
            ")");
        db.execute("CREATE TABLE videos("
            "lessonId TEXT PRIMARY KEY,"
            "videoPath TEXT"
            ")");
      },
      version: 1,
    );
  }

  static Database get database {
    return _database;
  }
}
