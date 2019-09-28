import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mmsfa_flu/Slider_pages/IntroSliderPage.dart';


class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  final duration= Duration(seconds: 3);
  @override
  void initState() {
    super.initState();
    Timer(duration, ()=> Navigator.push(context, MaterialPageRoute(builder :(context)=> MySlider())));
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SpinKitPouringHourglass(
            color: Colors.indigo,
            size: 80.0,
            duration: duration ,

          ),

        ),

      ),

    );

  }
}
//SpinKitChasingDots(color: Colors.white),
// SpinKitWave(color: Colors.white, type: SpinKitWaveType.center)
//  SpinKitThreeBounce(color: Colors.white)
//    SpinKitWanderingCubes(color: Colors.white)
//  SpinKitWanderingCubes(color: Colors.white, shape: BoxShape.circle)
//    SpinKitCircle(color: Colors.white)
// SpinKitCubeGrid(size: 51.0, color: Colors.white)

//   SpinKitFadingGrid(color: Colors.white, shape: BoxShape.rectangle)
//   SpinKitHourGlass(color: Colors.white)
