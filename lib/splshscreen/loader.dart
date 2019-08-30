import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Splash_Screen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: SpinKitPouringHourglass(
              color: Colors.indigo,
              size: 80.0,
              duration:  Duration(seconds: 5),
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
