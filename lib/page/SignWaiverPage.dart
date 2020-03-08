import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/controller/RemoteWSDCalculator.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/model/WaiverFormFields.dart';
import 'package:project_apraxia/page/SurveyPage.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';
import 'package:project_apraxia/widget/form/RepresentativeSignatureForm.dart';
import 'package:project_apraxia/widget/form/ResearchSubjectForm.dart';
import 'package:project_apraxia/widget/form/SubjectSignatureForm.dart';

class SignWaiverPage extends StatefulWidget {
  SignWaiverPage({Key key}) : super(key: key);

  @override
  _SignWaiverPageState createState() => _SignWaiverPageState();
}

class _SignWaiverPageState extends State<SignWaiverPage> {
  WaiverFormFields fields = new WaiverFormFields();
  static final _formKey = new GlobalKey<FormState>();
  static final _formAKey = new GlobalKey<FormState>();
  static final _formBKey = new GlobalKey<FormState>();
  final FormValidator validator = new FormValidator();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HIPAA Waiver Signature"),
      ),
      body: ListView(
        children: <Widget>[
          ResearchSubjectForm(formKey: _formKey, fields: fields),
          _buildSignatureOptions(context),
          fields.hasRepresentative == true
              ? RepresentativeSignatureForm(
                  formKey: _formBKey,
                  fields: fields,
                )
              : SubjectSignatureForm(
                  formKey: _formAKey,
                  fields: fields,
                ),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Text("Agree To Waiver"),
                ),
                onPressed: () => submitForm(context),
              )
            ],
          ),
        ],
      ),
    );
  }

  Column _buildSignatureOptions(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            "Signature Options",
            style: Theme.of(context).textTheme.title,
          ),
        ),
        RadioListTile(
          title: Text("Research Subject"),
          groupValue: fields.hasRepresentative,
          onChanged: (value) {
            _formBKey.currentState.save();
            setState(() {
              fields.hasRepresentative = false;
            });
          },
          value: false,
        ),
        RadioListTile(
          title: Text("Personal Representative"),
          groupValue: fields.hasRepresentative,
          onChanged: (value) {
            _formAKey.currentState.save();
            setState(() {
              fields.hasRepresentative = true;
            });
          },
          value: true,
        )
      ],
    );
  }

  void submitForm(BuildContext context) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (fields.hasRepresentative && _formBKey.currentState.validate()) {
        _formBKey.currentState.save();
        sendWaiver();
      } else if (fields.hasRepresentative == false &&
          _formAKey.currentState.validate()) {
        _formAKey.currentState.save();
        sendWaiver();
      }
    }
  }

  Future<void> sendWaiver() async {
    HttpConnector connector = HttpConnector.instance();
    try {
      if (fields.hasRepresentative) {
        await connector.sendRepresentativeWaiver(
            fields.representativeSignatureFile,
            fields.researchSubjectName.trim(),
            fields.researchSubjectEmail.trim().toLowerCase(),
            fields.representativeName.trim(),
            fields.representativeRelationship.trim(),
            fields.getFormattedRepresentativeDate());
      } else {
        await connector.sendSubjectWaiver(
            fields.researchSubjectSignatureFile,
            fields.researchSubjectName.trim(),
            fields.researchSubjectEmail.trim().toLowerCase(),
            fields.getFormattedSubjectDate());
      }
    } on ServerConnectionException {
      ErrorDialog dialog = new ErrorDialog(context);
      dialog.show('Error Connecting to Server',
          'If the problem persists, back out and use local processing.');
    } on InternalServerException catch (e) {
      ErrorDialog errorDialog = new ErrorDialog(context);
      errorDialog.show(
          "Error Generating Waiver",
          e.message +
              "\n\nIf the problem persists, back out and use local processing.");
    } catch (error) {
      ErrorDialog errorDialog = new ErrorDialog(context);
      errorDialog.show(
        "Error Sending Waiver",
        "There was an error sending the waiver, please try again. If the problem persists back out and use local processing instead.",
      );
      throw (error);
    }

    showSentWaiverDialog();
  }

  Future<void> showSentWaiverDialog() async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text("Sent the Waiver"),
            content: Text(
                "A waiver has been sent to ${fields.researchSubjectEmail} and the clinician email."),
            actions: <Widget>[
              FlatButton(
                child: Text("Continue Test"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });

    goToSurveyPage(context);
  }

  Future<void> goToSurveyPage(BuildContext context) async {
    IWSDCalculator wsdCalculator;
    if (await HttpConnector.instance().serverConnected()) {
      wsdCalculator = new RemoteWSDCalculator();
    } else {
      wsdCalculator = new LocalWSDCalculator();
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return new SurveyPage(
            wsdCalculator: wsdCalculator,
          );
        },
      ),
    );
  }
}
