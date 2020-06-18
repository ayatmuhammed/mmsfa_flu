import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

class UserModel {
  String userId;
  String username;
  String email;
  String imageUrl;

  UserModel.fromSnapshot(DocumentSnapshot snapshot)
      : userId = snapshot.documentID,
        username = snapshot.data[UsersCollection.USERNAME_FIELD] ?? 'Unknown',
        email = snapshot.data[UsersCollection.EMAIL_FIELD] ?? 'Unknown',
        imageUrl = snapshot.data[UsersCollection.IMAGE_URL_FIELD] ?? '';

  Map<String, dynamic> toJson() => {
        UsersCollection.USERNAME_FIELD: username,
        UsersCollection.EMAIL_FIELD: email,
        UsersCollection.IMAGE_URL_FIELD: imageUrl
      };
}
