import 'package:flutter/material.dart';
import 'package:mmsfa_flu/loginpages/signin.dart';
import 'mainpages/ui/home_page.dart';
void main() => runApp(MyApp());
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: new  Login_SigninPage(),
       routes: <String ,WidgetBuilder>{
        '/landingpage':(BuildContext context)=> MyApp(),
        '/register':(BuildContext context)=> Login_SigninPage(),
         '/homepage':(BuildContext context)=> Homepage(),
        },
      theme: ThemeData(primaryColor: Colors.indigo),
    );
  }
}
