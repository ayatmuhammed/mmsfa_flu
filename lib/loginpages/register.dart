import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mmsfa_flu/utils/usertodatabase.dart';

class  RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State< RegisterPage> {
  //user need to input the email and password to i need to text editing
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passWordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    //now i build the user interface
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(14.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(icon: Icon(Icons.email)),
              controller: _emailController,
            ),
            // sizedBox it give space between more widget
            SizedBox(
              height: 15.0,
            ),
            TextField(
              decoration: InputDecoration(icon: Icon(Icons.vpn_key)),
              controller: _passWordController,
            ),
            SizedBox(
              height: 15.0,
            ),
            MaterialButton(
              child: Text('register', style: TextStyle(color: Colors.white)),
              color: Colors.indigo,
              onPressed: () {
                FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: _emailController.text, password: _passWordController.text).then((signedUser){
                  UserToDatabase().addNewUser(signedUser, context);
                }).catchError((e){
                  print(e);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

