import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:practice/search/searchBook.dart';
import 'package:practice/Data/book.dart';

class Library extends StatefulWidget {
  final String id;

  Library(this.id);

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
    reference!.child(widget.id).onValue.listen((event) {
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
          // 색상이 있는 네모 안에 다른 글자들을 가로로 배치
          Positioned(
            bottom: 83, // 화면 하단으로부터 100px 떨어진 위치
            left: 0, // 화면 왼쪽으로부터 0px 위치
            right: 0, // 화면 오른쪽으로부터 0px 위치
            child: Container(
              width: MediaQuery.of(context).size.width, // 화면 너비에 맞게 조정
              height: 100,
              color: Colors.white.withOpacity(0.7), // 투명도 0.7 적용
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center, // 아이템을 중앙에 배치
                children: bookList.isEmpty
                    ? [CircularProgressIndicator()] // 데이터 로딩 중일 때 로딩 인디케이터 표시
                    : List.generate(bookList.length, (index) {
                  Color backgroundColor = Colors.primaries[
                  index % Colors.primaries.length];
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 1.5), // 네모 사이에 간격 3px
                    child: Container(
                      width: 40,
                      height: 90,
                      color: backgroundColor, // 배경 색상 설정
                      child: Center(
                        child: Text(
                          bookList[index].title.toString(), // 책 제목
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center, // 텍스트 중앙 정렬
                        ),
                      ),
                    ),
                  );
                }),
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
