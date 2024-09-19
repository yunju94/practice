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
  List<String> code = [];

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

    // Firebase 초기화가 완료된 후에 fetchBooks와 initListadd 호출
    await _fetchBooks();
    await initListadd();
  }

  Future<void> initListadd() async {
    var snapshot = await reference!.child(widget.id!).orderByChild('title')
        .equalTo(widget.booktitle).once();

    if (snapshot.snapshot.exists) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        code = data.keys.map((key) => key.toString()).toList();
      });
    } else {
      print('No matching data found');
    }
  }

  Future<void> _fetchBooks() async {
    reference!
        .child(widget.id!)
        .orderByChild('title')
        .equalTo(widget.booktitle)
        .once()
        .then((DatabaseEvent event) {
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
                              if (code.length > index) { // index 유효성 검사 추가
                                reference!
                                    .child(widget.id.toString())
                                    .child(code[index])
                                    .remove()
                                    .then((_) {
                                  print("삭제 성공");
                                  setState(() {
                                    historyList.removeAt(index); // UI 업데이트
                                    code.removeAt(index); // code 리스트에서 항목 제거
                                  });
                                }).catchError((error) {
                                  print("삭제 실패: $error");
                                });
                              } else {
                                print("삭제할 항목의 인덱스가 유효하지 않습니다.");
                              }
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
