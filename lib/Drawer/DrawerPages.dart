//import 'dart:io';
//
//import 'package:firebase_storage/firebase_storage.dart';
//import 'package:flutter/material.dart';
//import 'package:image_picker/image_picker.dart';
//class  ProfileImage extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MyProfileImage();
//  }
//}
//class MyProfileImage extends StatefulWidget {
//  @override
//  _MyProfileImageState createState() => _MyProfileImageState();
//}
//
//class _MyProfileImageState extends State<MyProfileImage> {
//  File _image;
//
//
//  @override
//  Widget build(BuildContext context) {
//   Future getImage()async{
//     var image=await ImagePicker.pickImage(source: ImageSource.gallery);
//
//     setState(() {
//       _image=image;
//       print('ImagePath $_image');
//     });
//   }
//
//  }
//
//  Future uploadPicture(BuildContext context)async{
//    String fileName = basename(_image.path);
//    StorageReference firebaseStorageRef = FirebaseStorage.instance.ref().child(fileName);
//    StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
//    StorageTaskSnapshot taskSnapshot=await uploadTask.onComplete;
//    setState(() {
//      print("Profile Picture uploaded");
//      Scaffold.of(context).showSnackBar(
//          SnackBar(content: Text('Profile Picture Uploaded')));
//    }
//    );
//
//    return Scaffold(
//
//    );
//
//}
//
//
//


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