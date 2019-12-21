//her i show all student that i will added it
import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mmsfa_flu/Drawer/DrawerPages.dart';
import 'package:mmsfa_flu/mainpages/model/class.dart';
import 'package:mmsfa_flu/mainpages/ui/ClassinfoUpdate.dart';
import 'package:mmsfa_flu/student_pages/listviewstudent.dart';
import 'package:mmsfa_flu/Profile_teacture/Photo_profile';


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
      title: 'Student DB',
      home: Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.all(1.0),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(1.0),
                child: DrawerHeader(
                  child: Padding(
                    padding: const EdgeInsets.all( 1.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.indigo[100],
                          radius: 50.0,
                          child:
                          AppImagePicker(),
//                          profilePic(),
                        ),
//
//                        IconButton(
//                          icon: Icon(
//                            Icons.add_a_photo,
//                          ),
//                          onPressed: () {
//                           // _getImage(ImageSource);
//                           // pickImageFromGallery(ImageSource.gallery);
//                          },
//                        ),

                      ],
                    ),
                  ),
                decoration: BoxDecoration(
                  color: Colors.white,
               ),

                ),
              ),

              ListTile(
                title: Text('Generate Qr',style: TextStyle(color: Colors.indigo),),
                onTap: () {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) =>  GenerateQr()));

                },
              ),
              ListTile(
                title: Text('Logout',style: TextStyle(color: Colors.indigo),),
                onTap: () {
                  _exitApp(context);
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




Future<bool>_exitApp(BuildContext context) {
  return showDialog(
    context: context,
    child: AlertDialog(
      title: Text('Do you want to exit this application?'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            print("you choose no");
            Navigator.of(context).pop(false);
          },
          child: Text('No'),
        ),
        FlatButton(
          onPressed: () {
            SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          },
          child: Text('Yes'),
        ),
      ],
    ),
  ) ??
      false;
}
