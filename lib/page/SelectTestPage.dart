import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/controller/RemoteWSDCalculator.dart';
import 'package:project_apraxia/page/AmbiancePage.dart';
import 'package:project_apraxia/page/SelectWaiverPage.dart';
import 'package:project_apraxia/page/SurveyPage.dart';
import 'package:project_apraxia/page/WaiverPage.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';
import 'package:project_apraxia/widget/form/ActionCard.dart';

class SelectTestPage extends StatefulWidget {
  SelectTestPage({Key key}) : super(key: key);

  @override
  _SelectTestPageState createState() => _SelectTestPageState();
}

class _SelectTestPageState extends State<SelectTestPage> {
  bool _waiver = true;
  List<dynamic> _patients = new List<dynamic>(0);
  bool _newPatient = true;
  int _oldPatientSelected = -1;
  String _patientName = '';
  String _patientEmail = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Waiver"),
      ),
      body: ListView(
        children: <Widget>[
          ActionCard(
            title: Text(
              "Local Processing",
              style: Theme.of(context).textTheme.headline6,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(" - Test is done on the local device"),
                Text(" - HIPAA waiver is not required"),
                Text(" - Audio processing is limited by the physical device"),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Start Local Test"),
                onPressed: () => _startLocalTest(context),
              )
            ],
          ),
          ActionCard(
            title: Text(
              "Advanced Processing",
              style: Theme.of(context).textTheme.headline6,
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(" - Audio processing done on a secure server"),
                Text(" - HIPAA waiver is required"),
                Text(" - Client data is shared for research purposes"),
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("Start Remote Test"),
                onPressed: () => _startRemoteTesting(context),
              )
            ],
          ),
        ],
      ),
    );

    return Scaffold(
        appBar: AppBar(
          title: Text("Select Waiver"),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              child: Container(),
              padding: EdgeInsets.only(top: 16.0),
            ),
            ListTile(
              title: Text('Skip HIPAA waiver and use basic processing',
                  style: Theme.of(context).textTheme.title),
              leading: Radio(
                value: false,
                groupValue: _waiver,
                onChanged: (bool value) {
                  setState(() {
                    _waiver = value;
                    _newPatient = false;
                    _oldPatientSelected = -1;
                  });
                },
              ),
            ),
            ListTile(
              title: Text('Select or sign waiver and use better processing',
                  style: Theme.of(context).textTheme.title),
              leading: Radio(
                value: true,
                groupValue: _waiver,
                onChanged: (bool value) {
                  setState(() {
                    _waiver = value;
                  });
                },
              ),
            ),
            _waiver
                ? Padding(
                    padding: EdgeInsets.only(left: 32.0, top: 8.0, right: 32.0),
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          title: const Text('New patient'),
                          leading: Radio(
                            value: true,
                            groupValue: _newPatient,
                            onChanged: (bool value) {
                              setState(() {
                                _newPatient = value;
                                _oldPatientSelected = -1;
                              });
                            },
                          ),
                        ),
                        ListTile(
                          title: const Text(
                              'Select a waiver from patients on file'),
                          leading: Radio(
                            value: false,
                            groupValue: _newPatient,
                            onChanged: (bool value) {
                              setState(() {
                                _newPatient = value;
                              });
                            },
                          ),
                        ),
                        _newPatient
                            ? Container()
                            : Column(
                                children: <Widget>[
                                  ListTile(
                                      title: TextFormField(
                                    initialValue: _patientName,
                                    decoration: InputDecoration(
                                        labelText: "Patient Name"),
                                    onChanged: (String name) {
                                      _patientName = name;
                                    },
                                  )),
                                  ListTile(
                                      title: TextFormField(
                                    initialValue: _patientEmail,
                                    decoration: InputDecoration(
                                        labelText: "Patient Email"),
                                    onChanged: (String email) {
                                      _patientEmail = email;
                                    },
                                  )),
                                  RaisedButton(
                                      child: const Text("Search"),
                                      onPressed: () async {
                                        var tmp = await loadPatients(_patientEmail);
                                        if (tmp != null) {
                                          if (tmp.length > 0) {
                                            setState(() {
                                              _patients = tmp;
                                            });
                                          } else {
                                            ErrorDialog dialog =
                                                new ErrorDialog(context);
                                            dialog.show("No waivers found",
                                                "There are no waivers on file for this name and email address. Please try another.");
                                          }
                                        }
                                      }),
                                  (_patients.length > 0)
                                      ? ListTile(
                                          title: Text('Name: ' +
                                              _patients[0]['subjectName'] +
                                              '\nEmail: ' +
                                              _patients[0]['subjectEmail']),
                                          leading: Radio(
                                            value: 0,
                                            groupValue: _oldPatientSelected,
                                            onChanged: (int value) {
                                              setState(() {
                                                _oldPatientSelected = value;
                                              });
                                            },
                                          ),
                                        )
                                      : Container()
                                ],
                              )
                      ],
                    ))
                : Container(),
            Align(
                alignment: Alignment.bottomCenter,
                child: ButtonBar(
                  children: <Widget>[
                    _waiver
                        ? Container()
                        : RaisedButton(
                            child: Text("Skip Waiver - Basic Processing"),
                            onPressed: () => _startLocalTest(context),
                          ),
                    (_waiver && _newPatient)
                        ? RaisedButton(
                            child: Text("Sign New Waiver"),
                            onPressed: () => _goToWaiverPage(context),
                          )
                        : Container(),
                    (_waiver && !_newPatient && _oldPatientSelected != -1)
                        ? RaisedButton(
                            child: Text("Use This Waiver"),
                            onPressed: () => _startRemoteTest(context),
                          )
                        : Container(),
                  ],
                  alignment: MainAxisAlignment.center,
                ))
          ],
        ));
  }

  Future<List<dynamic>> loadPatients(String subjectEmail) async {
    HttpConnector connector = new HttpConnector.instance();
    try {
      List<dynamic> result = await connector.getWaiversOnFile(subjectEmail.trim().toLowerCase());
      return result;
    } on ServerConnectionException catch (e) {
      ErrorDialog dialog = new ErrorDialog(context);
      dialog.show('Error Contacting Server', e.message);
    } on InternalServerException catch (e) {
      ErrorDialog dialog = new ErrorDialog(context);
      dialog.show('Internal Server Error', e.message);
    }
    return null;
  }

  void _startLocalTest(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return AmbiancePage(
        wsdCalculator: new LocalWSDCalculator(),
        evalId: "",
      );
    }));
  }

  void _startRemoteTesting(BuildContext context) {
    Navigator.push(context, MaterialPageRoute( builder: (context){
      return SelectWaiverPage();
    }));
  }

  void _goToWaiverPage(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return WaiverPage();
    }));
  }

  void _startRemoteTest(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return SurveyPage(
        wsdCalculator: new RemoteWSDCalculator(),
      );
    }));
  }
}
