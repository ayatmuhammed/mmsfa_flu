import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/StudyClassModel.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ScanScreenViewModel {
  String lectureUrl;
  bool isLoading = false;
  DocumentReference classRef;

  ScanScreenViewModel(this.classRef);

  Future<bool> selectAndScanImage() async {
    try {
      String encodedMsg = await scanner.scanPhoto();

      final parts = encodedMsg.split(",");
      if (parts[0] == classRef.documentID) {
        final docSnapshot = await classRef.get();
        final studyClass = StudyClassModel.fromSnapshot((docSnapshot));

        if (_qrIsValid(studyClass, parts)) {
          final studentReference = Firestore.instance
              .collection(StudentsCollection.NAME)
              .document("kNXrxODnpYQAQXyejFsysa3Pgmp1");

          studyClass.lastLecture.attendedStudentRefs.add(studentReference);
          await classRef.updateData(studyClass.lastLecture.toJson());

          lectureUrl = parts[1];
          return true;
        }
      }
    } on Exception catch (e) {
      throw e;
    }

    return false;
  }

  bool _qrIsValid(StudyClassModel studyClass, List<String> parts) {
    final startDate = studyClass.lastLecture.startDate;
    return studyClass.lastLecture.lectureUrl == parts[1] &&
        startDate.difference(DateTime.parse(parts[2])).inSeconds < 1 &&
        startDate.difference(DateTime.now()).inMinutes < 20;
  }
}
