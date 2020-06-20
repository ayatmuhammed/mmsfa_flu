import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mmsfa_flu/database/viewModels/ClassesViewModel.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/StudyClassModel.dart';
import 'package:mmsfa_flu/database/model/TeacherModel.dart';
import 'package:mmsfa_flu/database/model/UserModel.dart';
import 'package:mmsfa_flu/ui/cards/ClassCard.dart';
import 'package:mmsfa_flu/ui/dialog/ClassBottomSheet.dart';
import 'package:mmsfa_flu/ui/pages/Drawer_comp.dart';
import 'package:mmsfa_flu/ui/pages/ScanScreen.dart';
import 'package:mmsfa_flu/ui/pages/student/StudentsList.dart';
import 'package:provider/provider.dart';

class ClassesScreen extends StatefulWidget {
  @override
  _ClassesScreenState createState() => _ClassesScreenState();
}

class _ClassesScreenState extends State<ClassesScreen> {
  ClassesViewModel viewModel;
  UserModel userModel;

  @override
  void didChangeDependencies() {
    userModel = Provider.of<UserModel>(context);
    viewModel = ClassesViewModel(userModel?.userId);
    super.didChangeDependencies();
  }

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
        body: ClassesList(userModel: userModel, viewModel: viewModel),
        floatingActionButton: userModel is TeacherModel
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
      isScrollControlled: true,
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
    return userModel == null
        ? Center(
            child: SpinKitChasingDots(
              color: Colors.indigo,
            ),
          )
        : StreamBuilder<List<StudyClassModel>>(
            stream: viewModel.getClassesStream(userModel),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: SpinKitChasingDots(
                    color: Colors.indigo,
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || (snapshot.data as List).isEmpty) {
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
                        viewModel.deleteClass(studyClass);
                      },
                      onCardPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => userModel is TeacherModel
                                  ? StudentsList(studyClass)
//                        QrGenerator(
//                                classModel: studyClass,
//                                userId: userModel.userId,
//                              )
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
