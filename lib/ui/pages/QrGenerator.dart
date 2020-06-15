import 'dart:async';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:mmsfa_flu/database/viewModels/QrGeneratorViewModel.dart';
import 'package:mmsfa_flu/database/model/StudentModel.dart';
import 'package:mmsfa_flu/database/model/StudyClassModel.dart';
import 'package:mmsfa_flu/ui/cards/StudentCard.dart';
import 'package:mmsfa_flu/utils/DatabaseSchema.dart';

class QrGenerator extends StatefulWidget {
  final StudyClassModel classModel;
  final String userId;

  const QrGenerator({Key key, @required this.classModel, @required this.userId})
      : super(key: key);

  @override
  _QrGeneratorState createState() => _QrGeneratorState();
}

class _QrGeneratorState extends State<QrGenerator> {
  TextEditingController _inputController;
  QrGeneratorViewModel viewModel;

  @override
  initState() {
    super.initState();
    viewModel = QrGeneratorViewModel(widget.classModel);
    this._inputController = new TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.indigo),
            onPressed: () => Navigator.of(context).pop('/homepage'),
          ),
          backgroundColor: Colors.white,
          title: Text(
            'Qr Generator',
            style: TextStyle(color: Colors.indigo),
          ),
        ),
        backgroundColor: Colors.grey[300],
        body: Builder(
          builder: (BuildContext context) {
            return ListView(
              children: <Widget>[
                _qrCodeWidget(context),
                Container(
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 10.0, bottom: 10.0)),
                      TextField(
                        controller: this._inputController,
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.go,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.text_fields),
                          hintText: 'Please Input Your url of lecture',
                        ),
                      ),
                      this._buttonGroup(context),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      "Students Attendance",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                StreamBuilder<List<StudentModel>>(
                  stream: viewModel.getAttendedStudentsStream(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasError)
                      return Center(child: Text(snapshot.error.toString()));
                    else if (snapshot.hasData) {
                      List<StudentModel> attendedStudents = snapshot.data;
                      if (attendedStudents == null && attendedStudents.isEmpty)
                        return SizedBox();

                      return ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          return StudentCard(
                            studentModel: attendedStudents[index],
                          );
                        },
                        itemCount: attendedStudents.length,
                      );
                    } else
                      return SizedBox();
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _qrCodeWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Card(
        elevation: 6,
        child: Column(
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.verified_user, size: 18, color: Colors.green),
                  Text('  Generate Qrcode', style: TextStyle(fontSize: 15)),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 9),
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4), topRight: Radius.circular(4)),
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 40, right: 40, top: 30, bottom: 10),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 190,
                    child: viewModel.bytes.isEmpty
                        ? Center(
                            child: Text('Empty code ... ',
                                style: TextStyle(color: Colors.black38)),
                          )
                        : Image.memory(viewModel.bytes),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7, left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            child: Text(
                              'remove',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.indigo),
                              textAlign: TextAlign.left,
                            ),
                            onTap: () => this
                                .setState(() => viewModel.bytes = Uint8List(0)),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap: () async {
                              String success =
                                  await ImageGallerySaver.saveImage(
                                      viewModel.bytes);
                              SnackBar snackBar;
                              if (success != null && success.isNotEmpty) {
                                snackBar = new SnackBar(
                                    content: new Text('Saved Successfully'));
                                Scaffold.of(context).showSnackBar(snackBar);
                              } else {
                                snackBar = new SnackBar(
                                    content: new Text('Save failed!'));
                              }
                            },
                            child: Text(
                              'save',
                              style:
                                  TextStyle(fontSize: 15, color: Colors.indigo),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonGroup(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 25, left: 50, right: 50, bottom: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          !viewModel.isLoading
              ? Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () => _onGenerateClicked(context),
                    child: Text(
                      'Generate',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                )
              : CircularProgressIndicator(),
        ],
      ),
    );
  }

  void _onGenerateClicked(BuildContext context) async {
    this.setState(() {
      viewModel.isLoading = true;
    });
    try {
      await viewModel.startNewLecture(_inputController.text);
    } on Exception catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      Scaffold.of(context).showSnackBar(snackBar);
    }
    this.setState(() {
      viewModel.isLoading = false;
    });
  }
}
