import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:practice/search/searchBook.dart';
import 'package:practice/Data/book.dart';

import 'my/myBookHistory.dart';

class Library extends StatefulWidget {
  final String? id;

  Library({this.id});

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  List<Book> bookList = [];

  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://practice-76503-default-rtdb.firebaseio.com/';

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instanceFor(
        app: Firebase.app(), databaseURL: _databaseURL);
    reference = _database!.ref().child('books'); // 'books' 경로로 데이터 참조

    // 상태가 초기화될 때 책 데이터를 가져옴
    _fetchBooks();
  }

  Future<void> _fetchBooks() async {
    reference!.child(widget.id!).onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final List<Book> books = [];
        data.forEach((key, value) {
          final bookData = value as Map<dynamic, dynamic>;
          books.add(Book.fromJson(bookData.cast<String, dynamic>()));
        });

        setState(() {
          bookList = books;
        });
      }
    });
  }

  void deleteBook(int index) {
    if (index < 0 || index >= bookList.length) return; // 범위 체크
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(10),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Text("정말로 삭제하시겠습니까?"),
                TextButton(
                  onPressed: () async {
                    try {
                      await reference!
                          .child(widget.id!)
                          .child(bookList[index].uuid!)
                          .remove();

                      setState(() {
                        bookList.removeAt(index); // 로컬 리스트에서 제거
                      });
                      Navigator.of(context).pop();
                    } catch (e) {
                      // 오류 처리 (예: Snackbar로 오류 메시지 표시)
                    }
                  },
                  child: Text("예"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("아니요"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("나의 서재"), // 앱바 제목
      ),
      body: Stack(
        children: [
          // 배경 이미지에 투명도 적용
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('repo/images/libraryBackground.jpg'),
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.5), // 투명도 0.5 적용
                    BlendMode.darken, // 어두운 색상으로 혼합
                  ),
                ),
              ),
            ),
          ),
          // GridView 사용
          Positioned(
            bottom: 83, // 화면 하단으로부터 83px 떨어진 위치
            left: 0, // 화면 왼쪽으로부터 0px 위치
            right: 0, // 화면 오른쪽으로부터 0px 위치
            child: Container(
              width: MediaQuery.of(context).size.width, // 화면 너비에 맞게 조정
              height: 575,
              color: Colors.white.withOpacity(0.7), // 투명도 0.7 적용
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 8, // 한 행에 8개 아이템
                  childAspectRatio: (1 / 1.8), // 아이템 비율 조정
                  crossAxisSpacing: 3, // 아이템 사이의 간격
                  mainAxisSpacing: 11, // 행 사이의 간격
                ),
                itemCount: bookList.length,
                reverse: true, // 아래에서 위로 쌓이도록 설정
                itemBuilder: (context, index) {
                  if (index >= bookList.length) return SizedBox(); // 빈 공간 처리
                  final book = bookList[index];
                  Color backgroundColor = Colors
                      .primaries[index % Colors.primaries.length];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.5),
                    child: InkWell(
                      child: Container(
                        color: backgroundColor, // 배경 색상 설정
                        child: Center(
                          child: Text(
                            book.title.toString(), // 책 제목
                            style: TextStyle(color: Colors.white),
                            textAlign: TextAlign.center, // 텍스트 중앙 정렬
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => MyBookHistory(
                                id: widget.id,
                                booktitle: book.title.toString())));
                      },
                      onLongPress: () {
                        deleteBook(index);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          // FloatingActionButton을 GridView 위에 위치
          Positioned(
            bottom: 20, // 화면 하단으로부터 20px 떨어진 위치
            right: 20, // 화면 오른쪽으로부터 20px 떨어진 위치
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => SearchBook(id: widget.id),
                  ),
                );
              },
              child: Icon(
                Icons.add,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }


}
