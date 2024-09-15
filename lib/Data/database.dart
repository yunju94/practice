import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'books_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE books(id TEXT, title TEXT, author TEXT, thumbnail TEXT)",
        );
      },
      version: 1,
    );
  }

  Future<Database> initDatabaseReview() async {
    return openDatabase(
      join(await getDatabasesPath(), 'review_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE review(id TEXT, title TEXT, startDate TEXT, endDate TEXT, simpleFeel TEXT)",
        );
      },
      version: 1,
    );
  }
}
