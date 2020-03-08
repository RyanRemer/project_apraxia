import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/model/WaiverFormFields.dart';
import 'package:project_apraxia/widget/form_field/DateFormField.dart';
import 'package:project_apraxia/widget/form_field/SignatureField.dart';

class SubjectSignatureForm extends StatelessWidget {
  SubjectSignatureForm({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.fields,
  }) : _formAKey = formKey, super(key: key);

  final GlobalKey<FormState> _formAKey;
  final WaiverFormFields fields;
  final FormValidator validator = new FormValidator();
  final DateTime now = new DateTime.now();

  @override
  Widget build(BuildContext context) {
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
