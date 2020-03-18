import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:mmsfa_flu/loginpages/signin.dart';

class MySlider extends StatelessWidget {
  //making list of pages needed to pass in IntroViewsFlutter constructor.
  final pages = [
    PageViewModel(
        pageColor: Colors.white,
        body: Text(
          'Mobile Managment System For Attendent Student ',style: TextStyle(color: Colors.indigo),
        ),
        title: Text(
          'MMSFAS',style: TextStyle(color: Colors.indigo),
        ),
        mainImage: Image.asset('assets/ar-icons-school.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        ),
    ),
    PageViewModel(
      pageColor: Colors.white,
      body: Text(
        'Login With Your University Email ',style: TextStyle(color: Colors.indigo),
      ),
      title: Text('Step 1',style: TextStyle(color: Colors.indigo),
      ),
      mainImage: Image.asset(
        'assets/icon.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      pageColor: Colors.white,
      body: Text(
        'Add your classes',style: TextStyle(color: Colors.indigo),
      ),
      title: Text('Step 2',style: TextStyle(color: Colors.indigo),),
      mainImage: Image.asset(
        'assets/icon.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => IntroViewsFlutter(
          pages,
          onTapDoneButton: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LoginSignInPage(),
              ),
            );
          },
          pageButtonTextStyles: TextStyle(
            color: Colors.indigo,
            fontSize: 18.0,
          ),

        ),
      ),
    );
  }
}
