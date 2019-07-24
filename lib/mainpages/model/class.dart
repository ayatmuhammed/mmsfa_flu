import 'package:firebase_database/firebase_database.dart';

class Todo {
  String key;
  String lecture;
  String department;
  String branch;
  String teacher;
  List<dynamic> studentIds;

  Todo(this.lecture, this.department, this.branch,this.teacher);

  Todo.fromSnapshot(DataSnapshot snapshot) :
        key = snapshot.key,
        lecture = snapshot.value["lecture"],
        department = snapshot.value["department"],
        branch = snapshot.value["branch"],
        teacher = snapshot.value["teacher"],
  studentIds = List<dynamic>.from(snapshot.value["students"]?? []);



  toJson() {
    return {
      "lecture": lecture,
      "department": department,
      " branch":  branch,
      "teacher" : teacher,
    };
  }
}