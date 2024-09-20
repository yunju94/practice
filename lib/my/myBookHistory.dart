import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/Data/database.dart';
import 'package:practice/library.dart';
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
  List<String> bookcode = [];

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
    var snapshot = await reference!
        .child(widget.id!)
        .orderByChild('title')
        .equalTo(widget.booktitle)
        .once();

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
                          Text("좋아요: ${review.count}"),
                          ElevatedButton(
                            onPressed: () {
                              deleteReview(index);
                            },
                            child: Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    onLongPress: () {
                      updateReview(review, index);
                    },

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
 void updateReview(review, index){
   TextEditingController startDateController =
   TextEditingController(text: review.startDate);
   TextEditingController endDateController =
   TextEditingController(text: review.endDate);
   TextEditingController simpleFeelController =
   TextEditingController(text: review.simpleFeel);

   // AlertDialog를 화면에 표시하기 위해 showDialog를 사용합니다.
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         contentPadding: EdgeInsets.all(10),
         content: SingleChildScrollView(
           child: Column(
             mainAxisSize: MainAxisSize.min,
             children: [
               TextField(controller: startDateController),
               SizedBox(height: 10),
               TextField(controller: endDateController),
               SizedBox(height: 10),
               TextField(controller: simpleFeelController),
             ],
           ),
         ),
         actions: [
           TextButton(
             onPressed: () {
               Review updatedReview = Review(
                 widget.id,
                 widget.booktitle,
                 startDateController.value.text,
                 endDateController.value.text,
                 simpleFeelController.value.text,
                   historyList[index].count,
               );

               reference!
                   .child(widget.id!)
                   .child(code[index])
                   .update(updatedReview.toJson())
                   .then((_) {
                 Navigator.of(context).pop(); // 다이얼로그 닫기
                 setState(() {
                   _fetchBooks();
                   initListadd();
                 }); // UI 업데이트를 위해 setState 호출
               });
             },
             child: Text('수정하기'),
           ),
           TextButton(
             onPressed: () {
               Navigator.of(context).pop(); // 다이얼로그 닫기
             },
             child: Text('취소'),
           ),
         ],
       );
     },
   );
 }
  void deleteReview(int index) async {
    if (code.length > index) {
      // 인덱스 유효성 검사
      try {
        await reference!
            .child(widget.id.toString())
            .child(code[index])
            .remove();
        print("삭제 성공");

        setState(() {
          historyList.removeAt(index); // UI 업데이트
          code.removeAt(index); // code 리스트에서 항목 제거
        });

        // 모든 리뷰가 삭제된 경우 책 삭제
        if (code.isEmpty) {
          await deleteBookinit();

          // 삭제할 책 코드가 필요하므로 확인 후 삭제
          if (bookcode.isNotEmpty) {
            await _database!
                .ref()
                .child('books')
                .child(widget.id.toString())
                .child(bookcode[0]) // 필요한 책 코드를 사용하세요
                .remove();
            print('책 삭제 성공');
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => Library(id: widget.id)));
          }
        }
      } catch (error) {
        print("삭제 실패: $error");
      }
    } else {
      print("삭제할 항목의 인덱스가 유효하지 않습니다.");
    }
  }

  Future<void> deleteBookinit() async {
    var snapshot = await _database!
        .ref()
        .child('books')
        .child(widget.id!)
        .orderByChild('title')
        .equalTo(widget.booktitle)
        .once();

    if (snapshot.snapshot.exists) {
      final data = snapshot.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        bookcode = data.keys.map((key) => key.toString()).toList();
      });
    } else {
      print('No matching data found');
    }
  }
}
