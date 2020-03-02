import 'package:flutter/material.dart';
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
  List<Map<String, String>> _waivers;
  String _patientEmail;
  Map<String, String> _selectedWaiver;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.email),
            title: TextFormField(
              initialValue: _patientEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "Patient Email"),
              onChanged: (String email) {
                _patientEmail = email;
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
                if (_waivers == null) {
                  return Container();
                } else if (_waivers.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text("No Waivers Found"),
                  );
                } else {
                  return Column(
                    children: _waivers.map((waiver) {
                      return RadioListTile(
                        title: Text("Name: ${waiver["subjectName"]}"),
                        subtitle: Text("Date Signed: ${waiver["date"]}"),
                        onChanged: (Map<String, String> value) {
                          setState(() {
                            _selectWaiver(waiver);
                          });
                        },
                        groupValue: _selectedWaiver,
                        value: waiver,
                      );
                    }).toList(),
                  );
                }
              }
          )
        ],
      ),
    );
  }

  void _selectWaiver(Map<String, String> waiver) {
    _selectedWaiver = waiver;
    onSelect(waiver, context);
  }

  Future<void> _search() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      List<Map<String, String>> patientWaivers = await _loadWaivers(_patientEmail);
      setState(() {
        _waivers = patientWaivers;
      });
    }
  }

  Future<List<Map<String, String>>> _loadWaivers(String subjectEmail) async {
    HttpConnector connector = new HttpConnector.instance();
    try {
      List<Map<String, String>> result = await connector.getWaiversOnFile(subjectEmail.trim().toLowerCase());
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
