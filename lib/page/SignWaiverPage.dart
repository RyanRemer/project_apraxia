import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/controller/RemoteWSDCalculator.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/model/WaiverFormFields.dart';
import 'package:project_apraxia/page/SurveyPage.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';
import 'package:project_apraxia/widget/form/WaiverForm.dart';
import 'package:project_apraxia/widget/form_field/DateFormField.dart';
import 'package:project_apraxia/widget/form_field/SignatureField.dart';

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
          Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(
                    "Resaerch Subject Info",
                    style: Theme.of(context).textTheme.title,
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: TextFormField(
                    initialValue: fields.researchSubjectName,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                      labelText: "Research Subject Name",
                    ),
                    validator: validator.isValidName,
                    onSaved: (String value) {
                      fields.researchSubjectName = value;
                    },
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.email),
                  title: TextFormField(
                    initialValue: fields.researchSubjectEmail,
                    keyboardType: TextInputType.emailAddress,
                    decoration:
                        InputDecoration(labelText: "Research Subject Email"),
                    validator: validator.isValidName,
                    onSaved: (String value) {
                      fields.researchSubjectEmail = value;
                    },
                  ),
                ),
              ],
            ),
          ),
          Column(
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
          ),
          fields.hasRepresentative == true
              ? _buildOptionB(context)
              : _buildFormA(context),
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
          )
        ],
      ),
    );
  }

  void submitForm(BuildContext context) {
    // validate forms
    bool validated = _formKey.currentState.validate();
    if (fields.hasRepresentative) {
      validated = validated && _formBKey.currentState.validate();
    } else {
      validated = validated && _formAKey.currentState.validate();
    }

    // save forms
    if (validated) {
      _formKey.currentState.save();
      if (fields.hasRepresentative) {
        _formBKey.currentState.save();
      } else {
        _formAKey.currentState.save();
      }

      sendWaiver();
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

  void showSentWaiverDialog() {
    showDialog(
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
                  goToSurveyPage(context);
                },
              )
            ],
          );
        });
  }

  Future<void> goToSurveyPage(BuildContext context) async {
    IWSDCalculator wsdCalculator;
    if (await HttpConnector.instance().serverConnected()) {
      wsdCalculator = new RemoteWSDCalculator();
    } else {
      wsdCalculator = new LocalWSDCalculator();
    }
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return new SurveyPage(
        wsdCalculator: wsdCalculator,
      );
    }));
  }

  Form _buildOptionB(BuildContext context) {
    return Form(
      key: _formBKey,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "Personal Representative Signature",
              style: Theme.of(context).textTheme.title,
            ),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: TextFormField(
              initialValue: fields.representativeName,
              textCapitalization: TextCapitalization.words,
              decoration:
                  InputDecoration(labelText: "Personal Representative Name"),
              validator: validator.isValidName,
              onSaved: (String value) {
                fields.representativeName = value;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: TextFormField(
              initialValue: fields.representativeRelationship,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: "Relationship"),
              validator: validator.isValidRelationship,
              onSaved: (String value) {
                fields.representativeRelationship = value;
              },
            ),
          ),
          ListTile(
            subtitle: Text(
              "I am giving this permission by signing this HIPAA Authorization on behalf of the Research Participant.",
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: SignatureField(
                value: fields.representativeSignatureFile,
                validator: validator.isValidSignature,
                onSaved: (String value) {
                  fields.representativeSignatureFile = value;
                },
              )),
          DateFormField(
            initialValue: fields.representativeDate,
            firstDate: DateTime(now.year, 1),
            lastDate: DateTime(now.year + 1),
            validator: validator.isValidDate,
            onSaved: (DateTime value) {
              fields.researchSubjectDate = value;
            },
          )
        ],
      ),
    );
  }

  DateTime get now => new DateTime.now();

  Form _buildFormA(BuildContext context) {
    return Form(
      key: _formAKey,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "Research Subject Signature",
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: SignatureField(
                value: fields.researchSubjectSignatureFile,
                validator: validator.isValidSignature,
                onSaved: (String value) {
                  fields.researchSubjectSignatureFile = value;
                },
              )),
          DateFormField(
            initialValue: fields.researchSubjectDate,
            firstDate: DateTime(now.year, 1),
            lastDate: DateTime(now.year + 1),
            validator: validator.isValidDate,
            onSaved: (DateTime value) {
              fields.researchSubjectDate = value;
            },
          )
        ],
      ),
    );
  }
}
