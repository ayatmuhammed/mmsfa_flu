import 'package:firebase_database/firebase_database.dart';
//i want to sent the information of users as widget
import 'package:flutter/widgets.dart';

// i add the users which i want to send  them to database in class
class UserToDatabase {
  //function to help me to import it from any where
  addNewUser(user, context) {
    FirebaseDatabase.instance.reference().child('users').push().set({
      'email': user.email,
      'uid': user.uid,

      //i use then to do many thinks such as move it to another page
    }).then((value) {
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/home');
    }).catchError((e) {
      print(e);
    });
  }
}
