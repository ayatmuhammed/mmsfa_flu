//her i show all student that i will added it
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mmsfa_flu/mainpages/model/class.dart';
import 'package:mmsfa_flu/student_pages/Student.dart';
import 'package:mmsfa_flu/student_pages/studentInfoupdate.dart';
import 'package:mmsfa_flu/student_pages/studentInfoView.dart';

class ListViewStudent extends StatefulWidget {
  final Todo myClass;

  const ListViewStudent(this.myClass);

  @override
  _ListViewStudentState createState() => _ListViewStudentState();
}

final studentReference = FirebaseDatabase.instance.reference().child('student');

class _ListViewStudentState extends State<ListViewStudent> {
  //the user that i takes it from database i put them in list
  List<Student> items;
  // i need to FireBase realtime TO help me in delete and update the in formation so i use stream


  //his means when i add new user to list it is auto update and add the user
  // now i want to init. th database i means the database is download automatically

  @override
  void initState() {
    super.initState();
    items = new List();


    if(widget.myClass.studentIds != null) {
      for (int i = 0; i < (widget.myClass.studentIds.length); i++) {
        studentReference.child(widget.myClass.studentIds[i])
            .onValue.listen(_onStudentAdded);
      }
    }

  }

  //it is cancel to the subscription it is closed the database

  @override
  void dispose() {
    super.dispose();

  }

//now i design the ui to the user
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student DB',
      home: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop('/homepage'),
          ),
          backgroundColor: Colors.indigo,
          title: Text('Your Student', style: TextStyle(color: Colors.white)),
//          title:Text('Add Your Student',style: TextStyle(color: Colors.white)
//          ),
          centerTitle: true,
        ),
        body: Center(
          child: ListView.builder(
            itemCount: items.length,
            padding: EdgeInsets.only(top: 15.0),
            itemBuilder: (context, position) {
              return Column(
                children: <Widget>[
                  Divider(color: Colors.indigo, height: 6.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          //now i want to display the name of user in list
                          title: Text(
                            '${items[position].name}',
                            style: TextStyle(
                              color: Colors.indigo,
                              backgroundColor: Colors.purple[50],
                              fontSize: 22.0,
                            ),
                          ),
                          subtitle: Text(
                            '${items[position].section}',
                            style: TextStyle(
                              color: Colors.amber,
                              //  backgroundColor: Colors.purple[50],
                              fontSize: 14.0,
                            ),
                          ),
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.indigo,
                                radius: 14.0,
                                child: Text(
                                  '${position + 1}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    //  backgroundColor: Colors.purple[50],
                                    fontSize: 14.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          onTap: () => _navigateStudentInformation(
                              context, items[position]),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () =>
                            _deleteStudent(context, items[position], position),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.indigo,
                        ),
                        onPressed: () =>
                            _navigateStudent(context, items[position]),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.indigo,
          onPressed: () => _createNewStudent(context),
        ),
      ),
    );
  }

  void _onStudentAdded(Event event) {
    setState(() {
      try {
        var oldStudentValue =
            items.singleWhere((student) => student.id == event.snapshot.key);

        items[items.indexOf(oldStudentValue)] =
            new Student.fromSnapShot(event.snapshot);
      } catch (e) {
        print('${event.snapshot.value}');
        items.add(new Student.fromSnapShot(event.snapshot));
        print('_onStudentAdded $items');
      }
    });
  }



  //delete need to connect to FireBase so we need to async and await the result

  void _deleteStudent(
      BuildContext context, Student student, int position) async {
    await studentReference.child(student.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateStudent(BuildContext context, Student student) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StudentScreen(student)),
    );
  }

  void _navigateStudentInformation(
      BuildContext context, Student student) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StudentInformation(student)),
    );
  }
//when i want to create new user

  void _createNewStudent(BuildContext context) async {
    String studentKey= await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentScreen(
          Student(null, '', '', '', '', ''),
        ),
      ),

    );
    widget.myClass.studentIds.add(studentKey);
    print(widget.myClass.key);
    FirebaseDatabase.instance.reference().child('todo').child(widget.myClass.key).update({'students' :widget.myClass.studentIds},);
    studentReference.child(studentKey)
        .onValue.listen(_onStudentAdded);
  }
}
