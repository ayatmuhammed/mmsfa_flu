import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

import 'UserModel.dart';

class StudentModel extends UserModel {
  String department;
  String branch;
  int stage;
  List<DocumentReference> classRefs;

  StudentModel.fromSnapshot(DocumentSnapshot snapshot)
      :department = snapshot.data["department"] ?? '',
        branch = snapshot.data["branch"] ?? '',
        stage = snapshot.data["stage"] ?? 0,
        classRefs = snapshot.data["classRefs"].cast<DocumentReference>() ?? [],
        super(
          userId: snapshot.documentID,
          username: snapshot.data["studentName"] ?? '');


  @override
  String toString() {
    return 'StudentModel{studentId: $userId, studentName: $username, department: $department, branch: $branch, stage: $stage, classRefs: $classRefs}';
  }

}
