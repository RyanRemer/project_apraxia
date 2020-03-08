import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/model/WaiverFormFields.dart';

class ResearchSubjectForm extends StatelessWidget {
  ResearchSubjectForm({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.fields,
  }) : _formKey = formKey, super(key: key);

  final GlobalKey<FormState> _formKey;
  final WaiverFormFields fields;
  final FormValidator validator = new FormValidator();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              "Research Subject Info",
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
    );
  }
}
