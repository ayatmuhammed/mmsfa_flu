import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/UserModel.dart';
import 'package:mmsfa_flu/database/viewModels/Auth.dart';
import 'package:mmsfa_flu/ui/pages/Drawer_comp.dart';
import 'package:provider/provider.dart';

import 'IntroSlider.dart';
import 'file:///D:/Projects/Flutter/studentsAttendance/lib/ui/pages/login/LoginScreen.dart';

import '../ClassesScreen.dart';

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  FirebaseUser _firebaseUser;
  bool firstLogin = false;

  @override
  void initState() {
    super.initState();
    listenToUserUpdates();
  }

  void listenToUserUpdates() {
    widget.auth.getFirebaseUserStream().listen((user) {
      setState(() {
        if (user != null) {
          _firebaseUser = user;
        } else
          firstLogin = true;

        authStatus =
            user == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
  }

  Widget _buildWaitingScreen() {
    return Scaffold(
      body: Center(
          child:
              SpinKitWave(color: Colors.indigo, type: SpinKitWaveType.center)),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return _buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return SplashScreen(
          baseAuth: widget.auth,
        );
        break;
      case AuthStatus.LOGGED_IN:
        return StreamBuilder<UserModel>(
            stream: widget.auth.getUserModelStream(_firebaseUser),
            builder: (context, snapshot) {
              final userModel = snapshot.data;

              return Provider.value(
                value: userModel,
                child: firstLogin
                    ? IntroSlider(
                        isStudent: userModel is StudentModel,
                        onTabDone: () => setState(() {
                          firstLogin = false;
                        }),
                      )
                    : ClassesScreen(),
              );
            });
        break;
      default:
        return _buildWaitingScreen();
    }
  }
}
