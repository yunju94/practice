import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/my/addBook.dart';
import 'package:sqflite/sqflite.dart';

import '../Data/book.dart';

class DetailBook extends StatefulWidget {
  final String? id;
  final Map<String, dynamic>? BookList;

  DetailBook({this.id, this.BookList});

  @override
  State<DetailBook> createState() => _DetailBookState();
}

class _DetailBookState extends State<DetailBook> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://practice-76503-default-rtdb.firebaseio.com/';
  List<Book> book = List.empty(growable: true);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _database = FirebaseDatabase.instanceFor(
        app: Firebase.app(), databaseURL: _databaseURL);
    reference = _database!.ref().child('books');


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
              Text(widget.BookList!['contents'],),

              ElevatedButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddBook(
                    id: widget.id,
                    BookList: widget.BookList!,
                )));
              }, child: Text('내 책장에 넣기'))
            ],

          ),

        ),
      ),
    );
  }
}

