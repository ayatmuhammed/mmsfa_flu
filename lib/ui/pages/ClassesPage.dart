import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:logger/logger.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/StudyClassModel.dart';
import 'package:mmsfa_flu/database/model/TeacherModel.dart';
import 'package:mmsfa_flu/database/model/UserModel.dart';
import 'package:mmsfa_flu/ui/pages/Drawer_comp.dart';
import 'package:mmsfa_flu/ui/pages/ScanScreen.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

import '../../main.dart';


class ClassesPage extends StatefulWidget {
  @override
  _ClassesPageState createState() => _ClassesPageState();
}


class _ClassesPageState extends State<ClassesPage> {
  final isTeacher= true; // TODO: change this

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
              .collection(isTeacher? TeachersCollection.COL_NAME : StudentsCollection.COL_NAME)
              .document('9XaPOZ6oREN0or64tjcynOuEVHk2')
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


              UserModel userModel =
              isTeacher?
              TeacherModel.fromSnapshot(documentSnapshot):
              StudentModel.fromSnapshot(documentSnapshot);

              logger.i(userModel.toString());

              return ClassesList(
                userModel: userModel,
              );
            }
          },
        ),
      ),
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
          List<StudyClassModel> studentClasses= snapshot.data;
          return ListView.builder(
            itemCount: studentClasses.length,
            itemBuilder: (BuildContext context, int index) =>
                ClassCard(
                  name: studentClasses[index].className,
                  position: index + 1,),
          );

        }
      },
    );
  }

  Future<List<StudyClassModel>> _getClasses() async {
    List<StudyClassModel> classes = List();

    if(userModel is StudentModel) {
      for (DocumentReference classDoc in (userModel as StudentModel).classRefs) {
        var classModel = StudyClassModel.fromSnapshot(await classDoc.get());
        classes.add(classModel);
      }
    }else {
      final querySnapshot= await Firestore.instance
          .collection(TeachersCollection.COL_NAME)
          .document(userModel.userId)
          .collection(ClassesCollection.COL_NAME)
          .getDocuments();

      classes = querySnapshot
          .documents
          .map((e)=> StudyClassModel.fromSnapshot(e))
          .toList();
    }
    logger.i(classes.toString());
    return classes;
  }
}

class ClassCard extends StatelessWidget {
  final int position;
  final String name;

  const ClassCard({
    Key key,
    this.name,
    this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 9.0, bottom: 20.0, left: 14.0, right: 14.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                    title: Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                      ),
                    ),
//                  subtitle: Text(
//                    '${classes[posi].department}',
//                    style: TextStyle(color: Colors.grey,
//                      fontSize: 14.0,
//                    ),
//                  ),
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.indigo,
                          radius: 14.0,
                          child: Text(
                            '$position',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              //QrScan(),
                              ScanScreen(),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
