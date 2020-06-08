//her i show all student that i will added it
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mmsfa_flu/ui/pages/Drawer_comp.dart';
import 'package:mmsfa_flu/database/model/class.dart';
import 'package:mmsfa_flu/ui/pages/student/EditStudentInformation.dart';
import 'package:mmsfa_flu/ui/pages/student/StudentsList.dart';
class TeacherClassesTemp extends StatefulWidget {

const  TeacherClassesTemp(
{Key key,
  this.user,
}):super(key:key);
final FirebaseUser user;
 final String title = "Pick Image";
  @override
  _TeacherClassesTempState createState() => _TeacherClassesTempState();
}

final todoReference = FirebaseDatabase.instance.reference().child('todo');

class _TeacherClassesTempState extends State<TeacherClassesTemp> {
  final String title = "Flutter Pick Image demo";
  Future<File> imageFile;

  
  pickImageFromGallery(ImageSource source)
  {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

//final Auth=FirebaseAuth.instance;
  //the user that i takes it from database i put them in list
  List<Todo> classes;
  // i need to FireBase realtime TO help me in delete and update the in formation so i use stream
  StreamSubscription<Event> _onClassesAddedSubscription;
  StreamSubscription<Event>
  _onnClassesChangedSubscription;


  @override
  void initState() {
    super.initState();
    classes = new List();
    _onClassesAddedSubscription =
        todoReference.onChildAdded.listen(_onClassesAdded);
    _onnClassesChangedSubscription =
        todoReference.onChildChanged.listen(_onClassesUpdated);
  }


  @override
  void dispose() {
    super.dispose();
    _onClassesAddedSubscription.cancel();
    _onnClassesChangedSubscription.cancel();
  }



//now i design the ui to the user
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer:DrawerComp(),
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text(
            'Your Classes',
            style: TextStyle(color: Colors.white, fontSize: 18.0),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: ListView.builder(
            itemCount: classes.length,
            padding: EdgeInsets.only(top: 15.0),
            itemBuilder: (context, posi) {
              return Card(
                margin: EdgeInsets.only(
                    top: 9.0, bottom: 9.0, left: 14.0, right: 14.0),
                child: Column(
                  children: <Widget>[
                    Container(
                      height: 140.0,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: ListTile(
                              title: Text(
                                '${classes[posi].lecture}',
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 22.0,
                                ),
                              ),
                              subtitle: Text(
                                '${classes[posi].department}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14.0,
                                ),
                              ),
                              leading: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  CircleAvatar(
                                    backgroundColor: Colors.indigo,
                                    radius: 14.0,
                                    child: Text(
                                      '${posi + 1}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () => _navigateClassInformation(
                                  context, classes[posi]),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () =>
                                _deleteClass(context, classes[posi], posi),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.edit,
                              color: Colors.indigo,
                            ),
                            onPressed: () =>
                                _navigateClass(context, classes[posi]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
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
          onPressed: () => _createNewClass(context),
        ),
      ),
    );
  }

  void _onClassesAdded(Event event) {
    setState(() {
      classes.add(new Todo.fromSnapshot(event.snapshot));
    }
    );
  }

  void _onClassesUpdated(Event event) {
    var oldClassValue =
        classes.singleWhere((todo) => todo.key == event.snapshot.key);
    setState(() {
      classes[classes.indexOf(oldClassValue)] =
          new Todo.fromSnapshot(event.snapshot);
    }
    );
  }

  //delete need to connect to FireBase so we need to async and await the result

  void _deleteClass(BuildContext context, Todo todo, int position) async {
    await todoReference.child(todo.key).remove().then((_) {
      setState(() {
        classes.removeAt(position);
      });
    });
  }

  void _navigateClass(BuildContext context, Todo todo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditStudentInformation(todo)),
    );
  }

  void _navigateClassInformation(BuildContext context, Todo todo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentsList(todo),
      ),
    );
  }
//when i want to create new user

  void _createNewClass(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditStudentInformation(
          Todo(null, '', '', ''),
        ),
      ),
    );

  }
}



