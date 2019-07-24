//here i show the information of student in update case
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mmsfa_flu/mainpages/model/class.dart';

// here i will translate the information from listView_student to the student_screen
//so i use the constructor

class InformationScreen extends StatefulWidget {
  final Todo todo;
  InformationScreen(this.todo);
  @override
  _InformationScreenState createState() => _InformationScreenState();
}


final studentReference=FirebaseDatabase.instance.reference().child('todo');


class _InformationScreenState extends State<InformationScreen> {
  //user input the data so we need to controller
  TextEditingController _lecturecontroller;
  TextEditingController _departmentcontroller;
  TextEditingController _branchcontroller;
  TextEditingController _teachercontroller;
  //now we int the information by using int function


  @override
  void initState() {

    super.initState();
    _lecturecontroller =new TextEditingController(text: widget.todo.lecture);
    _departmentcontroller=new TextEditingController(text: widget.todo.department);
    _branchcontroller=new TextEditingController(text: widget.todo.branch);
    _teachercontroller=new TextEditingController(text: widget.todo.teacher);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop('/homepage'),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: Text('Update details of Class',style: TextStyle(fontSize: 18.0),),
//        title: Text('student'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.all(5.0 ),
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[TextField(
            style: TextStyle(fontSize:16.0,color: Colors.indigo ),
            controller: _lecturecontroller,
            decoration: InputDecoration(icon: Icon(Icons.edit),labelText: 'lecture',),
          ),
            //  Padding(padding: EdgeInsets.all(5.0)),
            TextField(
              style: TextStyle(fontSize:16.0,color: Colors.indigo ),
              controller: _departmentcontroller,
              decoration: InputDecoration(icon: Icon(Icons.edit),labelText: 'department'),
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
              controller: _teachercontroller,
              decoration: InputDecoration(icon: Icon(Icons.edit),labelText: 'teacher'),
            ),
            //Padding(padding: EdgeInsets.all(5.0)),
//            TextField(
//              style: TextStyle(fontSize:16.0,color: Colors.indigo ),
//              controller: _lecturecontroller,
//              decoration: InputDecoration(icon: Icon(Icons.person),labelText: 'lecture'),
//            ),
            //Padding(padding: EdgeInsets.all(5.0)),

            FlatButton(
                onPressed:(){
                  if ((widget.todo.key !=null)){
                    studentReference.child(widget.todo.key).set({
                      'lecture':_lecturecontroller.text,
                      'department':_departmentcontroller.text,
                      'branch':_branchcontroller.text,
                      'teacher':_teachercontroller.text,
                    }).then((_){
                      Navigator.pop(context);
                    });
                  }else{
                    studentReference.push().set({
                      'lecture':_lecturecontroller.text,
                      'department':_departmentcontroller.text,
                      'branch':_branchcontroller.text,
                      'teacher':_teachercontroller.text,
                    }).then((_) {
                      Navigator.pop(context);
                    });

                  }
                },
                child: (widget.todo.key !=null) ? Text('Update'):Text('Add')),
          ],
        ),
      ),
    );
  }
}
