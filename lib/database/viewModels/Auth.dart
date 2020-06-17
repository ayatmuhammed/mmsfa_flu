import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/TeacherModel.dart';
import 'package:mmsfa_flu/database/model/UserModel.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password);

  Future<FirebaseUser> getCurrentUser();

  Future<void> sendEmailVerification();

  Future<void> signOut();

  Future<bool> isEmailVerified();

  Stream<UserModel> getCurrentUserModelStream();

  bool isStudent(FirebaseUser firebaseUser);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    try {
      if (!email.contains("@student") && !email.contains("@teacher"))
        return "invalid email";

      FirebaseUser user = (await _firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user == null) return "couldn't login";
      return null;
    } on Exception catch (e) {
      return "error: $e";
    }
  }

  Future<String> signUp(String email, String password) async {
    try {
      if (!email.contains("@student") && !email.contains("@teacher"))
        return "invalid email";

      FirebaseUser user = (await _firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;

      if (user != null) return "couldn't register the user";

      return null;
    } on Exception catch (e) {
      return "Error: $e";
    }
  }

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  bool isStudent(FirebaseUser user) => user.email.contains("@student");

  @override
  Stream<UserModel> getCurrentUserModelStream() async* {
    await for (final firebaseUser in _firebaseAuth.onAuthStateChanged) {
      if (firebaseUser == null)
        yield null;
      else {
        final isUserStudent = isStudent(firebaseUser);

        final docRef = Firestore.instance
            .collection(isUserStudent
                ? StudentsCollection.NAME
                : TeachersCollection.NAME)
            .document(firebaseUser.uid);

        DocumentSnapshot docSnapshot = await docRef.get();
        if (docSnapshot.data == null) {
          await docRef
              .setData({UsersCollection.EMAIL_FIELD: firebaseUser.email});
          docSnapshot = await docRef.get();
        }

        yield isUserStudent
            ? StudentModel.fromSnapshot(docSnapshot)
            : TeacherModel.fromSnapshot(docSnapshot);
      }
    }
  }
}
