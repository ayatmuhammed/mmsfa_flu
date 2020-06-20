import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmsfa_flu/database/model/StudyClassModel.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';
import 'package:qrscan/qrscan.dart' as scanner;

class ScanScreenViewModel {
  String lectureUrl;
  bool isLoading = false;
  DocumentReference classRef;
  final String userId;

  ScanScreenViewModel(this.classRef, this.userId);

  Future<bool> selectAndScanImage() async {
    try {
      String encodedMsg = await scanner.scan();

      final parts = encodedMsg.split(",");
      if (parts[0] == classRef.documentID) {
        final docSnapshot = await classRef.get();
        final studyClass = StudyClassModel.fromSnapshot((docSnapshot));

        if (_qrIsValid(studyClass, parts)) {
          final studentReference = Firestore.instance
              .collection(StudentsCollection.NAME)
              .document(userId);

          final attendedStudents = studyClass.lastLecture.attendedStudentRefs;
          if (attendedStudents
                  .where((e) => e.path == studentReference.path)
                  .length <
              1) {
            studyClass.lastLecture.attendedStudentRefs.add(studentReference);
            await classRef.updateData(studyClass.lastLecture.toJson());
          }

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
    final qrTimeDiff = startDate.difference(DateTime.parse(parts[2])).inMinutes;

    return studyClass.lastLecture.lectureUrl == parts[1] &&
        (qrTimeDiff < 1 && qrTimeDiff > -1) &&
        DateTime.now().difference(startDate).inMinutes < 20;
  }
}
