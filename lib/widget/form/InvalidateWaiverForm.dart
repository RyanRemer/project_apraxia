import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/controller/Auth.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/model/UserAttributes.dart';

class InvalidateWaiverForm extends StatefulWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey();

  InvalidateWaiverForm({Key  key}) : super(key: key);

  @override
  _InvalidateWaiverFormState createState() => _InvalidateWaiverFormState();
}

class _InvalidateWaiverFormState extends State<InvalidateWaiverForm> {
  List<dynamic> _patients = new List<dynamic>(0);
  int _oldPatientSelected = -1;
  String _patientName = '';
  String _patientEmail = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: TextFormField(
            initialValue: _patientName,
            decoration: InputDecoration(labelText: "Patient Name"),
            onChanged: (String name) {
              _patientName = name;
            },
          )
        ),
        ListTile(
          title: TextFormField(
            initialValue: _patientEmail,
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
            setState(() {
              _patients = tmp;
            });
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
        ) : Container()
      ],
    );
  }

  Future<List<dynamic>> loadPatients(String subjectName, String subjectEmail) async {
    HttpConnector connector = new HttpConnector.instance();
    List<dynamic> result = await connector.getWaiversOnFile(subjectName.trim(), subjectEmail.trim().toLowerCase());
    return result;
  }

}
