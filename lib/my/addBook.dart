
import 'dart:core';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:practice/Data/database.dart';
import 'package:practice/Data/review.dart';
import 'package:practice/library.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';


import '../Data/book.dart';


class AddBook extends StatefulWidget {
  final String? id;
  final Map<String, dynamic>? BookList;

  AddBook({this.id, this.BookList});

  @override
  State<AddBook> createState() => _AddBookState();
}

class _AddBookState extends State<AddBook> {
  Future<Database>? database;
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://practice-76503-default-rtdb.firebaseio.com/';
  List<Book> book = List.empty(growable: true);

  TextEditingController? startController;
  TextEditingController? endController;
  TextEditingController? simpleFeelController;
  int count = 0;
  late String uuidId;

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instanceFor(
        app: Firebase.app(), databaseURL: _databaseURL);

    var uuid = Uuid();
    uuidId = uuid.v4();
    reference = _database!.ref().child('review');

    database = DB().initDatabase();

    startController = TextEditingController();
    endController = TextEditingController();
    simpleFeelController = TextEditingController();



  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic>? BookList = widget.BookList;

    return Scaffold(
      appBar: AppBar(
        title: Text("책 추가하기"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('repo/images/bookWrite.jpg'),
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.dstATop,
            ),
          ),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.all(50),
                  child: Text(BookList!['title']),
                ),
                Padding(
                  padding: EdgeInsets.all(50),
                  child: Text(BookList['authors'].toString()),
                ),
                Padding(
                  padding: EdgeInsets.all(50),
                  child: TextField(
                    controller: startController,
                    decoration: InputDecoration(labelText: '시작날짜: 1999-01-01'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(50),
                  child: TextField(
                    controller: endController,
                    decoration: InputDecoration(labelText: '종료날짜: 1999-12-31'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(50),
                  child: TextField(
                    controller: simpleFeelController,
                    decoration: InputDecoration(labelText: "감상평"),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[300],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {

                    reference!
                        .child(widget.id.toString())
                        .child(uuidId)
                        .set(Review(
                      widget.id,
                      BookList['title'],
                      startController!.text,
                      endController!.text,
                      simpleFeelController!.text,
                        count,
                       uuidId,
                      // Assuming this is the user ID
                    ).toJson())
                    .then((_){
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => Library(id: widget.id)));

                    }); // Assuming Book has a toMap method


                  },
                  child: Text('저장하기'),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}