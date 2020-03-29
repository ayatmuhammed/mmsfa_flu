import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intro_views_flutter/Models/page_view_model.dart';
import 'package:intro_views_flutter/intro_views_flutter.dart';
import 'package:mmsfa_flu/ui/pages/login/Login.dart';

class IntroSlider extends StatelessWidget {
  List<PageViewModel> getStudentPages() => [
    PageViewModel(
        pageColor: const Color(0xFF03A9F4),
        bubble: Image.asset('assets/air-hostess.png'),
        body: Text(
          'Haselfree  booking  of  flight  tickets  with  full  refund  on  cancelation',
        ),
        title: Text(
          'Flights',
        ),
        textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
        mainImage: Image.asset(
          'assets/airplane.png',
          height: 285.0,
          width: 285.0,
          alignment: Alignment.center,
        )),
    PageViewModel(
      pageColor: const Color(0xFF8BC34A),
      iconImageAssetPath: 'assets/waiter.png',
      body: Text(
        'We  work  for  the  comfort ,  enjoy  your  stay  at  our  beautiful  hotels',
      ),
      title: Text('Hotels'),
      mainImage: Image.asset(
        'assets/hotel.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
    PageViewModel(
      pageColor: const Color(0xFF607D8B),
      iconImageAssetPath: 'assets/taxi-driver.png',
      body: Text(
        'Easy  cab  booking  at  your  doorstep  with  cashless  payment  system',
      ),
      title: Text('Cabs'),
      mainImage: Image.asset(
        'assets/taxi.png',
        height: 285.0,
        width: 285.0,
        alignment: Alignment.center,
      ),
      textStyle: TextStyle(fontFamily: 'MyFont', color: Colors.white),
    ),
  ];


  List<PageViewModel> getTeacherPages() => [
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
      home:
      FutureBuilder(
          future:  isStudent(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting || !snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }


           return Builder(
              builder: (context) =>
                  IntroViewsFlutter(
                    snapshot.data? getStudentPages():getTeacherPages()
                  ,
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

            )
           );

          }

      ),


    );
  }

  Future<bool> isStudent() async {
   final user= await FirebaseAuth.instance.currentUser();
   if(user == null){
     // goto login
   }else{
     return user.email.contains("@Student");
   }

  }
}
