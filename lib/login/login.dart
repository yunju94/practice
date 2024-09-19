import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:practice/library.dart';
import '../Data/member.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    super.initState();
    _idTextController = TextEditingController();
    _pwTextController = TextEditingController();
    _database = FirebaseDatabase.instanceFor(app: Firebase.app(), databaseURL: _databaseURL);
    reference = _database!.ref().child('user');
  }

  @override
  void dispose() {
    _idTextController?.dispose();
    _pwTextController?.dispose();
    super.dispose();
  }

  Future<String> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      reference!.child(credential.idToken!).onChildAdded.listen((event) {
         Map<dynamic, dynamic> rawData = event.snapshot.value as Map<dynamic, dynamic>;
         Map<String, dynamic> data = rawData.map((key, value) => MapEntry(key.toString(), value as dynamic));

         Member member = Member.fromJson(data);
         var bytes = utf8.encode(credential.idToken!);
         var digest = sha1.convert(bytes);
         if (member.pw != digest.toString()) {
           reference!
               .child(credential.idToken!)
               .push()
               .set(Member(
               credential.idToken.toString(),
               digest.toString(),
               DateTime.now().toIso8601String()).toJson());
         }
      });

         await FirebaseAuth.instance.signInWithCredential(credential);
      return credential.idToken.toString();



    } catch (e) {
      print('구글 로그인 실패: $e');
      rethrow; // 필요 시 예외를 다시 던질 수 있습니다.
    }
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
                  decoration: InputDecoration(labelText: '아이디', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: 200,
                child: TextField(
                  obscureText: true,
                  controller: _pwTextController,
                  maxLines: 1,
                  decoration: InputDecoration(labelText: '비밀번호', border: OutlineInputBorder()),
                ),
              ),
              TextButton(
                onPressed: () async {
                  KakaoLogin();
                },
                child: Text('카카오톡으로 로그인'),
              ),
              TextButton(
                onPressed: () async {
                  Future<String>googling =  signInWithGoogle(); // 구글 로그인
                  await  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Library(id:googling.toString())));
                },
                child: Text('구글 로그인'),
              ),
              TextButton(
                onPressed: () {
                  if (_idTextController!.value.text.length == 0 || _pwTextController!.value.text.length == 0) {
                    makeDialog('빈칸이 있습니다. 다시 한 번 확인 해 주십시오.');
                  } else {
                    reference!.child(_idTextController!.value.text).onChildAdded.listen((event) {
                      Map<dynamic, dynamic> rawData = event.snapshot.value as Map<dynamic, dynamic>;
                      Map<String, dynamic> data = rawData.map((key, value) => MapEntry(key.toString(), value as dynamic));

                      Member member = Member.fromJson(data);
                      var bytes = utf8.encode(_pwTextController!.value.text);
                      var digest = sha1.convert(bytes);
                      if (member.pw == digest.toString()) {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Library(id: _idTextController!.value.text)));
                      } else {
                        makeDialog('비밀번호가 틀렸습니다. 다시 확인하십시오.');
                      }
                    });
                  }
                },
                child: Text('로그인'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/sign');
                },
                child: Text('회원가입'),
              ),
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
      },
    );
  }

  void KakaoLogin() async {
    try {
      OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
      print('카카오계정으로 로그인 성공 ${token.accessToken}');
    } catch (error) {
      print('카카오계정으로 로그인 실패 $error');
    }
  }
}
