import 'package:flutter/material.dart';
import 'package:mmsfa_flu/loginpages/signin.dart';
import 'mainpages/ui/home_page.dart';

//bool firstRun;
Future main() async {
  //SharedPreferences pref= await SharedPreferences.getInstance();
 // firstRun= pref.getBool('firstRun')?? true;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:
        //firstRun? SplashScreen():
        Login_SigninPage(),
       routes: <String ,WidgetBuilder>{
        '/landingpage':(BuildContext context)=> MyApp(),
        '/register':(BuildContext context)=> Login_SigninPage(),
         '/homepage':(BuildContext context)=> Homepage(),
        },
      theme: ThemeData(primaryColor: Colors.indigo),
    );
  }
}
