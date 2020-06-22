import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/UserModel.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';
import 'package:provider/provider.dart';

class DrawerComp extends StatefulWidget {
  @override
  _DrawerCompState createState() => _DrawerCompState();
}

class _DrawerCompState extends State<DrawerComp> {
  UserModel userModel;
  TextEditingController usernameController;
  bool _isImageUploading = false;

  cameraConnect() async {
    print('Picker is Called');
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      await uploadFile(img);
    }
  }

  Future uploadFile(File image) async {
    setState(() {
      _isImageUploading = true;
    });
    final collectionName = userModel is StudentModel
        ? StudentsCollection.NAME
        : TeachersCollection.NAME;

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('$collectionName/${userModel.userId}');
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) async {
      userModel.imageUrl = fileURL;

      await Firestore.instance
          .collection(collectionName)
          .document(userModel.userId)
          .updateData(userModel.toJson());

      setState(() {
        _isImageUploading = false;
      });
    });
  }

  @override
  void didChangeDependencies() {
    userModel = context.read<UserModel>();
    usernameController = TextEditingController(text: userModel.username);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final imageTop = MediaQuery.of(context).size.height * 0.15;

    return SafeArea(
      child: Drawer(
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 0.25,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ],
                    gradient: LinearGradient(
                        colors: <Color>[
                          Color(0xff3202b7),
                          Color(0xffffffff),
                        ],
                        begin: AlignmentDirectional.topCenter,
                        end: AlignmentDirectional.bottomCenter),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 100.0,
                    left: 32.0,
                    right: 32.0,
                  ),
                  child: TextField(
                    controller: usernameController,
                    style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                    onSubmitted: (value) async {
                      userModel.username = value;
                      final collectionName = userModel is StudentModel
                          ? StudentsCollection.NAME
                          : TeachersCollection.NAME;

                      await Firestore.instance
                          .collection(collectionName)
                          .document(userModel.userId)
                          .updateData(userModel.toJson());
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 24.0,
                    left: 32.0,
                    right: 32.0,
                  ),
                  child: Text(
                    userModel.email,
                    style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),
                Expanded(
                  child: Opacity(
                    opacity: 1,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(48.0),
                        child: Lottie.asset("assets/student.json"),
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                  },
                  child: Container(
                    color: Colors.black.withAlpha(20),
                    padding:
                        EdgeInsets.symmetric(vertical: 14.0, horizontal: 28.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 6.0),
                          child: RotatedBox(
                            quarterTurns: 2,
                            child: Icon(
                              FontAwesomeIcons.signOutAlt,
                              size: 20,
                            ),
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                        Text(
                          'Logout',
                          style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        Expanded(
                          child: SizedBox(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: imageTop,
              child: GestureDetector(
                onTap: () async {
                  await cameraConnect();
                },
                child: ClipOval(
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration:
                        BoxDecoration(color: Colors.white10, boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: Offset(0, 1),
                      ),
                    ]),
                    child: _isImageUploading
                        ? Lottie.asset("assets/loading.json")
                        : Image.network(
                            userModel.imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Lottie.asset("assets/loading.json");
                            },
                          ),
                  ),
                ),
              ),
            ),
            Positioned(
                top: 32,
                child: Text(
                  'User Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
