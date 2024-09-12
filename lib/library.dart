import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:practice/addBook.dart';
import 'package:practice/searchBook.dart';
import 'package:sqflite/sqflite.dart';

import 'Data/book.dart';

class Library extends StatefulWidget {
  final Future<Database> db;
  Library(this.db);


  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
Future<List<Book>>? bookList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookList = getBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("나의 서재"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(fit: BoxFit.cover, image: AssetImage('repo/images/libraryBackground.jpg'))
        ),
        child: Center(
          child: FutureBuilder(builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return CircularProgressIndicator();
              case ConnectionState.done:
                if(snapshot.hasData){
                  return ListView.builder(itemBuilder: (context, index){
                    Book book = (snapshot.data as List<Book>)[index];
                    return Card(
                      child: Column(
                        children: [
                          Text(book.title!),
                        ],
                      ),
                    );
                  },
                  itemCount: (snapshot.data as List<Book>).length,
                  );
                } else{
                  return Text("No data");
                }

            }
            return CircularProgressIndicator();
          }, future: bookList),
            
        ),
        
      ),
        floatingActionButton: FloatingActionButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SearchBook()));
        }, child: Icon(Icons.add, size: 20, color: Colors.white,),)
    );
  }



  Future<List<Book>> getBooks() async{
    final Database database = await widget.db;
    final List<Map<String, dynamic>> maps = await database.query('book');

    return List.generate(maps.length, (i){
      return Book(
        title: maps[i]['title'].toString(),
      );
    });
  }

}
