import 'dart:io';

import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/controller/Auth.dart';
import 'package:project_apraxia/model/UserAttributes.dart';
import 'package:project_apraxia/widget/ErrorDialog.dart';
import 'package:project_apraxia/widget/ForgotPasswordButton.dart';

class UpdateUserForm extends StatefulWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey();

  UpdateUserForm({Key key}) : super(key: key);

  @override
  _UpdateUserFormState createState() => _UpdateUserFormState();
}

class _UpdateUserFormState extends State<UpdateUserForm> {
  final Auth _auth = new Auth.instance();
 Future<List<CognitoUserAttribute>> fetchAttributes;
  bool _validPhoneNumber = true;

  _UpdateUserFormState() {
    this.fetchAttributes = _auth.getUserAttributes();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchAttributes,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData == false) {
          return Center(child: CircularProgressIndicator());
        }
        else if (snapshot.hasError){
          ErrorDialog errorDialog = new ErrorDialog(context);
          errorDialog.show("Error loading User Data", snapshot.error.toString());
          return Center(child: Text(snapshot.error.toString()));
        }

        print(snapshot.data);

        UserAttributes attributes =
            new UserAttributes(attributes: snapshot.data);

        return Form(
          key: UpdateUserForm._formKey,
          child: Column(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.person),
                title: TextFormField(
                  controller: TextEditingController(text: attributes.name),
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                  ),
                  validator: (String name) {
                    return FormValidator.isValidName(name);
                  },
                  onChanged: (String name) {
                    attributes.name = name;
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.email),
                title: TextFormField(
                  controller: TextEditingController(text: attributes.email),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                  onChanged: (String email) {
                    attributes.email = email;
                  },
                  validator: (String email) {
                    return FormValidator.isValidEmail(email);
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: InternationalPhoneNumberInput.withCustomDecoration(
                  onInputChanged: (PhoneNumber number) {
                    attributes.phoneNumber = number.phoneNumber;
                  },
                  isEnabled: true,
                  autoValidate: true,
                  formatInput: true,
                  countries: ['US', 'CA'],
                  initialCountry2LetterCode: 'US',
                  textFieldController: TextEditingController(
                      text: attributes.phoneNumber.substring(2)),
                  inputDecoration: InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                  errorMessage: 'Invalid phone number',
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: TextFormField(
                  controller: TextEditingController(text: attributes.address),
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: "Address",
                  ),
                  keyboardType: TextInputType.multiline,
                  onChanged: (String address) {
                    attributes.address = address;
                  },
                  validator: (String address) {
                    return FormValidator.isValidAddress(address);
                  },
                ),
              ),
              RaisedButton(
                child: Text("Save Changes"),
                onPressed: () => this.saveChanges(context, attributes),
              ),
              ForgotPasswordButton(),
            ],
          ),
        );
      },
    );
  }

  Future saveChanges(BuildContext context, UserAttributes attributes) async {
    if (UpdateUserForm._formKey.currentState.validate() && _validPhoneNumber) {
      UpdateUserForm._formKey.currentState.save();
      try {
        await _auth.updateUserAttributes(attributes.email, attributes.address,
            attributes.phoneNumber, attributes.name);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: Text("Success"),
                    content: Text("All changes have been saved successfully."),
                    actions: <Widget>[
                      FlatButton(
                        child: Text("Okay"),
                        onPressed: () => Navigator.pop(context),
                      )
                    ]));
      } on CognitoClientException catch (error) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
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
