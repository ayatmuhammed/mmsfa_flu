import 'package:flutter/material.dart';
import 'package:mmsfa_flu/ui/pages/QrGenerator.dart';
import 'package:mmsfa_flu/ui/pages/ScanScreen.dart';

class ClassCard extends StatelessWidget {
  final int position;
  final String name;
  final bool canEdit;
  final void Function() onEditPressed;
  final void Function() onDeletePressed;

  const ClassCard({
    Key key,
    this.name,
    this.position,
    this.canEdit,
    @required this.onEditPressed,
    @required this.onDeletePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: 9.0, bottom: 20.0, left: 14.0, right: 14.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                    title: Text(
                      name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 22.0,
                      ),
                    ),
//                  subtitle: Text(
//                    '${classes[posi].department}',
//                    style: TextStyle(color: Colors.grey,
//                      fontSize: 14.0,
//                    ),
//                  ),
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundColor: Colors.indigo,
                          radius: 14.0,
                          child: Text(
                            '$position',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QrGenerator()
                          //QrScan(),
                          //ScanScreen(),
                        ),
                      );
                    }),
              ),
              canEdit
                  ? IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: onDeletePressed)
                  : SizedBox(),
              canEdit
                  ? IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.indigo,
                  ),
                  onPressed: onEditPressed)
                  : SizedBox(),
            ],
          ),
        ],
      ),
    );
  }
}