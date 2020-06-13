import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ClassBottomSheet extends StatefulWidget {
  final String className;

  ClassBottomSheet({Key key, this.className = ""}) : super(key: key);

  @override
  _ClassBottomSheetState createState() => _ClassBottomSheetState();
}

class _ClassBottomSheetState extends State<ClassBottomSheet> {
  final classNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    classNameController.text = widget.className;
  }

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
                  icon: Icon(Icons.edit), labelText: 'class name'),
            ),
          ),
          MaterialButton(
              color: Colors.indigo,
              child: Text(
                widget.className.isEmpty ? "Add" : "Edit",
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
