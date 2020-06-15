import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mmsfa_flu/database/viewModels/Auth.dart';
import 'package:mmsfa_flu/ui/pages/QrGenerator.dart';
import 'package:mmsfa_flu/ui/pages/login/LoginSignInPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerComp extends StatefulWidget {
  @override
  _DrawerCompState createState() => _DrawerCompState();
}

class _DrawerCompState extends State<DrawerComp> {
  File image;
  cameraConnect() async {
    print('Picker is Called');
    File img = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      image = img;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 150.0, top: 10.0),
                  child: Text(
                    'More',
                    style: TextStyle(color: Colors.indigo, fontSize: 18.0),
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Divider(
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 8.0,
                ),
                CircleAvatar(
                  backgroundColor: Colors.indigo[100],
                  child: FlatButton(
                    onPressed: () {
                      Image.file(image);
                    },
                    child: Icon(Icons.image),
                  ),
                  radius: 60.0,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'ayatprogram@gmail.com',
                  style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Divider(
                  color: Colors.grey,
                  height: 10.0,
                ),
                SizedBox(
                  height: 2.0,
                ),
                FlatButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.remove('userPreference');
                    await Future.delayed(Duration(seconds: 2));

                    Navigator.of(context).pushAndRemoveUntil(
                      // the new route
                      MaterialPageRoute(
                        builder: (BuildContext context) => LoginSignInPage(
                          auth: Auth(),
                        ),
                      ),
                      (Route route) => false,
                    );
                  },
                  child: Text(
                    '-Logout',
                    style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
