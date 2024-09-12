import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'booklist.dart';

class SearchBook extends StatefulWidget {
  @override
  State<SearchBook> createState() => _SearchBook();
}

class _SearchBook extends State<SearchBook> {
  TextEditingController? titleController;
  List? data;
  String titleList='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = new TextEditingController();
    data = new List.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("책 검색"),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('repo/images/bookWrite.jpg'),
              opacity: 0.3),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(50),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: '제목'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                BookApi(titleController!);

              },
              child: Icon(Icons.search_off),
            )
          ],
        ),
      ),
    );
  }

  void BookApi(TextEditingController titleController) async {
    print(titleController);
    var title = titleController.value.text;
    var url = 'https://dapi.kakao.com/v3/search/book?target=title&query=$title';
    var response = await http.get(Uri.parse(url),
        headers: {"Authorization": "KakaoAK b2c40fb11578953edf7c5f85c64546e4"});

      var dataConvertedToJSON = json.decode(response.body);
      List result = dataConvertedToJSON['documents'];
      data!.addAll(result);
      titleList = data!.first['title'];
      print(titleList);
      Navigator.of(context)
          .pushNamed('/list', arguments: data);

  }
}
