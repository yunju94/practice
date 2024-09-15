import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/Data/database.dart';
import 'package:sqflite/sqflite.dart';

import '../Data/book.dart';

class MyBookHistory extends StatefulWidget {
  final String? id;
  final String? booktitle;

  MyBookHistory({this.id, this.booktitle});

  @override
  State<MyBookHistory> createState() => _MyBookHistoryState();
}

class _MyBookHistoryState extends State<MyBookHistory> {
  Future<Database>? db;
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://practice-76503-default-rtdb.firebaseio.com/';
  List<Book> historyList = [];

  @override
  void initState() {
    super.initState();
    db = DB().initDatabase(); // Future<Database>를 초기화
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(); // Firebase 초기화

    _database = FirebaseDatabase.instanceFor(
        app: Firebase.app(), databaseURL: _databaseURL);
    reference = _database!.ref().child('books');
    _fetchBooks(); // 책 목록을 가져오는 작업 수행
  }

  Future<void> _fetchBooks() async {

    final snapshot = await reference!
        .child(widget.id!)
        .orderByChild('title')
        .equalTo(widget.booktitle!)
        .get();

    final data = snapshot.value as Map<dynamic, dynamic>?;

    if (data != null) {
      final List<Book> history = [];
      data.forEach((key, value) {
        final bookData = value as Map<dynamic, dynamic>;
        history.add(Book.fromJson(bookData.cast<String, dynamic>()));
      });

      setState(() {
        historyList = history;
      });
    }
  }

  Future<void> deleteHistory(String feel) async {
    final Database? database = await db;

    if (database == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Database is not initialized')));
      return;
    }

    try {
      final int count = await database.delete(
        'books',
        where: 'simpleFeel=?',
        whereArgs: [feel],
      );

      if (count > 0) {
        setState(() {
          _fetchBooks(); // 삭제 후 리스트 갱신
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('감상평을 삭제했습니다.')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('해당 감상평을 찾을 수 없습니다.')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('오류 발생: ${e.toString()}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.booktitle ?? 'Book History'), // null 체크 추가
      ),
      body: FutureBuilder<Database>(
        future: db,
        builder: (BuildContext context, AsyncSnapshot<Database> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: historyList.length,
              itemBuilder: (context, index) {
                return Card(
                  child: InkWell(
                    onTap: () {
                      // 항목을 탭했을 때의 동작을 정의할 수 있습니다.
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("시작 날짜: ${historyList[index].startDate}"),
                          Text("종료 날짜: ${historyList[index].endDate}"),
                          Text("감상평: ${historyList[index].simpleFeel}"),
                          ElevatedButton(
                            onPressed: () {
                              deleteHistory(historyList[index].simpleFeel ?? '');
                            },
                            child: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No data'));
          }
        },
      ),
    );
  }
}
