import 'package:flutter/material.dart';

import 'Data/book.dart';

class AddBook extends StatefulWidget {
  const AddBook({super.key});

  @override
  State<AddBook> createState() => _AddBook();
}

class _AddBook extends State<AddBook> {
  TextEditingController? titleController;
  TextEditingController? authorController;
  TextEditingController? startController;
  TextEditingController? endController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController = new TextEditingController();
    authorController = new TextEditingController();
    startController = new TextEditingController();
    endController = new TextEditingController();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("책 추가하기"),
        ),
        body: Container(
          decoration: BoxDecoration(
              image: DecorationImage(fit: BoxFit.cover, image: AssetImage('repo/images/bookWrite.jpg'),
             opacity: 0.3 ),

          ),
          child: CustomScrollView(
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Padding(
                  padding: EdgeInsets.all(50),
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(labelText: '제목'),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(50),
                  child: TextField(
                    controller: authorController,
                    decoration: InputDecoration(labelText: '저자'),
                  ),
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
              ElevatedButton(style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[300],
                foregroundColor: Colors.white,
              ), onPressed: (){
                  Book book = Book(
                    title: titleController!.value.text,
                    author: authorController!.value.text,
                    startDate: startController!.value.text,
                    endDate: endController!.value.text,
                  );
                  Navigator.of(context).pop(book);
              }, child: Text('저장하기'), )
                  ]),

              )
            ],
          ),
        ));
  }
}
