import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/StudyClassModel.dart';
import 'package:mmsfa_flu/database/model/UserModel.dart';
import 'package:mmsfa_flu/main.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

class ClassesViewModel {
  CollectionReference classesCollection;
  final Firestore _firestore = Firestore.instance;

  ClassesViewModel(String userId) {
    classesCollection = _firestore
        .collection(TeachersCollection.NAME)
        .document(userId)
        .collection(ClassesCollection.NAME);
  }

  Future<void> addClass(StudyClassModel classModel) async {
    final className = classModel.className;
    if (className == null || className.isEmpty) return;

    if (classModel.classId.isEmpty) {
      await classesCollection.document().setData(classModel.toJson());
    } else {
      await classesCollection
          .document(classModel.classId)
          .setData(classModel.toJson());
    }
  }

  Future<void> deleteClass(StudyClassModel classModel) async {
    final batch = _firestore.batch();
    final classRef = classesCollection.document(classModel.classId);
    final classStudents = await _getClassStudents(classModel.studentRefs);

    batch.delete(classRef);
    for (int i = 0; i < classStudents.length; i++) {
      final studentRef = classModel.studentRefs[i];
      final student = classStudents[i];

      student.classRefs
          .removeWhere((stuClassRef) => stuClassRef.path == classRef.path);
      batch.updateData(studentRef, student.toJson());
    }

    await batch.commit();
  }

  Future<List<StudentModel>> _getClassStudents(
      List<DocumentReference> studentsRefs) async {
    List<StudentModel> students = [];

    for (final studentRef in studentsRefs) {
      final student = StudentModel.fromSnapshot(await studentRef.get());
      students.add(student);
    }

    return students;
  }

  Stream<List<StudyClassModel>> getClassesStream(UserModel userModel) async* {
    if (userModel is StudentModel) {
      List<StudyClassModel> classes = List();

      for (DocumentReference classDoc in userModel.classRefs) {
        var classModel = StudyClassModel.fromSnapshot(await classDoc.get());
        classes.add(classModel);
      }
      yield classes;
    } else {
      final querySnapshotStream = Firestore.instance
          .collection(TeachersCollection.NAME)
          .document(userModel.userId)
          .collection(ClassesCollection.NAME)
          .snapshots();

      final stream = querySnapshotStream.map((querySnapshot) => querySnapshot
          .documents
          .map((docSnapshot) => StudyClassModel.fromSnapshot(docSnapshot))
          .toList());

      await for (final list in stream) {
        yield list;
      }
    }
  }
}
