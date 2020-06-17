import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddStudentBottomSheet extends StatelessWidget {
  final classNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextField(
              controller: classNameController,
              style: TextStyle(fontSize: 16.0, color: Colors.indigo),
              decoration: InputDecoration(
                  icon: Icon(Icons.person_add), labelText: 'student email'),
            ),
          ),
          MaterialButton(
              color: Colors.indigo,
              child: Text(
                "Add",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.pop(context, classNameController.text);
              }),
          Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom))
        ],
      ),
    );
  }
}
