import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentCard extends StatelessWidget {
  final String name;
  final int position;
  final Function onDeletePressed;
  final bool isAttended;

  const StudentCard(
      {Key key,
      @required this.position,
      @required this.name,
      @required this.onDeletePressed,
      this.isAttended})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Divider(color: Colors.indigo, height: 6.0),
        Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                //now i want to display the name of user in list
                title: Row(
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        color: Colors.indigo,
                        backgroundColor: Colors.purple[50],
                        fontSize: 22.0,
                      ),
                    ),
                    SizedBox(
                      width: 12,
                    ),
                    isAttended != null
                        ? Text(
                            isAttended ? "\u{2713}" : "\u{274C}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: isAttended ? 24 : 18,
                                fontWeight: FontWeight.w900,
                                color: Colors.green),
                          )
                        : SizedBox()
                  ],
                ),
//                              subtitle: Text(
//                                '${items[position].department}',
//                                style: TextStyle(
//                                  color: Colors.amber,
//                                  //  backgroundColor: Colors.purple[50],
//                                  fontSize: 14.0,
//                                ),
//                              ),
                leading: CircleAvatar(
                  backgroundColor: Colors.indigo,
                  radius: 14.0,
                  child: Text(
                    '$position',
                    style: TextStyle(
                      color: Colors.white,
                      //  backgroundColor: Colors.purple[50],
                      fontSize: 14.0,
                    ),
                  ),
                ),
                onTap: () {},
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: onDeletePressed,
            ),
//                          IconButton(
//                            icon: Icon(
//                              Icons.edit,
//                              color: Colors.indigo,
//                            ),
//                            onPressed: () {
////                              _navigateStudent(context, items[position])
//                            },
//                          ),
          ],
        ),
      ],
    );
  }
}

//class StudentCard extends StatelessWidget {
//  final StudentModel studentModel;
//
//  const StudentCard({
//    Key key,
//    @required this.studentModel,
//  }) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return Card(
//      margin: EdgeInsets.all(10.0),
//      color: Colors.white,
//      child: Column(
//        mainAxisSize: MainAxisSize.min,
//        children: <Widget>[
//          Row(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
//              Expanded(
//                child: ListTile(
//                  title: Text(
//                    studentModel.username,
//                    style: TextStyle(
//                      color: Colors.black,
//                      fontSize: 22.0,
//                    ),
//                  ),
//                  leading: Image(image: NetworkImage("image url")),
//                ),
//              ),
//            ],
//          ),
//        ],
//      ),
//    );
//  }
//}
