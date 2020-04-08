import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mmsfa_flu/database/controller/Auth.dart';
import 'package:mmsfa_flu/ui/pages/Drawer_comp.dart';
import 'package:mmsfa_flu/ui/pages/Lectures.dart';
import 'package:mmsfa_flu/ui/pages/login/LoginٍSignInPage.dart';
import 'package:mmsfa_flu/ui/pages/SplashScreen.dart';
import 'package:mmsfa_flu/ui/pages/login/Root_pages.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ui/pages/Classes.dart';
bool firstRun=true;
const firstRunKey= 'firstRun';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

//      firstRun? SplashScreen():
//      LoginSignInPage(),
       routes: <String ,WidgetBuilder>{
        '/landingpage':(BuildContext context)=> MyApp(),
        '/register':(BuildContext context)=> LoginSignInPage(),
         '/homepage':(BuildContext context)=> Classes(),
        },
      theme: ThemeData(primaryColor: Colors.indigo),
    );
  }

  Future<Widget> firstPage() async {
    if(firstRun){
      return Classes();
        //SplashScreen();
    }


    return RootPage(
        auth: Auth()
    );
  }
}


