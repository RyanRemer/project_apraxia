import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/model/WaiverFormFields.dart';
import 'package:project_apraxia/widget/form_field/DateFormField.dart';
import 'package:project_apraxia/widget/form_field/SignatureField.dart';

class RepresentativeSignatureForm extends StatelessWidget {
  RepresentativeSignatureForm({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.fields,
  }) : _formBKey = formKey, super(key: key);

  final GlobalKey<FormState> _formBKey;
  final WaiverFormFields fields;
  final FormValidator validator = new FormValidator();
  final DateTime now = DateTime.now();

  @override
  Widget build(BuildContext context) {
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
}
