import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mmsfa_flu/database/controller/Auth.dart';
import 'package:mmsfa_flu/ui/pages/QrGenerator.dart';
import 'package:mmsfa_flu/ui/pages/login/Login%D9%8DSignInPage.dart';
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

//  File galleryFile;
//  imageSelectorGallery() async {
//    galleryFile = await ImagePicker.pickImage(
//      source: ImageSource.gallery,
//    );
//    if(img !=null){
//      galleryFile=File.img;
//    }
//
//    print("You selected gallery image : " + galleryFile.path);
//    setState(() {});
//  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DrawerHeader(
              child: Column(
                children: <Widget>[
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
                    height: 2.0,
                  ),
                  Text('ayatprogram@gmail.com', style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold, color: Colors.indigo),
                  ),

                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            FlatButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QrGenerator(),
                  ),
                );
              },
              child: Text('- QR Generate', style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold, color: Colors.indigo),),
            ),
            SizedBox(
              height: 2.0,
            ),

            FlatButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('userPreference');
                await Future.delayed(Duration(seconds: 2));

                Navigator.of(context).pushAndRemoveUntil(
                  // the new route
                  MaterialPageRoute(
                    builder: (BuildContext context) => LoginSignInPage(auth: Auth(),),
                  ),
                      (Route route) => false,
                );
              },
              child: Text('-Logout', style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold, color: Colors.indigo),),
            ),
          ],
        ),
      ),
    );

  }

}
