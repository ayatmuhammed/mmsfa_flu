import 'package:flutter/material.dart';
import 'package:mmsfa_flu/database/controller/Auth.dart';
import 'package:mmsfa_flu/ui/pages/login/LoginٍSignInPage.dart';
import 'package:mmsfa_flu/ui/pages/login/Root_pages.dart';
import 'ui/pages/Classes.dart';

//bool firstRun=true;
//const firstRunKey= 'firstRun';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
 // SharedPreferences ref= await SharedPreferences.getInstance();
 // firstRun=ref.getBool(firstRunKey)?? true;
 // ref.setBool(firstRunKey, false);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home:RootPage(
          auth: Auth()
      ),
       routes: <String ,WidgetBuilder>{
        '/landingpage':(BuildContext context)=> MyApp(),
        '/register':(BuildContext context)=> LoginSignInPage(),
         '/homepage':(BuildContext context)=> Classes(),
        },
      theme: ThemeData(primaryColor: Colors.indigo),
    );
  }

}


