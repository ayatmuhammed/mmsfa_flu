import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

class StudyClassModel {
  String classId;
  String className;
  LectureModel lastLecture;

  StudyClassModel(this.classId, this.className);

  StudyClassModel.fromSnapshot(DocumentSnapshot snapshot)
      : classId = snapshot.documentID,
        className = snapshot.data[ClassesCollection.CLASS_NAME_FIELD],
        lastLecture = LectureModel.fromMap(snapshot.data);

  //lastLecture= Lecture.fromMap(snapshot.data)
  Map<String, dynamic> toJson() {
    final map = {ClassesCollection.CLASS_NAME_FIELD: className};
    map.addAll(lastLecture.toJson());

    return map;
  }

  @override
  String toString() {
    return 'StudyClassModel{classId: $classId, className: $className, ${lastLecture.toString()}';
  }
}

class LectureModel {
  String lectureUrl;
  DateTime startDate;
  List<DocumentReference> attendedStudentRefs;

  LectureModel(this.lectureUrl) {
    attendedStudentRefs = [];
    startDate = DateTime.now();
  }

  LectureModel.fromMap(Map<String, dynamic> map)
      : lectureUrl = map[ClassesCollection.LECTURE_URL] ?? "",
        startDate =
            (map[ClassesCollection.START_DATE] as Timestamp)?.toDate() ??
                DateTime.now(),
        attendedStudentRefs = map[ClassesCollection.ATTENDED_STUDENTS_REFS]
                ?.cast<DocumentReference>() ??
            [];

  Map<String, dynamic> toJson() => {
        ClassesCollection.LECTURE_URL: lectureUrl,
        ClassesCollection.START_DATE: startDate,
        ClassesCollection.ATTENDED_STUDENTS_REFS: attendedStudentRefs,
      };

  @override
  String toString() {
    return 'LectureModel{lectureUrl: $lectureUrl, startDate: $startDate, attendedStudentRefs: $attendedStudentRefs}';
  }
}
