import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/StudyClassModel.dart';
import 'package:mmsfa_flu/database/model/UserModel.dart';
import 'package:mmsfa_flu/main.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

class ClassesViewModel {
  final documentId =
      'kNXrxODnpYQAQXyejFsysa3Pgmp1'; // teacher: 9XaPOZ6oREN0or64tjcynOuEVHk2, student: kNXrxODnpYQAQXyejFsysa3Pgmp1

  CollectionReference classesCollection;

  ClassesViewModel() {
    classesCollection = Firestore.instance
        .collection(TeachersCollection.NAME)
        .document(documentId)
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

  Future<void> deleteClass(String documentId) async {
    await classesCollection.document(documentId).delete();
  }

  Stream<List<StudyClassModel>> getClasses(UserModel userModel) async* {
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