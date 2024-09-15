import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:practice/library.dart';

import '../Data/member.dart';


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
                onPressed: () async {
                  KakaoLogin();
                },
                child: Text('카카오톡으로 로그인'),
              ),
              TextButton(onPressed: ()async{
                signInWithGoogle();
              }, child: Text('구글 로그인')),

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

                        Member user = Member.fromJson(data);
                        var bytes = utf8.encode(_pwTextController!.value.text);
                        var digest = sha1.convert(bytes);
                        if (user.pw == digest.toString()) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  Library(id: _idTextController!.value.text)));
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

  void KakaoLogin() async {
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        print('카카오톡으로 로그인 성공');
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          await UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    Member user = Member(googleUser!.email, googleUser.email, TimeOfDay.now().toString());
    reference!.
    child('User')
    .push()
    .set(user.toJson());

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}