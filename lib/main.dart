import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mmsfa_flu/loginpages/signin.dart';
import 'package:mmsfa_flu/splshscreen/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mainpages/ui/home_page.dart';
bool firstRun;
const firstRunKey= 'firstRun';
Future main() async {
  SharedPreferences ref= await SharedPreferences.getInstance();
  firstRun=ref.getBool(firstRunKey)?? true;
  ref.setBool(firstRunKey, false);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:FutureBuilder<Widget>(
future: firstPage(),
    builder:
    (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: SpinKitDoubleBounce(color: Colors.indigo,));
      }
      return snapshot.data;
    },
        ),

        //firstRun? SplashScreen():
      //  LoginSignInPage(),
       routes: <String ,WidgetBuilder>{
        '/landingpage':(BuildContext context)=> MyApp(),
        '/register':(BuildContext context)=> LoginSignInPage(),
         '/homepage':(BuildContext context)=> Homepage(),
        },
      theme: ThemeData(primaryColor: Colors.indigo),
    );
  }

  Future<Widget> firstPage() async {
    if(firstRun){
      return SplashScreen();
    }

    var user =  await FirebaseAuth.instance.currentUser();
    if(user == null){
      return LoginSignInPage();
    }

    return Homepage();
  }
}


