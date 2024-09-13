import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:path/path.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:practice/my/addBook.dart';
import 'package:practice/login/signPage.dart';
import 'package:practice/search/booklist.dart';
import 'package:practice/firebase_options.dart';
import 'package:practice/library.dart';
import 'package:practice/search/searchBook.dart';
import 'package:sqflite/sqflite.dart';

import 'search/detailBook.dart';
import 'login/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: 'a9deccfadee1c1f3f09b4868f001d3cc',
    javaScriptAppKey: 'd2553dd12dba6d5a7b09b636cb59a91d',
  );

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
          '/': (context) => Login(),



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
