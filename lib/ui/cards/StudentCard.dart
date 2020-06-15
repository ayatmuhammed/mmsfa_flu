import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';

class StudentCard extends StatelessWidget {
  final StudentModel studentModel;

  const StudentCard({
    Key key,
    @required this.studentModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: ListTile(
                  title: Text(
                    studentModel.username,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22.0,
                    ),
                  ),
                  leading: Image(image: NetworkImage("image url")),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
