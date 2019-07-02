import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    //now i build the user interface
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('add new class'),
            SizedBox(
              height: 15.0,
            ),
            MaterialButton(
              child: Text('logout', style: TextStyle(color: Colors.white)),
              color: Colors.indigo,
              onPressed: () {
            FirebaseAuth.instance.signOut().then((value){
              Navigator.of(context).pushReplacementNamed('/landingpage').catchError((e){
                print(e);
              });
            });
              },
            ),
          ],
        ),
      ),
    );
  }
}
