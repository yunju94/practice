import 'package:flutter/material.dart';
import 'package:path/path.dart';

import 'package:practice/addBook.dart';
import 'package:practice/booklist.dart';
import 'package:practice/library.dart';
import 'package:practice/searchBook.dart';
import 'package:sqflite/sqflite.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    final Future<Database> database = initDatabase();
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Library(database),
          '/search': (context) => SearchBook(),
          '/list': (context) => BookList(),

        }
    );
  }

  Future<Database> initDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'book_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE book(id INTEGER PRIMARY KEY AUTOINCREMENT, "
              "title TEXT, author Text, startDate Text, endDate Text)",
        );
      },
      version: 1,
    );
  }
}
