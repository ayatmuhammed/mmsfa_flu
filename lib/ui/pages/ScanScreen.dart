import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mmsfa_flu/database/model/StudyClassModel.dart';
import 'package:mmsfa_flu/database/viewModels/ScanScreenViewModel.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:url_launcher/url_launcher.dart';

class ScanScreen extends StatefulWidget {
  final DocumentReference classRef;

  const ScanScreen({Key key, this.classRef}) : super(key: key);

  @override
  _ScanScreenState createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  ScanScreenViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = ScanScreenViewModel(widget.classRef);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(
              (Icons.arrow_back),
              color: Colors.indigo,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Qrcode Scanner',
            style: TextStyle(color: Colors.indigo),
          ),
        ),
        body: Builder(
          builder: (BuildContext context) => Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                viewModel.isLoading
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 120.0),
                        child: SpinKitChasingDots(color: Colors.indigo),
                      )
                    : SizedBox(),
                viewModel.lectureUrl != null
                    ? registeredSuccessfully()
                    : SizedBox(),
                viewModel.lectureUrl != null
                    ? LectureLauncher(lectureUrl: viewModel.lectureUrl)
                    : SizedBox(),
                RaisedButton(
                    onPressed: () => _scan(context),
                    child:
                        Text("Scan", style: TextStyle(color: Colors.indigo))),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding registeredSuccessfully() {
    return Padding(
      padding: const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 32.0),
      child: Text(
        "You have been registered as an attendant \u{2714}",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 32, fontWeight: FontWeight.w900, color: Colors.green),
      ),
    );
  }

  Future _scan(BuildContext context) async {
    setState(() {
      viewModel.isLoading = true;
    });

    try {
      final isSuccessful = await viewModel.selectAndScanImage();

      if (!isSuccessful) {
        Scaffold.of(context)
            .showSnackBar(SnackBar(content: Text("invalid QR-Code")));
      }
    } on Exception catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("error: $e}")));
    }

    setState(() {
      viewModel.isLoading = false;
    });
  }
}

class ScanWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LectureLauncher extends StatelessWidget {
  const LectureLauncher({
    Key key,
    @required this.lectureUrl,
  }) : super(key: key);

  final String lectureUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 32.0, right: 32.0, bottom: 120, top: 60),
      child: InkWell(
        onTap: () async {
          if (await canLaunch(lectureUrl)) {
            await launch(lectureUrl);
          } else {
            Scaffold.of(context)
                .showSnackBar(SnackBar(content: Text("Couldn't launch url")));
          }
        },
        child: Text(
          "Goto Lecture",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 32, fontWeight: FontWeight.w900, color: Colors.blue),
        ),
      ),
    );
  }
}
