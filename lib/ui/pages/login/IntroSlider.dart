import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';

class IntroSlider extends StatelessWidget {
  final bool isStudent;
  final Function onTabDone;

  const IntroSlider({Key key, this.isStudent, this.onTabDone})
      : super(key: key);

  List<PageViewModel> getStudentPages() => [
    PageViewModel(
      pageColor: Colors.white,
      body: Text(
        'Mobile Managment System For Attendent Student ',
        style: TextStyle(color: Colors.indigo),
      ),
      title: Text(
        'MMSFAS',
        style: TextStyle(color: Colors.indigo),
      ),
      mainImage: Image.asset(
        'assets/ar-icons-school.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
    ),
    PageViewModel(
      pageColor: Colors.white,
      body: Text(
        'Login With Your University Email ',
        style: TextStyle(color: Colors.indigo),
      ),
      title: Text(
        'Step 1',
        style: TextStyle(color: Colors.indigo),
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
        'Add Your Information',
        style: TextStyle(color: Colors.indigo),
      ),
      title: Text(
        'Step 2',
        style: TextStyle(color: Colors.indigo),
      ),
      mainImage: Image.asset(
        'assets/icon.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
    ),
      ];

  List<PageViewModel> getTeacherPages() => [
        PageViewModel(
          pageColor: Colors.white,
          body: Text(
            'Mobile Managment System For Attendent Student ',
            style: TextStyle(color: Colors.indigo),
          ),
          title: Text(
            'MMSFAS',
            style: TextStyle(color: Colors.indigo),
          ),
          mainImage: Image.asset(
            'assets/ar-icons-school.png',
            height: 285.0,
            width: 285.0,
            alignment: Alignment.center,
          ),
        ),
        PageViewModel(
          pageColor: Colors.white,
          body: Text(
            'Login With Your University Email ',
            style: TextStyle(color: Colors.indigo),
          ),
          title: Text(
            'Step 1',
            style: TextStyle(color: Colors.indigo),
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
            'Add your classes',
            style: TextStyle(color: Colors.indigo),
          ),
          title: Text(
            'Step 2',
            style: TextStyle(color: Colors.indigo),
          ),
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
                isStudent ? getStudentPages() : getTeacherPages(),
                onTapDoneButton: () {
                  onTabDone();
                },
                pageButtonTextStyles: TextStyle(
                  color: Colors.indigo,
                  fontSize: 18.0,
                ),
              )),
    );
  }
}
