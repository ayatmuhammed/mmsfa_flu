import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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