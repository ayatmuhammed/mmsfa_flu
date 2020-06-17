import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:mmsfa_flu/database/viewModels/Auth.dart';
import 'package:mmsfa_flu/ui/pages/ClassesScreen.dart';
import 'package:mmsfa_flu/ui/pages/login/Root_pages.dart';

//bool firstRun=true;
//const firstRunKey= 'firstRun';
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SharedPreferences ref= await SharedPreferences.getInstance();
  // firstRun=ref.getBool(firstRunKey)?? true;
  // ref.setBool(firstRunKey, false);
  runApp(MyApp());
}

final Logger logger = Logger();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootPage(auth: Auth()),
      theme: ThemeData(primaryColor: Colors.indigo),
    );
  }
}
