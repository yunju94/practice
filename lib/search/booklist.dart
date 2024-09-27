import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/search/detailBook.dart';


import '../Data/book.dart';

class BookList extends StatefulWidget {
  final List? Books;
  final String? id;

  BookList({ this.Books, this.id});



  @override
  State<BookList> createState() => _BookListState();
}

class _BookListState extends State<BookList> {

  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://practice-76503-default-rtdb.firebaseio.com/';
  List<Book> book = List.empty(growable: true);


  @override
  void initState() {
    super.initState();

    _database = FirebaseDatabase.instanceFor(
        app: Firebase.app(), databaseURL: _databaseURL);
    reference = _database!.ref().child('books');


  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("도서 리스트"),
      ),
      body: Container(
        child: Center(child: ListView.builder(itemBuilder: (context, index) {
          return Card(
              child: InkWell(
                child: Row(
                  children: [
                    Container(
                      child: Image.network(
                        widget.Books![index]['thumbnail'],
                        height: 200,
                        width: 100,
                        fit: BoxFit.contain,
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                    Expanded( // 여기에 Expanded 추가
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.Books![index]['title'].toString(),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(widget.Books![index]['authors'].toString()),
                        ],
                      ),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailBook(
                        id: widget.id,
                        BookList: widget.Books![index],
                      ),
                    ),
                  );
                },
              ),
          );
        }, itemCount: widget.Books!.length,),
        ),
      ),
    );
  }
}
