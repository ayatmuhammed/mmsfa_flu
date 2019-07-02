import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
              child: Text('Login', style: TextStyle(color: Colors.white)),
              color: Colors.indigo,
              onPressed: () {
                FirebaseAuth.instance.signInWithEmailAndPassword(
                    email: _emailController.text, password: _passWordController.text).then((FirebaseUser user){
                      //pushReplacementNamed can not back to home page
                  Navigator.of(context).pushReplacementNamed('/home').catchError((e){
                    print(e);
                  });
                });
              },
            ),
            SizedBox(
              height: 15.0,
            ),
            Text('Don\'t have an account'),
            SizedBox(
              height: 15.0,
            ),
            MaterialButton(
              child: Text('register', style: TextStyle(color: Colors.white)),
              color: Colors.indigo,
              onPressed: () {
                //pushNamed can back to home
                Navigator.of(context).pushNamed('/register');
              },
            ),
          ],
        ),
      ),
    );
  }
}
