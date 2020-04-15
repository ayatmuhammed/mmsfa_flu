import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:qrscan/qrscan.dart' as scanner;

class ScanScreen extends StatefulWidget {
  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  String barcode = '';
  Uint8List bytes = Uint8List(200);

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              (Icons.arrow_back),
              color: Colors.indigo,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Qrcode Scanner',
            style: TextStyle(color: Colors.indigo),
          ),
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 200,
                height: 200,
                child: Image.memory(bytes),
              ),
              Text('RESULT  $barcode'),
              RaisedButton(
                  onPressed: _scan,
                  child: Text("Scan", style: TextStyle(color: Colors.indigo))),
              RaisedButton(
                  onPressed: () {
                    final studentReference = FirebaseDatabase.instance
                        .reference()
                        .child('todo/$barcode');
                    studentReference.set({"ff": barcode});
                  },
                  child: Text("Add To Lec",
                      style: TextStyle(color: Colors.indigo))),
            ],
          ),
        ),
      ),
    );
  }

  Future _scan() async {
    String barcode = await scanner.scan();
    setState(() => this.barcode = barcode);
  }
}
