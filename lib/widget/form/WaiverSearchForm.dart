import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';

class WaiverSearchForm extends StatefulWidget {
  final Function(Map<String, String>, BuildContext context) onSelect;
  WaiverSearchForm({Key key, @required this.onSelect}) : super(key: key);

  @override
  _WaiverSearchFormState createState() => _WaiverSearchFormState(onSelect: this.onSelect);
}

class _WaiverSearchFormState extends State<WaiverSearchForm> {
  _WaiverSearchFormState({@required this.onSelect});

  static final _formKey = new GlobalKey<FormState>();
  final Function(Map<String, String>, BuildContext context) onSelect;
  Map<String, String> _waiver;
  Map<String, String> _selectedWaiver;
  String _patientEmail;
  String _patientName;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: TextFormField(
              initialValue: _patientName,
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: "Patient Name"),
              onChanged: (String value) {
                _patientName = value;
              },
              validator: (String value) {
                return FormValidator.isValidName(value);
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: TextFormField(
              initialValue: _patientEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "Patient Email"),
              onChanged: (String email) {
                _patientEmail = email;
              },
              validator: (String value) {
                return FormValidator.isValidEmail(value);
              },
            ),
          ),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Search"),
                ),
                onPressed: _search,
              ),
            ],
          ),
          Builder(
            builder: (BuildContext context) {
              if (_waiver == null) {
                return Container();
              } else if (_waiver.keys.length == 0) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("No Waivers Found"),
                );
              } else {
                return RadioListTile(
                  title: Text("Name: ${_waiver["subjectName"]}"),
                  subtitle: Text("Date Signed: ${_waiver["date"]}"),
                  onChanged: (Map<String, String> value) {
                    _selectWaiver(_waiver);
                  },
                  groupValue: _selectedWaiver,
                  value: _waiver,
                );
              }
            }
          ),
        ],
      ),
    );
  }

  void _selectWaiver(Map<String, String> waiver) {
    setState(() {
      _selectedWaiver = waiver;
    });
    onSelect(waiver, context);
    setState(() {
      _selectedWaiver = null;
    });
  }

  Future<void> _search() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      Map<String, String> patientWaivers = await _loadWaivers(_patientEmail, _patientName);
      setState(() {
        _waiver = patientWaivers;
      });
    }
  }

  Future<Map<String, String>> _loadWaivers(String subjectEmail, String subjectName) async {
    HttpConnector connector = new HttpConnector.instance();
    try {
      Map<String, String> result = await connector.getWaiverOnFile(subjectEmail.trim().toLowerCase(), subjectName.trim());
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
}
