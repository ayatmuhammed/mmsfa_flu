import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mmsfa_flu/utils/usertodatabase.dart';
//import 'package:mmsfa_flu/mainpages/ui/listview_student.dart';

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
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

            TextField(
              decoration: InputDecoration(icon: Icon(Icons.email,color: Colors.indigo,)),
              controller: _emailController,
            ),
            // sizedBox it give space between more widget
            SizedBox(
              height: 15.0,
            ),
            TextField(
              decoration: InputDecoration(icon: Icon(Icons.vpn_key,color: Colors.indigo,)),
              controller: _passWordController,
            ),
            SizedBox(
              height: 60.0,
            ),
            MaterialButton(
              child: Text('Login', style: TextStyle(color: Colors.white)),
              color: Colors.indigo,
              onPressed: () {
                Navigator.of(context).pushNamed('/homepage');
               // print ("onClick");
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

