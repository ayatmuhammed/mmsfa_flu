import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

import 'UserModel.dart';

class StudentModel extends UserModel {
//  String department;
//  String branch;
//  int stage;
  List<DocumentReference> classRefs;

  StudentModel.fromSnapshot(DocumentSnapshot snapshot)
      :
//        department = snapshot.data[StudentsCollection.CLASS_DEPARTMENT_FIELD] ??
//            'Unknown',
//        branch =
//            snapshot.data[StudentsCollection.CLASS_BRANCH_FIELD] ?? 'Unknown',
//        stage = snapshot.data[StudentsCollection.CLASS_STAGE_FIELD] ?? -1,
        classRefs = snapshot.data[StudentsCollection.CLASS_REFS_FIELD]
                ?.cast<DocumentReference>() ??
            [],
        super.fromSnapshot(snapshot);

  Map<String, dynamic> toJson() {
    final map = {
//      StudentsCollection.CLASS_DEPARTMENT_FIELD: department,
//      StudentsCollection.CLASS_BRANCH_FIELD: branch,
//      StudentsCollection.CLASS_STAGE_FIELD: stage,
      StudentsCollection.CLASS_REFS_FIELD: classRefs,
    };

    map.addAll(super.toJson());

    return map;
  }

  @override
  String toString() {
    return 'StudentModel{studentId: $userId, studentName: $username, classRefs: $classRefs}';
  }
}
