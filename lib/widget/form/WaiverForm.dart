import 'package:flutter/material.dart';
import 'package:project_apraxia/model/WaiverFormFields.dart';
import 'package:project_apraxia/page/AmbiancePage.dart';
import 'package:project_apraxia/controller/RemoteWSDCalculator.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'dart:io';

import 'package:project_apraxia/page/SignaturePage.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';

class WaiverForm extends StatelessWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey();
  final WaiverFormFields fields = new WaiverFormFields.test();

  WaiverForm({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0, top: 4.0),
            child: Text("Research Subject Info", style: Theme.of(context).textTheme.body2,),
          ),
          ListTile(
            title: TextFormField(
              initialValue: fields.researchSubjectName,
              decoration: InputDecoration(labelText: "Research Subject Name"),
              onSaved: (String name) {
                fields.researchSubjectName = name;
              },
            ),
          ),
          ListTile(
            title: TextFormField(
              initialValue: fields.researchSubjectEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "Research Subject Email"),
              onSaved: (String email) {
                fields.researchSubjectEmail = email;
              },
            ),
          ),

          const Divider(thickness: 1.5),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0, top: 4.0),
            child: Text("Research Subject Signature", style: Theme.of(context).textTheme.body2,),
          ),
          RaisedButton(
            child: Text("Sign"),
            onPressed: () async {
              fields.researchSubjectSignatureFile = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return new SignaturePage();
              }));
            },
          ),
          _buildResearchSignature(context),
          ListTile(
            title: TextFormField(
              initialValue: fields.researchSubjectDate,
              decoration: InputDecoration(labelText: "Date"),
              onSaved: (String date) {
                fields.researchSubjectDate = date;
              },
            ),
          ),

          const Divider(thickness: 1.5),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 4.0, top: 4.0),
            child: Text("For Personal Representative of the Research Participant (if applicable)", style: Theme.of(context).textTheme.body2,),
          ),
          ListTile(
            title: TextFormField(
              initialValue: fields.representativeName,
              decoration: InputDecoration(labelText: "Personal Representative Name"),
              onSaved: (String name) {
                fields.representativeName = name;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Please explain your authority to act on behalf of this Research Subject"),
          ),
          ListTile(
            title: TextFormField(
              initialValue: fields.representativeRelationship,
              decoration: InputDecoration(labelText: "Relationship"),
              onSaved: (String relationship) {
                fields.representativeRelationship = relationship;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("I am giving this permission by signing this HIPAA Authorization on behalf of the Research Participant."),
          ),
          RaisedButton(
            child: Text("Sign"),
            onPressed: () async {
              fields.representativeSignatureFile = await Navigator.push(context, MaterialPageRoute(builder: (context) {
                return new SignaturePage();
              }));
            },
          ),
          _buildRepresentativeSignature(context),
          ListTile(
            title: TextFormField(
              initialValue: fields.representativeDate,
              decoration: InputDecoration(labelText: "Date"),
              onSaved: (String date) {
                fields.representativeDate = date;
              },
            ),
          ),

          ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: Text("Skip Waiver - Basic Processing"),
                onPressed: () => _startLocalTest(context),
              ),
              RaisedButton(
                  child: new Text("Agree To Waiver"),
                  onPressed: () => _agreeToWaiver(context)
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildResearchSignature(BuildContext context) {
    if (fields.researchSubjectSignatureFile == "") {
      return new Container();
    }
    else {
      return new FractionallySizedBox(
          widthFactor: 0.8,
          heightFactor: 0.15,
          child: Image.file(new File(fields.researchSubjectSignatureFile))
      );
    }
  }

  Widget _buildRepresentativeSignature(BuildContext context) {
    if (fields.representativeSignatureFile == "") {
      return new Container();
    }
    else {
      return new FractionallySizedBox(
          widthFactor: 0.8,
          heightFactor: 0.15,
          child: Image.file(new File(fields.representativeSignatureFile))
      );
    }
  }

  void _agreeToWaiver(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      if (_isSigned()) {
        // TODO: Save that this user has agreed to the HIPAA waiver and save their signature
        _startRemoteTest(context);
      }
      else {
        ErrorDialog errorDialog = new ErrorDialog(context);
        errorDialog.show("Incomplete Waiver", "Fill in required information and provide at least one signature.");
      }
    }
  }

  void _startLocalTest(BuildContext context) {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return AmbiancePage(
        wsdCalculator: new LocalWSDCalculator(),
      );
    }));
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
      return new AmbiancePage(
        wsdCalculator: wsdCalculator,
      );
    }));
  }

  bool _isSigned() {
    if (
      FormValidator.isValidName(fields.researchSubjectName) != null
      || FormValidator.isValidEmail(fields.researchSubjectEmail) != null
    ) {
      return false;
    }
    if (
      FormValidator.isValidDate(fields.researchSubjectDate) == null
      && FormValidator.isValidFile(fields.researchSubjectSignatureFile) == null
    ) {
      return true;
    }
    else if (
      FormValidator.isValidDate(fields.representativeDate) == null
      && FormValidator.isValidFile(fields.representativeSignatureFile) == null
      && FormValidator.isValidName(fields.representativeName) == null
      && FormValidator.isValidRelationship(fields.representativeRelationship) == null
    ) {
      return true;
    }
    return false;
  }

}
