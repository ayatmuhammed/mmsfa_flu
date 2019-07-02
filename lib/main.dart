import 'package:flutter/material.dart';
//import 'splshscreen/loader.dart';
import 'package:mmsfa_flu/loginpages/home.dart';
import 'package:mmsfa_flu/loginpages/signin.dart';
import 'package:mmsfa_flu/loginpages/register.dart';

void main() => runApp(MyApp());
class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: new LoginPage(),
       routes: <String ,WidgetBuilder>{
        '/landingpage':(BuildContext context)=>new MyApp(),
        '/register':(BuildContext context)=>new RegisterPage(),
         '/home':(BuildContext context)=>new Home(),
        },

      //ColorLoader3(),

    );
  }



}
//class MyHomePage extends StatefulWidget {
//  MyHomePage({Key key, this.title}) : super(key: key);
//  final String title;
//  @override
//  _MyHomePageState createState() => _MyHomePageState();
//}
//class _MyHomePageState extends State<MyHomePage> {
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      body: Center(
//        child: ColorLoader3(),
//
//      ),
//
//    );
//  }
//}