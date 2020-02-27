import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:project_apraxia/controller/FormValidator.dart';
import 'package:project_apraxia/controller/Auth.dart';
import 'package:project_apraxia/model/UserAttributes.dart';
import 'package:international_phone_input/international_phone_input.dart';
import 'package:phone_number/phone_number.dart';

class UpdateUserForm extends StatefulWidget {
  static GlobalKey<FormState> _formKey = new GlobalKey();

  UpdateUserForm({Key  key}) : super(key: key);

  @override
  _UpdateUserFormState createState() => _UpdateUserFormState();
}

class _UpdateUserFormState extends State<UpdateUserForm> {
  final Auth auth = new Auth.instance();
  UserAttributes attributes = new UserAttributes();
  bool _validPhoneNumber = true;
  PhoneNumber _phoneNumberParser = new PhoneNumber();


  _UpdateUserFormState() {
    auth.getUserAttributes().then((initialAttributes) {
      setState(() {
        this.attributes = new UserAttributes(attributes: initialAttributes);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
//          ListTile(
//            leading: Icon(Icons.phone),
//            title: TextFormField(
//              controller: TextEditingController(text: attributes.phoneNumber.substring(2)),
//              decoration: InputDecoration(
//                labelText: "Phone Number",
//              ),
//              keyboardType: TextInputType.phone,
//              validator: (String phoneNumber){
//                return FormValidator.isValidPhoneNumber(phoneNumber);
//              },
//              onChanged: (String phoneNumber) {
//                attributes.phoneNumber = "+1" + phoneNumber;
//              },
//            ),
//          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: InternationalPhoneInput(
              onPhoneNumberChange: (String number, String internationalizedPhoneNumber, String isoCode) {
                if (internationalizedPhoneNumber != "") {
                  attributes.phoneNumber = internationalizedPhoneNumber;
                  _validPhoneNumber = true;
                }
                else {
                  _validPhoneNumber = false;
                }
              },

              initialPhoneNumber: attributes.phoneNumber.substring(2),
              initialSelection: "US",
              errorText: "Invalid phone number",
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
            onPressed: () => this.saveChanges(context),
          )
        ],
      ),
    );
  }

  Future saveChanges(BuildContext context) async {
    if (UpdateUserForm._formKey.currentState.validate() && _validPhoneNumber) {
      UpdateUserForm._formKey.currentState.save();
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
