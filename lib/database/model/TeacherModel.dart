
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

import 'UserModel.dart';

class TeacherModel extends UserModel{

  TeacherModel.fromSnapshot(DocumentSnapshot snapshot)
      :super(
          userId: snapshot.documentID,
          username: snapshot.data[TeachersCollection.TEACHER_NAME_FIELD] ?? '');

  @override
  String toString() {
    return 'TeacherModel{teacherId: $userId, teacherName: $username}';
  }
}