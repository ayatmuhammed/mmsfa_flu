import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/StudyClassModel.dart';
import 'package:mmsfa_flu/database/model/TeacherModel.dart';
import 'package:mmsfa_flu/database/model/UserModel.dart';
import 'package:mmsfa_flu/database/model/class.dart';
import 'package:mmsfa_flu/ui/cards/ClassCard.dart';
import 'package:mmsfa_flu/ui/dialog/ClassBottomSheet.dart';
import 'package:mmsfa_flu/ui/pages/Drawer_comp.dart';
import 'package:mmsfa_flu/ui/pages/ScanScreen.dart';
import 'package:mmsfa_flu/ui/pages/student/EditStudentInformation.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

import '../../main.dart';

class ClassesPage extends StatefulWidget {
  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  final isTeacher = true; // TODO: change this

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
              .collection(isTeacher
                  ? TeachersCollection.COL_NAME
                  : StudentsCollection.COL_NAME)
              .document(// TODO: change this
                  '9XaPOZ6oREN0or64tjcynOuEVHk2') // teacher: 9XaPOZ6oREN0or64tjcynOuEVHk2, student: kNXrxODnpYQAQXyejFsysa3Pgmp1
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

              return ClassesList(
                userModel: userModel,
              );
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

  void showAddClassBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => ClassBottomSheet(),
    );
  }
}

class ClassesList extends StatelessWidget {
  final UserModel userModel;

  const ClassesList({Key key, @required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StudyClassModel>>(
      future: _getClasses(),
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
          return Center(child: Text("You have no classes!"));
        } else {
          List<StudyClassModel> studentClasses = snapshot.data;

          return ListView.builder(
            itemCount: studentClasses.length,
            itemBuilder: (BuildContext context, int index) {
              final className = studentClasses[index].className;
              return ClassCard(
                name: className,
                position: index + 1,
                canEdit: userModel is TeacherModel,
                onEditPressed: () =>
                    showAddClassBottomSheet(context, className),
                onDeletePressed: () {
                  logger.i("delete clicked");
                },
              );
            },
          );
        }
      },
    );
  }

  void showAddClassBottomSheet(BuildContext context, String className) {

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => ClassBottomSheet(
        className: className,
      ),
    );
  }

  Future<List<StudyClassModel>> _getClasses() async {
    List<StudyClassModel> classes = List();

    if (userModel is StudentModel) {
      for (DocumentReference classDoc
          in (userModel as StudentModel).classRefs) {
        var classModel = StudyClassModel.fromSnapshot(await classDoc.get());
        classes.add(classModel);
      }
    } else {
      final querySnapshot = await Firestore.instance
          .collection(TeachersCollection.COL_NAME)
          .document(userModel.userId)
          .collection(ClassesCollection.COL_NAME)
          .getDocuments();

      classes = querySnapshot.documents
          .map((e) => StudyClassModel.fromSnapshot(e))
          .toList();
    }
    logger.i(classes.toString());
    return classes;
  }
}
