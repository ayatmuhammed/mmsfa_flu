//her i show all student that i will added it
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mmsfa_flu/database/model/Student.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/StudyClassModel.dart';
import 'package:mmsfa_flu/database/model/UserModel.dart';
import 'package:mmsfa_flu/database/viewModels/StudentsViewModel.dart';
import 'package:mmsfa_flu/ui/dialog/AddStudentBottomSheet.dart';
import 'package:mmsfa_flu/ui/pages/QrGenerator.dart';
import 'package:mmsfa_flu/ui/pages/student/AddStudentInformation.dart';
import 'package:mmsfa_flu/ui/pages/student/StudentInformation.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';
import 'package:provider/provider.dart';

class StudentsList extends StatefulWidget {
  final StudyClassModel classModel;

  const StudentsList(this.classModel);

  @override
  _StudentsListState createState() => _StudentsListState();
}

final studentReference = FirebaseDatabase.instance.reference().child('student');

class _StudentsListState extends State<StudentsList> {
//now i design the ui to the user
  StudentsViewModel viewModel;

  @override
  void didChangeDependencies() {
    final userId = context.read<UserModel>().userId;
    viewModel = StudentsViewModel(widget.classModel, userId);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student DB',
      home: Scaffold(
        appBar: buildAppBar(context),
        body: StreamBuilder<List<StudentModel>>(
          stream: viewModel.getClassStudentsStream(),
          builder: (BuildContext context,
              AsyncSnapshot<List<StudentModel>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: SpinKitChasingDots(
                  color: Colors.indigo,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data.isEmpty) {
              return Center(child: Text("You have no students!"));
            }
            final items = snapshot.data;

            return Center(
              child: ListView.builder(
                itemCount: items.length,
                padding: EdgeInsets.only(top: 15.0),
                itemBuilder: (context, position) {
                  return Column(
                    children: <Widget>[
                      Divider(color: Colors.indigo, height: 6.0),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              //now i want to display the name of user in list
                              title: Text(
                                '${items[position].username}',
                                style: TextStyle(
                                  color: Colors.indigo,
                                  backgroundColor: Colors.purple[50],
                                  fontSize: 22.0,
                                ),
                              ),
//                              subtitle: Text(
//                                '${items[position].department}',
//                                style: TextStyle(
//                                  color: Colors.amber,
//                                  //  backgroundColor: Colors.purple[50],
//                                  fontSize: 14.0,
//                                ),
//                              ),
                              leading: CircleAvatar(
                                backgroundColor: Colors.indigo,
                                radius: 14.0,
                                child: Text(
                                  '${position + 1}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    //  backgroundColor: Colors.purple[50],
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                              onTap: () {
                                _navigateStudentInformation(
                                    context, items[position]);
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              _deleteStudent(context, items[position]);
                            },
                          ),
//                          IconButton(
//                            icon: Icon(
//                              Icons.edit,
//                              color: Colors.indigo,
//                            ),
//                            onPressed: () {
////                              _navigateStudent(context, items[position])
//                            },
//                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.indigo,
          onPressed: () => _addStudent(context),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: true,
      leading: new IconButton(
        icon: new Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop('/homepage'),
      ),
      actions: <Widget>[
        FlatButton(
          color: Colors.white,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    QrGenerator(classModel: widget.classModel),
              ),
            );
          },
          child: Text(
            '- QR Generate',
            style: TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Colors.indigo),
          ),
        ),
      ],
      backgroundColor: Colors.indigo,
      title: Text('Your Students', style: TextStyle(color: Colors.white)),
//          title:Text('Add Your Student',style: TextStyle(color: Colors.white)
//          ),
      centerTitle: true,
    );
  }

  void _deleteStudent(BuildContext context, StudentModel studentModel) async {
    viewModel.removeStudent(studentModel);
  }

  void _navigateStudent(BuildContext context, Student student) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddStudentInformation(student)),
    );
  }

  void _navigateStudentInformation(
      BuildContext context, StudentModel studentModel) async {
//    await Navigator.push(
//      context,
//      MaterialPageRoute(builder: (context) => StudentInformation(studentModel)),
//    );
  }

  void _addStudent(BuildContext context) async {
    final studentEmail = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => AddStudentBottomSheet(),
    );

    if (studentEmail == null || studentEmail.isEmpty) return;
    viewModel.addStudent(studentEmail);
  }
}
