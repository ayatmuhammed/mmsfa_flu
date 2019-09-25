
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//
//class DrawerView extends StatefulWidget {
//  @override
//  _DrawerViewState createState() => _DrawerViewState();
//}
//
//class _DrawerViewState extends State<DrawerView> {
//  final FirebaseAuth _auth = FirebaseAuth.instance;
//  FirebaseUser user;
//
//  @override
//  void initState() {
//    super.initState();
//    initUser();
//  }
//
//  initUser() async {
//    user = await _auth.currentUser();
//    setState(() {});
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
////      appBar: AppBar(
////        title: Text("this is an appbar yaay!"),
////      ),
//      drawer: Drawer(
//        elevation: 10.0,
//        child: ListView(
//          children: <Widget>[
//            UserAccountsDrawerHeader(
//              accountName: Text("${user?.displayName}"),
//              accountEmail: Text("${user?.email}"),
//              decoration: BoxDecoration(
//                image: DecorationImage(
//                  fit: BoxFit.fill,
//                  image: NetworkImage("${user?.photoUrl}"),
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//      body: Center(
//        child: Container(),
//      ),
//    );
//  }
//}