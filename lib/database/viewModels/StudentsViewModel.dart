import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/StudyClassModel.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

class StudentsViewModel {
  final StudyClassModel _classModel;
  final Firestore _firestore = Firestore.instance;
  DocumentReference _classRef;

  StudentsViewModel(this._classModel, String userId) {
    _classRef = _firestore
        .collection(TeachersCollection.NAME)
        .document(userId)
        .collection(ClassesCollection.NAME)
        .document(_classModel.classId);
  }

  Stream<List<StudentModel>> getClassStudentsStream() {
    final classDocStream = _classRef.snapshots();

    return classDocStream.asyncMap<List<StudentModel>>((classSnapshot) async {
      final updatedClassModel = StudyClassModel.fromSnapshot(classSnapshot);
      _classModel.lastLecture = updatedClassModel.lastLecture;

      List<StudentModel> students = [];
      for (final studentRef in updatedClassModel.studentRefs) {
        final student = StudentModel.fromSnapshot(await studentRef.get());
        students.add(student);
      }

      return students;
    });
  }

  Future<void> removeStudent(StudentModel studentModel) async {
    final studentRef = _firestore
        .collection(StudentsCollection.NAME)
        .document(studentModel.userId);

    final batch = _firestore.batch();

    _classModel.studentRefs
        .removeWhere((element) => element.path == studentRef.path);
    batch.updateData(_classRef, _classModel.toJson());

    studentModel.classRefs
        .removeWhere((element) => element.path == _classRef.path);
    batch.updateData(studentRef, studentModel.toJson());

    await batch.commit();
  }

  Future<void> addStudent(String studentEmail) async {
    final studentDocument = (await _firestore
            .collection(StudentsCollection.NAME)
            .where(UsersCollection.EMAIL_FIELD, isEqualTo: studentEmail)
            .getDocuments())
        .documents
        .first;

    if (_studentExist(studentDocument)) return;

    final batch = _firestore.batch();

    _classModel.studentRefs.add(studentDocument.reference);
    batch.updateData(_classRef, _classModel.toJson());

    final studentModel = StudentModel.fromSnapshot(studentDocument);
    studentModel.classRefs.add(_classRef);
    batch.updateData(studentDocument.reference, studentModel.toJson());

    await batch.commit();
  }

  bool _studentExist(DocumentSnapshot studentDocument) {
    return _classModel.studentRefs
            .where((element) => element.path == studentDocument.reference.path)
            .length >
        0;
  }
}
