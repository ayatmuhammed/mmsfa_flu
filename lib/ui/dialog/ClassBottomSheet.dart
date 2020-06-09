import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassBottomSheet extends StatelessWidget {
  final String className;

  const ClassBottomSheet({Key key, this.className= ""}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
       mainAxisSize:  MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              controller: TextEditingController(text: className),
              style: TextStyle(fontSize: 16.0, color: Colors.indigo),
              decoration: InputDecoration(
                  icon: Icon(Icons.edit), labelText: 'class name'),
            ),
          ),
          MaterialButton(
            color: Colors.indigo,
            child: Text(
              className.isEmpty? "Add" : "Edit",
              style: TextStyle(color: Colors.white),
            ),
              onPressed: () {}),
        ],
      ),
    );
  }
}
