import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/search/detailBook.dart';
import 'package:sqflite/sqflite.dart';

class BookList extends StatelessWidget {
  final List? Books;
  final String? id;

  BookList({ this.Books, this.id});

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
                child:
                  Row(
                    children: [
                      Container(
                        child: Image.network(
                          Books![index]['thumbnail'],
                          height: 200,
                          width: 100,
                          fit: BoxFit.contain,
                        ),padding: const EdgeInsets.all(10),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Text(Books![index]['title'].toString()),
                            Text(Books![index]['authors'].toString()),
                          ],

                        ),
                      )

                    ],
                  ),
                onTap: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (context)=> DetailBook(
                      id: id,
                      BookList:  Books![index]
                  )));



                },
              ),


          );
        }, itemCount: Books!.length,),
        ),
      ),
    );
  }
}
