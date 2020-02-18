import 'package:flutter/material.dart';
import 'package:project_apraxia/model/SurveyFormFields.dart';
import 'package:project_apraxia/page/AmbiancePage.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/controller/FormValidator.dart';

import 'package:project_apraxia/widget/ErrorDialog.dart';

class SurveyForm extends StatefulWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey();
  final IWSDCalculator wsdCalculator;

  SurveyForm({@required this.wsdCalculator, Key key}) : super(key: key);

  @override
  _SurveyFormState createState() => _SurveyFormState();
}

class _SurveyFormState extends State<SurveyForm> {
  final SurveyFormFields fields = new SurveyFormFields();
  bool loading = false;
  List<String> _genderOptions = ['Female', 'Male', 'Other', 'Prefer not to disclose'];
  bool _doNotDiscloseAge = false;
  bool _aphasia = false;
  bool _apraxia = false;
  bool _dysarthria = false;
  bool _other = false;
  String _otherImpression;
  bool _none = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: SurveyForm._formKey,
      child: loading
      ? Expanded(
        child: Center(child: CircularProgressIndicator(),)
      )
      : Column(
        children: <Widget>[
          ListTile(
            leading: Text("Patient gender:"),
            title: DropdownButton<String>(
              hint: Text("Please select an option"),
              items: _genderOptions.map((String value) {
                return new DropdownMenuItem<String>(
                  value: value,
                  child: new Text(value),
                );
              }).toList(),
              value: fields.gender,
              onChanged: (String value) {
                setState(() {
                  fields.gender = value;
                });
              }
            ),
          ),
          ListTile(
            leading: Text("Patient age:"),
            title: TextFormField(
              initialValue: fields.age,
              validator: (String age) {
                if (!_doNotDiscloseAge) {
                  return FormValidator.isValidAge(age);
                }
                return null;
              },
              onChanged: (String value) {
                setState(() {
                  fields.age = value;
                });
              },
              onSaved: (String value) {
                fields.age = value;
              }
            ),
          ),
          ListTile(
            leading: Text("Patient does not wish to disclose age:"),
            title: Checkbox(
              value: _doNotDiscloseAge,
              onChanged: (bool value) {
                setState(() {
                  _doNotDiscloseAge = value;
                  if (!value) {
                    fields.age = "";
                  }
                });
              },
            ),
          ),

          ListTile(
            leading: Text("Clinical impression (check all that apply):")
          ),

          ListTile(
            leading: Text("Aphasia"),
            title: Checkbox(
              value: _aphasia,
              onChanged: (bool value) {
                setState(() {
                  _aphasia = value;
                  if (value) {
                    _none = false;
                  }
                });
              },
            ),
          ),
          ListTile(
            leading: Text("Apraxia"),
            title: Checkbox(
              value: _apraxia,
              onChanged: (bool value) {
                setState(() {
                  _apraxia = value;
                  if (value) {
                    _none = false;
                  }
                });
              },
            ),
          ),
          ListTile(
            leading: Text("Dysarthria"),
            title: Checkbox(
              value: _dysarthria,
              onChanged: (bool value) {
                setState(() {
                  _dysarthria = value;
                  if (value) {
                    _none = false;
                  }
                });
              },
            ),
          ),
          ListTile(
            leading: Text("Other (specify)"),
            title: Checkbox(
              value: _other,
              onChanged: (bool value) {
                setState(() {
                  _other = value;
                  if (value) {
                    _none = false;
                  }
                });
              },
            )
          ),
          !_other ? Container() : ListTile(
            title: TextFormField(
              initialValue: _otherImpression,
              onChanged: (String value) {
                setState(() {
                  _otherImpression = value;
                });
              },
            ),
          ),
          ListTile(
            leading: Text("None"),
            title: Checkbox(
              value: _none,
              onChanged: (bool value) {
                setState(() {
                  _none = value;
                  if (value) {
                    _dysarthria = false;
                    _aphasia = false;
                    _apraxia = false;
                    _other = false;
                  }
                });
              },
            ),
          ),
          RaisedButton(
            child: Text("Submit"),
            onPressed: () => this.submit(context),
          )
        ],
      )
    );
  }

  void submit(BuildContext context) async {
    if (SurveyForm._formKey.currentState.validate()) {
      SurveyForm._formKey.currentState.save();
      if (_doNotDiscloseAge) {
        fields.age = 'no answer';
      }
      fields.impression = "";
      if (_apraxia) {
        fields.impression += "apraxia,";
      }
      if (_aphasia) {
        fields.impression += "aphasia,";
      }
      if (_dysarthria) {
        fields.impression += "dysarthria,";
      }
      if (_other) {
        fields.impression += _otherImpression;
      }
      HttpConnector connector = new HttpConnector.instance();

      try {
        String evalId = await connector.createEvaluation(fields.age, fields.gender, fields.impression);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AmbiancePage(wsdCalculator: widget.wsdCalculator, evalId: evalId,)));
      } on ServerConnectionException {
        ErrorDialog errorDialog = new ErrorDialog(context);
        errorDialog.show("Error Connecting to Server",
            "The server is currently down. Switching to local processing.");
      } on InternalServerException {
        ErrorDialog errorDialog = new ErrorDialog(context);
        errorDialog.show("Error Connecting to Server",
            "An unexpected server error occurred. Switching to local processing.");
      }
    }
  }
}