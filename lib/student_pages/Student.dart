//here   i added to database or received from data database
import 'package:firebase_database/firebase_database.dart';

class Student{
  String _id ;
  String _name ;
  String _section ;
  String _branch ;
  String _stage  ;
  String _lecture;

//now i use the constructor to  add new student by using it
  Student ( this._id,this._name,this._section,this._branch,this._stage,this._lecture);
//now i want to add and receive from database
  Student.map(dynamic obj){
    this._name=obj['name'];
    this._section=obj['section'];
    this._branch=obj['branch'];
    this._stage=obj['stage'];
    this._lecture=obj['lecture'];
  }
// i takes this information from user by using(get)
  String get id =>_id;
  String get name =>_name;
  String get section=>_section;
  String get branch=>_branch;
  String get stage =>_stage;
  String get lecture =>_lecture;


  //here i want to received the information
  Student.fromSnapShot(DataSnapshot snapshot){
    _id=snapshot.key;
    _name=snapshot.value['name'];
    _section=snapshot.value['section'];
    _branch=snapshot.value['branch'];
    _stage=snapshot.value['stage'];
    _lecture=snapshot.value['lecture'];

  }


}


