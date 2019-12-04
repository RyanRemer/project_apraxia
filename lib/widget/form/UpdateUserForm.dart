import 'package:amazon_cognito_identity_dart/cognito.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/controller/Auth.dart';
import 'package:project_apraxia/model/UserAttributes.dart';

class UpdateUserForm extends StatelessWidget {
  final GlobalKey<FormState> _formKey = new GlobalKey();
  final Auth auth = new Auth.instance();
  UserAttributes attributes;

  UpdateUserForm({Key key}) : super(key: key) {
    auth.getUserAttributes().then(
      (userAttributes) => {this.attributes = new UserAttributes(attributes: userAttributes)}
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Icon(Icons.person),
            title: TextFormField(
              initialValue: attributes.name,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                labelText: "Full Name",
              ),
              validator: (String name) {
                return FormValidator.isValidName(name);
              },
              onSaved: (String name) {
                attributes.name = name;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: TextFormField(
              initialValue: attributes.email,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
              ),
              onSaved: (String email) {
                attributes.email = email;
              },
              validator: (String email) {
                return FormValidator.isValidEmail(email);
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: TextFormField(
              initialValue: attributes.phoneNumber.substring(2),
              decoration: InputDecoration(
                labelText: "Phone Number",
              ),
              keyboardType: TextInputType.phone,
              validator: (String phoneNumber){
                return FormValidator.isValidPhoneNumber(phoneNumber);
              },
              onSaved: (String phoneNumber) {
                attributes.phoneNumber = "+1" + phoneNumber;
              },
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: TextFormField(
              initialValue: attributes.address,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: "Address",
              ),
              keyboardType: TextInputType.multiline,
              onSaved: (String address) {
                attributes.address = address;
              },
              validator: (String address) {
                return FormValidator.isValidAddress(address);
              },
            ),
          ),
          RaisedButton(
            child: Text("Save Changes"),
            onPressed: () => this.saveChanges(context),
          )
        ],
      ),
    );
  }

  Future saveChanges(BuildContext context) async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      try {
        await auth.updateUserAttributes(
          attributes.email,
          attributes.address,
          attributes.phoneNumber,
          attributes.name
        );
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text("Success"),
                content: Text("All changes have been saved successfully."),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Okay"),
                    onPressed: () => Navigator.pop(context),
                  )
                ]
              )
        );
      } on CognitoClientException catch (error) {
        showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text("Error Saving Changes"),
                content: Text(error.message),
                actions: <Widget>[
                  FlatButton(
                    child: Text("Okay"),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
        );
      }
    }
  }
}
