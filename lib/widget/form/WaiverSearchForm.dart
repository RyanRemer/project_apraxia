import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/controller/RemoteWSDCalculator.dart';
import 'package:project_apraxia/page/SurveyPage.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';

class WaiverSearchForm extends StatefulWidget {
  WaiverSearchForm({Key key}) : super(key: key);

  @override
  _WaiverSearchFormState createState() => _WaiverSearchFormState();
}

class _WaiverSearchFormState extends State<WaiverSearchForm> {
  static final _formKey = new GlobalKey<FormState>();
  List<Map<String, String>> waivers;
  String _patientName;
  String _patientEmail;

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
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: "Patient Name"),
              onChanged: (String name) {
                _patientName = name;
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
            ),
          ),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Search"),
                ),
                onPressed: search,
              ),
            ],
          ),
          Builder(
            builder: (BuildContext context) {
              if (waivers == null) {
                return Container();
              } else if (waivers.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("No Waivers Found"),
                );
              } else {
                return Column(
                  children: waivers.map((waiver) {
                    return ListTile(
                      title: Text(
                          "Name: ${waiver["subjectName"]}\nEmail:${waiver["subjectEmail"]}"),
                      onTap: () => selectWaiver(waiver),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void selectWaiver(Map<String, String> waiver) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return SurveyPage(
        wsdCalculator: new RemoteWSDCalculator(),
      );
    }));
  }

  Future<void> search() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      var patientWaviers = await loadWaivers(_patientName, _patientEmail);
      setState(() {
        waivers = patientWaviers;
      });
    }
  }

  Future<List<dynamic>> loadWaivers(
      String subjectName, String subjectEmail) async {
    HttpConnector connector = new HttpConnector.instance();
    try {
      List<dynamic> result = await connector.getWaiversOnFile(
          subjectName.trim(), subjectEmail.trim().toLowerCase());
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
