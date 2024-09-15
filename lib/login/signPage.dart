import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Data/member.dart';

class SignPage extends StatefulWidget {
  @override
  State<SignPage> createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://practice-76503-default-rtdb.firebaseio.com/';

  TextEditingController?  _idTextController;
  TextEditingController?  _pwTextController;
  TextEditingController?  _pwCheckTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();
    _pwCheckTextController = TextEditingController();

    _database = FirebaseDatabase.instanceFor(
        app: Firebase.app(), databaseURL: _databaseURL);
    reference = _database!.ref().child('user');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
          title: Text("회원가입"),
          background: Icon(Icons.key_outlined),
        ),
      ),body:Container(
      child: Center(
        child: Column(
          children: [
            SizedBox(
              width: 200,
              child: TextField(
                controller: _idTextController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: '4자 이상 입력해주세요',
                  labelText: '아이디',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _pwTextController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: '6자 이상 입력해주세요',
                  labelText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _pwCheckTextController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: '비밀번호가 일치하지 않습니다.',
                  labelText: '비밀번호 확인',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(onPressed: (){
              if(_idTextController!.value.text.length >= 4 &&
              _pwCheckTextController!.value.text.length >=6){
                if(_pwTextController!.value.text == _pwCheckTextController!.value.text){
                  var bytes = utf8.encode(_pwTextController!.value.text);
                  var digest = sha1.convert(bytes);
                  reference!
                      .child(_idTextController!.value.text)
                      .push()
                      .set(Member(_idTextController!.value.text, digest.toString(), DateTime.now().toIso8601String()).toJson())
                      .then((_){
                        Navigator.of(context).pop();
                  });
                }else{
                  makeDialog('비밀번호가 일치하지 않습니다.');
                }
              }else{
                makeDialog('단어 길이가 기준보다 짧습니다.');
              }
            }, child: Text('회원가입'))
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    ),
    );
  }

  void makeDialog(String text) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(text),
          );
        });
  }


}
