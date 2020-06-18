import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mmsfa_flu/database/model/Student.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';

class StudentInformation extends StatefulWidget {
  final StudentModel studentModel;
  StudentInformation(this.studentModel);
  @override
  _StudentInformationState createState() => _StudentInformationState();
}

final studentReference = FirebaseDatabase.instance.reference().child('student');

class _StudentInformationState extends State<StudentInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop('/listview'),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: Text('details of student', style: TextStyle(fontSize: 18.0)),
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top: 15.0),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text(
              widget.studentModel.username,
              maxLines: 4,
              style: TextStyle(fontSize: 16.0, color: Colors.indigo),
            ),
            Padding(padding: EdgeInsets.only(top: 8.0)),
//            Text(
//              widget.studentModel.department,
//              maxLines: 4,
//              style: TextStyle(fontSize: 16.0, color: Colors.indigo),
//            ),
//            Padding(padding: EdgeInsets.only(top: 8.0)),
//            Text(
//              widget.studentModel.branch,
//              maxLines: 4,
//              style: TextStyle(fontSize: 16.0, color: Colors.indigo),
//            ),
//            Padding(padding: EdgeInsets.only(top: 8.0)),
//            Text(
//              widget.studentModel.stage.toString(),
//              maxLines: 4,
//              style: TextStyle(fontSize: 16.0, color: Colors.indigo),
//            ),
            Padding(padding: EdgeInsets.only(top: 8.0)),
            Text(
              "lecture",
              maxLines: 4,
              style: TextStyle(fontSize: 16.0, color: Colors.indigo),
            ),
            Padding(padding: EdgeInsets.only(top: 8.0)),
          ],
        ),
      ),
    );
  }
}
