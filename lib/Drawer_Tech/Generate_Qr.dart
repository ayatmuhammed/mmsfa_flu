import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:qrscan/qrscan.dart' as scanner;


class GenerateQr extends StatefulWidget {
  @override
  _GenerateQrState createState() => _GenerateQrState();
}

class _GenerateQrState extends State<GenerateQr> {
  Uint8List bytes = Uint8List(0);
  TextEditingController _inputController;
  TextEditingController _outputController;

  @override
  initState() {
    super.initState();
    this._inputController = new TextEditingController();
    this._outputController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading:new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.indigo),
            onPressed: () => Navigator.of(context).pop('/homepage'),
          ),
          backgroundColor: Colors.white,
          title: Text('Qr Generator',style: TextStyle(color: Colors.indigo),
          ),
        ),
        backgroundColor: Colors.grey[300],
        body: Builder(
          builder: (BuildContext context) {
            return ListView(
              children: <Widget>[
                _qrCodeWidget(this.bytes, context),
                Container(
                  color: Colors.white ,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(padding:EdgeInsets.only(top: 10.0,bottom: 10.0)),
                      TextField(
                        controller: this._inputController,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.go,
                        onSubmitted: (value) => _generateBarCode(value),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.text_fields),
                          hintText: 'Please Input Your url of lecture',
                        ),
                      ),
                      this._buttonGroup(),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _qrCodeWidget(Uint8List bytes, BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        elevation: 6,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.verified_user, size: 18, color: Colors.green),
                  Text('  Generate Qrcode', style: TextStyle(fontSize: 15)),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 190,
                    child: bytes.isEmpty
                        ? Center(
                      child: Text('Empty code ... ', style: TextStyle(color: Colors.black38)),
                    )
                        : Image.memory(bytes),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7, left: 25, right: 25),
                    child:
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            child: Text(
                              'remove',
                              style: TextStyle(fontSize: 15, color: Colors.indigo),
                              textAlign: TextAlign.left,
                            ),
                            onTap: () => this.setState(() => this.bytes = Uint8List(0)),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: () async {
                              final success = await ImageGallerySaver.saveImage(this.bytes);
                              SnackBar snackBar;
                              if (success) {
                                snackBar = new SnackBar(content: new Text('Successful Preservation!'));
                                Scaffold.of(context).showSnackBar(snackBar);
                              } else {
                                snackBar = new SnackBar(content: new Text('Save failed!'));
                              }
                            },
                            child: Text(
                              'save',
                              style: TextStyle(fontSize: 15, color: Colors.indigo),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonGroup() {
    return Padding(
      padding: EdgeInsets.only(top: 25, left:50, right:50, bottom: 25),
      child:
    Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
           flex:1,
            child:  GestureDetector(
              onTap: ()async{
                _generateBarCode(this._inputController.text);
              },
              child: Text('Generate',style: TextStyle(color: Colors.red),),
            ),
          ),

        ],
      ),
    );
  }


  Future _generateBarCode(String inputCode) async {
    // get the the information we need inside bar code
    // convert to json
    Lecture fakeLecture= new Lecture("5b", "5", "4", "10:30", DateTime.sunday);

    
    Uint8List result = await scanner.generateBarCode(fakeLecture.toJson());
    this.setState(() => this.bytes = result);
  }

}


class Lecture{
  String lectureId;
  String stageId;
  String branchId;
  String time; // TODO : improve type
  int day;

  Lecture(this.lectureId, this.stageId, this.branchId, this.time,
      this.day);

  toJson() {
    return {
      "lectureId": lectureId,
      "stageId": stageId,
      " branchId":  branchId,
      "time" : time,
      "day" : day
    };
  }

  fromSnapShot(Map<String, dynamic> map){
    lectureId=map['lectureId'];
    stageId=map['stageId'];
    branchId=map['branchId'];
    time=map['time'];
    day=map['day'];

  }
}



List stages= ["One", "Two", "Three", "Four"];
List branches= ["Sw", "Ai", "Network", "Security"];






















//import 'dart:async';
//import 'dart:typed_data';
//import 'package:flutter/material.dart';
//import 'package:qrscan/qrscan.dart' as scanner;
//
//void main() {
//  runApp(QrScan());
//}
//
//class QrScan extends StatefulWidget {
//  @override
//  _QrScanState createState() => _QrScanState();
//}
//
//class _QrScanState extends State<QrScan> {
//  String barcode = '';
//  Uint8List bytes = Uint8List(200);
//
//  @override
//  initState() {
//    super.initState();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      home: Scaffold(
//        appBar: AppBar(
//          backgroundColor: Colors.white,
//          title: Text('Qrcode Scanner',style:TextStyle(color: Colors.indigo),),
//        ),
//        body: Center(
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//
//              RaisedButton(onPressed: _generateBarCode, child: Text("Scan"),color:Colors.indigo,),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//
//  Future _scan() async {
//    String barcode = await scanner.scan();
//    setState(() => this.barcode = barcode);
//  }
//
//  Future _scanPhoto() async {
//    String barcode = await scanner.scanPhoto();
//    setState(() => this.barcode = barcode);
//  }
//
//  Future _generateBarCode() async {
//    Uint8List result = await scanner.generateBarCode('https://github.com/leyan95/qrcode_scanner');
//    this.setState(() => this.bytes = result);
//  }
//}


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