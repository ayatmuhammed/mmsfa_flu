import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mmsfa_flu/ui/pages/QrGenerator.dart';
import 'package:mmsfa_flu/ui/pages/ScanScreen.dart';

class ClassCard extends StatelessWidget {
  final int position;
  final String name;
  final bool canEdit;
  final void Function() onEditPressed;
  final void Function() onDeletePressed;
  final void Function() onCardPressed;

  const ClassCard({
    Key key,
    this.name,
    this.position,
    this.canEdit,
    @required this.onEditPressed,
    @required this.onDeletePressed,
    @required this.onCardPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10.0),
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      mainAxisAlignment: MainAxisAlignment.center,
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
                    onTap: onCardPressed),
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
