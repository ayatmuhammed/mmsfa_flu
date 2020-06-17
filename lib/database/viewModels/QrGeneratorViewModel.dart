import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/StudyClassModel.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class QrGeneratorViewModel {
  bool isLoading = false;
  Uint8List bytes = Uint8List(0);
  final StudyClassModel classModel;
  DocumentReference classRef;

  QrGeneratorViewModel(this.classModel, String userId) {
    classRef = classRef = Firestore.instance
        .collection(TeachersCollection.NAME)
        .document(userId)
        .collection(ClassesCollection.NAME)
        .document(classModel.classId);
  }

  Stream<List<StudentModel>> getAttendedStudentsStream() async* {
    await for (final updateClassModel in classRef
        .snapshots()
        .map((docSnapshot) => StudyClassModel.fromSnapshot(docSnapshot))) {
      final List<StudentModel> attendedStudents = [];
      for (final studentRef
          in updateClassModel.lastLecture.attendedStudentRefs) {
        final studentModel = StudentModel.fromSnapshot(await studentRef.get());
        attendedStudents.add(studentModel);
      }

      yield attendedStudents;
    }
  }

  Future<void> startNewLecture(String lectureUrl) async {
    LectureModel lecture = LectureModel(lectureUrl);
    classModel.lastLecture = lecture;
    try {
      await classRef.updateData(classModel.lastLecture.toJson());
      _generateBarCode();
    } on Exception catch (e) {
      throw e;
    }
  }

  Future _generateBarCode() async {
    String inputCode = classModel.classId +
        "," +
        classModel.lastLecture.lectureUrl +
        "," +
        classModel.lastLecture.startDate.toString();

    Uint8List result = await scanner.generateBarCode(inputCode);
    print(inputCode);
    bytes = result;
  }
}
