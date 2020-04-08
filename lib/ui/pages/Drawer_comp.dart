import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mmsfa_flu/ui/pages/QrGenerator.dart';
class DrawerComp extends StatefulWidget {
  @override
  _DrawerCompState createState() => _DrawerCompState();
}

class _DrawerCompState extends State<DrawerComp> {
  @override
  Widget build(BuildContext context) {

    return Drawer(
      child: Container(
        color: Colors.purple[50],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DrawerHeader(
              child:Column(
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.indigo,
                    child: Image.asset('assets/ar-icons-school.png'),
                    radius: 60.0,
                  ),
                  SizedBox(
                    height: 2.0,
                  ),
                  Text('ayatprogram@gmail.com',style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,color: Colors.indigo),
                  ),

                ],
              ),
            ),
            SizedBox(
              height:5.0,
            ),
            FlatButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  QrGenerator(),
                  ),
                );
              },
              child: Text('- QR Generate',style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,color: Colors.indigo),),
            ),
            SizedBox(
              height:2.0,
            ),

            FlatButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                   // builder: (context) =>,
                  ),
                );
              },
              child: Text('-Logout',style: TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,color: Colors.indigo),),
            ),
          ],


        ),
      ),
    );

  }
}