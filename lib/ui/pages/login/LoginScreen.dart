import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/UserModel.dart';
import 'package:mmsfa_flu/database/viewModels/Auth.dart';
import 'package:mmsfa_flu/database/viewModels/DataBofLogin.dart';
import 'package:mmsfa_flu/ui/pages/ClassesScreen.dart';

import 'IntroSlider.dart';

class SplashScreen extends StatefulWidget {
  final BaseAuth baseAuth;

  const SplashScreen({Key key, this.baseAuth}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final duration = Duration(seconds: 2);
  bool animationCompleted = false;

  @override
  void initState() {
    super.initState();
    Timer(
      duration,
      () async {
        setState(() {
          animationCompleted = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        body: animationCompleted
            ? LoginBody(auth: widget.baseAuth)
            : Center(
                child: SpinKitWave(
                    color: Colors.indigo, type: SpinKitWaveType.center)),
      ),
    );
  }
}

class LoginBody extends StatefulWidget {
  final BaseAuth auth;

  const LoginBody({Key key, @required this.auth}) : super(key: key);

  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  String _email, _password;

  login(BuildContext context) async {
    final formData = formState.currentState;
    if (formData.validate()) {
      formData.save();

      String loginError = await widget.auth.signIn(_email, _password);

      if (loginError != null && loginError.contains("ERROR_USER_NOT_FOUND")) {
        final errorString = await widget.auth.signUp(_email, _password);

        if (errorString != null) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text(errorString)));
          return;
        }
      } else if (loginError != null) {
        Scaffold.of(context).showSnackBar(SnackBar(content: Text(loginError)));
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    //now i build the user interface
    return Container(
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
                  Builder(
                    builder: (BuildContext context) {
                      return MaterialButton(
                        child: Text('Login',
                            style: TextStyle(color: Colors.white)),
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
                          login(context);
                        },
                      );
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
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () async {
        try {
          await signInWithGoogle();
        } on Exception catch (e) {
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("Login failed: $e")));
        }
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
