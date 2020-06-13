import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

class StudyClassModel{
  String classId;
  String className;

  StudyClassModel(this.classId, this.className);

  StudyClassModel.fromSnapshot(DocumentSnapshot snapshot):
      classId= snapshot.documentID,
      className= snapshot.data[ClassesCollection.CLASS_NAME_FIELD];

  Map<String, dynamic> toJson() => {
    ClassesCollection.CLASS_NAME_FIELD: className,
    };

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