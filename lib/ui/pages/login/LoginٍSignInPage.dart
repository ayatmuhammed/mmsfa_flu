import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import '../Classes.dart';
import 'package:mmsfa_flu/database/controller/Auth.dart';
import 'package:mmsfa_flu/database/controller/DataBofLogin.dart';

class LoginSignInPage extends StatefulWidget {
  final BaseAuth auth;

  const LoginSignInPage({Key key, this.auth}) : super(key: key);

  @override
  _LoginSignInPageState createState() => _LoginSignInPageState();
}

class _LoginSignInPageState extends State<LoginSignInPage> {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  String _email, _password;

  login() async {
    final formData = formState.currentState;
    if (formData.validate()) {
      formData.save();

      String uid = await widget.auth.signIn(_email, _password);

      if (uid == null || uid.isEmpty)
        uid = await widget.auth.signUp(_email, _password);

      FirebaseUser user = await widget.auth.getCurrentUser();
      if (user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Classes(user: user)));
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    //now i build the user interface
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(50.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Form(
              key: formState,
              child: Container(
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Colors.indigo,
                          ),
                          hintText: 'Email'),
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Enter Your Email';
                        } else if (val.length < 5) {
                          return 'error';
                        } else
                          return null;
                      },
                      onSaved: (val) {
                        _email = val;
                      },
                    ),

                    // sizedBox it give space between more widget
                    SizedBox(
                      height: 15.0,
                    ),

                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.lock,
                            color: Colors.indigo,
                          ),
                          hintText: 'Password'),
                      // controller: _passWordController,
                      validator: (val) {
                        if (val.isEmpty) {
                          return 'Enter Your Password';
                        } else if (val.length < 5) {
                          return 'error';
                        } else
                          return null;
                      },

                      onSaved: (val) {
                        _password = val;
                      },
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                    MaterialButton(
                      child:
                          Text('Login', style: TextStyle(color: Colors.white)),
                      color: Colors.indigo,
                      onPressed: () {
//                        Navigator.of(context).pushNamed('/homepage');
//                        FirebaseAuth.instance
//                            .createUserWithEmailAndPassword(
//                                email: _email, password: _password)
//                            .then((signedUser) {
//                          UserToDatabase().addNewUser(signedUser, context);
//                        }).catchError((e) {
//                          print(e);
//                        });
                        login();
                      },
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 25.0)),
                    _signInButton(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return Classes();
              },
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.indigoAccent[100]),
          borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage("assets/google_logo.png"), height: 20.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Sign in with Google',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.indigo,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
