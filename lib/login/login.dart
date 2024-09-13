import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:practice/library.dart';
import '../Data/user.dart';
import '../kakao_login.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseDatabase? _database;
  DatabaseReference? reference;
  String _databaseURL = 'https://practice-76503-default-rtdb.firebaseio.com/';

  TextEditingController? _idTextController;
  TextEditingController? _pwTextController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();

    _database = FirebaseDatabase.instanceFor(
        app: Firebase.app(), databaseURL: _databaseURL);
    reference = _database!.ref().child('user');
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: FlexibleSpaceBar(
          title: Text('로그인'),
          background: Icon(Icons.menu_book_rounded),
        ),
      ),
      body: Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                  width: 200,
                  child: TextField(
                    obscureText: true,
                    controller: _idTextController,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: '아이디', border: OutlineInputBorder()),
                  )),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                  width: 200,
                  child: TextField(
                    obscureText: true,
                    controller: _pwTextController,
                    maxLines: 1,
                    decoration: InputDecoration(
                        labelText: '비밀번호', border: OutlineInputBorder()),
                  )),
              TextButton(
                  onPressed: () {
                    signInWithKakao();
                  },
                  child: Text('카카오 로그인')),
              TextButton(
                  onPressed: () {
                    if (_idTextController!.value.text.length == 0 ||
                        _pwTextController!.value.text.length == 0) {
                      makeDialog('빈칸이 있습니다. 다시 한 번 확인 해 주십시오.');
                    } else {
                      reference!
                          .child(_idTextController!.value.text)
                          .onChildAdded
                          .listen((event) {
                        Map<dynamic, dynamic> rawData =
                        event.snapshot.value as Map<dynamic, dynamic>;

                        // Map<dynamic, dynamic>을 Map<String, dynamic>으로 변환
                        Map<String, dynamic> data = rawData.map((key, value) =>
                            MapEntry(key.toString(), value as dynamic));

                        User user = User.fromJson(data);
                        var bytes = utf8.encode(_pwTextController!.value.text);
                        var digest = sha1.convert(bytes);
                        if (user.pw == digest.toString()) {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context)=> Library(_idTextController!.value.text)));
                        } else {
                          makeDialog('비밀번호가 틀렸습니다. 다시 확인하십시오.');
                        }
                      });
                    }
                  },
                  child: Text('로그인')),
              TextButton(onPressed: () {
                Navigator.of(context).pushNamed('/sign');
              }, child: Text('회원가입'))
            ],
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
