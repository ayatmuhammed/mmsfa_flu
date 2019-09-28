//her i show all student that i will added it
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mmsfa_flu/loginpages/signin.dart';
import 'package:mmsfa_flu/mainpages/model/class.dart';
import 'package:mmsfa_flu/mainpages/ui/ClassinfoUpdate.dart';
import 'package:mmsfa_flu/student_pages/listviewstudent.dart';
import 'package:path/path.dart';

class Homepage extends StatefulWidget {

const  Homepage(
{Key key,
  this.user,
}):super(key:key);

final FirebaseUser user;
//Homepage() : super();
 final String title = "Pick Image";
  @override
  _HomepageState createState() => _HomepageState();
}

final todoReference = FirebaseDatabase.instance.reference().child('todo');

class _HomepageState extends State<Homepage> {
  Future<File> imageFile;
  pickImageFromGallery(ImageSource source)
  {
    setState(() {
      imageFile = ImagePicker.pickImage(source: source);
    });
  }

  Widget showImage() {
    return FutureBuilder<File>(
      future: imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          return Image.file(
            snapshot.data,
//            width: 300,
//            height: 300,

          );
        } else if (snapshot.error != null) {
          return const Text(
            'Error Picking Image',
            textAlign: TextAlign.center,
          );
        } else {
          return const Text(
            'No Image Selected',
            textAlign: TextAlign.center,
          );
        }
      },
    );
  }
//final Auth=FirebaseAuth.instance;
  //the user that i takes it from database i put them in list
  List<Todo> classes;
  // i need to FireBase realtime TO help me in delete and update the in formation so i use stream
  StreamSubscription<Event> _onClassesAddedSubscription;
  StreamSubscription<Event>
      _onnClassesChangedSubscription; //his means when i add new user to list it is auto update and add the user
  // now i want to init. th database i means the database is download automatically
  Future<void> _signOut() async {
    FirebaseAuth.instance.signOut();
    // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginSignInPage()));
  }

  @override
  void initState() {
    super.initState();
    classes = new List();
    _onClassesAddedSubscription =
        todoReference.onChildAdded.listen(_onClassesAdded);
    _onnClassesChangedSubscription =
        todoReference.onChildChanged.listen(_onClassesUpdated);
  }

  //it is cancel to the subscription it is closed the database

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
      title: 'Student DB',
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircleAvatar(
                      backgroundColor: Colors.indigo[100],
                      radius: 50.0,
                      child: showImage(),
                    ),

                    IconButton(
                      icon: Icon(
                        Icons.add_a_photo,
                      ),
                      onPressed: () {
                        // getImage();
                        pickImageFromGallery(ImageSource.gallery);
                      },
                    ),


                  ],
                ),
//                decoration: BoxDecoration(
//                  color: Colors.white,
//                ),
              ),
              ListTile(
                title: Text('Report'),
                onTap: () {
                  // Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Logout'),
                onTap: () {
                  _signOut();
                },
              ),
            ],
          ),
        ),
        drawerScrimColor: Colors.white,
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
                color: Colors.purple[50],
                child: Column(
                  children: <Widget>[

                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            //now i want to display the name of user in list
                            title: Text(
                              '${classes[posi].lecture}',
                              style: TextStyle(
                                color: Colors.indigo,
                                backgroundColor: Colors.purple[50],
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.indigo,
                                  radius: 14.0,
                                  child: Text(
                                    '${posi + 1}',
                                    style: TextStyle(
                                      color: Colors.black,
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
    });
  }

  void _onClassesUpdated(Event event) {
    var oldClassValue =
        classes.singleWhere((todo) => todo.key == event.snapshot.key);
    setState(() {
      classes[classes.indexOf(oldClassValue)] =
          new Todo.fromSnapshot(event.snapshot);
    });
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
      MaterialPageRoute(builder: (context) => InformationScreen(todo)),
    );
  }

  void _navigateClassInformation(BuildContext context, Todo todo) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ListViewStudent(todo),
      ),
    );
  }
//when i want to create new user

  void _createNewClass(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InformationScreen(
          Todo(null, '', '', ''),
        ),
      ),
    );
  }
}
