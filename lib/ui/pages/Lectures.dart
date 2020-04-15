import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:mmsfa_flu/ui/pages/Drawer_comp.dart';
import 'package:mmsfa_flu/ui/pages/ScanScreen.dart';
import 'package:mmsfa_flu/database/model/classes.dart';
class Lectures extends StatefulWidget {
  @override
  _LecturesState createState() => _LecturesState();
}

final todoReference=FirebaseDatabase.instance.reference().child('todo');
class _LecturesState extends State<Lectures> {
  List<Todo> classes;
  StreamSubscription<Event> _onClassesAddedSubscription;
  StreamSubscription<
      Event> _onnClassesChangedSubscription;
  @override
  void initState() {
    super.initState();
    classes = new List();
    _onClassesAddedSubscription =
        todoReference.onChildAdded.listen(_onClassesAdded);
  }

  @override
  void dispose() {
    super.dispose();
    _onClassesAddedSubscription.cancel();
    _onnClassesChangedSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer:DrawerComp(),
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: Text('Your Classes',
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
                    top: 9.0, bottom: 20.0, left: 14.0, right: 14.0),
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: ListTile(
                            title: Text(
                              '${classes[posi].lecture}',
                              style: TextStyle(color: Colors.black,
                                fontSize: 22.0,
                              ),
                            ),
                            subtitle: Text(
                              '${classes[posi].department}',
                              style: TextStyle(color: Colors.grey,
                                fontSize: 14.0,
                              ),
                            ),
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                CircleAvatar(
                                  backgroundColor: Colors.indigo,
                                  radius: 14.0,
                                  child: Text('${posi + 1}',
                                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,

                                      fontSize: 14.0,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            onTap: () {
                              Navigator.push(
                                context, MaterialPageRoute(
                                builder:
                                    (context) =>
                                //QrScan(),
                                ScanScreen(),
                              ),
                              );
                            }
                          ),
                        ),

                      ],
                    ),

                  ],
                ),
              );
            },
          ),
        ),

      ),
    );
  }

  void _onClassesAdded(Event event) {
    setState(() {
      classes.add(
          new Todo.fromSnapshot(event.snapshot));
    });
  }
}