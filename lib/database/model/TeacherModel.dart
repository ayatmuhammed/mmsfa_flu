import 'package:cloud_firestore/cloud_firestore.dart';


import 'UserModel.dart';

class TeacherModel extends UserModel {
  TeacherModel.fromSnapshot(DocumentSnapshot snapshot)
      : super.fromSnapshot(snapshot);

  @override
  String toString() {
    return 'TeacherModel{teacherId: $userId, teacherName: $username}';
  }
}
