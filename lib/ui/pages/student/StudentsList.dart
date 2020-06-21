//her i show all student that i will added it
import 'dart:ffi';

import 'package:mmsfa_flu/database/viewModels/ScanScreenViewModel.dart';
import 'package:mmsfa_flu/ui/cards/StudentCard.dart';
import 'package:provider/provider.dart';
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

class StudentsList extends StatefulWidget {
  final StudyClassModel classModel;

  const StudentsList(this.classModel);

  @override
  _StudentsListState createState() => _StudentsListState();
}

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
                  final studentModel = items[position];

                  final lectureModel = widget.classModel.lastLecture;

                  bool isAttended = isStudentAttended(studentModel);
                  if (!isAttended && !lectureTimeUp(lectureModel)) {
                    isAttended = null;
                  }

                  return StudentCard(
                    position: position + 1,
                    name: studentModel.username,
                    onDeletePressed: () =>
                        _deleteStudent(context, studentModel),
                    isAttended: isAttended,
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

  bool isStudentAttended(StudentModel studentModel) {
    final isAttended = widget.classModel.lastLecture.attendedStudentIds
            .where((studentId) => studentId == studentModel.userId)
            .length >
        0;

    return isAttended;
  }

  bool lectureTimeUp(LectureModel lectureModel) {
    return DateTime.now().difference(lectureModel.startDate).inMinutes >=
        LECTURE_TIME_LIMIT;
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
      isScrollControlled: true,
      builder: (BuildContext context) => AddStudentBottomSheet(),
    );

    if (studentEmail == null || studentEmail.isEmpty) return;
    viewModel.addStudent(studentEmail);
  }
}
