import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class StudyClassModel{
  String classId;
  String className;

  StudyClassModel.fromSnapshot(DocumentSnapshot snapshot):
      classId= snapshot.documentID,
      className= snapshot.data["className"];

  @override
  String toString() {
    return 'StudyClassModel{classId: $classId, className: $className}';
  }
}


class Lecture{
  String lectureId;
  DateTime startDate;
  List<String> attendedStudentRefs;

  Lecture.fromSnapshot(DataSnapshot snapshot):
        lectureId= snapshot.key,
        startDate= snapshot.value["startDate"],
        attendedStudentRefs= snapshot.value["attendedStudentRefs"];
}