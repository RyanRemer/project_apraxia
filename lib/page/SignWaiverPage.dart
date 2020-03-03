import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/HttpConnector.dart';
import 'package:project_apraxia/controller/LocalWSDCalculator.dart';
import 'package:project_apraxia/controller/RemoteWSDCalculator.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/model/WaiverFormFields.dart';
import 'package:project_apraxia/page/SurveyPage.dart';
import 'package:project_apraxia/widget/form/WaiverForm.dart';

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
                      onChanged: (String name) {
                        fields.researchSubjectName = name;
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
                      onChanged: (String email) {
                        fields.researchSubjectEmail = email;
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
                //TODO: Wording
                RadioListTile(
                  title: Text("Research Subject"),
                  groupValue: fields.hasRepresentative,
                  onChanged: (value) {
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
                  onPressed: () => agreeToWaiver(context),
                )
              ],
            )
          ],
        ));
  }

  Future<void> agreeToWaiver(BuildContext context) async {
    IWSDCalculator wsdCalculator;
    if (await HttpConnector.instance().serverConnected()) {
      wsdCalculator = new RemoteWSDCalculator();
    } else {
      wsdCalculator = new LocalWSDCalculator();
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return new SurveyPage(
        wsdCalculator: wsdCalculator,
      );
    }));
  }

  Form _buildOptionB(BuildContext context) {
    return Form(
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
              onChanged: (String name) {
                fields.representativeName = name;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: TextFormField(
              initialValue: fields.representativeRelationship,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(labelText: "Relationship"),
              onChanged: (String relationship) {
                fields.representativeRelationship = relationship;
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
            child: RaisedButton(
              child: Text("Sign"),
              onPressed: () {},
              // Date
            ),
          )
        ],
      ),
    );
  }

  Form _buildFormA(BuildContext context) {
    return Form(
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
            child: RaisedButton(
              child: Text("Sign"),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }
}
