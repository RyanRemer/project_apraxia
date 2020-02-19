import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/SafeFile.dart';
import 'package:project_apraxia/model/WaiverFormFields.dart';
import 'package:project_apraxia/controller/RemoteWSDCalculator.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'dart:io';

import 'package:project_apraxia/page/SignaturePage.dart';
import 'package:project_apraxia/page/SurveyPage.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';

class WaiverForm extends StatefulWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey();

  WaiverForm({Key key}) : super(key: key);

  @override
  _WaiverFormState createState() => _WaiverFormState();
}

class _WaiverFormState extends State<WaiverForm> {
  final WaiverFormFields fields = new WaiverFormFields();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: WaiverForm._formKey,
      child: loading
      ? Expanded(
        child: Center(child: CircularProgressIndicator(),)
      )
      : Expanded(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0, top: 4.0),
              child: Text("Research Subject Info (Required)", style: Theme.of(context).textTheme.title,),
            ),
            ListTile(
              title: TextFormField(
                initialValue: fields.researchSubjectName,
                decoration: InputDecoration(labelText: "Research Subject Name"),
                onChanged: (String name) {
                  fields.researchSubjectName = name;
                },
              ),
            ),
            ListTile(
              title: TextFormField(
                initialValue: fields.researchSubjectEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: "Research Subject Email"),
                onChanged: (String email) {
                  fields.researchSubjectEmail = email;
                },
              ),
            ),

            const Divider(thickness: 3, color: Colors.black45),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0, top: 4.0),
              child: Text("Research Subject Signature (Option A)", style: Theme.of(context).textTheme.title,),
            ),
            Column(
              children: <Widget> [
                _buildResearchSignature(context),
              ]
            ),
            ListTile(
              title: Text(fields.getFormattedSubjectDate()),
              trailing: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectSubjectDate(context),
              ),
            ),

            const Divider(thickness: 3, color: Colors.black45),

            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0, top: 4.0),
              child: Text("Legal Representative (Option B)", style: Theme.of(context).textTheme.title,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0),
              child: Text("For Personal Representative of the Research Participant (if applicable)", style: Theme.of(context).textTheme.subtitle,),
            ),
            ListTile(
              title: TextFormField(
                initialValue: fields.representativeName,
                decoration: InputDecoration(labelText: "Personal Representative Name"),
                onChanged: (String name) {
                  fields.representativeName = name;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              child: Text("Please explain your authority to act on behalf of this Research Subject"),
            ),
            ListTile(
              title: TextFormField(
                initialValue: fields.representativeRelationship,
                decoration: InputDecoration(labelText: "Relationship"),
                onChanged: (String relationship) {
                  fields.representativeRelationship = relationship;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text("I am giving this permission by signing this HIPAA Authorization on behalf of the Research Participant."),
            ),
            Column(
              children: <Widget>[
                _buildRepresentativeSignature(context),
              ],
            ),
            ListTile(
              title: Text(fields.getFormattedRepresentativeDate()),
              trailing: IconButton(
                icon: Icon(Icons.calendar_today),
                onPressed: () => _selectRepresentativeDate(context),
              ),
            ),
            ButtonBar(
              children: <Widget>[
                RaisedButton(
                  child: new Text("Agree To Waiver"),
                  onPressed: () => _agreeToWaiver(context)
                )
              ],
            )
          ],
        ),
      )
    );
  }

  Widget _buildResearchSignature(BuildContext context) {
    if (fields.researchSubjectSignatureFile == "") {
      return RaisedButton(
        child: Text("Sign"),
        onPressed: () async {
          String filePath = await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return new SignaturePage(filePrefix: "research-subject");
          }));
          if (filePath != null) {
            setState(() {
              fields.researchSubjectSignatureFile = filePath;
            });
          }
        },
      );
    }
    else {
      return Image.file(new File(fields.researchSubjectSignatureFile));
    }
  }

  Widget _buildRepresentativeSignature(BuildContext context) {
    if (fields.representativeSignatureFile == "") {
      return RaisedButton(
        child: Text("Sign"),
        onPressed: () async {
          String filePath = await Navigator.push(context, MaterialPageRoute(builder: (context) {
            return new SignaturePage(filePrefix: "representative");
          }));
          if (filePath != null) {
            setState(() {
              fields.representativeSignatureFile = filePath;
            });
          }
        },
      );
    }
    else {
      return new Image.file(new File(fields.representativeSignatureFile));
    }
  }

  void _agreeToWaiver(BuildContext context) async {
    if (WaiverForm._formKey.currentState.validate()) {
      WaiverForm._formKey.currentState.save();
      int isSigned = _isSigned();
      if (isSigned != -1) {
        setState(() {
          loading = true;
        });
        HttpConnector connector = HttpConnector.instance();
        try {
          if (isSigned == 0) {
            await connector.sendSubjectWaiver(
                fields.researchSubjectSignatureFile,
                fields.researchSubjectName.trim(),
                fields.researchSubjectEmail.trim().toLowerCase(),
                fields.getFormattedSubjectDate()
            );
          } else {
            await connector.sendRepresentativeWaiver(
                fields.representativeSignatureFile,
                fields.researchSubjectName.trim(),
                fields.researchSubjectEmail.trim().toLowerCase(),
                fields.representativeName.trim(),
                fields.representativeRelationship.trim(),
                fields.getFormattedRepresentativeDate()
            );
          }
          setState(() {
            loading = false;
          });

          SafeFile resFile = new SafeFile(fields.researchSubjectSignatureFile);
          resFile.safeDeleteSync();
          SafeFile repFile = new SafeFile(fields.representativeSignatureFile);
          repFile.safeDeleteSync();
          _startRemoteTest(context);
        } on ServerConnectionException {
          ErrorDialog dialog = new ErrorDialog(context);
          dialog.show('Error Connecting to Server', 'If the problem persists, back out and use local processing.');
          setState(() {
            loading = false;
          });
        } on InternalServerException catch (e) {
          ErrorDialog errorDialog = new ErrorDialog(context);
          errorDialog.show("Error Generating Waiver", e.message + "\n\nIf the problem persists, back out and use local processing.");
          setState(() {
            loading = false;
          });
        }
      }
      else {
        ErrorDialog errorDialog = new ErrorDialog(context);
        errorDialog.show("Incomplete Waiver", "Fill in required information and provide at least one signature.");
      }
    }
  }

  void _startRemoteTest(BuildContext context) async {
    IWSDCalculator wsdCalculator;
    if (await HttpConnector.instance().serverConnected()) {
      wsdCalculator = new RemoteWSDCalculator();
    }
    else {
      wsdCalculator = new LocalWSDCalculator();
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return new SurveyPage(
        wsdCalculator: wsdCalculator,
      );
    }));
  }

  void _selectSubjectDate(BuildContext context) async {
    DateTime now = new DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: fields.researchSubjectDate,
        firstDate: DateTime(now.year, 1),
        lastDate: DateTime(now.year + 1));
    if (picked != null && picked != fields.researchSubjectDate) {
      setState(() {
        fields.researchSubjectDate = picked;
      });
    }
  }

  void _selectRepresentativeDate(BuildContext context) async {
    DateTime now = new DateTime.now();
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: fields.representativeDate,
        firstDate: DateTime(now.year, 1),
        lastDate: DateTime(now.year + 1));
    if (picked != null && picked != fields.representativeDate) {
      setState(() {
        fields.representativeDate = picked;
      });
    }
  }

  int _isSigned() {
    if (
      FormValidator.isValidName(fields.researchSubjectName) != null
      || FormValidator.isValidEmail(fields.researchSubjectEmail) != null
    ) {
      return -1;
    }
    if (
      FormValidator.isValidDate(fields.researchSubjectDate) == null
      && FormValidator.isValidFile(fields.researchSubjectSignatureFile) == null
    ) {
      return 0;
    }
    else if (
      FormValidator.isValidDate(fields.representativeDate) == null
      && FormValidator.isValidFile(fields.representativeSignatureFile) == null
      && FormValidator.isValidName(fields.representativeName) == null
      && FormValidator.isValidRelationship(fields.representativeRelationship) == null
    ) {
      return 1;
    }
    return -1;
  }
}