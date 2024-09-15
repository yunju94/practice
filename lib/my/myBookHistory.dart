import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/Data/database.dart';
import 'package:sqflite/sqflite.dart';
import '../Data/review.dart';

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
  List<Review> historyList = [];

  @override
  void initState() {
    super.initState();
    db = DB().initDatabaseReview(); // Future<Database>를 초기화
    _initializeFirebase();
  }

  Future<void> _initializeFirebase() async {
    await Firebase.initializeApp(); // Firebase 초기화

    _database = FirebaseDatabase.instanceFor(
        app: Firebase.app(), databaseURL: _databaseURL);
    reference = _database!.ref().child('review');
    _fetchBooks(); // 책 목록을 가져오는 작업 수행
  }

  Future<void> _fetchBooks() async {
    reference!.child(widget.id!)
        .orderByChild('title')
        .equalTo(widget.booktitle)
        .once().then((DatabaseEvent event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final List<Review> history = [];
        data.forEach((key, value) {
          final bookData = value as Map<dynamic, dynamic>;
          history.add(Review.fromJson(bookData.cast<String, dynamic>()));
        });

        setState(() {
          historyList = history;
        });
      }
    });
  }

  Future<void> deleteHistory(String feel, int index) async {
    final Database? database = await db;

    if (database == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Database is not initialized')),
      );
      return;
    }

    try {
      // SQLite에서 데이터 삭제
      await database.delete(
        'review',
        where: 'simpleFeel=?',
        whereArgs: [feel],
      );

      // Firebase에서 데이터 삭제
      if (feel.isNotEmpty) {
        await reference!.child(feel).remove();
      }

      setState(() {
        historyList.removeAt(index);
        Navigator.of(context).pop();
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }

    reference!.child(feel).remove();
    //doc(feel).delete().then(
      //    (doc) => print("Document deleted"),
      //onError: (e) => print("Error updating document $e"),
    //);

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
                final review = historyList[index];
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
                          Text("시작 날짜: ${review.startDate}"),
                          Text("종료 날짜: ${review.endDate}"),
                          Text("감상평: ${review.simpleFeel ?? 'No comment'}"),
                          ElevatedButton(
                            onPressed: () {
                              //deleteHistory(review.simpleFeel ?? '', index);

                              reference!
                              .child(widget.id.toString())
                                  .child('books')
                                  .child(review.title!)
                              .remove().then((_){print("object");});
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
