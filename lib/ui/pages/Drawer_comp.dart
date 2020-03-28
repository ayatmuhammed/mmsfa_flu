import 'package:flutter/material.dart';
import 'package:smart_flare/actors/smart_flare_actor.dart';

class DrawerComp extends StatefulWidget {
  @override
  _DrawerCompState createState() => _DrawerCompState();
}

class _DrawerCompState extends State<DrawerComp> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          DrawerHeader(
            child: Text("jooo"),
          ),

        ],
      ),
    );

  }
}