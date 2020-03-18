import 'package:flutter/material.dart';

class DrawerComp extends StatefulWidget {
  @override
  _DrawerCompState createState() => _DrawerCompState();
}

class _DrawerCompState extends State<DrawerComp> {
  @override
  Widget build(BuildContext context) {
    UserAccountsDrawerHeader(
      accountName: Text("ayat muhammed"),
      accountEmail: Text("ayatprogram@gmail.com"),
      currentAccountPicture: CircleAvatar(
        backgroundColor:Theme.of(context).platform==TargetPlatform.iOS?
        Colors.indigo:Colors.white,
        child: Text("A",style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
    return ListView(
      children: <Widget>[
      ],
    );
  }
}