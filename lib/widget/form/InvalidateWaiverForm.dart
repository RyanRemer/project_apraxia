import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';

class InvalidateWaiverForm extends StatefulWidget {

  InvalidateWaiverForm({Key  key}) : super(key: key);

  @override
  _InvalidateWaiverFormState createState() => _InvalidateWaiverFormState();
}

class _InvalidateWaiverFormState extends State<InvalidateWaiverForm> {
  List<dynamic> _patients = new List<dynamic>(0);
  int _oldPatientSelected = -1;
  String _patientName = '';
  String _patientEmail = '';
  bool _boxChecked = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: TextFormField(
            controller: TextEditingController(text: _patientName),
            decoration: InputDecoration(labelText: "Patient Name"),
            onChanged: (String name) {
              _patientName = name;
            },
          )
        ),
        ListTile(
          title: TextFormField(
            controller: TextEditingController(text: _patientEmail),
            decoration: InputDecoration(labelText: "Patient Email"),
            onChanged: (String email) {
              _patientEmail = email;
            },
          )
        ),
        RaisedButton(
          child: const Text("Search"),
          onPressed: () async {
            var tmp = await loadPatients(_patientName, _patientEmail);
            if (tmp != null) {
              if (tmp.length > 0) {
                setState(() {
                  _patients = tmp;
                });
              }
              else {
                ErrorDialog dialog = new ErrorDialog(context);
                dialog.show("No waivers found",
                    "There are no waivers on file for this name and email address. Please try another.");
              }
            }
          }
        ),
        (_patients.length > 0) ?
        ListTile(
          title: Text('Name: ' + _patients[0]['subjectName'] + '\nEmail: ' + _patients[0]['subjectEmail']),
          leading: Radio(
            value: 0,
            groupValue: _oldPatientSelected,
            onChanged: (int value) {
              setState(() {
                _oldPatientSelected = value;
              });
            },
          ),
        ) : Container(),
        (_oldPatientSelected != -1) ?
        Column(
          children: <Widget>[
            ListTile(
                title: Text('I, $_patientName, certify that I invalidate my HIPAA waiver and revoke researcher\'s future access to my files.'),
                leading: Checkbox(
                  value: _boxChecked,
                  onChanged: (bool value) {
                    setState(() {
                      _boxChecked = value;
                    });
                  },
                )
            ),
            _boxChecked ?
            RaisedButton(
              child: Text("Invalidate Waiver"),
              onPressed: () async {
                bool result = await invalidateWaiver(_patientName, _patientEmail);
                if (result) {
                  setState(() {
                    _patientName = '';
                    _patientEmail = '';
                    _boxChecked = false;
                    _oldPatientSelected = -1;
                    _patients = new List<dynamic>(0);
                  });
                  ErrorDialog dialog = new ErrorDialog(context);
                  dialog.show("Success", "The waiver for $_patientName has been successfully invalidated.");
                }
              },
            ) : Container()
          ],
        ) : Container()
      ],
    );
  }

  Future<List<dynamic>> loadPatients(String subjectName, String subjectEmail) async {
    HttpConnector connector = new HttpConnector.instance();
    try {
      return await connector.getWaiversOnFile(
          subjectName.trim(), subjectEmail.trim().toLowerCase());
    } on ServerConnectionException {
      ErrorDialog dialog = new ErrorDialog(context);
      dialog.show('Error Connecting to Server', 'Please try again later.');
    } on InternalServerException catch (e) {
      ErrorDialog dialog = new ErrorDialog(context);
      dialog.show('Internal Server Error', e.message);
    }
    return null;
  }

  Future<bool> invalidateWaiver(String subjectName, String subjectEmail) async {
    HttpConnector connector = new HttpConnector.instance();
    try {
      return await connector.invalidateWaiver(
          subjectName.trim(), subjectEmail.trim().toLowerCase());
    } on ServerConnectionException {
      ErrorDialog dialog = new ErrorDialog(context);
      dialog.show('Error Connecting to Server', 'Please try again later.');
    } on InternalServerException catch (e) {
      ErrorDialog dialog = new ErrorDialog(context);
      dialog.show('Internal Server Error', e.message);
    }
    return false;
  }

}
