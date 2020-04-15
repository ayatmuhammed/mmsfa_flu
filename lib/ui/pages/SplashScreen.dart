import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mmsfa_flu/database/controller/Auth.dart';
import 'package:mmsfa_flu/ui/pages/login/Login%D9%8DSignInPage.dart';
class SplashScreen extends StatefulWidget {
  final BaseAuth baseAuth;

  const SplashScreen({Key key, this.baseAuth}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  final duration= Duration(seconds: 3);
  @override
  void initState() {
    super.initState();
    Timer(duration, ()=> Navigator.push(context, MaterialPageRoute(builder :(context)=> LoginSignInPage(
      auth: widget.baseAuth,
    ))));
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SpinKitWave(color: Colors.indigo, type: SpinKitWaveType.center)

        ),

      ),

    );

  }
}

