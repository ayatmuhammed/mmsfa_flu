import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';
import 'package:mmsfa_flu/database/viewModels/ClassesViewModel.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/StudyClassModel.dart';
import 'package:mmsfa_flu/database/model/TeacherModel.dart';
import 'package:mmsfa_flu/database/model/UserModel.dart';
import 'package:mmsfa_flu/database/model/class.dart';
import 'package:mmsfa_flu/ui/cards/ClassCard.dart';
import 'package:mmsfa_flu/ui/dialog/ClassBottomSheet.dart';
import 'package:mmsfa_flu/ui/pages/Drawer_comp.dart';
import 'package:mmsfa_flu/ui/pages/QrGenerator.dart';
import 'package:mmsfa_flu/ui/pages/ScanScreen.dart';
import 'package:mmsfa_flu/ui/pages/student/EditStudentInformation.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

import '../../main.dart';

class ClassesScreen extends StatefulWidget {
  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  final isTeacher = false; // TODO: change this
  // TODO: change this
  final documentId =
      'kNXrxODnpYQAQXyejFsysa3Pgmp1'; // teacher: 9XaPOZ6oREN0or64tjcynOuEVHk2, student: kNXrxODnpYQAQXyejFsysa3Pgmp1

  ClassesViewModel viewModel = ClassesViewModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: DrawerComp(),
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text(
            'Your Classes',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          centerTitle: true,
        ),
        body: FutureBuilder<DocumentSnapshot>(
          future: Firestore.instance
              .collection(
                  isTeacher ? TeachersCollection.NAME : StudentsCollection.NAME)
              .document(documentId)
              .get(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: SpinKitChasingDots(
                  color: Colors.indigo,
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData) {
              return Center(child: Text("Error: No data"));
            } else {
              DocumentSnapshot documentSnapshot = snapshot.data;
              logger.i("documentSnapshot: ${documentSnapshot.data}");

              UserModel userModel = isTeacher
                  ? TeacherModel.fromSnapshot(documentSnapshot)
                  : StudentModel.fromSnapshot(documentSnapshot);

              logger.i(userModel.toString());

              return ClassesList(userModel: userModel, viewModel: viewModel);
            }
          },
        ),
        floatingActionButton: isTeacher
            ? FloatingActionButton(
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                backgroundColor: Colors.indigo,
                onPressed: () => showAddClassBottomSheet(context),
              )
            : SizedBox(),
      ),
    );
  }

  Future<void> showAddClassBottomSheet(BuildContext context) async {
    final className = await showModalBottomSheet<String>(
      context: context,
      builder: (BuildContext context) => ClassBottomSheet(),
    );

    viewModel.addClass(StudyClassModel("", className));
  }
}

class ClassesList extends StatelessWidget {
  final UserModel userModel;
  final ClassesViewModel viewModel;

  const ClassesList({Key key, @required this.userModel, this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<StudyClassModel>>(
      stream: viewModel.getClasses(userModel),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: SpinKitChasingDots(
              color: Colors.indigo,
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData) {
          return Center(child: Text("You have no classes!"));
        } else {
          List<StudyClassModel> studentClasses = snapshot.data;

          return ListView.builder(
            itemCount: studentClasses.length,
            itemBuilder: (BuildContext context, int index) {
              final studyClass = studentClasses[index];
              return ClassCard(
                name: studyClass.className,
                position: index + 1,
                canEdit: userModel is TeacherModel,
                onEditPressed: () =>
                    showEditClassBottomSheet(context, studyClass),
                onDeletePressed: () {
                  viewModel.deleteClass(studyClass.classId);
                },
                onCardPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => userModel is TeacherModel
                            ? QrGenerator(
                                classModel: studyClass,
                                userId: userModel.userId,
                              )
                            : ScanScreen(
                                classRef: getClassRef(index),
                              )),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  DocumentReference getClassRef(int index) =>
      (userModel as StudentModel).classRefs[index];

  Future<void> showEditClassBottomSheet(
      BuildContext context, StudyClassModel studyClassModel) async {
    final className = await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) => ClassBottomSheet(
        className: studyClassModel.className,
      ),
    );
    if (className == null || className.isEmpty) return;

    studyClassModel.className = className;
    viewModel.addClass(studyClassModel);
  }
}
