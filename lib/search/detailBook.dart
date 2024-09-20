import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/my/addBook.dart';
import 'package:practice/search/reviewAll.dart';

import 'package:sqflite/sqflite.dart';

import '../Data/book.dart';
import '../Data/database.dart';

class DetailBook extends StatefulWidget {
  final String? id;
  final Map<String, dynamic>? BookList;

  DetailBook({this.id, this.BookList});

  @override
  State<DetailBook> createState() => _DetailBookState();
}

class _DetailBookState extends State<DetailBook> {
  Future<Database>? db;
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://practice-76503-default-rtdb.firebaseio.com/';
  List<Book> book = List.empty(growable: true);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    db = DB().initDatabase(); //
    _database = FirebaseDatabase.instanceFor(
        app: Firebase.app(), databaseURL: _databaseURL);
    reference = _database!.ref().child('books');
    setupList();
  }

  Future<void> setupList() async {
    await reference!
        .child(
          widget.BookList!['title'],
        )
        .onChildAdded
        .listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>?;

      if (data != null) {
        final List<Book> books = [];
        data.forEach((key, value) {
          final bookData = value as Map<dynamic, dynamic>;
          books.add(Book.fromJson(bookData.cast<String, dynamic>()));
        });
        setState(() {
          setupList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.BookList!['title']),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              Image.network(
                widget.BookList!['thumbnail'],
                height: 300,
                width: 800,
              ),
              Text(
                widget.BookList!['contents'],
              ),
              ElevatedButton(
                  onPressed: () {
                    reference!
                        .child(widget.id.toString())
                        .push()
                        .set(Book(
                            widget.id,
                            widget.BookList!['title'],
                            widget.BookList!['authors'].toString(),
                            widget.BookList!['thumbnail']).toJson())
                        .then((_) {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddBook(
                                id: widget.id,
                                BookList: widget.BookList!,
                              )));
                    });
                  },
                  child: Text('내 책장에 넣기')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => ReviewAll(
                              Booktitle: widget.BookList!['title'],)));
                  },
                  child: Text('감상평 몰아보기')),
            ],
          ),
        ),
      ),
    );
  }
}
