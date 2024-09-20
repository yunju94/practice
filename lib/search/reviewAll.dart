import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../Data/book.dart';
import '../Data/database.dart';
import '../Data/review.dart';

class ReviewAll extends StatefulWidget {
  final String? Booktitle;

  ReviewAll({this.Booktitle});

  @override
  State<ReviewAll> createState() => _ReviewAllState();
}

class _ReviewAllState extends State<ReviewAll> {
  Future<Database>? db;
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://practice-76503-default-rtdb.firebaseio.com/';
  List<Review> reviews = [];

  @override
  void initState() {
    super.initState();
    db = DB().initDatabase();
    _database = FirebaseDatabase.instanceFor(
        app: Firebase.app(), databaseURL: _databaseURL);
    reference = _database!.ref().child('review');
    initiateReview();
  }

  Future<void> initiateReview() async {
    reference!.onChildAdded.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        data.forEach((key, value) {
          final bookData = value as Map<dynamic, dynamic>;
          // Booktitle 필터링
          if (bookData['title'] == widget.Booktitle) {
            reviews.add(Review.fromJson(bookData.cast<String, dynamic>()));
          }
        });

        // UI 업데이트
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("감상평 몰아보기"),
      ),
      body: Container(
        child: Center(
          child: reviews.isEmpty
              ? CircularProgressIndicator()
              : ListView.builder(
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0), // 패딩 추가
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          // 양쪽 끝에 정렬
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start, // 왼쪽 정렬
                                children: [
                                  Text(reviews[index].id ?? 'Unknown ID'),
                                  SizedBox(height: 10), // 세로 간격 추가
                                  Text(
                                      reviews[index].simpleFeel ?? 'No Review'),
                                ],
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                print("object");
                              },
                              child: Icon(Icons.adb, color: Colors.green),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
