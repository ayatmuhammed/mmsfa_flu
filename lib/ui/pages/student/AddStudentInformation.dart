//here i show the information of student in update case
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mmsfa_flu/database/model/Student.dart';

// here i will translate the information from listView_student to the student_screen
//so i use the constructor

class AddStudentInformation extends StatefulWidget {
  final Student student;
  AddStudentInformation(this.student);
  @override
  _AddStudentInformationState createState() => _AddStudentInformationState();
}


final studentReference=FirebaseDatabase.instance.reference().child('student');


class _AddStudentInformationState extends State<AddStudentInformation> {
  //user input the data so we need to controller
  TextEditingController _namecontroller;
  TextEditingController _sectioncontroller;
  TextEditingController _branchcontroller;
  TextEditingController _stagecontroller;
  TextEditingController _lecturecontroller;
  //now we int the information by using int function


  @override
  void initState() {

    super.initState();
    _namecontroller =new TextEditingController(text: widget.student.name);
    _sectioncontroller=new TextEditingController(text: widget.student.section);
    _branchcontroller=new TextEditingController(text: widget.student.branch);
    _stagecontroller=new TextEditingController(text: widget.student.stage);
    _lecturecontroller=new TextEditingController(text: widget.student.lecture);
  }

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
        title: Text('add details of student',style: TextStyle(fontSize: 18.0)),
//        title: Text('student'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.all(5.0 ),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[TextField(
            style: TextStyle(
                fontSize:16.0,color: Colors.indigo ),
            controller: _namecontroller,
            decoration: InputDecoration(
              icon: Icon(Icons.person),labelText: 'name',
            ),
          ),
            //  Padding(padding: EdgeInsets.all(5.0)),
            TextField(
              style: TextStyle(fontSize:16.0,color: Colors.indigo ),
              controller: _sectioncontroller,
              decoration: InputDecoration(icon: Icon(Icons.edit),labelText: 'section'),
            ),
            //Padding(padding: EdgeInsets.all(5.0)),
            TextField(
              style: TextStyle(fontSize:16.0,color: Colors.indigo ),
              controller: _branchcontroller,
              decoration: InputDecoration(icon: Icon(Icons.edit),labelText: 'branch'),
            ),
            // Padding(padding: EdgeInsets.all(5.0)),
            TextField(
              style: TextStyle(fontSize:16.0,color: Colors.indigo ),
              controller: _stagecontroller,
              decoration: InputDecoration(icon: Icon(Icons.edit),labelText: 'stage'),
            ),
            //Padding(padding: EdgeInsets.all(5.0)),
            TextField(
              style: TextStyle(fontSize:16.0,color: Colors.indigo ),
              controller: _lecturecontroller,
              decoration: InputDecoration(icon: Icon(Icons.edit),labelText: 'lecture'),
            ),
            //Padding(padding: EdgeInsets.all(5.0)),

            FlatButton(
                onPressed:(){
                  if ((widget.student.id !=null)){
                    studentReference.child(widget.student.id).set({
                      'name':_namecontroller.text,
                      'section':_sectioncontroller.text,
                      'branch':_branchcontroller.text,
                      'stage':_stagecontroller.text,
                      'lecture':_lecturecontroller.text
                    }).then((_){
                      Navigator.pop(context, widget.student.id);
                    });
                  }else{
                    String key =studentReference.push().key;


                    studentReference.child(key).set({
                      'name':_namecontroller.text,
                      'section':_sectioncontroller.text,
                      'branch':_branchcontroller.text,
                      'stage':_stagecontroller.text,
                      'lecture':_lecturecontroller.text
                    }).then((_) {

                      Navigator.pop(context, key);
                    });

                  }
                },
                child: (widget.student.id !=null) ? Text('Update'):Text('Add')),
          ],
        ),
      ),
    );
  }
}
