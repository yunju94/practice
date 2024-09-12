import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BookList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List? BookList = ModalRoute.of(context)!.settings.arguments as List?;

    return Scaffold(
      appBar: AppBar(
        title: Text("도서 리스트"),
      ),
      body: Container(
        child: Center(child: ListView.builder(itemBuilder: (context, index) {
          return Card(

              child: Column(
                children: [
                  Row(
                    children: [
                      Image.network(
                        BookList[index]['thumbnail'],
                        height: 200,
                        width: 100,
                        fit: BoxFit.contain,
                      ),
                      Text(BookList[index]['title']),
                      Text(BookList[index]['authors']),
                    ],
                  ),

                ],

              ),

          );
        }, itemCount: BookList!.length,),),
      ),
    );
  }
}
