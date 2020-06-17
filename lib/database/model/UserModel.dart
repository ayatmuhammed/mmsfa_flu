import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

class UserModel {
  String userId;
  String username;
  String email;

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : userId = snapshot.documentID,
        username = snapshot.data[UsersCollection.USERNAME_FIELD] ?? 'Unknown',
        email = snapshot.data[UsersCollection.EMAIL_FIELD] ?? 'Unknown';

  Map<String, dynamic> toJson() => {
        UsersCollection.USERNAME_FIELD: username,
        UsersCollection.EMAIL_FIELD: email,
      };
}
