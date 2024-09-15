import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import 'package:practice/my/addBook.dart';
import 'package:practice/login/signPage.dart';
import 'package:practice/my/myBookHistory.dart';
import 'package:practice/search/booklist.dart';
import 'package:practice/firebase_options.dart';
import 'package:practice/library.dart';
import 'package:practice/search/searchBook.dart';


import 'search/detailBook.dart';
import 'login/login.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: 'a9deccfadee1c1f3f09b4868f001d3cc',
    javaScriptAppKey: 'd2553dd12dba6d5a7b09b636cb59a91d',
  );

  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => Login(),

          '/sign': (context) => SignPage(),

          '/library': (context) => Library(),
          '/search': (context) => SearchBook(),
          '/list': (context) => BookList(),
          '/detail': (context) => DetailBook(),

          '/add': (context) => AddBook(),
          '/myhistory': (context) => MyBookHistory(),


        }
    );
  }


}
