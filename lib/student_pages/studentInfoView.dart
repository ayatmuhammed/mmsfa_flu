import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mmsfa_flu/student_pages/Student.dart';
class StudentInformation extends StatefulWidget {
  final Student student;
  StudentInformation(this.student);
  @override
  _StudentInformationState createState() => _StudentInformationState();
}


final studentReference=FirebaseDatabase.instance.reference().child('student');


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
        title: Text('details of student',style: TextStyle(fontSize: 18.0)),
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(top:15.0 ),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            Text( widget.student.name,
              maxLines: 4,
              style: TextStyle(fontSize:16.0,color: Colors.indigo ),),
            Padding(padding: EdgeInsets.only(top: 8.0)),

            Text( widget.student.section,
              maxLines: 4,
              style: TextStyle(fontSize:16.0,color: Colors.indigo ),),
            Padding(padding: EdgeInsets.only(top: 8.0)),

            Text( widget.student.branch,
              maxLines: 4,
              style: TextStyle(fontSize:16.0,color: Colors.indigo ),),
            Padding(padding: EdgeInsets.only(top: 8.0)),

            Text( widget.student.stage,
              maxLines: 4,
              style: TextStyle(fontSize:16.0,color: Colors.indigo ),),
            Padding(padding: EdgeInsets.only(top: 8.0)),

            Text( widget.student.lecture,
              maxLines: 4,
              style: TextStyle(fontSize:16.0,color: Colors.indigo ),),
            Padding(padding: EdgeInsets.only(top: 8.0)),

          ],
        ),
      ),
    );
  }
}
