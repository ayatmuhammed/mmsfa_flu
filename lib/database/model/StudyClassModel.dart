import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

class StudyClassModel {
  String classId;
  String className;
  LectureModel lastLecture;
  List<DocumentReference> studentRefs = [];

  StudyClassModel(this.classId, this.className);

  StudyClassModel.fromSnapshot(DocumentSnapshot snapshot)
      : classId = snapshot.documentID,
        className = snapshot.data[ClassesCollection.CLASS_NAME_FIELD],
        studentRefs = snapshot.data[ClassesCollection.STUDENTS_REFS]
                ?.cast<DocumentReference>() ??
            [],
        lastLecture = LectureModel.fromMap(snapshot.data);

  //lastLecture= Lecture.fromMap(snapshot.data)
  Map<String, dynamic> toJson() {
    final map = {
      ClassesCollection.CLASS_NAME_FIELD: className,
      ClassesCollection.STUDENTS_REFS: studentRefs,
    };
    if (lastLecture != null) map.addAll(lastLecture.toJson());

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
  List<String> attendedStudentIds;

  LectureModel(this.lectureUrl) {
    attendedStudentIds = [];
    startDate = DateTime.now();
  }

  LectureModel.fromMap(Map<String, dynamic> map)
      : lectureUrl = map[ClassesCollection.LECTURE_URL] ?? "",
        startDate =
            (map[ClassesCollection.START_DATE] as Timestamp)?.toDate() ??
                DateTime.now(),
        attendedStudentIds =
            map[ClassesCollection.ATTENDED_STUDENT_IDS]?.cast<String>() ?? [];

  Map<String, dynamic> toJson() => {
        ClassesCollection.LECTURE_URL: lectureUrl,
        ClassesCollection.START_DATE: startDate,
        ClassesCollection.ATTENDED_STUDENT_IDS: attendedStudentIds,
      };

  @override
  String toString() {
    return 'LectureModel{lectureUrl: $lectureUrl, startDate: $startDate, attendedStudentRefs: $attendedStudentIds}';
  }
}
